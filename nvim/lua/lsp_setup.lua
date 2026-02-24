vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            check = {
                command = 'clippy',
            },
            cargo = {
                allFeatures = true,
                targetDir = '/home/funnyboy_roks/.cargo-target',
            },
            completion = {
                postfix = {
                    enable = false,
                },
            },
        },
    },
})
vim.lsp.enable('rust_analyzer')

-- vim.lsp.enable('ts_ls')
vim.lsp.enable('denols')
vim.lsp.enable('eslint')
vim.lsp.enable('svelte')

vim.lsp.enable('clangd')

vim.lsp.enable('tinymist')

vim.lsp.config('jdtls', {
    settings = {
        java = {
            signatureHelp = { enabled = true },
        },
    },
})
vim.lsp.enable('jdtls')

vim.lsp.config('kotlin_lsp', {
    cmd = { "/home/fbr/downloads/kotlin-lsp/kotlin-lsp.sh", "--stdio" }
})
vim.lsp.enable('kotlin_lsp')

vim.lsp.config('hls', {
    filetypes = { 'haskell', 'lhaskell', 'cabal' },
})
vim.lsp.enable('hls')

vim.lsp.enable('zls')

vim.lsp.enable('openscad_lsp')


-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'


        CustomHover = function()
            vim.lsp.buf.hover({
                border = { '', '', '', ' ', '', '', '', ' ' },
            })
        end

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', CustomHover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        --vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, opts)

        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- TODO: find some way to make this only apply to the current line.
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end

        -- None of this semantics tokens business.
        -- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
        client.server_capabilities.semanticTokensProvider = nil

        -- format on save for Rust
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
                pattern = '*.rs',
                group = vim.api.nvim_create_augroup("RustFormat", { clear = true }),
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
})
