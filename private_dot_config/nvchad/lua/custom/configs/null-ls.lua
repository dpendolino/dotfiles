local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with({ filetypes = { "html", "markdown", "css" } }), -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,
  b.diagnostics.luacheck.with({ extra_args = { "--global vim" } }),

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),

  -- Python
  b.formatting.autopep8,

  -- Go
  b.diagnostics.golangci_lint,
  b.formatting.gofmt,

  -- Ruby
  b.diagnostics.rubocop,

  -- Yaml
  b.diagnostics.yamllint,

  -- cpp
  b.formatting.clang_format,

  -- vale
  b.diagnostics.vale.with({ filetypes = { "md", "markdown", "tex", "asciidoc" } }),

  -- terraform
  b.formatting.terraform_fmt,

  -- packer/hcl
  b.formatting.packer,

  -- GH Actions https://github.com/rhysd/actionlint
  b.diagnostics.actionlint,

  -- nix language
  b.formatting.nixfmt,
}

null_ls.setup({
  debug = true,
  sources = sources,
})
