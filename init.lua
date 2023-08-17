vim.g.mapleader = '='
vim.g.maplocalleader = '='
vim.g.kitty_fast_forwarded_modifiers = 'super'

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- [[ Setting options ]]
-- See `:help vim.o`

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Highlight current line as cursor
vim.o.cursorline = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- set termguicolors to enable highlight groups
vim.o.termguicolors = true;

-- Renders spaces as "·"
vim.opt.list = true
vim.opt.listchars = vim.opt.listchars + "space:·"
vim.g.camelcasemotion_key = "<leader>"

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Specific configuration for vscode-nvim
local if_not_vscode = function() return not vim.g.vscode end

require('lazy').setup({
  'github/copilot.vim',
  -- Git managmenet
  'tpope/vim-fugitive',
  -- Allows openning git urls
  'tpope/vim-rhubarb',
  'lewis6991/fileline.nvim',
  -- Autosave, not sure why I have it
  'pocco81/auto-save.nvim',
  -- Multi cursor support
  'mg979/vim-visual-multi',
  'weilbith/nvim-code-action-menu',
  'nkrkv/nvim-treesitter-rescript',
  'jparise/vim-graphql',
  'easymotion/vim-easymotion',
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require("project_nvim").setup({
        show_hidden = false,
        silent_chdir = false,
        detection_methods = { "patterns" },
        patterns = { ".git" }
      })
    end
  },
  -- Camel case motion plugin
  {
    "bkad/CamelCaseMotion",
    config = function()
    end
  },
  -- Toggle terminal plugin
  {
    "NvChad/nvterm",
    config = function()
      require("nvterm").setup()
      local toggleTerm = function() require("nvterm.terminal").toggle("horizontal") end;

      vim.keymap.set('n', '<A-C>', toggleTerm, {});
      vim.keymap.set({ 'n', 't' }, '<D-S-c>', toggleTerm, {});
    end,
  },
  -- NOTE: This is here your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim',  opts = {} },

  {
    -- Adds git releated signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
          { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
          { buffer = bufnr, desc = '[G]it go to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>gd', require('gitsigns').preview_hunk,
          { buffer = bufnr, desc = '[G]it [D]iff Hunk' })

        vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { buffer = bufnr, desc = '[G]it [R]eset hunk' })
        vim.keymap.set('n', '<leader>gb', require('gitsigns').toggle_current_line_blame,
          { buffer = bufnr, desc = '[G]it [B]lame' })
      end,
    },
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'palenight',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- Surround text objects with quotes, brackets, etc
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup()
    end
  },

  -- Automatically fill/change/remove xml-like tags
  {
    "https://github.com/windwp/nvim-ts-autotag",
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim' }
  },

  -- Project specific marks for most editable files
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("harpoon").setup({
        global_settings = {
          save_on_toggle = true,
          save_on_change = true,
        },
        projects = {
          ["~/dev/"] = {
            term = {
              cmds = {
                "yarn dev",
                "yarn test",
                "yarn lint",
                "yarn build",
              },
              size = 0.5,
              pos = "bottom",
            },
            mark = {
              marks = { "1", "2", "3", "4" },
              sign = false,
              hl = "String",
              numhl = "Comment",
              size = 1,
              hidden = false,
              stacked = false,
            },
          },
        },
      })

      vim.keymap.set('n', '<A-h>', require("harpoon.ui").toggle_quick_menu, { noremap = true })
      vim.keymap.set('n', '<A-a>', require("harpoon.mark").add_file, { noremap = true })

      vim.keymap.set('n', '<F1>', function() require("harpoon.ui").nav_file(1) end, {})
      vim.keymap.set('n', '<F2>', function() require("harpoon.ui").nav_file(2) end, {})
      vim.keymap.set('n', '<F3>', function() require("harpoon.ui").nav_file(3) end, {})
      vim.keymap.set('n', '<F4>', function() require("harpoon.ui").nav_file(4) end, {})
    end
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          max_lines = 3
        }
      },
    },
    build = ':TSUpdate',
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    cond = if_not_vscode,
    dependencies = {
      {
        'nvim-tree/nvim-web-devicons',
        config = function()
          require("nvim-web-devicons").setup()
        end
      }
    },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        view = {
          width = 40,
          centralize_selection = true
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
        update_focused_file = {
          enable = true,
          update_root = false,
          ignore_list = {}
        }
      })

      vim.keymap.set('n', '<D-b>', ':NvimTreeToggle<CR>', { noremap = true })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    cond = if_not_vscode,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'kosayoda/nvim-lightbulb',
    lazy = false,
    config = function()
      require("nvim-lightbulb").setup({
        autocmd = { enabled = true }
      })
    end
  },
  -- This plugins is already deprecated but it seems to be the only way to choose which formatters
  -- from the lsp config to use for specific filetypes. And it works pretty well
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local null_ls = require "null-ls"

      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      local formatting = null_ls.builtins.formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      -- local diagnostics = null_ls.builtins.diagnostics

      null_ls.setup {
        debug = false,
        sources = {
          formatting.prettierd.with {
            extra_filetypes = { "toml", "solidity" },
          },
          formatting.stylua,
          formatting.ocamlformat,
          formatting.clang_format.with {
            filetypes = { "cpp", "c" },
          },
        },
      }
    end,
  },
}, {})


-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
require('telescope').load_extension('projects')

-- Set telescope keymaps
vim.keymap.set('n', '<D-f>', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    previewer = true,
  })
end, { desc = '] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<D-p>', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<D-o>', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })

vim.keymap.set('n', '<D-k>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<D-S-f>', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<D-C-r>', ':Telescope projects<CR>', { desc = '[S]earch [P]projects' })

vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim', 'rescript' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<D-e>', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<D-S-m>', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_lsp_attach = function(_, bufnr)
  local lsp_map = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  lsp_map('<D-r>', vim.lsp.buf.rename, '[R]e[n]ame')
  lsp_map('<D-.>', ':CodeActionMenu<CR>', '[C]ode [A]ction')

  lsp_map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  lsp_map('<D-g>', vim.lsp.buf.definition, '[G]oto [D]efinition')
  lsp_map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  lsp_map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  lsp_map('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  lsp_map('<D-A-g>', vim.lsp.buf.type_definition, 'Type [D]efinition')

  lsp_map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  lsp_map('<D-i>', vim.lsp.buf.hover, 'Hover Documentation')
  lsp_map('<D-u>', vim.lsp.buf.signature_help, 'Signature Documentation')
  lsp_map('<A-F>', vim.lsp.buf.format, 'Format')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  eslint = { filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' } },
  rust_analyzer = {
    inlayHints = {
      enabled = true,
      parameterNames = "none",
      typeHints = true,
    },
    imports = {
      granularity = {
        group = "module",
      },
      prefix = "self",
    },
    cargo = {
      buildScripts = {
        enable = true,
      },
    },
    procMacro = {
      enable = true
    },
    checkOnSave = {
      command = "clippy"
    },
  },
  tsserver = {},
  html = { filetypes = { 'html', 'twig', 'hbs' } },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_lsp_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'

-- Loads all the snippets installed by extensions in vscode.
-- require('luasnip.loaders.from_vscode').lazy_load()
require("luasnip.loaders.from_vscode").load({ paths = "~/.config/nvim/snippets" })

luasnip.config.setup {}

-- Make sure that we can work with luasnip and copilot at the same time
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      -- provide a value for copilot to fallback if there is no suggestion to accept. If no suggestion accept mimic normal tab behavior.
      local tab_shift_width = vim.opt.shiftwidth:get()
      local copilot_keys = vim.fn['copilot#Accept'](string.rep(' ', tab_shift_width))

      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif copilot_keys ~= '' and type(copilot_keys) == 'string' then
        vim.api.nvim_feedkeys(copilot_keys, 'i', true)
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- Set all the overrides and the extensions for the things that are available in native vim
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- My lovely vertical navigation speedups
vim.keymap.set({ 'n', 'v' }, '<C-j>', '}', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<C-k>', '{', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'J', '10j', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'K', '10k', { silent = true })

-- Move lines up and down
vim.api.nvim_set_keymap('n', '<A-j>', "V:move '>+1<CR>gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<A-j>', ":move '>+1<CR>gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', "V:move '>-2<CR>gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<A-k>', ":move '<-2<CR>gv", { noremap = true, silent = true })

-- Make backpsace work as black hole cut
vim.api.nvim_set_keymap('n', '<backspace>', '"_x', { noremap = true })
vim.api.nvim_set_keymap('v', '<backspace>', '"_d', { noremap = true })

-- Paste line on cmd+v
vim.api.nvim_set_keymap('n', '<D-v>', 'p', { noremap = true })
vim.api.nvim_set_keymap('i', '<D-v>', '<C-r>+', { noremap = true })

-- Write file on cmd+s
vim.api.nvim_set_keymap('n', '<D-s>', ':w<CR>', { noremap = true })
-- Open git
vim.api.nvim_set_keymap('n', '<A-g>', ':Git<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<D-S-g>', ':Git<CR>', { silent = true })

-- Map multi cursor view to the cmd
vim.api.nvim_set_keymap('n', '<D-d>', '<C-n>', { silent = true })
vim.api.nvim_set_keymap('v', '<D-d>', '<C-n>', { silent = true })

-- Delete a word by alt+backspace
vim.api.nvim_set_keymap('i', '<A-BS>', '<C-w>', { noremap = true })

-- Select whole buffer
vim.api.nvim_set_keymap('n', '<D-a>', 'ggVG', {})

-- Comment out lines
vim.api.nvim_set_keymap('n', '<D-/>', 'gc_', {})
vim.api.nvim_set_keymap('v', '<D-/>', 'gc', {})

-- Switch between buffers
vim.keymap.set('n', 'H', ':bprevious<CR>', { silent = true })
vim.keymap.set('n', 'L', ':bnext<CR>', { silent = true })

-- Duplicate lines
vim.api.nvim_set_keymap('v', '<D-C-Up>', 'y`>p`<', { silent = true })
vim.api.nvim_set_keymap('n', '<D-C-Up>', 'Vy`>p`<', { silent = true })
vim.api.nvim_set_keymap('v', '<D-C-Down>', 'y`<kp`>', { silent = true })
vim.api.nvim_set_keymap('n', '<D-C-Down>', 'Vy`<p`>', { silent = true })

-- Exit terminal mode with Esc
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { nowait = true })
-- Opens file under cursor in the panel above
vim.api.nvim_set_keymap('n', 'gf', 'yiW<C-w>k:e <C-r>"<CR>', { silent = true })
