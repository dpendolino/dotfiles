"""Google Docs markdown formatter — native styles, update-in-place.

Parses a markdown file and renders it into a Google Doc with:
  - TITLE / HEADING_1..3 paragraph styles
  - Bullet & numbered lists via createParagraphBullets
  - Bold, italic, inline code (Courier New + gray bg + green text), clickable hyperlinks
  - Fenced code blocks with optional language label
  - Native tables with bold + shaded header row

On rerun, each top-level block is hashed and tagged in the doc via a `mdgdoc:<hash>`
namedRange. We diff the existing tagged blocks against the new MD and replace only the
blocks whose source changed — comments anchored to unchanged blocks are preserved.

Requires the `gws` CLI to be authenticated for Google Docs API access (see the
google-workspace plugin's setup script).

Known limitations:
  - Manual edits inside an unchanged tagged block are preserved on rerun, but content
    inserted *between* blocks (in the gap between two namedRanges) can be displaced or
    deleted when an adjacent block is replaced. Keep manual additions inside a block,
    not between them.
  - Tables are populated cell-by-cell, one batchUpdate per cell. Fine for the small
    tables typical in plan docs; would be worth batching for table-heavy inputs.
  - The diff is content-based: any change to a block's source MD — even whitespace —
    re-renders that block and drops Drive comments anchored to its specific text.
    Comments anchored to *other* blocks survive.
  - Nested list items get extra indentStart but keep the level-0 glyph (disc, "1.",
    etc.). The Docs API treats Bullet.nestingLevel as output-only, so true sub-glyph
    nesting isn't achievable post-creation.
  - Ordered lists always render starting at 1. The leading number (e.g. `3. item`) is
    parsed but ignored — NestingLevel.startNumber isn't updatable through batchUpdate.
  - `:::toc` emits a placeholder paragraph; the Docs API has no native TOC insertion.
"""
import argparse
import difflib
import hashlib
import json
import pathlib
import re
import subprocess
import sys


NAMED_RANGE_PREFIX = 'mdgdoc:'

DRY_RUN = False  # set by --dry-run; suppresses all writes


# ---------- gws helpers ----------
def g(cmd, p=None, b=None):
    a = ['gws', 'docs', 'documents', cmd]
    if p: a += ['--params', json.dumps(p)]
    if b: a += ['--json', json.dumps(b)]
    r = subprocess.run(a, capture_output=True, text=True)
    if r.returncode != 0:
        hint = ''
        err = r.stderr.lower()
        if 'not found' in err or 'no such file' in err or 'command not found' in err:
            hint = '\nHint: gws CLI is not installed. Run: brew install googleworkspace-cli'
        elif 'auth' in err or 'credential' in err or 'token' in err:
            hint = '\nHint: gws is not authenticated. Run `gws auth login` in a separate terminal.'
        sys.exit(f'gws {cmd} failed: {r.stderr.strip()}{hint}')
    return json.loads(r.stdout) if r.stdout.strip() else {}


def batch(doc_id, reqs):
    if not reqs:
        return {}
    if DRY_RUN:
        # Don't send; the caller will see no-op behavior. update_in_place / full_rebuild
        # print a higher-level summary so the user sees what would happen.
        return {}
    return g('batchUpdate', p={'documentId': doc_id}, b={'requests': reqs})


def get_doc(doc_id):
    return g('get', p={'documentId': doc_id})


def end_idx_from(doc):
    return doc['body']['content'][-1]['endIndex']


def end_idx(doc_id):
    return end_idx_from(get_doc(doc_id))


# ---------- Inline markdown tokenizer ----------
def parse_inline(text):
    """Return [(segment, style_dict), ...] covering the input text."""
    out = []
    i = 0
    n = len(text)
    while i < n:
        if text[i:i + 2] == '**':
            end = text.find('**', i + 2)
            if end != -1 and end > i + 2:
                for seg, sty in parse_inline(text[i + 2:end]):
                    s = dict(sty); s['bold'] = True
                    out.append((seg, s))
                i = end + 2
                continue
        if text[i] == '*' and text[i:i + 2] != '**':
            end = text.find('*', i + 1)
            if end != -1 and text[end:end + 2] != '**' and end > i + 1:
                for seg, sty in parse_inline(text[i + 1:end]):
                    s = dict(sty); s['italic'] = True
                    out.append((seg, s))
                i = end + 1
                continue
        if text[i] == '`':
            end = text.find('`', i + 1)
            if end != -1:
                out.append((text[i + 1:end], {'code': True}))
                i = end + 1
                continue
        if text[i] == '[':
            close = text.find(']', i + 1)
            if close != -1 and close + 1 < n and text[close + 1] == '(':
                url_end = text.find(')', close + 2)
                if url_end != -1:
                    url = text[close + 2:url_end]
                    for seg, sty in parse_inline(text[i + 1:close]):
                        s = dict(sty); s['link'] = url
                        out.append((seg, s))
                    i = url_end + 1
                    continue
        if text[i] == '<':
            m = re.match(r'<((?:https?://|mailto:)[^>\s]+)>', text[i:])
            if m:
                url = m.group(1)
                out.append((url, {'link': url}))
                i += len(m.group(0))
                continue
        j = i
        while j < n and text[j] not in '*`[<':
            j += 1
        if j == i:
            out.append((text[j], {}))
            i = j + 1
        else:
            out.append((text[i:j], {}))
            i = j
    return out


# ---------- Block parser ----------
def parse_blocks(md):
    lines = md.split('\n')
    blocks = []
    i = 0
    while i < len(lines):
        L = lines[i]
        if L.startswith('### '):
            blocks.append(('heading', 3, L[4:].strip())); i += 1
        elif L.startswith('## '):
            blocks.append(('heading', 2, L[3:].strip())); i += 1
        elif L.startswith('# '):
            blocks.append(('heading', 1, L[2:].strip())); i += 1
        elif L.startswith(':::'):
            # Container fence: opener carries a header (':::kind args'); a bare ':::' is a closer.
            header = L[3:].strip()
            if header:
                opener_idx = i
                parts = header.split(None, 1)
                kind = parts[0]
                args = parts[1] if len(parts) > 1 else ''
                i += 1
                depth = 1
                inner_lines = []
                closed = False
                while i < len(lines):
                    stripped = lines[i].strip()
                    if stripped.startswith(':::'):
                        rest = stripped[3:].strip()
                        if rest:
                            depth += 1
                            inner_lines.append(lines[i])
                        else:
                            depth -= 1
                            if depth == 0:
                                i += 1
                                closed = True
                                break
                            inner_lines.append(lines[i])
                    else:
                        inner_lines.append(lines[i])
                    i += 1
                if closed:
                    inner = parse_blocks('\n'.join(inner_lines))
                    blocks.append(('container', kind, args, inner))
                else:
                    blocks.append(('p', lines[opener_idx]))
                    i = opener_idx + 1
            else:
                blocks.append(('p', L)); i += 1
        elif L.startswith('```'):
            lang = L[3:].strip()
            i += 1
            code = []
            while i < len(lines) and not lines[i].startswith('```'):
                code.append(lines[i]); i += 1
            i += 1
            blocks.append(('code', '\n'.join(code), lang))
        elif L.startswith('|') and i + 1 < len(lines) and lines[i + 1].startswith('|'):
            rows = []
            while i < len(lines) and lines[i].startswith('|'):
                rows.append(lines[i]); i += 1
            parsed = []
            has_header = False
            for r in rows:
                cells = [c.strip() for c in r.strip().strip('|').split('|')]
                if cells and all(re.match(r'^:?-+:?$', c) for c in cells if c):
                    has_header = True
                    continue
                parsed.append(cells)
            blocks.append(('table', parsed, has_header))
        elif re.match(r'^\s*[-*]\s+', L):
            items = []
            while i < len(lines):
                m = re.match(r'^(\s*)[-*]\s+(.*)', lines[i])
                if not m:
                    break
                level = len(m.group(1)) // 2
                items.append((level, m.group(2)))
                i += 1
            blocks.append(('ul', items))
        elif re.match(r'^\s*\d+\.\s+', L):
            start_m = re.match(r'^\s*(\d+)\.\s+', L)
            start_num = int(start_m.group(1)) if start_m else 1
            items = []
            while i < len(lines):
                m = re.match(r'^(\s*)\d+\.\s+(.*)', lines[i])
                if not m:
                    break
                level = len(m.group(1)) // 2
                items.append((level, m.group(2)))
                i += 1
            blocks.append(('ol', items, start_num))
        elif L.startswith('> '):
            quoted = []
            while i < len(lines) and lines[i].startswith('> '):
                quoted.append(lines[i][2:]); i += 1
            blocks.append(('quote', quoted))
        elif re.match(r'^---+$', L):
            blocks.append(('hr',)); i += 1
        elif L.strip() == '':
            blocks.append(('blank',)); i += 1
        else:
            blocks.append(('p', L)); i += 1
    return blocks


def annotate_blocks(blocks):
    """Promote the first H1 to a 'title' block so its rendered form is captured in its hash."""
    seen = False
    out = []
    for b in blocks:
        if not seen and b[0] == 'heading' and b[1] == 1:
            seen = True
            out.append(('title', b[2]))
        else:
            out.append(b)
    return out


def block_hash(block):
    canon = json.dumps(block, sort_keys=True, ensure_ascii=True, separators=(',', ':'))
    return hashlib.sha1(canon.encode('utf-8')).hexdigest()[:16]


# ---------- Style request builders ----------
def text_style_request(start, length, style):
    if length <= 0 or not style:
        return None
    ts = {}
    fields = []
    if style.get('bold'):
        ts['bold'] = True; fields.append('bold')
    if style.get('italic'):
        ts['italic'] = True; fields.append('italic')
    if style.get('code'):
        ts['weightedFontFamily'] = {'fontFamily': 'Courier New', 'weight': 400}
        ts['backgroundColor'] = {'color': {'rgbColor': {'red': 0.95, 'green': 0.95, 'blue': 0.95}}}
        ts['foregroundColor'] = {'color': {'rgbColor': {'red': 0.118, 'green': 0.557, 'blue': 0.243}}}
        fields += ['weightedFontFamily', 'backgroundColor', 'foregroundColor']
    if style.get('link'):
        ts['link'] = {'url': style['link']}
        ts['foregroundColor'] = {'color': {'rgbColor': {'red': 0.067, 'green': 0.333, 'blue': 0.8}}}
        ts['underline'] = True
        fields += ['link', 'foregroundColor', 'underline']
    if not fields:
        return None
    return {'updateTextStyle': {
        'range': {'startIndex': start, 'endIndex': start + length},
        'textStyle': ts,
        'fields': ','.join(fields)
    }}


def paragraph_style_request(start, end, named=None, shading_rgb=None, indent_pt=None):
    pstyle = {}
    fields = []
    if named:
        pstyle['namedStyleType'] = named
        fields.append('namedStyleType')
    if shading_rgb:
        pstyle['shading'] = {'backgroundColor': {'color': {'rgbColor': shading_rgb}}}
        fields.append('shading.backgroundColor')
    if indent_pt is not None:
        pstyle['indentStart'] = {'magnitude': indent_pt, 'unit': 'PT'}
        fields.append('indentStart')
    if not fields:
        return None
    return {'updateParagraphStyle': {
        'range': {'startIndex': start, 'endIndex': end},
        'paragraphStyle': pstyle,
        'fields': ','.join(fields)
    }}


def insert_styled(idx, spans, newline=True):
    text = ''.join(s[0] for s in spans)
    payload = text + ('\n' if newline else '')
    insert_req = {'insertText': {'location': {'index': idx}, 'text': payload}}
    style_reqs = []
    off = idx
    for seg, sty in spans:
        if sty:
            req = text_style_request(off, len(seg), sty)
            if req:
                style_reqs.append(req)
        off += len(seg)
    return idx, idx + len(payload), insert_req, style_reqs


# ---------- Positional block renderers ----------
# Each returns the new end-of-content position after rendering at `at_idx`.

def render_heading_at(doc_id, at_idx, level, text):
    spans = parse_inline(text)
    start, end, insert_req, style_reqs = insert_styled(at_idx, spans)
    named = {1: 'HEADING_1', 2: 'HEADING_2', 3: 'HEADING_3'}[level]
    p = paragraph_style_request(start, end, named=named)
    batch(doc_id, [insert_req] + ([p] if p else []) + style_reqs)
    return end


def render_title_at(doc_id, at_idx, text):
    spans = parse_inline(text)
    start, end, insert_req, style_reqs = insert_styled(at_idx, spans)
    p = paragraph_style_request(start, end, named='TITLE')
    batch(doc_id, [insert_req] + ([p] if p else []) + style_reqs)
    return end


def render_paragraph_at(doc_id, at_idx, text):
    spans = parse_inline(text)
    start, end, insert_req, style_reqs = insert_styled(at_idx, spans)
    p = paragraph_style_request(start, end, named='NORMAL_TEXT')
    batch(doc_id, [insert_req] + ([p] if p else []) + style_reqs)
    return end


def render_list_at(doc_id, at_idx, items, ordered=False):
    """`items` is a list of (level, text) tuples. level is the 0-based nesting depth.

    The Docs API doesn't expose Bullet.nestingLevel as writable, so deeper items get
    extra indentStart for visual nesting; the glyph stays at level 0.
    """
    if not items:
        return at_idx
    cursor = at_idx
    first_start = cursor
    item_starts = []
    for level, text in items:
        item_starts.append((cursor, level))
        spans = parse_inline(text)
        _, end, insert_req, style_reqs = insert_styled(cursor, spans)
        batch(doc_id, [insert_req] + style_reqs)
        cursor = end
    preset = 'NUMBERED_DECIMAL_ALPHA_ROMAN' if ordered else 'BULLET_DISC_CIRCLE_SQUARE'
    batch(doc_id, [{'createParagraphBullets': {
        'range': {'startIndex': first_start, 'endIndex': cursor - 1},
        'bulletPreset': preset,
    }}])
    # Level 0 keeps the bullet preset's defaults (indentStart=36pt, indentFirstLine=18pt).
    # Each additional level shifts both by another 36pt, matching the preset's nestingLevels.
    nested = [{'updateParagraphStyle': {
        'range': {'startIndex': s, 'endIndex': s + 1},
        'paragraphStyle': {
            'indentStart': {'magnitude': 36 + level * 36, 'unit': 'PT'},
            'indentFirstLine': {'magnitude': 18 + level * 36, 'unit': 'PT'},
        },
        'fields': 'indentStart,indentFirstLine',
    }} for s, level in item_starts if level > 0]
    if nested:
        batch(doc_id, nested)
    return cursor


def render_code_block_at(doc_id, at_idx, code, lang=''):
    cursor = at_idx
    if lang:
        label = lang + '\n'
        batch(doc_id, [
            {'insertText': {'location': {'index': cursor}, 'text': label}},
            {'updateParagraphStyle': {
                'range': {'startIndex': cursor, 'endIndex': cursor + len(label)},
                'paragraphStyle': {'namedStyleType': 'NORMAL_TEXT', 'indentStart': {'magnitude': 18, 'unit': 'PT'}},
                'fields': 'namedStyleType,indentStart',
            }},
            {'updateTextStyle': {
                'range': {'startIndex': cursor, 'endIndex': cursor + len(lang)},
                'textStyle': {
                    'italic': True,
                    'fontSize': {'magnitude': 8, 'unit': 'PT'},
                    'foregroundColor': {'color': {'rgbColor': {'red': 0.45, 'green': 0.45, 'blue': 0.45}}},
                },
                'fields': 'italic,fontSize,foregroundColor',
            }},
        ])
        cursor += len(label)
    payload = code + '\n'
    L = len(payload) - 1
    reqs = [
        {'insertText': {'location': {'index': cursor}, 'text': payload}},
        {'updateParagraphStyle': {
            'range': {'startIndex': cursor, 'endIndex': cursor + len(payload)},
            'paragraphStyle': {
                'namedStyleType': 'NORMAL_TEXT',
                'shading': {'backgroundColor': {'color': {'rgbColor': {'red': 0.96, 'green': 0.96, 'blue': 0.96}}}},
                'indentStart': {'magnitude': 18, 'unit': 'PT'}
            },
            'fields': 'namedStyleType,shading.backgroundColor,indentStart'
        }},
    ]
    if L > 0:
        reqs.append({'updateTextStyle': {
            'range': {'startIndex': cursor, 'endIndex': cursor + L},
            'textStyle': {
                'weightedFontFamily': {'fontFamily': 'Courier New', 'weight': 400},
                'fontSize': {'magnitude': 9, 'unit': 'PT'}
            },
            'fields': 'weightedFontFamily,fontSize'
        }})
    batch(doc_id, reqs)
    return cursor + len(payload)


def render_quote_at(doc_id, at_idx, lines):
    if isinstance(lines, str):  # tolerate the old single-string form
        lines = [lines]
    cursor = at_idx
    for line in lines:
        spans = parse_inline(line)
        spans = [(s, {**sty, 'italic': True}) for s, sty in spans]
        start, end, insert_req, style_reqs = insert_styled(cursor, spans)
        p = paragraph_style_request(start, end, named='NORMAL_TEXT', indent_pt=24)
        batch(doc_id, [insert_req] + ([p] if p else []) + style_reqs)
        cursor = end
    return cursor


def render_table_at(doc_id, at_idx, rows, has_header):
    if not rows:
        return at_idx
    nr = len(rows)
    nc = max(len(r) for r in rows)
    batch(doc_id, [{'insertTable': {'location': {'index': at_idx}, 'rows': nr, 'columns': nc}}])
    tbl_elem = _find_table_at(doc_id, at_idx)
    if not tbl_elem:
        return at_idx
    tbl = tbl_elem['table']
    cells = []
    for ri, row in enumerate(tbl['tableRows']):
        for ci, cell in enumerate(row['tableCells']):
            cs = cell['content'][0]['startIndex']
            txt = rows[ri][ci] if ri < len(rows) and ci < len(rows[ri]) else ''
            cells.append((cs, ri, ci, txt))
    cells.sort(key=lambda x: -x[0])
    for cs, ri, ci, txt in cells:
        if not txt:
            continue
        spans = parse_inline(txt)
        plain = ''.join(s[0] for s in spans)
        reqs = [{'insertText': {'location': {'index': cs}, 'text': plain}}]
        off = cs
        for seg, sty in spans:
            if sty:
                req = text_style_request(off, len(seg), sty)
                if req:
                    reqs.append(req)
            off += len(seg)
        batch(doc_id, reqs)
    if has_header and nr > 0:
        tbl_elem = _find_table_at(doc_id, at_idx)
        if tbl_elem:
            tbl_start = tbl_elem['startIndex']
            header_row = tbl_elem['table']['tableRows'][0]
            reqs = []
            for cell in header_row['tableCells']:
                cs0 = cell['content'][0]['startIndex']
                ce0 = cell['content'][-1]['endIndex']
                if ce0 - 1 > cs0:
                    reqs.append({'updateTextStyle': {
                        'range': {'startIndex': cs0, 'endIndex': ce0 - 1},
                        'textStyle': {'bold': True},
                        'fields': 'bold'
                    }})
            reqs.append({'updateTableCellStyle': {
                'tableRange': {
                    'tableCellLocation': {
                        'tableStartLocation': {'index': tbl_start},
                        'rowIndex': 0,
                        'columnIndex': 0
                    },
                    'rowSpan': 1,
                    'columnSpan': nc
                },
                'tableCellStyle': {
                    'backgroundColor': {'color': {'rgbColor': {'red': 0.93, 'green': 0.93, 'blue': 0.93}}}
                },
                'fields': 'backgroundColor'
            }})
            batch(doc_id, reqs)
    tbl_elem = _find_table_at(doc_id, at_idx)
    return tbl_elem['endIndex'] if tbl_elem else at_idx


def _find_table_at(doc_id, at_idx):
    # insertTable auto-prepends a newline, so the resulting table's startIndex is
    # at_idx + 1 (not at_idx). Accept either for resilience against future API tweaks.
    d = get_doc(doc_id)
    for c in d['body']['content']:
        if 'table' in c and c.get('startIndex') in (at_idx, at_idx + 1):
            return c
    return None


def render_hr_at(doc_id, at_idx):
    text = '― ― ― ― ― ― ― ― ― ―\n'
    batch(doc_id, [{'insertText': {'location': {'index': at_idx}, 'text': text}}])
    return at_idx + len(text)


def render_blank_at(doc_id, at_idx):
    batch(doc_id, [{'insertText': {'location': {'index': at_idx}, 'text': '\n'}}])
    return at_idx + 1


CALLOUT_PALETTES = {
    'info':    {'bg': {'red': 0.890, 'green': 0.949, 'blue': 0.992},
                'border': {'red': 0.098, 'green': 0.463, 'blue': 0.824}},
    'warning': {'bg': {'red': 1.000, 'green': 0.973, 'blue': 0.882},
                'border': {'red': 0.976, 'green': 0.659, 'blue': 0.145}},
    'note':    {'bg': {'red': 0.961, 'green': 0.961, 'blue': 0.961},
                'border': {'red': 0.620, 'green': 0.620, 'blue': 0.620}},
    'success': {'bg': {'red': 0.910, 'green': 0.961, 'blue': 0.914},
                'border': {'red': 0.220, 'green': 0.557, 'blue': 0.235}},
    'error':   {'bg': {'red': 1.000, 'green': 0.922, 'blue': 0.933},
                'border': {'red': 0.827, 'green': 0.184, 'blue': 0.184}},
}


def render_callout_at(doc_id, at_idx, variant, inner_blocks):
    palette = CALLOUT_PALETTES.get(variant.lower() if variant else '', CALLOUT_PALETTES['note'])
    cursor = at_idx
    nested_ranges = []  # nested containers keep their own palette; skip them when styling outer
    for block in inner_blocks:
        block_start = cursor
        cursor = render_block_at(doc_id, cursor, block)
        if block[0] == 'container':
            nested_ranges.append((block_start, cursor))

    # Build sub-ranges of this callout that aren't covered by nested containers.
    spans = []
    cur = at_idx
    for cs, ce in nested_ranges:
        if cur < cs:
            spans.append((cur, cs))
        cur = ce
    if cur < cursor:
        spans.append((cur, cursor))

    reqs = []
    for s, e in spans:
        reqs.append({'updateParagraphStyle': {
            'range': {'startIndex': s, 'endIndex': e},
            'paragraphStyle': {
                'shading': {'backgroundColor': {'color': {'rgbColor': palette['bg']}}},
                'borderLeft': {
                    'color': {'color': {'rgbColor': palette['border']}},
                    'width': {'magnitude': 3, 'unit': 'PT'},
                    'padding': {'magnitude': 8, 'unit': 'PT'},
                    'dashStyle': 'SOLID',
                },
            },
            'fields': 'shading.backgroundColor,borderLeft',
        }})
    if reqs:
        batch(doc_id, reqs)
    return cursor


def render_checklist_at(doc_id, at_idx, inner_blocks):
    items = []
    for b in inner_blocks:
        if b[0] == 'ul':
            for _level, item in b[1]:
                m = re.match(r'^\s*\[[ xX]\]\s+', item)
                if m:
                    item = item[m.end():]
                items.append(item)
    if not items:
        return at_idx
    cursor = at_idx
    first_start = cursor
    for item in items:
        spans = parse_inline(item)
        _, end, insert_req, style_reqs = insert_styled(cursor, spans)
        batch(doc_id, [insert_req] + style_reqs)
        cursor = end
    batch(doc_id, [{'createParagraphBullets': {
        'range': {'startIndex': first_start, 'endIndex': cursor - 1},
        'bulletPreset': 'BULLET_CHECKBOX',
    }}])
    return cursor


def render_toc_at(doc_id, at_idx):
    # The Docs API has no insertTableOfContents request, so leave a muted placeholder
    # that prompts the reader to populate it from Insert → Table of contents.
    text = '[ Table of contents — Insert > Table of contents in Google Docs to populate ]\n'
    batch(doc_id, [
        {'insertText': {'location': {'index': at_idx}, 'text': text}},
        {'updateTextStyle': {
            'range': {'startIndex': at_idx, 'endIndex': at_idx + len(text) - 1},
            'textStyle': {
                'italic': True,
                'foregroundColor': {'color': {'rgbColor': {'red': 0.5, 'green': 0.5, 'blue': 0.5}}},
            },
            'fields': 'italic,foregroundColor',
        }},
    ])
    return at_idx + len(text)


def render_columns_at(doc_id, at_idx, num_cols_arg, inner_blocks):
    try:
        n = int((num_cols_arg or '').strip())
    except ValueError:
        n = 2
    n = max(2, min(n, 4))

    # insertSectionBreak adds 2 chars at `at_idx`: a paragraph break + the section break.
    # Inner content of the new section starts at at_idx + 2.
    batch(doc_id, [{'insertSectionBreak': {
        'location': {'index': at_idx},
        'sectionType': 'CONTINUOUS',
    }}])
    section_start = at_idx + 2
    cursor = section_start

    for block in inner_blocks:
        cursor = render_block_at(doc_id, cursor, block)

    closing_at = cursor
    batch(doc_id, [{'insertSectionBreak': {
        'location': {'index': closing_at},
        'sectionType': 'CONTINUOUS',
    }}])
    cursor = closing_at + 2

    # Column widths are output-only in the Docs API; only paddingEnd is writable.
    # Number of entries in columnProperties controls the column count.
    gap = 18.0
    column_props = []
    for i in range(n):
        cp = {}
        if i < n - 1:
            cp['paddingEnd'] = {'magnitude': gap, 'unit': 'PT'}
        column_props.append(cp)

    batch(doc_id, [{'updateSectionStyle': {
        'range': {'startIndex': section_start, 'endIndex': closing_at},
        'sectionStyle': {'columnProperties': column_props},
        'fields': 'columnProperties',
    }}])
    return cursor


def render_container_at(doc_id, at_idx, kind, args, inner_blocks):
    if kind == 'callout':
        return render_callout_at(doc_id, at_idx, args, inner_blocks)
    if kind == 'checklist':
        return render_checklist_at(doc_id, at_idx, inner_blocks)
    if kind == 'toc':
        return render_toc_at(doc_id, at_idx)
    if kind == 'columns':
        return render_columns_at(doc_id, at_idx, args, inner_blocks)
    # Unknown container kind — render inner blocks plain so content isn't lost.
    cursor = at_idx
    for block in inner_blocks:
        cursor = render_block_at(doc_id, cursor, block)
    return cursor


def render_block_at(doc_id, at_idx, block):
    kind = block[0]
    if kind == 'title':
        return render_title_at(doc_id, at_idx, block[1])
    if kind == 'heading':
        return render_heading_at(doc_id, at_idx, block[1], block[2])
    if kind == 'p':
        return render_paragraph_at(doc_id, at_idx, block[1])
    if kind == 'ul':
        return render_list_at(doc_id, at_idx, block[1], ordered=False)
    if kind == 'ol':
        # block[2] is the start number; the Docs API can't set list startNumber so it's unused.
        return render_list_at(doc_id, at_idx, block[1], ordered=True)
    if kind == 'code':
        return render_code_block_at(doc_id, at_idx, block[1], block[2] if len(block) > 2 else '')
    if kind == 'quote':
        return render_quote_at(doc_id, at_idx, block[1])
    if kind == 'table':
        return render_table_at(doc_id, at_idx, block[1], block[2])
    if kind == 'hr':
        return render_hr_at(doc_id, at_idx)
    if kind == 'blank':
        return render_blank_at(doc_id, at_idx)
    if kind == 'container':
        return render_container_at(doc_id, at_idx, block[1], block[2], block[3])
    return at_idx


def tag_range(doc_id, name, start, end):
    """Wrap [start, end) in a namedRange so we can find this block on rerun."""
    if end <= start:
        return
    batch(doc_id, [{'createNamedRange': {
        'name': name,
        'range': {'startIndex': start, 'endIndex': end},
    }}])


# ---------- Reading existing tagged units ----------
def extract_existing_units(doc):
    """Return ordered list of {hash, start, end} for blocks tagged by previous runs."""
    named = doc.get('namedRanges', {})
    units = []
    for name, group in named.items():
        if not name.startswith(NAMED_RANGE_PREFIX):
            continue
        h = name[len(NAMED_RANGE_PREFIX):]
        for nr in group.get('namedRanges', []):
            for rng in nr.get('ranges', []):
                units.append({
                    'hash': h,
                    'start': rng['startIndex'],
                    'end': rng['endIndex'],
                })
    units.sort(key=lambda u: u['start'])
    return units


# ---------- Full rebuild path (also handles first-run tagging) ----------
def full_rebuild(doc_id, blocks):
    d = get_doc(doc_id)
    e = end_idx_from(d)
    # Wipe existing namedRanges we own so they don't pollute the new tags.
    delete_reqs = []
    for name, group in d.get('namedRanges', {}).items():
        if name.startswith(NAMED_RANGE_PREFIX):
            for nr in group.get('namedRanges', []):
                delete_reqs.append({'deleteNamedRange': {'namedRangeId': nr['namedRangeId']}})
    if delete_reqs:
        batch(doc_id, delete_reqs)
    if e > 2:
        batch(doc_id, [{'deleteContentRange': {'range': {'startIndex': 1, 'endIndex': e - 1}}}])
    batch(doc_id, [{'updateParagraphStyle': {
        'range': {'startIndex': 1, 'endIndex': 2},
        'paragraphStyle': {'namedStyleType': 'NORMAL_TEXT'},
        'fields': 'namedStyleType'
    }}])

    cursor = 1
    for block in blocks:
        start = cursor
        cursor = render_block_at(doc_id, cursor, block)
        tag_range(doc_id, NAMED_RANGE_PREFIX + block_hash(block), start, cursor)


# ---------- Diff-and-apply path ----------
def update_in_place(doc_id, blocks):
    doc = get_doc(doc_id)
    existing = extract_existing_units(doc)
    if not existing:
        full_rebuild(doc_id, blocks)
        return

    new_hashes = [block_hash(b) for b in blocks]
    existing_hashes = [u['hash'] for u in existing]

    sm = difflib.SequenceMatcher(a=existing_hashes, b=new_hashes, autojunk=False)
    opcodes = sm.get_opcodes()

    if DRY_RUN:
        print(f'[dry-run] existing tagged blocks: {len(existing)}')
        print(f'[dry-run] new blocks: {len(new_hashes)}')
        for tag, i1, i2, j1, j2 in opcodes:
            if tag == 'equal':
                print(f'  equal:   {i2 - i1} block(s) unchanged')
            elif tag == 'delete':
                print(f'  delete:  {i2 - i1} existing block(s) at doc index {existing[i1]["start"]}')
            elif tag == 'insert':
                kinds = ', '.join(blocks[j][0] for j in range(j1, j2))
                print(f'  insert:  {j2 - j1} new block(s) ({kinds})')
            elif tag == 'replace':
                kinds = ', '.join(blocks[j][0] for j in range(j1, j2))
                print(f'  replace: {i2 - i1} existing → {j2 - j1} new ({kinds}) at doc index {existing[i1]["start"]}')

    # Process in reverse so that earlier opcodes' indices (recorded in `existing`)
    # remain valid after later opcodes mutate higher portions of the doc.
    for tag, i1, i2, j1, j2 in reversed(opcodes):
        if tag == 'equal':
            continue

        if tag in ('delete', 'replace'):
            start = existing[i1]['start']
            end = existing[i2 - 1]['end']
            # deleteContentRange also removes any namedRanges fully contained in the range.
            batch(doc_id, [{'deleteContentRange': {'range': {'startIndex': start, 'endIndex': end}}}])
            insert_pos = start
        else:  # 'insert'
            if i1 < len(existing):
                insert_pos = existing[i1]['start']
            else:
                insert_pos = end_idx(doc_id) - 1

        if tag in ('insert', 'replace'):
            cursor = insert_pos
            for j in range(j1, j2):
                block = blocks[j]
                block_start = cursor
                cursor = render_block_at(doc_id, cursor, block)
                tag_range(doc_id, NAMED_RANGE_PREFIX + block_hash(block), block_start, cursor)


# ---------- Main ----------
def main():
    ap = argparse.ArgumentParser(description='Render a markdown file into a Google Doc; update in place on rerun.')
    ap.add_argument('--doc-id', required=True, help='Target Google Doc ID')
    ap.add_argument('--markdown', required=True, type=pathlib.Path, help='Path to the markdown source file')
    ap.add_argument('--rebuild', action='store_true', help='Force a full clear+rebuild instead of diff-update')
    ap.add_argument('--dry-run', action='store_true', help='Print what would change without sending any writes')
    args = ap.parse_args()

    global DRY_RUN
    DRY_RUN = args.dry_run

    doc_id = args.doc_id
    md_path = args.markdown.expanduser()
    if not md_path.is_file():
        sys.exit(f'Markdown file not found: {md_path}')

    md = md_path.read_text()
    blocks = annotate_blocks(parse_blocks(md))

    if args.rebuild:
        if DRY_RUN:
            print(f'[dry-run] would rebuild — {len(blocks)} blocks to render')
        full_rebuild(doc_id, blocks)
    else:
        update_in_place(doc_id, blocks)

    if DRY_RUN:
        print(f'[dry-run] no changes sent to https://docs.google.com/document/d/{doc_id}/edit')
    else:
        print(f'Done: https://docs.google.com/document/d/{doc_id}/edit')


if __name__ == '__main__':
    main()
