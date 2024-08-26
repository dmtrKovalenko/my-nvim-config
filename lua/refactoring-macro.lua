local macros = {
  {
    filetypes = { "typescriptreact" },
    binding = "<F1>",
    desc = "Wraps string under cursor with clsx and spreads down className",
    keys = 'ysa"{ysi{(itwMerge<Esc>l%i,className<Esc><F12>',
    mode = "i",
  },
  {
    filetypoes = { "fugitive" },
    binding = "spu",
    desc = "Push stack",
    keys = "<cmd>terminal fish --command 'git spr update'<cr>",
  },
  {
    filetypoes = { "fugitive" },
    binding = "gap",
    desc = "Amend lateest commit and force push",
    keys = "<cmd> terminal fish --command 'git commit --amend --no-edit && git push --force-with-lease'<cr>",
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
            vim.api.nvim_feedkeys(keys, macro.mode or "n", true)
          end, { desc = macro.desc, remap = true })
        end,
      })
    end
  end,
}
