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

-- Default value for tabstop
vim.o.shiftwidth = 4
vim.o.tabstop = 4

-- Enale mouse mode
vim.o.mouse = "a"
vim.o.foldmethod = "manual"
vim.o.autochdir = true

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
-- Set timeout for key sequences
vim.o.timeout = true
vim.o.timeoutlen = 250

-- Improve default search behavior
vim.o.incsearch = true

-- Set the scolloff
vim.o.scrolloff = 10
-- Highlight current line as cursor
vim.o.cursorline = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- set termguicolors to enable highlight groups
vim.o.termguicolors = true

-- Renders spaces as "·"
vim.opt.list = true
vim.opt.listchars = vim.opt.listchars + "space:·"

-- Do not create swap files as this config autosaving everything on disk
vim.opt.swapfile = false
-- Set terminal tab title to `filename (cwd)`
vim.opt.title = true
function GetCurrentIconFile()
  local filename = vim.fn.expand "%:t"
  local icon = require("nvim-web-devicons").get_icon(filename)
  return icon or "✌️"
end
vim.o.titlestring = '%{fnamemodify(getcwd(), ":t")} %{v:lua.GetCurrentIconFile()} %{expand("%:t")}'

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

function _G.close_floating_wins()
  require("edgy").close()
  require("nvterm.terminal").close_all_terms()
end

require("lazy").setup({
  "github/copilot.vim",
  -- Git management
  "tpope/vim-fugitive",
  -- Allows cursor locations in the :e
  "lewis6991/fileline.nvim",
  -- Code actions preview using telescope
  "aznhe21/actions-preview.nvim",
  --  Automatically jump to the last cursor position
  "farmergreg/vim-lastplace",
  -- Turn off some of the feature on big buffers
  "LunarVim/bigfile.nvim",
  {
    -- A better code actions menu
    "weilbith/nvim-code-action-menu",
    event = "BufWinEnter",
    config = function()
      require("actions-preview").setup {
        diff = {
          algorithm = "minimal",
          ignore_whitespace = true,
        },
      }
    end,
  },
  { "chentoast/marks.nvim", event = "VeryLazy", opts = {} },
  { "luckasRanarison/tailwind-tools.nvim", opts = {
    custom_filetypes = {
      "rescript",
    },
  } },
  {
    "stevearc/oil.nvim",
    lazy = true,
    cmd = "Oil",
    keys = {
      { "<D-o>", "<cmd>Oil<CR>", silent = true, desc = "Open Oil" },
    },
    opts = {
      keymaps = {
        ["<D-i>"] = "actions.select",
        ["yp"] = {
          desc = "Copy filepath to system clipboard",
          callback = function()
            require("oil.actions").copy_entry_path.callback()
            vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
            vim.notify("Copied full path", "info", { title = "Oil" })
          end,
        },
      },
      default_file_explorer = false,
      delete_to_trash = true,
      lsp_file_methods = {
        autosave_changes = true,
      },
    },
  },
  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",
  -- Camel case motion plugin
  {
    "bkad/CamelCaseMotion",
    event = "VeryLazy",
    init = function()
      vim.g.camelcasemotion_key = "q"
    end,
  },
  -- Allows correctly opening and closing nested nvims in the terminal
  {
    "samjwill/nvim-unception",
    event = "VeryLazy",
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
  -- Handy rename in a floating method
  {
    "filipdutescu/renamer.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "mrcjkb/rustaceanvim",
    lazy = false,
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "ruifm/gitlinker.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("gitlinker").setup()
      vim.keymap.set(
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
    event = "BufWinEnter",
    opts = {
      terminals = {
        type_opts = {
          horizontal = {
            split_ratio = ((IS_STREAMING or vim.api.nvim_get_option_value("lines", {}) < 60) and 0.5) or 0.35,
          },
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
      "ocaml-mlx/ocaml_mlx.nvim",
    },
  },

  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    opts = {
      signs = {
        add = { text = "┃" },
        chage = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },
      on_attach = function(bufnr)
        local gitsigns = require "gitsigns"
        local function gsmap(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        gsmap("n", "[g", function()
          gitsigns.nav_hunk "prev"
        end, { desc = "[G]o to [P]revious Hunk" })
        gsmap("n", "]g", function()
          gitsigns.nav_hunk "next"
        end, { desc = "[G]it go to [N]ext Hunk" })
        gsmap("n", "<leader>gd", gitsigns.preview_hunk, { desc = "[G]it [D]iff Hunk" })
        gsmap("n", "<leader>gr", gitsigns.reset_hunk, { desc = "[G]it [R]eset hunk" })
        gsmap("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "[G]it [U]nstage hunk" })
        gsmap("n", "<leader>gs", gitsigns.stage_hunk, { desc = "[G]it [S]tage hunk" })
        gsmap("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "[G]it [B]lame" })
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
        cmp = true,
        treesitter = true,
        telescope = true,
        notify = true,
        gitsigns = true,
        noice = true,
        dap = true,
        dap_ui = true,
        nvimtree = true,
        markdown = true,
        mason = true,
      },
    },
    init = function()
      local catpuccin = require "catppuccin.palettes.mocha"
      vim.cmd.colorscheme "catppuccin"
      vim.api.nvim_set_hl(0, "LspInlayHint", { bg = catpuccin.base, fg = catpuccin.overlay0 })
      vim.api.nvim_set_hl(0, "WinSeparator", { bg = catpuccin.mantle, fg = catpuccin.surface1 })
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { sp = catpuccin.surface2, underline = false })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { sp = catpuccin.surface2, underline = false })
    end,
  },
  {
    priority = 1000,
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "linrongbin16/lsp-progress.nvim",
        opts = {
          format = function(client_messages)
            local api = require "lsp-progress.api"
            local lsp_clients = #api.lsp_clients()
            if #client_messages > 0 then
              return table.concat(client_messages, " ")
            elseif lsp_clients > 0 then
              return "󰄳 LSP " .. lsp_clients .. " clients"
            end
            return ""
          end,
        },
      },
    },
    cond = function()
      return os.getenv "PRESENTATION" ~= "true"
    end,
    config = function()
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = "lualine_augroup",
        pattern = "LspProgressStatusUpdated",
        callback = require("lualine").refresh,
      })
      local catpuccin = require "catppuccin.palettes.mocha"

      local custom_catppuccin_theme = {
        normal = {
          a = { fg = catpuccin.crust, bg = catpuccin.mauve },
          b = { fg = catpuccin.mauve, bg = catpuccin.base },
          c = { fg = catpuccin.subtext0, bg = catpuccin.base },
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
            statusline = { "alpha", "NvimTree", "trouble" },
          },
          theme = custom_catppuccin_theme,
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(str)
                -- Define single-letter mode mappings
                local mode_map = {
                  ["NORMAL"] = "NR",
                  ["INSERT"] = "IN",
                  ["VISUAL"] = "VV",
                  ["V-LINE"] = "VL",
                  ["V-BLOCK"] = "VB",
                  ["REPLACE"] = "RP",
                  ["COMMAND"] = "CM",
                  ["TERMINAL"] = "TR",
                  ["SELECT"] = "SL",
                }
                -- Return the mapped single letter or first letter if not found
                return mode_map[str] or str:sub(1, 1)
              end,
            },
          },
          lualine_c = {
            function()
              -- invoke `progress` here.
              return require("lsp-progress").progress()
            end,
          },
          lualine_x = { "filetype" },
          lualine_y = {},
          lualine_z = { { "os.date('󱑈 %H:%M')", color = { fg = "#363a4f", gui = "bold" } } },
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
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {
      opts = {
        -- Defaults
        enable_close = true, -- Auto close tags
        enable_rename = true, -- Auto rename pairs of tags
        enable_close_on_slash = false, -- Auto close on trailing </
      },
    },
  },

  -- Project specific marks for most editable files
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    commit = "e76cb03",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require "harpoon"
      harpoon:setup {
        settings = {
          save_on_toggle = true,
          mark_branch = true,
          excluded_filetypes = { "harpoon", "NvimTree", "TelescopePrompt" },
        },
        projects = {
          ["$HOME/dev/"] = {
            mark = {
              marks = { "1", "2", "3", "4", "5" },
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

      vim.keymap.set("n", "<leader>h", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { noremap = true, desc = "Harpoon view" })

      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end, { noremap = true, desc = "Harpoon this path" })

      vim.keymap.set("n", "<leader>q", function()
        harpoon:list():select(1)
      end, { desc = "Harpoon #1" })
      vim.keymap.set("n", "<leader>w", function()
        harpoon:list():select(2)
      end, { desc = "Harpoon #2" })
      vim.keymap.set("n", "<leader>e", function()
        harpoon:list():select(3)
      end, { desc = "Harpoon #3" })
      vim.keymap.set("n", "<leader>r", function()
        harpoon:list():select(4)
      end, { desc = "Harpoon #4" })
      vim.keymap.set("n", "<leader>t", function()
        harpoon:list():select(5)
      end, { desc = "Harpoon #5" })
    end,
  },

  {
    -- Highlight, edit, and navigate code
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      -- Custom treesitter parserrs
      "rescript-lang/tree-sitter-rescript",
      "danielo515/tree-sitter-reason",
      "IndianBoy42/tree-sitter-just",
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          max_lines = IS_STREAMING and 1 or 3,
        },
      },
    },
    build = ":TSUpdate",
    config = function()
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
          "vimdoc",
          "vim",
          "rescript",
          "markdown",
          "wgsl",
          "html",
          "ocaml",
        },

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = true,
        highlight = {
          enable = true,
          use_languagetree = true,
          additional_vim_regex_highlighting = false,
        },
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
              ["as"] = "@statement.outer",
              ["is"] = "@statement.inner",
              ["av"] = "@assignment.outer",
              ["iv"] = "@assignment.inner",
              ["in"] = "@assignment.lhs",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]{"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_next_end = {
              ["]}"] = "@function.outer",
              ["]C"] = "@class.outer",
            },
            goto_previous_start = {
              ["[{"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
            goto_previous_end = {
              ["[}"] = "@function.outer",
              ["[C"] = "@class.outer",
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
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.just = {
        install_info = {
          url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
          files = { "src/parser.c", "src/scanner.cc" },
          branch = "main",
          use_makefile = true, -- this may be necessary on MacOS (try if you see compiler errors)
        },
        maintainers = { "@IndianBoy42" },
      }

      parser_config.rescript = {
        install_info = {
          url = "https://github.com/rescript-lang/tree-sitter-rescript",
          branch = "main",
          files = { "src/parser.c", "src/scanner.c" },
          generate_requires_npm = false,
          requires_generate_from_grammar = true,
          use_makefile = true, -- macOS specific instruction
        },
      }
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
    opts = {
      completion = {
        cmp = {
          enabled = true,
        },
      },
    },
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
    opts = {},
    keys = {
      {
        mode = "n",
        "<D-S-r>",
        "<cmd>lua require('spectre').toggle()<CR>",
      },
      {
        mode = "v",
        "<D-S-r>",
        ":lua require('spectre').open_visual()<CR>",
      },
    },
  },

  -- Better notifications and messagess
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        lsp_doc_border = true,
      },
      lsp = {
        progress = {
          enabled = false,
        },
        hover = {
          enabled = false,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      notify = {
        view = "mini",
      },
      routes = {
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          rust = { "rustfmt" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          python = { "isort", "black" },
          javascript = { "prettier" },
          markdown = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          css = { "prettier" },
          svg = { "xmlformat" },
          json = { "prettier" },
          yaml = { "prettier" },
          graphql = { "prettier" },
          rescript = { "rescript-format" },
          ocaml = { "ocamlformat" },
          sql = { "pg_format" },
          proto = { "clang-format" },
          ocaml_mlx = { "ocamlformat_mlx" },
        },
      }

      local function format()
        require("conform").format {
          lsp_fallback = true,
        }
      end

      vim.keymap.set({ "n", "i" }, "<F12>", format, { desc = "Format", silent = true })
      vim.api.nvim_create_user_command("Format", format, { desc = "Format current buffer with LSP" })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
    },
  },

  {
    "dmtrkovalenko/project.nvim",
    config = function()
      require("project_nvim").setup {
        detection_methods = { "pattern" },
        patterns = { ".git", ".sl" },
        after_project_selection_callback = function()
          vim.notify "SessionRestore"
        end,
      }
    end,
  },

  {
    "rmagatti/auto-session",
    opts = {
      log_level = "error",
      auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
      bypass_session_save_file_types = { "help", "alpha", "telescope", "trouble" },
      pre_save_cmds = { _G.close_floating_wins },
    },
    init = function()
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

      vim.api.nvim_create_user_command("CloseFloats", close_floating_wins, {})
    end,
  },

  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "dmtrKovalenko/caps-word.nvim",
    -- dir = "~/dev/caps-word.nvim",
    lazy = true,
    opts = {
      enter_callback = function()
        vim.notify("On", vim.log.levels.INFO, { title = "Caps Word:" })
      end,
      exit_callback = function()
        vim.notify("Off", vim.log.levels.INFO, { title = "Caps Word:" })
      end,
    },
    keys = {
      {
        mode = { "i", "n" },
        "<C-s>",
        "<cmd>lua require('caps-word').toggle()<CR>",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  },

  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
      "echasnovski/mini.pick", -- optional
    },
    config = true,
  },

  {
    "mbbill/undotree",
    keys = {
      {
        mode = "n",
        "<leader>u",
        "<cmd>UndotreeToggle<CR>",
      },
    },
  },

  -- Follow up with the custom reusable configuration for plugins located in ~/lua folder
  require("telescope-lazy").lazy {},
  require("alpha-lazy").lazy {},
  require("dap-lazy").lazy {},
  require("hop-lazy").lazy {},
  require("multicursor-lazy").lazy {},
  require "cmp-lazy",
  require "sidebar",
}, {})

-- [[ Custom Autocmds]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave" }, {
  command = "silent! wa",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "css", "html", "json", "yaml", "markdown" },
  callback = function()
    vim.opt.iskeyword:append { "-", "#", "$" }
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.wrap = false
    vim.opt.linebreak = true
  end,
})

vim.filetype.add { extension = { wgsl = "wgsl" } }

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

    vim.keymap.set("n", keys, func, { remap = true, buffer = bufnr, desc = desc, silent = true })
  end

  -- if vim.bo.filetype == "rust" then
  --   lsp_map("<D-.>", ":RustLsp codeAction<CR>", "[C]ode [A]ction")
  --   vim.keymap.set("n", "<F4>", ":RustLsp debuggables<CR>", { silent = true, desc = "Rust: Debuggables" })
  -- else
  --   lsp_map("<D-.>", require("actions-preview").code_actions, "[C]ode [A]ction")
  -- end
  lsp_map("<D-.>", require("actions-preview").code_actions, "[C]ode [A]ction")

  lsp_map("<D-r>", require("renamer").rename, "[R]e[n]ame")

  lsp_map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  lsp_map("gD", vim.lsp.buf.definition, "[G]oto [D]eclaration")
  lsp_map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  lsp_map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

  lsp_map("<D-g>", "<C-]>", "[G]oto [D]efinition")
  lsp_map("<D-A-g>", vim.lsp.buf.type_definition, "Type [D]efinition")

  lsp_map("<D-i>", vim.lsp.buf.hover, "Hover Documentation")
  lsp_map("<D-u>", vim.lsp.buf.signature_help, "Signature Documentation")

  lsp_map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  lsp_map("<leader>lr", function()
    vim.cmd "LspRestart"
  end, "Lsp [R]eload")
  lsp_map("<leader>li", function()
    vim.cmd "LspInfo"
  end, "Lsp [R]eload")
  lsp_map("<leader>lh", function()
    local bufFitler = { bufnr }
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
  end, "Lsp toggle inlay [h]ints")
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
  html = { filetypes = { "html", "twig", "hbs" } },
  lua_ls = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  typos_lsp = {
    single_file_support = false,
    init_options = { diagnosticSeverity = "WARN" },
  },
  grammarly = {
    -- Grammarly language server requires node js 16.4 ¯\_(ツ)_/¯
    -- https://github.com/neovim/nvim-lspconfig/issues/2007
    cmd = {
      "n",
      "run",
      "16.4",
      "/Users/dmtrkovalenko/.local/share/nvim/mason/bin/grammarly-languageserver",
      "--stdio",
    },
    filetypes = { "markdown", "text", "hgcommit", "gitcommit" },
  },
  bashls = {
    settings = {
      includeAllWorkspaceSymbols = true,
    },
  },
  pylsp = {},
  astro = {},
  dhall_lsp_server = {},
  marksman = {},
  taplo = {},
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

local signs = { Error = "󰚌 ", Warn = " ", Hint = "󱧡 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border,
  }),
}

-- Your existing floating preview override
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

require("typescript-tools").setup {
  on_attach = on_lsp_attach,
  handlers = handlers,
}

vim.g.rustaceanvim = {
  -- LSP configuration
  server = {
    on_attach = on_lsp_attach,
    default_settings = {
      -- rust-analyzer language server configuration
      ["rust-analyzer"] = {
        check = {
          allTargets = false,
        },
        files = {
          excludeDirs = { "target", "node_modules", ".git", ".sl" },
        },
      },
    },
  },
  dap = {
    adapter = {
      type = "executable",
      command = "/opt/homebrew/opt/llvm/bin/lldb-vscode", -- adjust as needed, must be absolute path
      name = "lldb",
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
      single_file_support = (servers[server_name] or {}).single_file_support,
      filetypes = (servers[server_name] or {}).filetypes,
      cmd = (servers[server_name] or {}).cmd,
      init_options = (servers[server_name] or {}).init_options,
    }
  end,
}

-- In order to enforce using the ocaml lsp from the current switch/sandbox/esy env avoid using mason
-- and configure ocaml lsp manually.
require("lspconfig").ocamllsp.setup {
  capabilities = capabilities,
  on_attach = on_lsp_attach,
  handlers = handlers,
  settings = {},
}

require("lspconfig").relay_lsp.setup {
  handlers = handlers,
  capabilities = capabilities,
  on_attach = on_lsp_attach,
  cmd = { "yarn", "relay-compiler", "lsp" },
  settings = {},
}

-- Set all the overrides and the extensions for the things that are available in native vim
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- My lovely vertical navigation speedups (do not add them to the jumplist)
vim.keymap.set("n", "<C-j>", "<cmd>keepjumps normal! }<CR>", { silent = true, remap = true })
vim.keymap.set("v", "<C-j>", "}", { silent = true, remap = true })
vim.keymap.set("n", "<C-k>", "<cmd>keepjumps normal! {<CR>", { silent = true, remap = true })
vim.keymap.set("v", "<C-k>", "{", { silent = true, remap = true })
vim.keymap.set({ "n", "v" }, "-", "$", { silent = true })

-- Move lines up and down
-- Normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
-- Visual mode
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Make backspace work as black hole cut
vim.keymap.set("n", "<backspace>", '"_dh', { noremap = true })
vim.keymap.set("v", "<backspace>", '"_d', { noremap = true })

-- Write file on cmd+s
vim.keymap.set("n", "<D-s>", "w<CR>", { silent = true })
-- Open git
vim.keymap.set("n", "<A-g>", "<cmd>Git<CR>", { silent = true })
vim.keymap.set("n", "<D-S-g>", "<cmd>Git<CR>", { silent = true })

-- Move to next occurrence using native search
vim.keymap.set("n", "<D-n>", "*", { silent = true })
vim.keymap.set("n", "<D-S-n>", "#", { silent = true })

-- Delete a word by alt+backspace
vim.keymap.set({ "i", "c" }, "<A-BS>", "<C-w>", { noremap = true })
vim.keymap.set("n", "<A-BS>", "db", { noremap = true })

-- Select whole buffer
vim.keymap.set("n", "<D-a>", "ggVG", {})

-- Comment out lines
vim.keymap.set("n", "<D-/>", "gcc", {})
vim.keymap.set("v", "<D-/>", "gc", {})

-- Clear line with cd
vim.keymap.set("n", "cd", "0D", {})

-- Switch between buffers
vim.keymap.set("n", "H", "<cmd>bprevious<CR>", { silent = true })
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { silent = true })

vim.keymap.set({ "n", "v" }, "<C-h>", "b", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-l>", "w", { silent = true })

-- Duplicate lines
vim.keymap.set("v", "<D-C-Up>", "y`>p`<", { silent = true })
vim.keymap.set("n", "<D-C-Up>", "Vy`>p`<", { silent = true })
vim.keymap.set("v", "<D-C-Down>", "y`<kp`>", { silent = true })
vim.keymap.set("n", "<D-C-Down>", "Vy`<p`>", { silent = true })

-- Map default <C-w> to the cmd+alt
vim.keymap.set("n", "<D-A-v>", "<C-w>v<C-w>w", { silent = true })
vim.keymap.set("n", "<D-A-s>", "<C-w>s<C-w>j", { silent = true })
vim.keymap.set("n", "<D-A-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<D-A-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<D-A-q>", "<C-w>q", { silent = true })
vim.keymap.set("n", "<D-A-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<D-A-k>", "<C-w>k", { silent = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set({ "n" }, "<D-s>", "<cmd>w<CR>", { silent = true, desc = "Save file" })

-- Swap the p and P to not mess up the clipbard with replaced text
-- but leave the ability to paste the text
vim.keymap.set("x", "p", "P", {})
vim.keymap.set("x", "P", "p", {})

-- Exit terminal mode with Esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { nowait = true })

-- A bunch of useful shortcuts for one-time small actions bound on leader
vim.keymap.set("n", "<leader>n", "<cmd>nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<leader><leader>", "zz", { silent = true })
vim.keymap.set("n", "<A-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<A-s>", [[y:%s/<C-r>"/<C-r>"/gI<Left><Left><Left>]])

-- A bunch of remaps for the command lilne mode
vim.keymap.set({ "c", "i" }, "<C-a>", "<Home>", { silent = true })
vim.keymap.set({ "c", "i" }, "<C-e>", "<End>", { silent = true })
vim.keymap.set({ "c", "i" }, "<A-Bs>", "<C-w>", { noremap = true })

--  Pull one line down useful rempaps from the numeric line
vim.keymap.set("n", "<C-t>", "%", { remap = true })

local function open_file_under_cursor_in_the_panel_above()
  local has_telescope, telescope = pcall(require, "telescope.builtin")

  local filename = vim.fn.expand "<cfile>"
  local full_path_with_suffix = vim.fn.expand "<cWORD>"

  vim.api.nvim_command "wincmd k"

  if vim.loop.fs_stat(filename) then
    vim.api.nvim_command(string.format("e %s", full_path_with_suffix))
  elseif has_telescope then
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

require("refactoring-macro").setupMacro()

if os.getenv "PRESENTATION" then
  vim.cmd "LspStop"
  vim.o.relativenumber = false
  vim.o.cursorline = false
end
