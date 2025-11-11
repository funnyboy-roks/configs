local cmp = require 'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED by nvim-cmp. get rid of it once we can
        expand = function(args)
            vim.fn['vsnip#anonymous'](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<M-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    }),
    sources = cmp.config.sources({
        -- TODO: currently snippets from lsp end up getting prioritized -- stop that!
        { name = 'nvim_lsp' },
    }
   --  ,
   --  {
   --      { name = 'path' },
   --  }
),
    experimental = {
        ghost_text = true,
    },
})

-- Enable completing paths in :
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' }
    })
})

CustomHover = function()
    vim.lsp.buf.hover({
        border = { '', '', '', ' ', '', '', '', ' ' }
    })
end

-- Setup lspconfig.
local on_attach = function(lang)
    return function(_, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        --Enable completion triggered by <c-x><c-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        local opts = { noremap = true, silent = true }

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
        if lang ~= 'C' then
            buf_set_keymap('n', 'K', '<Cmd>lua CustomHover()<CR>', opts)
        end
        buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
        buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
        buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
        buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
        buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
        buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
        buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
        buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
        buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
        buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.format()<CR>', opts)


        -- Get signatures (and _only_ signatures) when in argument lists.
        require 'lsp_signature'.on_attach({
            doc_lines = 0,
            handler_opts = {
                border = 'none'
            },
        })
    end
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        signs = true,
        update_in_insert = true,
    }
)

local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.enable('rust_analyzer')
vim.lsp.config('rust_analyzer', {
    on_attach = on_attach(),
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        ['rust-analyzer'] = {
            check = {
                command = 'clippy',
            },
            cargo = {
                allFeatures = true,
            },
            completion = {
                postfix = {
                    enable = false,
                },
            },
        },
    },
    capabilities = capabilities,
})

vim.lsp.enable('ts_ls')
vim.lsp.config('ts_ls', {
    on_attach = on_attach(),
})

-- lspconfig.denols.setup{
--     on_attach = on_attach(),
-- }

vim.lsp.enable('eslint')
vim.lsp.config('eslint', {
    on_attach = on_attach(),
})

vim.lsp.enable('svelte')
vim.lsp.config('svelte', {
    on_attach = on_attach(),
})

vim.lsp.enable('clangd')
vim.lsp.config('clangd', {
    on_attach = on_attach('C'),
})

vim.lsp.enable('tinymist')
vim.lsp.config('tinymist', {
    on_attach = on_attach(),
})

vim.lsp.enable('jdtls')
vim.lsp.config('jdtls', {
    on_attach = on_attach(),
    settings = {
        java = {
            signatureHelp = { enabled = true },
        },
    },
})
-- lspconfig.java_language_server.setup {
--     cmd = { '/home/funnyboy_roks/dev/lsp/java-language-server/dist/lang_server_linux.sh' },
--     settings = {
--         java = {
--             externalDependencies = {
--                 'org.antlr:antlr4-runtime:4.13.2'
--             }
--         }
--     }
-- }

vim.lsp.enable('hls')
vim.lsp.config('hls', {
    on_attach = on_attach(),
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
})

vim.lsp.enable('zls')
vim.lsp.config('zls', {
    on_attach = on_attach(),
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
})
