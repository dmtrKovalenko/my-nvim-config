return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("snacks").setup {
      bigfile = {
        enabled = true,
        max_size = 2 * 1024 * 1024, -- 2MB
      },
      image = {
        enabled = true,
      },
      terminal = {},
      picker = {
        prompt = "🍪 ",
        layout = { preset = "telescope" },
        hidden = true,
        file = true,
        current = true,
        matcher = {
          fuzzy = true,
          frecency = true,
          filename_bonus = false,
        },
      },
    }

    local function find_files()
      require("snacks.picker").files {
        prompt = "🍪 ",
        wrap = true,
        find_command = { "rg", "--files", "--no-require-git" },
      }
    end

    local function find_recent_files()
      -- Use smart() which combines recent files, buffers and files (similar to smart_open)
      require("snacks.picker").smart {
        multi = { "files" },
        format = "file",
        prompt = "🍪 ",
        wrap = true,
        matcher = {
          fuzzy = true,
          filename_bonus = true,
          history_bonus = true,
          sort_empty = true,
          frecency = true,
        },
        keys = {
          "<leader>q",
          Snacks.picker.qflist,
          desc = "Add to quickfix list",
        },
        filter = {
          cwd = true,
        },
      }
    end

    local function find_recent_files_or_files()
      find_recent_files()
    end

    local function live_grep()
      require("snacks.picker").grep {
        wrap = true,
        live = true,
      }
    end

    -- Keep the same keymaps but update the functions
    vim.keymap.set("n", "<D-k>", find_recent_files_or_files, { desc = "Search recent Files" })
    vim.keymap.set("n", "<D-S-f>", live_grep, { desc = "Live Grep" })
    vim.keymap.set("n", "<D-m>", require("snacks.picker").diagnostics, { desc = "Diagnostics" })
    vim.keymap.set("n", "<leader>b", require("snacks.picker").buffers, { desc = "Buffers" })
    vim.keymap.set("n", "<leader>gb", require("snacks.picker").git_branches, { desc = "Git branches" })
    vim.keymap.set("n", "<leader>sw", require("snacks.picker").grep_word, { desc = "Search word" })

    local function open_file_under_cursor_in_picker()
      local target = vim.fn.expand "<cfile>"
      vim.api.nvim_command "wincmd k"

      require("snacks.picker").files {
        prompt = "🍪 ",
        default_text = target,
        wrap = true,
        find_command = { "rg", "--files", "--no-require-git" },
      }
    end

    vim.keymap.set("n", "gs", open_file_under_cursor_in_picker, { desc = "Search file name under cursor" })

    vim.keymap.set("n", "<D-f>", function()
      require("snacks.picker").lines {
        layout = {
          preset = "select",
        },
      }
    end, { desc = "Fuzzily search in current buffer" })

    vim.keymap.set("n", "<D-s-;>", require("snacks.picker").commands, { desc = "Search commands" })
    vim.keymap.set("n", "<leader>sh", require("snacks.picker").help, { desc = "Search help" })

    vim.keymap.set({ "n", "x" }, "<leader>gg", function()
      require("snacks.gitbrowse").open {
        branch = "main",
      }
    end, { desc = "Open git link in the browser", silent = true })
  end,
}
