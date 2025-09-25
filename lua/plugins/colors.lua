local theme = "cyberdream"

local function get_goose_lualine_theme()
  if theme == "catppuccin" then
    local catpuccin = require "catppuccin.palettes.mocha"
    return {
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
  end

  return "auto"
end

return {
  {
    "uga-rosa/ccc.nvim",
    keys = {
      { mode = "n", "<leader>cc", "<cmd>CccPick<cr>" },
    },
    opts = {
      highlighter = {
        auto_enable = true,
        lsp = false,
      },
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = theme == "catppuccin",
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

      vim.api.nvim_set_hl(0, "EdgyWinBar", { bg = catpuccin.mantle })
      vim.api.nvim_set_hl(0, "EdgyNormal", { bg = catpuccin.mantle })
      vim.api.nvim_set_hl(0, "LspInlayHint", { bg = catpuccin.base, fg = catpuccin.overlay0 })
      vim.api.nvim_set_hl(0, "WinSeparator", { bg = catpuccin.mantle, fg = catpuccin.surface1 })
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { sp = catpuccin.surface2, underline = false })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { sp = catpuccin.surface2, underline = false })
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {},
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    enabled = theme == "tokyonight",
    opts = {
      transparent = true,
      sidebars = "transparent",
    },
    init = function()
      vim.cmd "colorscheme tokyonight"
    end,
  },
  {
    "scottmckendry/cyberdream.nvim",
    enabled = theme == "cyberdream",
    lazy = false,
    priority = 1000000,
    opts = {
      transparent = true,
      borderless_pickers = false,
      saturation = 0.95,
      cache = true,
    },
    init = function()
      vim.cmd "colorscheme cyberdream"
      vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "none", ctermbg = "none" })
      vim.api.nvim_set_hl(0, "TroubleNormalNC", { bg = "none", ctermbg = "none" })
      vim.api.nvim_set_hl(0, "TroubleNormal", { bg = "none", ctermbg = "none" })
      vim.api.nvim_set_hl(0, "TroubleNormalNC", { bg = "none", ctermbg = "none" })
      vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#3c4048", bg = "none" })
      vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = "#7b8496" })
      vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#232429" })
      vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#232429" })
      vim.api.nvim_set_hl(0, "TreesitterContextBottom", { bg = "#232429", underline = true })
      vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff" })
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

      require("lualine").setup {
        options = {
          disabled_filetypes = {
            statusline = { "alpha", "NvimTree", "trouble", "Outline" },
          },
          theme = get_goose_lualine_theme(),
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
          lualine_z = { { "os.date('󰅐 %H:%M')" } },
        },
      }
    end,
  },
}
