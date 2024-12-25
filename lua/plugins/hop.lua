return {
  "smoka7/hop.nvim",
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
}
