return {
  "nvim-telescope/telescope.nvim",
  enabled = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope-ui-select.nvim",
    -- Fuzzy Finder Algorithm which requires local dependencies to be built.
    -- Only load if `make` is available. Make sure you have the system
    -- requirements installed.
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
    {
      "danielfalk/smart-open.nvim",
      dependencies = {
        "kkharji/sqlite.lua",
      },
    },
  },
  config = function()
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "live_grep_args")
    pcall(require("telescope").load_extension, "projects")
    pcall(require("telescope").load_extension, "smart_open")

    -- Enable telescope fzf native, if installed
    pcall(require("telescope").load_extension, "fzf")

    local function find_files()
      require("telescope.builtin").find_files {
        prompt_prefix = "🔭 ",
        wrap_results = true,
        find_command = { "rg", "--files", "--no-require-git" },
      }
    end

    local function find_recent_files()
      require("telescope").extensions.smart_open.smart_open {
        cwd_only = true,
        prompt_prefix = "🔭 ",
        __locations_input = true,
        previewer = require("telescope.config").values.grep_previewer {},
        wrap_results = true,
        find_command = { "rg", "--files", "--no-require-git" },
      }
    end

    local function find_recent_files_or_files()
      if not pcall(find_recent_files) then
        find_files()
      end
    end

    local function live_grep()
      require("telescope").extensions.live_grep_args.live_grep_args {
        wrap_results = true,
      }
    end

    vim.keymap.set("n", "<D-k>", find_recent_files_or_files, { desc = "Search recent Files" })
    vim.keymap.set("n", "<D-l>", find_files, { desc = "Search Files" })
    vim.keymap.set("n", "<D-S-f>", live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<D-m>", require("telescope.builtin").diagnostics, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>sg", require("telescope.builtin").git_files, { desc = "Search by git files" })
    vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "Search word" })

    local function open_file_under_cursor_in_telescope()
      local target = vim.fn.expand "<cfile>"
      vim.api.nvim_command "wincmd k"

      require("telescope.builtin").find_files {
        prompt_prefix = "🪿 ",
        default_text = target,
        wrap_results = true,
        find_command = { "rg", "--files", "--no-require-git" },
      }
    end

    vim.keymap.set("n", "gs", open_file_under_cursor_in_telescope, { desc = "Search file name under cursor" })

    -- Set telescope keymaps
    vim.keymap.set("n", "<D-f>", function()
      -- You can pass additional configuration to telescope to change theme, layout, etc.
      require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
        previewer = true,
      })
    end, { desc = "] Fuzzily search in current buffer" })

    vim.keymap.set("n", "<D-s-;>", require("telescope.builtin").commands, { desc = "Search commands" })
    vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "Search help" })

    require("telescope").setup {
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        smart_open = {
          match_algorithm = "fzf",
          disable_devicons = false,
          mappings = {
            i = {
              -- works around smart_open overriding ctrl-w keybind for deleting
              -- word. should be able to remove this once this issue is resolved:
              -- https://github.com/danielfalk/smart-open.nvim/issues/71
              ["<C-w>"] = function()
                vim.api.nvim_input "<c-s-w>"
              end,
            },
          },
        },
      },
      defaults = {
        mappings = {
          i = {
            ["<S-D-'>"] = require("telescope-live-grep-args.actions").quote_prompt(),
            ["<D-i>"] = require("telescope-live-grep-args.actions").quote_prompt {
              postfix = " --iglob ",
            },
            ["<D-e>"] = require("telescope-live-grep-args.actions").quote_prompt {
              postfix = " --fixed-strings",
            },
            ["<C-Down>"] = require("telescope.actions").cycle_history_next,
            ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
            ["<D-p>"] = function(prompt_bufnr)
              local action_state = require "telescope.actions.state"
              local current_picker = action_state.get_current_picker(prompt_bufnr)
              local text = vim.fn.getreg('"'):gsub("\n", "")
              current_picker:set_prompt(text, false)
            end,
          },
        },
      },
    }
  end,
}
