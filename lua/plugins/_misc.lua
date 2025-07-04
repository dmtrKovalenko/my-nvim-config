return {
  -- Git management
  "tpope/vim-fugitive",
  -- Allows cursor locations in the :e
  "lewis6991/fileline.nvim",
  --  Automatically jump to the last cursor position
  "farmergreg/vim-lastplace",
  -- Respects .editorconfig file
  "gpanders/editorconfig.nvim",
  -- Syntax highlighting for at&t assembly
  "HealsCodes/vim-gas",
  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        mode = "n",
        "<leader>ch",
        "<cmd>ClaudeCode<CR>",
        desc = "Claude Code",
      },
    },
    opts = {
      window = {
        split_ratio = 0.4,
      },
    },
  },
  {
    "github/copilot.vim",
    config = function()
      vim.g.copilot_settings = { selectedCompletionModel = "gpt-4o-copilot" }
      vim.g.copilot_integration_id = "vscode-chat"
    end,
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
    "mbbill/undotree",
    keys = {
      {
        mode = "n",
        "<leader>u",
        "<cmd>UndotreeToggle<CR>",
      },
    },
  },
  { "chentoast/marks.nvim", event = "VeryLazy", opts = {} },
  {
    "chrisgrieser/nvim-spider",
    keys = {
      { "qw", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
      { "qe", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
      { "qb", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
    },
    opts = {
      skipInsignificantPunctuation = true,
      subwordMovement = true,
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    config = function()
      require("various-textobjs").setup {
        keymaps = {
          -- Disable all default mappings
          useDefaults = false,
        },
      }

      -- Custom keymappings for subword text objects
      vim.keymap.set({ "o", "x" }, "iqw", function()
        require("various-textobjs").subword "inner"
      end)
      vim.keymap.set({ "o", "x" }, "aqw", function()
        require("various-textobjs").subword "outer"
      end)
    end,
  },
  { "akinsho/git-conflict.nvim", version = "*", config = true },
  {
    "akinsho/toggleterm.nvim",
    keys = {
      {
        "<D-S-c>",
        function()
          require("toggleterm").toggle()
        end,
        desc = "Toggle Terminal (Floating)",
      },
    },
    opts = {
      open_mapping = [[<D-S-c>]],
      size = function(term)
        if term.direction == "float" then
          return 20 -- Height for floating terminal
        end
      end,
      highlights = {
        NormalFloat = {
          guibg = "#16181a",
        },
        FloatBorder = {
          guibg = "#16181a",
        },
      },
      float_opts = {
        border = "curved",
        width = function()
          return math.floor(vim.o.columns * 0.8)
        end,
        height = function()
          return math.floor(vim.o.lines * 0.8)
        end,
        winblend = 0,
      },
      direction = "float",
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
    },
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
        gsmap("n", "<leader>gl", gitsigns.toggle_current_line_blame, { desc = "[G]it [B]lame" })
      end,
    },
  },

  {
    -- Add indentation guides even on blank lines
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        highlight = {
          "WhiteSpace",
        },
        char = "┊",
      },
      scope = {
        show_start = false,
        show_end = false,
        char = "│",
        highlight = {
          "IndentBlanklineChar",
        },
      },
    },
  },

  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    opts = {},
  },

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
  -- Autocompletion and version display for rust projects
  {
    "saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- Auto close brackets
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
  -- Search and replace
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      {
        mode = "n",
        "<D-S-r>",
        "<cmd>GrugFar<CR>",
      },
    },
    opts = {},
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
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
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
    },
  },
  {
    "rmagatti/auto-session",
    opts = {
      log_level = "error",
      suppressed_dirs = { "~/", "~/Downloads", "/" },
      bypass_save_filetypes = { "help", "alpha", "telescope", "trouble" },
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
        mode = { "i" },
        "<C-s>",
        "<cmd>lua require('caps-word').toggle()<CR>",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  },
  {
    "mistricky/codesnap.nvim",
    build = "make",
    command = "CodeSnap",
    opts = {
      save_path = "~/Pictures",
      has_breadcrumbs = false,
      code_font_family = "JetBrains Mono",
      bg_theme = "summer",
      watermark = "neogoose",
    },
  },
}
