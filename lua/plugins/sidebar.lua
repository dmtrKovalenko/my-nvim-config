return {
  {
    "hedyhli/outline.nvim",
    dev = true,
    dir = "~/dev/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<D-b>", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      outline_window = {
        position = "left",
        width = 35,
        auto_close = false,
        focus_on_open = false,
        relative_width = false,
        no_provider_message = "",
      },
    },
    config = function(_, opts)
      require("outline").setup(opts)
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          local function count_normal_windows()
            local count = 0
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local config = vim.api.nvim_win_get_config(win)
              if config.relative == "" then -- Non-floating windows
                count = count + 1
              end
            end
            return count
          end

          if vim.bo.filetype == "Outline" and count_normal_windows() == 1 then
            vim.cmd "q"
          end
        end,
      })
    end,
  },
  -- {
  --   "folke/edgy.nvim",
  --   event = "VeryLazy",
  --   init = function()
  --     local edgy = require "edgy"
  --
  --     vim.opt.splitkeep = "screen"
  --     vim.keymap.set("n", "<D-b>", function()
  --       edgy.toggle "left"
  --     end, { desc = "Toggle sidebar" })
  --   end,
  --   dependencies = {
  --     {
  --       "folke/trouble.nvim",
  --       event = "VeryLazy",
  --       modes = {
  --         symbols = {
  --           filter = {
  --             -- remove Package since luals uses it for control flow structures
  --             ["not"] = { ft = "lua", kind = "Package" },
  --             any = {
  --               -- all symbol kinds for help / markdown files
  --               ft = { "help", "markdown" },
  --               -- default set of symbol kinds
  --               kind = {
  --                 "Class",
  --                 "Constructor",
  --                 "Enum",
  --                 "Field",
  --                 "Function",
  --                 "Interface",
  --                 "Method",
  --                 "Module",
  --                 "Namespace",
  --                 "Package",
  --                 "Property",
  --                 "Struct",
  --                 "Trait",
  --                 "Variable",
  --               },
  --             },
  --           },
  --         },
  --       },
  --       opts = {
  --         restore = false,
  --         auto_close = false,
  --         auto_preview = true,
  --         open_no_results = true,
  --         pinned = true,
  --         multiline = false,
  --         highlights = {
  --           normal = { guibg = "none", ctermbg = "none" },
  --         },
  --       },
  --       init = function()
  --         vim.api.nvim_create_autocmd("BufReadPost", {
  --           pattern = "*",
  --           callback = function()
  --             require("trouble").refresh()
  --           end,
  --         })
  --       end,
  --     },
  --   },
  --   opts = {
  --     options = {
  --       left = {
  --         size = 35,
  --       },
  --     },
  --     animate = {
  --       enabled = false,
  --     },
  --     exit_when_last = false,
  --     close_when_all_hidden = false,
  --     wo = {
  --       winhighlight = "",
  --       winbar = false,
  --     },
  --     highlights = {
  --       normal = { guibg = "none", ctermbg = "none" },
  --       normal_nc = { guibg = "none", ctermbg = "none" },
  --     },
  --     left = {
  --       {
  --         ft = "trouble",
  --         pinned = true,
  --         title = "Sidebar",
  --         filter = function(_buf, win)
  --           return vim.w[win].trouble.mode == "symbols"
  --         end,
  --         open = "Trouble symbols position=left focus=false filter.buf=0",
  --         size = { height = 0.6 },
  --       },
  --       {
  --         ft = "trouble",
  --         pinned = true,
  --         title = "Troubles",
  --         filter = function(_buf, win)
  --           return vim.w[win].trouble.mode == "diagnostics"
  --         end,
  --         open = "Trouble diagnostics focus=false filter.severity=vim.diagnostic.severity.ERROR",
  --         size = { height = 0.4 },
  --       },
  --     },
  --   },
  -- },
}
