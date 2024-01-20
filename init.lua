vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.kitty_fast_forwarded_modifiers = "super"

local IS_STREAMING = os.getenv "STREAM" ~= nil
if IS_STREAMING then
  vim.print "Subscribe to my twitter @goose_plus_plus"
end

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enale mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  move this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"
vim.o.showmode = false

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Highlight current line as cursor
vim.o.cursorline = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- set termguicolors to enable highlight groups
vim.o.termguicolors = true

-- Renders spaces as "·"
vim.opt.list = true
vim.opt.listchars = vim.opt.listchars + "space:·"

vim.opt.swapfile = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "css", "html", "json", "yaml", "markdown" },
  callback = function()
    vim.opt.iskeyword:append { "-", "#", "$" }
  end,
})

-- Set terminal tab title to `filename (cwd)`
vim.opt.title = true
vim.opt.titlestring = '%t%( (%{fnamemodify(getcwd(), ":~:.")})%)'

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Specific configuration for vscode-nvim
local if_not_vscode = function()
  return not vim.g.vscode
end

require("lazy").setup({
  "github/copilot.vim",
  -- Git management
  "tpope/vim-fugitive",
  -- Allows cursor locations in the :e
  "lewis6991/fileline.nvim",
  -- Multi cursor support
  "mg979/vim-visual-multi",
  -- Quick code actions menu
  "weilbith/nvim-code-action-menu",
  -- A bunch of treesitter plugins
  "nkrkv/nvim-treesitter-rescript",
  "danielo515/tree-sitter-reason",
  "IndianBoy42/tree-sitter-just",
  "jparise/vim-graphql",
  { 'chentoast/marks.nvim',      opts = {} },
  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",
  -- Camel case motion plugin
  {
    "bkad/CamelCaseMotion",
    init = function()
      vim.g.camelcasemotion_key = "="
    end,
  },
  -- Allows correctly opening and closing nested nvims in the terminal
  {
    "samjwill/nvim-unception",
    init = function()
      vim.g.unception_delete_replaced_buffer = true
      vim.api.nvim_create_autocmd("User", {
        pattern = "UnceptionEditRequestReceived",
        callback = function()
          require("nvterm.terminal").hide "horizontal"
        end,
      })
    end,
  },
  {
    "smoka7/hop.nvim",
    version = "*",
    config = function()
      local hop = require "hop"
      local directions = require("hop.hint").HintDirection

      hop.setup {}

      vim.keymap.set("", "<leader>f", function()
        hop.hint_char2 { current_line_only = false }
      end, { remap = true, desc = "Hop 2 characters" })

      vim.keymap.set("", "f", function()
        hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true }
      end, { remap = true, desc = "Hop to next character (this line)" })
      vim.keymap.set("", "F", function()
        hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true }
      end, { remap = true, desc = "Hop to previous character (this line)" })
    end,
  },
  -- Handy rename in a floating method
  {
    "filipdutescu/renamer.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "ruifm/gitlinker.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("gitlinker").setup()
      vim.api.nvim_set_keymap(
        "n",
        "<leader>gg",
        '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>',
        { silent = true, desc = "Open git link in the browser" }
      )
    end,
  },
  -- Toggle terminal plugin
  {
    "NvChad/nvterm",
    opts = {
      terminals = {
        type_opts = {
          horizontal = { split_ratio = (IS_STREAMING and 0.5) or 0.3 },
        },
      },
    },
    init = function()
      vim.keymap.set({ "n", "t" }, "<D-S-c>", function()
        require("nvterm.terminal").toggle "horizontal"
      end, {})
    end,
  },
  -- NOTE: This is here your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
    },
  },

  {
    -- Autocompletion
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp",
      },
      "saadparwaiz1/cmp_luasnip",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",

      -- Adds a number of user-friendly snippets
      -- 'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { "folke/which-key.nvim",   opts = {} },

  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        vim.keymap.set(
          "n",
          "<leader>gp",
          require("gitsigns").prev_hunk,
          { buffer = bufnr, desc = "[G]o to [P]revious Hunk" }
        )
        vim.keymap.set(
          "n",
          "<leader>gn",
          require("gitsigns").next_hunk,
          { buffer = bufnr, desc = "[G]it go to [N]ext Hunk" }
        )
        vim.keymap.set(
          "n",
          "<leader>gd",
          require("gitsigns").preview_hunk,
          { buffer = bufnr, desc = "[G]it [D]iff Hunk" }
        )

        vim.keymap.set(
          "n",
          "<leader>gr",
          require("gitsigns").reset_hunk,
          { buffer = bufnr, desc = "[G]it [R]eset hunk" }
        )
        vim.keymap.set(
          "n",
          "<leader>gb",
          require("gitsigns").toggle_current_line_blame,
          { buffer = bufnr, desc = "[G]it [B]lame" }
        )
      end,
    },
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    cond = if_not_vscode,
    priority = 1000,
    opts = {
      integrations = {
        treesitter = true,
        telescope = true,
        notify = true,
        gitsigns = true,
        noice = true,
        dap = true,
        dap_ui = true,
        nvimtree = true,
      },
    },
    init = function()
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    priority = 1000,
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    -- See `:help lualine.txt`
    config = function()
      local catpuccin = require "catppuccin.palettes.mocha"

      local custom_catppuccin_theme = {
        normal = {
          a = { fg = catpuccin.crust, bg = catpuccin.mauve },
          b = { fg = catpuccin.mauve, bg = catpuccin.base },
          c = { fg = catpuccin.text, bg = catpuccin.base },
        },

        insert = { a = { fg = catpuccin.base, bg = catpuccin.peach, gui = "bold" } },
        visual = { a = { fg = catpuccin.base, bg = catpuccin.sky } },
        replace = { a = { fg = catpuccin.base, bg = catpuccin.green } },

        inactive = {
          a = { fg = catpuccin.text, bg = catpuccin.surface0 },
          b = { fg = catpuccin.text, bg = catpuccin.surface0 },
          c = { fg = catpuccin.text, bg = catpuccin.surface0 },
        },
      }

      require("lualine").setup {
        options = {
          disabled_filetypes = {
            statusline = { "NvimTree" },
          },
          theme = custom_catppuccin_theme,
          component_separators = "|",
          section_separators = "",
        },
      }
    end,
  },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "┊",
      },
      scope = {
        show_start = false,
        show_end = false,
      },
    },
    -- cond = function() return false end
  },

  -- Surround text objects with quotes, brackets, etc
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    opts = {},
  },

  -- Automatically fill/change/remove xml-like tags
  { "windwp/nvim-ts-autotag", opts = {} },

  -- "gc" to comment visual regions/lines
  { "numToStr/Comment.nvim",  opts = {} },

  -- Project specific marks for most editable files
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup {
        global_settings = {
          save_on_toggle = true,
          save_on_change = true,
          mark_branch = true,
          excluded_filetypes = { "harpoon", "NvimTree", "TelescopePrompt" },
        },
        projects = {
          ["~/dev/"] = {
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
      }

      vim.keymap.set(
        "n",
        "<leader>h",
        require("harpoon.ui").toggle_quick_menu,
        { noremap = true, desc = "Harpoon view" }
      )
      vim.keymap.set("n", "<leader>a", require("harpoon.mark").add_file, { noremap = true, desc = "Harpoon this path" })

      vim.keymap.set("n", "<leader>q", function()
        require("harpoon.ui").nav_file(1)
      end, { desc = "Harpoon #1" })
      vim.keymap.set("n", "<leader>w", function()
        require("harpoon.ui").nav_file(2)
      end, { desc = "Harpoon #2" })
      vim.keymap.set("n", "<leader>e", function()
        require("harpoon.ui").nav_file(3)
      end, { desc = "Harpoon #3" })
      vim.keymap.set("n", "<leader>r", function()
        require("harpoon.ui").nav_file(4)
      end, { desc = "Harpoon #4" })
      vim.keymap.set("n", "<leader>t", function()
        require("harpoon.ui").nav_file(5)
      end, { desc = "Harpoon #5" })
    end,
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          max_lines = IS_STREAMING and 1 or 3,
        },
      },
    },
    build = ":TSUpdate",
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    cond = if_not_vscode,
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
        opts = {
          override_by_extension = {
            ["toml"] = {
              icon = "",
              color = "#475569",
              name = "Toml",
            },
            ["patch"] = {
              icon = "",
              color = "#cbd5e1",
              name = "patch",
            },
          },
        },
      },
    },
    config = function()
      require("nvim-tree").setup {
        sort_by = "case_sensitive",
        respect_buf_cwd = true,
        sync_root_with_cwd = true,
        view = {
          width = IS_STREAMING and 30 or 35,
          centralize_selection = true,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
          custom = {
            "^.git$",
            "^.sl",
            "^.DS_Store",
            "^target",
            "node_modules",
          },
        },
        ui = {
          confirm = {
            remove = false,
            trash = false,
          },
        },
        update_focused_file = {
          enable = true,
          update_root = false,
          ignore_list = {},
        },
      }

      vim.keymap.set("n", "<D-b>", ":NvimTreeToggle<CR>", { noremap = true })
    end,
  },
  -- A lightbulb highlight for code actions
  {
    "kosayoda/nvim-lightbulb",
    lazy = false,
    config = function()
      require("nvim-lightbulb").setup {
        autocmd = { enabled = true },
      }
    end,
  },

  {
    "saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      enable_check_bracket_line = false,
    },
    init = function()
      local npairs = require "nvim-autopairs"
      local rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"

      npairs.add_rules { rule("|", "|", { "rust", "go", "lua" }):with_move(cond.after_regex "|") }
    end,
  },

  -- Global search and replace within cwd
  {
    "nvim-pack/nvim-spectre",
    config = function()
      local spectre = require "spectre"

      vim.keymap.set("n", "<D-S-r>", spectre.toggle, {
        desc = "Toggle Spectre",
      })
      vim.keymap.set("v", "<D-S-r>", spectre.open_visual, {
        desc = "Toggle Spectre",
      })
    end,
  },

  -- Better notifications and messagess
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        lsp_doc_border = false,
      },
      lsp = {
        hover = {
          enabled = false,
        },
      },
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
  },

  -- Follow up with the custom reusable configuration for plugins located in ~/lua folder
  require("telescope-lazy").lazy {},
  require("alpha-lazy").lazy {},
  require("dap-lazy").lazy {},
}, {})

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

-- Do not create swap files as this config autosaving
vim.opt.swapfile = false
vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave" }, {
  command = "silent! wa",
})

vim.filetype.add { extension = { wgsl = "wgsl" } }

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.configs").setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = {
    "c",
    "cpp",
    "go",
    "lua",
    "python",
    "rust",
    "tsx",
    "typescript",
    "vimdoc",
    "vim",
    "rescript",
    "markdown",
    "wgsl",
  },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = true,

  autotag = {
    enable = true,
    enable_close_on_slash = false,
  },

  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<c-space>",
      node_incremental = "<c-space>",
      scope_incremental = "<c-s>",
      node_decremental = "<S-space>",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["ap"] = "@parameter.outer",
        ["ip"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<A-p>"] = "@parameter.inner",
      },
      swap_previous = {
        ["<A-P>"] = "@parameter.inner",
      },
    },
  },
}

require("nvim-treesitter.install").compilers = { "gcc", "clang" }
require("nvim-treesitter.parsers").get_parser_configs().just = {
  install_info = {
    url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main",
    use_makefile = true, -- this may be necessary on MacOS (try if you see compiler errors)
  },
  maintainers = { "@IndianBoy42" },
}

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<D-e>", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<D-S-m>", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_lsp_attach = function(client, bufnr)
  local lsp_map = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, silent = true })
  end

  lsp_map("<D-r>", require("renamer").rename, "[R]e[n]ame")
  lsp_map("<D-.>", ":CodeActionMenu<CR>", "[C]ode [A]ction")

  lsp_map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  lsp_map("gD", vim.lsp.buf.definition, "[G]oto [D]eclaration")
  lsp_map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  lsp_map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

  lsp_map("<D-g>", "<C-]>", "[G]oto [D]efinition")
  lsp_map("<D-A-g>", vim.lsp.buf.type_definition, "Type [D]efinition")

  lsp_map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

  lsp_map("<D-i>", vim.lsp.buf.hover, "Hover Documentation")
  lsp_map("<D-u>", vim.lsp.buf.signature_help, "Signature Documentation")

  -- this appeared to be much easier way to hijack the formatter specifically for prettier
  -- because for other languages the automatic formatter is usually the best one
  local function format()
    local filetype = vim.api.nvim_buf_get_option(0, "filetype")
    if
        filetype == "typescript"
        or filetype == "typescriptreact"
        or filetype == "javascript"
        or filetype == "css"
        or filetype == "json"
        or filetype == "yaml"
        or filetype == "markdown"
        or filetype == "graphql"
        or filetype == "vue"
        or filetype == "svelte"
    then
      local Job = require "plenary.job"

      -- Get the content of the buffer
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      -- Get the filename of the current buffer
      local filename = vim.api.nvim_buf_get_name(bufnr)

      local output = {}
      local prettierd = Job:new {
        command = "prettierd",
        args = { "--stdin-filepath", filename }, -- Pass the --stdin-filepath option and filename
        writer = table.concat(lines, "\n"),      -- Provide the content of the buffer as stdin
        enable_handlers = true,                  -- Enable handlers for on_stdout and on_stderr
        on_stdout = function(_job, data)
          if data then
            table.insert(output, data)
          end
        end,

        on_exit = function(_job, code, _signal)
          if code == 0 then
            -- Update the buffer with the output of prettierd
            vim.schedule(function() -- schedule is used to avoid conflict with the event loop
              vim.api.nvim_buf_set_lines(bufnr, 0, #lines, false, output)
            end)
          else
            vim.notify(table.concat(output, "\n"), vim.log.levels.ERROR, { title = "Prettier failed" })
          end
        end,

        on_stderr = function(job, data)
          -- Print the error if there is one
          if data then
            vim.notify(data, vim.log.levels.ERROR, { title = "Prettierd" })
          end
        end,
      }

      -- Start the job
      prettierd:start()
    else
      vim.lsp.buf.format()
    end
  end

  vim.keymap.set({ "n", "i" }, "<F12>", format, { buffer = bufnr, desc = "Format", silent = true })
  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
    format()
  end, { desc = "Format current buffer with LSP" })
end

-- Enable the following language servers
local servers = {
  clangd = {
    filetypes = { "c", "cpp", "proto" },
    cmd = {
      "clangd",
      "--background-index",
      "--query-driver=/Users/dmtrkovalenko/.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-gcc",
      "--offset-encoding=utf-16",
    },
  },
  eslint = {
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  },
  tsserver = {},
  html = { filetypes = { "html", "twig", "hbs" } },
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  typos_lsp = {},
  grammarly = {
    -- Grammarly language server requires node js 16.4 ¯\_(ツ)_/¯
    -- https://github.com/neovim/nvim-lspconfig/issues/2007
    cmd = { "n", "run", "16.4", "/Users/dmtrkovalenko/.local/share/nvim/mason/bin/grammarly-languageserver", "--stdio" },
    filetypes = { "markdown", "text", "hgcommit", "gitcommit" },
  },
  pylsp = {},
  ocamllsp = {},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- it then vim cmp overrides only completion part of the text document. leave all other preassigned
capabilities.textDocument.completion =
    require("cmp_nvim_lsp").default_capabilities(capabilities).textDocument.completion

-- optimizes cpu usage source https://github.com/neovim/neovim/issues/23291
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

require("rust-tools").setup {
  tools = {
    executor = require("rust-tools.executors").toggleterm,
    inlay_hints = {
      other_hints_prefix = ": ",
    },
  },
  server = {
    on_attach = on_lsp_attach,
    capabilities = capabilities,
  },
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        experimental = {
          enable = true,
        },
      },
    },
  },
}

-- Ensure the servers above are installed
local mason_lspconfig = require "mason-lspconfig"

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {
      capabilities = capabilities,
      on_attach = on_lsp_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
      cmd = (servers[server_name] or {}).cmd,
    }
  end,
}

require("lspconfig").typos_lsp.setup {}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require "cmp"
local luasnip = require "luasnip"

-- Loads all the snippets installed by extensions in vscode.
-- require('luasnip.loaders.from_vscode').lazy_load()
require("luasnip.loaders.from_vscode").load { paths = "~/.config/nvim/snippets" }

luasnip.config.set_config {
  region_check_events = "InsertEnter",
  delete_check_events = "InsertLeave",
}

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
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-Enter>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      -- provide a value for copilot to fallback if there is no suggestion to accept. If no suggestion accept mimic normal tab behavior.
      local tab_shift_width = vim.opt.shiftwidth:get()
      local copilot_keys = vim.fn["copilot#Accept"](string.rep(" ", tab_shift_width))

      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
        vim.api.nvim_feedkeys(copilot_keys, "i", true)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "crates" },
  },
}

-- Set all the overrides and the extensions for the things that are available in native vim
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- My lovely vertical navigation speedups (do not add them to the jumplist)
vim.keymap.set("n", "<C-j>", ":keepjumps normal! }<CR>", { silent = true })
vim.keymap.set("v", "<C-j>", "}", { silent = true })
vim.keymap.set("n", "<C-k>", ":keepjumps normal! {<CR>", { silent = true })
vim.keymap.set("v", "<C-k>", "{", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-h>", "b", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-l>", "w", { silent = true })
vim.keymap.set({ "n", "v" }, "-", "$", { silent = true })

-- vim.keymap.set({ 'n', 'v' }, 'J', '10j', { silent = true })
-- vim.keymap.set({ 'n', 'v' }, 'K', '10k', { silent = true })

-- Move lines up and down
vim.api.nvim_set_keymap("n", "<A-j>", "V:move '>+1<CR>gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<A-j>", ":move '>+1<CR>gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-k>", "V:move '>-2<CR>gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "<A-k>", ":move '<-2<CR>gv", { noremap = true, silent = true })

-- Make backspace work as black hole cut
vim.api.nvim_set_keymap("n", "<backspace>", '"_dh', { noremap = true })
vim.api.nvim_set_keymap("v", "<backspace>", '"_d', { noremap = true })

-- Paste line on cmd+v
vim.api.nvim_set_keymap("v", "<D-c>", '"+y', { silent = true })
vim.keymap.set("n", "<D-v>", "p", { remap = true })
vim.keymap.set("v", "<D-v>", '"_dP', { remap = true })
vim.keymap.set("i", "<D-v>", "<C-r>+", { remap = true })

-- Write file on cmd+s
vim.api.nvim_set_keymap("n", "<D-s>", ":silent w<CR>", { silent = true })
-- Open git
vim.api.nvim_set_keymap("n", "<A-g>", ":Git<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<D-S-g>", ":Git<CR>", { silent = true })

-- Map multi cursor view to the cmd
vim.api.nvim_set_keymap("n", "<D-d>", "<C-n>", { silent = true })
vim.api.nvim_set_keymap("v", "<D-d>", "<C-n>", { silent = true })

-- Delete a word by alt+backspace
vim.api.nvim_set_keymap("i", "<A-BS>", "<C-w>", { noremap = true })

-- Select whole buffer
vim.api.nvim_set_keymap("n", "<D-a>", "ggVG", {})

-- Comment out lines
vim.api.nvim_set_keymap("n", "<D-/>", "gc_", {})
vim.api.nvim_set_keymap("v", "<D-/>", "gc", {})

-- Switch between buffers
vim.keymap.set("n", "H", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "L", ":bnext<CR>", { silent = true })

-- Duplicate lines
vim.api.nvim_set_keymap("v", "<D-C-Up>", "y`>p`<", { silent = true })
vim.api.nvim_set_keymap("n", "<D-C-Up>", "Vy`>p`<", { silent = true })
vim.api.nvim_set_keymap("v", "<D-C-Down>", "y`<kp`>", { silent = true })
vim.api.nvim_set_keymap("n", "<D-C-Down>", "Vy`<p`>", { silent = true })

-- Map default <C-w> to the cmd+alt
vim.api.nvim_set_keymap("n", "<D-A-v>", "<C-w>v<C-w>w", { silent = true })
vim.api.nvim_set_keymap("n", "<D-A-l>", "<C-w>l", { silent = true })
vim.api.nvim_set_keymap("n", "<D-A-h>", "<C-w>h", { silent = true })
vim.api.nvim_set_keymap("n", "<D-A-q>", "<C-w>q", { silent = true })
vim.api.nvim_set_keymap("n", "<D-A-j>", "<C-w>j", { silent = true })
vim.api.nvim_set_keymap("n", "<D-A-k>", "<C-w>k", { silent = true })

-- Exit terminal mode with Esc
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { nowait = true })

local function open_file_under_cursor_in_the_panel_above()
  local telescope = require "telescope.builtin"

  local filename = vim.fn.expand "<cfile>"
  local full_path_with_suffix = vim.fn.expand "<cWORD>"

  vim.api.nvim_command "wincmd k"

  if vim.loop.fs_stat(filename) then
    vim.api.nvim_command(string.format("e %s", full_path_with_suffix))
  elseif telescope then
    telescope.find_files {
      prompt_prefix = "🪿 ",
      default_text = full_path_with_suffix,
      wrap_results = true,
      find_command = { "rg", "--files", "--no-require-git" },
    }
  else
    error(string.format("File %s does not exist", filename))
  end
end

-- Opens file under cursor in the panel above
vim.keymap.set("n", "gf", open_file_under_cursor_in_the_panel_above, { silent = true })

-- Set of commands that should be executed on startup
vim.cmd [[command! -nargs=1 Browse silent lua vim.fn.system('open ' .. vim.fn.shellescape(<q-args>, 1))]]
vim.cmd [[highlight DiagnosticUnderlineError cterm=undercurl gui=undercurl guisp=#f87171]]

-- Simulate netrw gx without netrw
-- Map 'gx' to open the file or URL under cursor
vim.keymap.set("n", "gx", function()
  local target = vim.fn.expand "<cfile>"
  vim.fn.system(string.format("open '%s'", target))
end, { silent = false })
