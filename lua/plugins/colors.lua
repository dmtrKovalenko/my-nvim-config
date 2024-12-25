local theme = "cyberdream"

function GetGooseLuaLineTheme()
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
    "scottmckendry/cyberdream.nvim",
    enabled = theme == "cyberdream",
    lazy = false,
    priority = 1000,
    opts = {
      borderless_telescope = false,
    },
    init = function()
      vim.cmd "colorscheme cyberdream"
      vim.api.nvim_set_hl(0, "Whitespace", { fg = "#444444" })
    end,
  },
}
