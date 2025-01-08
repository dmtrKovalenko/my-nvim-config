local macros = {
  {
    filetypes = { "typescriptreact" },
    binding = "<F1>",
    desc = "Wraps string under cursor with clsx and spreads down className",
    keys = 'ysa"{ysi{(itwMerge<Esc>l%i,className<Esc><F12>',
    mode = "i",
  },
  {
    filetypes = { "fugitive" },
    binding = "spu",
    desc = "Push stack",
    keys = "<cmd>terminal fish --command 'git spr update'<cr>",
  },
  {
    filetypes = { "fugitive" },
    binding = "gap",
    desc = "Amend lateest commit and force push",
    keys = "<cmd>terminal fish --command 'git commit --amend --no-edit && git push --force-with-lease'<cr>",
  },
  {
    filetypes = { "rust" },
    binding = "<F1>",
    desc = "Wrap the thing in Some(_)",
    mode = "x",
    keys = "S)iSome<Esc>"
  },
  {
    filetypes = { "rust" },
    binding = "<F1>",
    desc = "Wrap the thing in Some(_)",
    mode = "n",
    keys = "ysiw)iSome<Esc>"
  },
  {
    filetypes = { "rust" },
    binding = "<F2>",
    desc = "Wrap the thing in Ok(_)",
    mode = "x",
    keys = "S)iOk<Esc>"
  },
  {
    filetypes = { "rust" },
    binding = "<F2>",
    desc = "Wrap the thing in Ok(_)",
    mode = "n",
    keys = "ysiw)iOk<Esc>"
  }
}

return {
  setupMacro = function()
    for _, macro in ipairs(macros) do
      vim.api.nvim_create_autocmd("FileType", {
        pattern = macro.filetypes,
        callback = function()
          vim.keymap.set(macro.mode or "n", macro.binding, macro.keys, { desc = macro.desc, remap = true })
        end,
      })
    end
  end,
}
