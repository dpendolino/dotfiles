#!/bin/sh
# Claude Code status line — Dracula + powerline arrows, no background colors

input=$(cat)

# Dracula palette (true color, fg only)
PINK=$(printf '\033[38;2;255;121;198m')
PURPLE=$(printf '\033[38;2;189;147;249m')
CYAN=$(printf '\033[38;2;139;233;253m')
GREEN=$(printf '\033[38;2;80;250;123m')
YELLOW=$(printf '\033[38;2;241;250;140m')
ORANGE=$(printf '\033[38;2;255;184;108m')
RED=$(printf '\033[38;2;255;85;85m')
FG=$(printf '\033[38;2;248;248;242m')
DIM=$(printf '\033[38;2;98;114;164m')
RST=$(printf '\033[0m')

# Powerline symbols
PL=''     # U+E0B0 filled right arrow
PL_THIN=''  # U+E0B1 thin right arrow

# Nerd Font icons (explicit UTF-8 bytes)
ICON_USER=$(printf '\xef\x80\x87')   # U+F007 nf-fa-user
ICON_HOST=$(printf '\xef\x84\x89')   # U+F109 nf-fa-laptop
ICON_DIR=$(printf '\xef\x81\xbb')    # U+F07B nf-fa-folder
ICON_MODEL=$(printf '\xef\x82\x85')  # U+F085 nf-fa-cogs
ICON_CTX=$(printf '\xef\x82\x80')    # U+F080 nf-fa-bar_chart
ICON_TIME=$(printf '\xef\x80\x97')   # U+F017 nf-fa-clock_o
ICON_VIM=$(printf '\xee\x98\xab')    # U+E62B nf-dev-vim

user=$(whoami | tr '[:upper:]' '[:lower:]')
host=$(hostname -s | cut -d'-' -f1 | tr '[:upper:]' '[:lower:]')
dir=$(basename "$(pwd)" | tr '[:upper:]' '[:lower:]')

# Prefix: icon + colored segments separated by powerline arrows
prefix="${PINK}${ICON_USER}  ${user} ${DIM}${PL}${CYAN}${ICON_DIR}  ${dir} ${DIM}${PL}${RST}"

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')

used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used_pct" ]; then
  pct_int=$(printf "%.0f" "$used_pct")
  if [ "$pct_int" -ge 80 ]; then
    ctx_color="$RED"
  elif [ "$pct_int" -ge 50 ]; then
    ctx_color="$ORANGE"
  else
    ctx_color="$GREEN"
  fi
  ctx="${ctx_color}${ICON_CTX} ${pct_int}%${RST}"
else
  ctx="${DIM}${ICON_CTX} --%${RST}"
fi

five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
limits=""
if [ -n "$five" ]; then
  limits="${ORANGE}${ICON_TIME} 5h:$(printf "%.0f%%" "$five")${RST}"
fi
if [ -n "$week" ]; then
  week_fmt="${ORANGE}7d:$(printf "%.0f%%" "$week")${RST}"
  if [ -n "$limits" ]; then
    limits="$limits $week_fmt"
  else
    limits="$week_fmt"
  fi
fi

vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    normal)  vim_color="$GREEN"  ;;
    insert)  vim_color="$PINK"   ;;
    visual)  vim_color="$PURPLE" ;;
    replace) vim_color="$RED"    ;;
    *)       vim_color="$YELLOW" ;;
  esac
  vim_section="${vim_color}${ICON_VIM} ${vim_mode}${RST}"
fi

sep="${DIM}  ${PL_THIN}  ${RST}"
sep_tight="${DIM} ${PL_THIN} ${RST}"
parts="${prefix} ${YELLOW}${ICON_MODEL} ${model}${RST}${sep_tight}${ctx}"
[ -n "$limits" ] && parts="${parts}${sep}${limits}"
[ -n "$vim_mode" ] && parts="${parts}${sep_tight}${vim_section}"

printf "%s" "$parts"
