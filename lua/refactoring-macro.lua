local macros = {
  {
    filetypes = { "typescriptreact" },
    binding = "<F1>",
    desc = "Wraps string under cursor with clsx and spreads down className",
    keys = 'ysa"{ysi{(iclsx<Esc>l%i,className<Esc><F12>',
  },
}

return {
  setupMacro = function()
    for _, macro in ipairs(macros) do
      vim.api.nvim_create_autocmd("FileType", {
        pattern = macro.filetypes,
        callback = function()
          vim.keymap.set("n", macro.binding, function()
            local keys = vim.api.nvim_replace_termcodes(macro.keys, true, false, true)
            vim.api.nvim_feedkeys(keys, "i", true)
          end, { desc = macro.desc, remap = true })
        end,
      })
    end
  end,
}
