return {
  "stevearc/oil.nvim",
  lazy = true,
  cmd = "Oil",
  keys = {
    { "<D-o>", "<cmd>Oil<CR>", silent = true, desc = "Open Oil" },
  },
  opts = {
    keymaps = {
      ["<D-i>"] = "actions.select",
      ["cc"] = {
        desc = "Copy filepath to system clipboard",
        callback = function()
          require("oil.actions").copy_entry_path.callback()
          vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
          vim.notify("Copied full path", "info", { title = "Oil" })
        end,
      },
    },
    default_file_explorer = true,
    delete_to_trash = true,
    view_options = {
      show_hidden = true,
      case_insensitive = true,
    },
    lsp_file_methods = {
      autosave_changes = true,
    },
  },
}
