local null_ls = require("null-ls")
local b = null_ls.builtins

local diagnostics_code_template = "#{m} [#{c}]"

local with_root_file = function(...)
    local files = { ... }
    return function(utils)
        return utils.root_has_file(files)
    end
end

local sources ={
    b.formatting.autopep8.with({
        extra_args={'--max-line-length=100'},
    }),
    -- b.diagnostics.flake8.with({
    --     extra_args={'--max-line-length=100'},
    --     diagnostics_format = diagnostics_code_template,
    --     condition = function (utils)
    --         return not utils.root_has_file({'.pylintrc'})
    --     end
    -- }),
    b.diagnostics.pylint.with({
        diagnostics_format = diagnostics_code_template,
        condition = function (utils)
            return utils.root_has_file({'.pylintrc'})
        end
    }),
    b.formatting.prettierd.with({
        filetypes = {
            'html', 'css', 'typescript', 'typescriptreact', 'javascriptreact'
        }
    }),
    b.formatting.rustfmt,
    -- b.diagnostics.write_good.with({
    --     filetypes = {'markdown', 'org'}
    -- }),
    -- b.completion.spell.with({
    --     filetypes = {'org', 'markdown', 'txt'}
    -- })
}


local M = {}
M.setup = function(on_attach)
    if not vim.g.started_by_firenvim then
        null_ls.setup({
            -- debug = true,
            sources = sources,
            on_attach = on_attach,
        })
    end
end

return M
