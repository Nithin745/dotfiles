local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- Python
  -- b.diagnostics.pylint.with({
  --   extra_args = {'--load-plugins', 'pylint_django'}
  -- }),
  b.formatting.black.with({
    extra_args = {'-l', '120'}
  }),
  b.formatting.isort

}

null_ls.setup {
  debug = false,
  sources = sources,
}
