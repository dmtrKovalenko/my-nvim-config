local macros = {
  typescriptreact = {
    {
      desc = "Wraps string under cursor with clsx and spreads down className",
      binding = "<F1>",
      keys = 'ysa"{ysi{(itwMerge<Esc>l%i,className<Esc><F12>',
    },
  },
  fugitive = {
    {
      binding = "spu",
      desc = "Push stack",
      keys = "<cmd>terminal fish --command 'git spr update'<cr>",
    },
    {
      binding = "gap",
      desc = "Amend lateest commit and force push",
      keys = "<cmd>terminal fish --command 'git commit --amend --no-edit && git push --force-with-lease'<cr>",
    },
  },
  rust = {
    {
      desc = "Wrap the thing in Some(_)",
      binding = "<F1>",
      mode = "x",
      keys = "S)iSome<Esc>",
    },
    {
      binding = "<F1>",
      mode = "n",
      keys = "ysiw)iSome<Esc>",
    },
    {
      binding = "<F1>",
      mode = "i",
      keys = "Some()<Left>",
    },
    {
      desc = "Wrap the thing in Ok(_)",
      binding = "<F2>",
      mode = "x",
      keys = "S)iOk<Esc>",
    },
    {
      binding = "<F2>",
      mode = "n",
      keys = "ysiw)iOk<Esc>",
    },
    {
      binding = "<F2>",
      mode = "i",
      keys = "Ok()<Left>",
    },
  },
  asm = {
    {
      binding = "gd",
      mode = "n",
      keys = function()
        local word = vim.fn.expand "<cword>"
        local search_pattern =  word .. ":"

        -- Store current position
        local initial_pos = vim.fn.getcurpos()

        -- Try to search for pattern with colon
        vim.fn.setreg("/", search_pattern)
        -- Use normal command for search to create jumplist entry
        vim.cmd "normal! n"

        -- If pattern with colon not found, try without colon
        if vim.fn.searchpos(search_pattern, "n")[1] == 0 then
          vim.fn.setreg("/", word)
          vim.cmd "normal! n"
        end

        -- Center the screen on the found match
        vim.cmd "normal! zz"
      end,
    },
  },
}

return {
  setupMacro = function()
    for filetype, bindings in pairs(macros) do
      vim.api.nvim_create_autocmd("FileType", {
        pattern = filetype,
        callback = function()
          print("Setting up macros for " .. filetype)
          for _, macro in ipairs(bindings) do
            vim.keymap.set(macro.mode or "n", macro.binding, macro.keys, { desc = macro.desc, remap = true })
          end
        end,
      })
    end
  end,
}
