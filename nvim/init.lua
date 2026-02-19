vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-- prevent folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'
vim.opt.foldlevelstart = 99

vim.opt.scrolloff = 2
vim.opt.wrap = false
vim.opt.signcolumn = 'yes'
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.grepprg = 'rg --vimgrep'

-- Fix C switch indent: https://vi.stackexchange.com/questions/5218/auto-indent-the-key-of-c-switch-block/5221#5221
-- Fix Java indent: https://neovim.io/doc/user/indent.html#java-cinoptions
vim.opt.cinoptions:append('l1', 'j1')

vim.opt.splitright = true
vim.opt.splitbelow = true

-- configure mouse
vim.opt.mouse = 'a'
vim.opt.mousemodel = 'extend'

-- like vimdid, but ends up in ~/.local/state/nvim/undo/
vim.opt.undofile = true

vim.opt.wildmode = 'list:longest'
-- Don't recommend files which match these patterns
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

-- Setup tabs
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- search options
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

-- diff configuration
vim.opt.diffopt:append('iwhite')
-- Better diff algorithm
-- https://vimways.org/2018/the-power-of-diff/
-- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
-- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')

-- colorcolumn at 80 for all files
vim.opt.colorcolumn = '80'
-- override colorcolumn for rust
vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })

-- invis list
vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'

--------------
-- Keybinds --
--------------

-- quickly save
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')
-- ; -> :
vim.keymap.set('n', ';', ':')
-- I know how to quit vim, thanks
vim.keymap.set('n', '<C-c>', '<nop>')
-- switch between buffers
vim.keymap.set('n', '<leader><leader>', '<c-^>')
-- show invisible characters
vim.keymap.set('n', '<leader>,', '<cmd>set invlist<cr>')
-- replace up to _
vim.keymap.set('n', '<leader>m', 'ct_')

-- F1 show syntax token under the cursor (useful for highlighting changes)
-- TODO: translate this to lua
vim.keymap.set('n', '<F1>', ':echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . "> trans<" . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>', { silent = true });
vim.keymap.set('n', '<F8>', ':echo synIDattr(synID(line("."), col("."), 1), "name")<cr>')

-- start/end of line
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')
-- visual line
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
-- bigger line step
vim.keymap.set('', '<A-j>', '10gj')
vim.keymap.set('', '<A-k>', '10gk')

-- no arrow keys
vim.keymap.set('n', '<up>', '<nop>')
vim.keymap.set('n', '<down>', '<nop>')
vim.keymap.set('i', '<up>', '<nop>')
vim.keymap.set('i', '<down>', '<nop>')
vim.keymap.set('i', '<left>', '<nop>')
vim.keymap.set('i', '<right>', '<nop>')

-- left/right for switch buffers
vim.keymap.set('n', '<left>', '<cmd>bp<cr>')
vim.keymap.set('n', '<right>', '<cmd>bn<cr>')

-- C-k and C-j as up and down
vim.keymap.set('s', '<C-j>', '<Down>')
vim.keymap.set('x', '<C-j>', '<Down>')
vim.keymap.set('c', '<C-j>', '<Down>')
vim.keymap.set('o', '<C-j>', '<Down>')
vim.keymap.set('l', '<C-j>', '<Down>')
vim.keymap.set('t', '<C-j>', '<Down>')
vim.keymap.set('s', '<C-k>', '<Up>')
vim.keymap.set('x', '<C-k>', '<Up>')
vim.keymap.set('c', '<C-k>', '<Up>')
vim.keymap.set('o', '<C-k>', '<Up>')
vim.keymap.set('l', '<C-k>', '<Up>')
vim.keymap.set('t', '<C-k>', '<Up>')

-- center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })

-- copy with system clipboard
vim.keymap.set('n', '<leader>p', '"+p');
vim.keymap.set('n', '<leader>P', '"+P');
vim.keymap.set('n', '<leader>y', '"+y');

-- magic in search 
vim.keymap.set('n', '?', '?\\v')
vim.keymap.set('n', '/', '/\\v')
vim.keymap.set('c', '%s/', '%sm/')

-- open new file adjacent to the current file
vim.keymap.set('n', '<leader>o', ':e <C-R>=expand("%:p:h") . "/" <cr>')

---------------------
-- Custom Commands --
---------------------


------------------
-- Autocommands --
------------------

-- Highlight on yank
vim.api.nvim_create_autocmd(
    'TextYankPost',
    {
        pattern = '*',
        callback = function()
            vim.highlight.on_yank {higroup="IncSearch", timeout=150}
        end
    }
)

-- jump to previous location when opening a file
vim.api.nvim_create_autocmd(
    'BufReadPost',
    {
        pattern = '*',
        callback = function(ev)
            if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
                -- except for in git commit messages
                -- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
                if not vim.fn.expand('%:p'):find('.git', 1, true) then
                    vim.cmd('exe "normal! g\'\\""')
                end
            end
        end
    }
)

-- custom filetypes
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.mcmeta', command = 'set filetype=json' })
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.fsh,*.vsh', command = 'set filetype=glsl' })
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.st', command = 'set filetype=stark' })

local text = vim.api.nvim_create_augroup('text', { clear = true })
for _, pat in ipairs({'text', 'markdown', 'mail', 'gitcommit'}) do
	vim.api.nvim_create_autocmd('Filetype', {
		pattern = pat,
		group = text,
		command = 'setlocal spell tw=72 colorcolumn=73',
	})
end

vim.diagnostic.config({ virtual_text = true, virtual_lines = false })

-------------
-- plugins --
-------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- then, setup!
require("lazy").setup({
	 -- main color scheme
     {
     	"bradcush/nvim-base16",
     	lazy = false, -- load at start
     	priority = 1000, -- load first
     	config = function()
     		vim.cmd([[colorscheme base16-circus]])
     		vim.o.background = 'dark'
     		vim.cmd([[hi Normal ctermbg=NONE]])

     		vim.api.nvim_set_hl(0, "WinSeparator", { fg = '#181818' })

     		vim.api.nvim_set_hl(0, 'PmenuSel', { link = 'Visual' })


             -- compound initialisers in C have an error for the {}.
             -- https://github.com/neovim/neovim/issues/14980
             -- https://stackoverflow.com/questions/55643206/where-can-i-reset-the-highlighting-for-cerrinparen-and-cerrinbracket-in-vim
             vim.api.nvim_create_autocmd('BufRead', {
                 pattern = '*.[ch]',
                 command = 'syntax clear cErrInParen'
             })
             vim.api.nvim_create_autocmd('BufRead', {
                 pattern = '*.[ch]',
                 command = 'syntax clear cParenError'
             })
                     

             vim.api.nvim_set_hl(0, 'NormalFloat', {
                 link = 'StatusLineNC',
             })
             vim.api.nvim_set_hl(0, 'FloatBorder', {
                 link = 'StatusLineNC',
             })
     	end
     },
     -- better %
     {
     	'andymass/vim-matchup',
     	config = function()
     		vim.g.matchup_matchparen_offscreen = { method = 'popup' }
            vim.g.matchup_treesitter_disabled = { "markdown" }
     	end
     },
     -- auto-cd to root of git project
     {
     	'notjedi/nvim-rooter.lua',
     	config = function()
     		require('nvim-rooter').setup()
     	end
     },
     -- fzf support for ^p
     {
     	'ibhagwan/fzf-lua',
     	config = function()
     		-- stop putting a giant window over my editor
     		require'fzf-lua'.setup{
     			winopts = {
     				split = "belowright 10new",
     				preview = {
     					hidden = true,
     				}
     			},
     			files = {
     				file_icons = false,
     				git_icons = false,
     				_fzf_nth_devicons = true,
     			},
     			buffers = {
     				file_icons = false,
     				git_icons = false,
     			},
     			fzf_opts = {
     				-- no reverse view
     				["--layout"] = "default",
     			},
     		}
     		-- when using C-p for quick file open, pass the file list through
     		--
     		--   https://github.com/jonhoo/proximity-sort
     		--
     		-- to prefer files closer to the current file.
     		vim.keymap.set('', '<C-p>', function()
     			opts = {}
     			opts.cmd = 'fd --color=never --hidden --type f --type l --exclude .git'
     			local base = vim.fn.fnamemodify(vim.fn.expand('%'), ':h:.:S')
     			if base ~= '.' then
     				-- if there is no current file,
     				-- proximity-sort can't do its thing
     				opts.cmd = opts.cmd .. (" | proximity-sort %s"):format(vim.fn.shellescape(vim.fn.expand('%')))
     			end
     			opts.fzf_opts = {
     			  ['--scheme']    = 'path',
     			  ['--tiebreak']  = 'index',
     			  ["--layout"]    = "default",
     			}
     			require'fzf-lua'.files(opts)
     		end)
     		-- use fzf to search buffers as well
     		vim.keymap.set('n', '<leader>;', function()
     			require'fzf-lua'.buffers({
     				-- just include the paths in the fzf bits, and nothing else
     				-- https://github.com/ibhagwan/fzf-lua/issues/2230#issuecomment-3164258823
     				fzf_opts = {
     				  ["--with-nth"]      = "{-3..-2}",
     				  ["--nth"]           = "-1",
     				  ["--delimiter"]     = "[:\u{2002}]",
     				  ["--header-lines"]  = "false",
     				},
     				header = false,
     			})
     		end)
     	end
     },
     -- LSP
     {
     	'neovim/nvim-lspconfig',
     	config = function()
     		-- Setup language servers.
             require('./lsp_setup')
     	end
     },
     -- LSP-based code-completion
     {
     	"hrsh7th/nvim-cmp",
     	-- load cmp on InsertEnter
     	event = "InsertEnter",
     	-- these dependencies will only be loaded when cmp loads
     	-- dependencies are always lazy-loaded unless specified otherwise
     	dependencies = {
     		'neovim/nvim-lspconfig',
     		"hrsh7th/cmp-nvim-lsp",
     		"hrsh7th/cmp-buffer",
     		"hrsh7th/cmp-path",
     	},
     	config = function()
     		local cmp = require'cmp'
     		cmp.setup({
     			snippet = {
     				-- REQUIRED by nvim-cmp. get rid of it once we can
     				expand = function(args)
     					vim.snippet.expand(args.body)
     				end,
     			},
     			mapping = cmp.mapping.preset.insert({
     				['<C-b>'] = cmp.mapping.scroll_docs(-4),
     				['<C-f>'] = cmp.mapping.scroll_docs(4),
     				['<M-Space>'] = cmp.mapping.complete(),
     				['<C-e>'] = cmp.mapping.abort(),
     				-- Accept currently selected item.
     				-- Set `select` to `false` to only confirm explicitly selected items.
     				['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
                     ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                     ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
     			}),
     			sources = cmp.config.sources({
     				{ name = 'nvim_lsp' },
     			}, {
     				{ name = 'path' },
     			}),
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
     	end
     },
     -- inline function signatures
     {
     	"ray-x/lsp_signature.nvim",
     	event = "VeryLazy",
     	opts = {},
     	config = function(_, opts)
     		-- Get signatures (and _only_ signatures) when in argument lists.
     		require "lsp_signature".setup({
     			doc_lines = 0,
     			handler_opts = {
     				border = "none"
     			},
     		})
     	end
     },

     'tpope/vim-abolish',
     'junegunn/vim-easy-align',
     {
         'vim-scripts/transpose-words',
         config = function()
     		vim.keymap.set('n', 'gn', '<plug>Transposewords')
         end
     },

     -- language support
     'mfussenegger/nvim-jdtls',
     'cespare/vim-toml',
     'stephpy/vim-yaml',
     'dag/vim-fish',
     {
         'preservim/vim-markdown',
         dependencies = {
             'godlygeek/tabular',
         },
         config = function()
             -- support frontmatter
             vim.g.vim_markdown_frontmatter = 1
             -- 'o' on a list item should insert at same level
             vim.g.vim_markdown_new_list_item_indent = 0
             -- don't add bullets when wrapping:
             -- https://github.com/preservim/vim-markdown/issues/232
             vim.g.vim_markdown_auto_insert_bullets = 0
         end
     },
     -- 'lervag/vimtex',
     'othree/html5.vim',
     'pangloss/vim-javascript',
     'evanleck/vim-svelte',
     'GutenYe/json5.vim',
     'ron-rs/ron.vim',
     'tikhomirov/vim-glsl',
     'kaarmu/typst.vim',
     'zah/nim.vim',
     'sirtaj/vim-openscad',
})

