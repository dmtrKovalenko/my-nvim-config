return {
  "jake-stewart/multicursor.nvim",
  event = "BufReadPost",
  config = function()
    local mc = require "multicursor-nvim"

    mc.setup {
      -- set to true if you want multicursor undo history
      -- to clear when clearing cursors
      shallowUndo = false,

      -- set to empty table to disable signs
      signs = { " ┆", " │", " ┃" },
    }

    -- Add or skip cursor above/below the main cursor.
    vim.keymap.set({ "n", "v" }, "<C-A-k>", function()
      mc.lineAddCursor(-1)
    end)
    vim.keymap.set({ "n", "v" }, "<C-A-j>", function()
      mc.lineAddCursor(1)
    end)
    vim.keymap.set({ "n", "v" }, "<C-A-up>", function()
      mc.lineSkipCursor(-1)
    end)
    vim.keymap.set({ "n", "v" }, "<C-A-down>", function()
      mc.lineSkipCursor(1)
    end)

    -- First add a cursor to the current word next jump the next match
    vim.keymap.set("n", "<D-d>", "viw")

    -- Add a cursor and jump to the next word under cursor.
    vim.keymap.set("v", "<D-d>", function()
      mc.addCursor "*"
    end)

    -- Jump to the next word under cursor but do not add a cursor.
    vim.keymap.set({ "n", "v" }, "<D-C-d>", function()
      mc.skipCursor "*"
    end)

    -- Rotate the main cursor.
    vim.keymap.set({ "n", "v" }, "<left>", mc.nextCursor)
    vim.keymap.set({ "n", "v" }, "<right>", mc.prevCursor)

    -- Delete the main cursor.
    vim.keymap.set({ "n", "v" }, "<leader>x", mc.deleteCursor)

    -- clone every cursor and disable the originals
    vim.keymap.set({ "n", "v" }, "<leader><c-q>", mc.duplicateCursors)

    vim.keymap.set("n", "<esc>", function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      else
        -- Default <esc> handler.
      end
    end)

    -- Align cursor columns.
    vim.keymap.set("v", "<leader>a", mc.alignCursors)

    -- Append/insert for each line of visual selections.
    vim.keymap.set("v", "I", mc.insertVisual)

    -- match new cursors within visual selections by regex.
    vim.keymap.set("v", "M", mc.matchCursors)

    -- Rotate visual selection contents.
    vim.keymap.set("v", "<leader>t", function()
      mc.transposeCursors(1)
    end)
    vim.keymap.set("v", "<leader>T", function()
      mc.transposeCursors(-1)
    end)

    -- Customize how cursors look.
    vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
    vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn" })
    vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
