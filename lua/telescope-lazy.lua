local function lazy(options)
  -- Fuzzy Finder (files, lsp, etc)
  return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      "kkharji/sqlite.lua",
      'prochri/telescope-all-recent.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return not options.onlyLocalSearch and vim.fn.executable 'make' == 1
        end,
      },
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
        version = "^1.0.0",
        config = function()
          require("telescope").load_extension("live_grep_args")
        end
      }
    },
    config = function()
      -- Enable telescope fzf native, if installed
      if not options.onlyLocalSearch then
        pcall(require('telescope').load_extension, 'fzf')
        require('telescope').load_extension('projects')

        local function find_files()
          require('telescope.builtin').find_files({
            prompt_prefix = '🔍 ',
            find_command = { 'rg', '--files', '--no-require-git' },
          })
        end

        local function live_grep()
          require('telescope.builtin').live_grep({
            max_results = 1,
            addional_args = function()
              return { '--files' }
            end,
          })
        end

        vim.keymap.set('n', '<D-k>', find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<D-S-f>', live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<D-C-r>', ':Telescope projects<CR>', { desc = '[S]earch [P]projects' })
        vim.keymap.set('n', '<D-m>', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<D-o>', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
        vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
        vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
      end

      -- Sorts output of the telescope (all the pickers) using fecency alghoritm
      require 'telescope-all-recent'.setup({})

      -- Set telescope keymaps
      vim.keymap.set('n', '<D-f>', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          previewer = true,
        })
      end, { desc = '] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<D-p>', require('telescope.builtin').commands, { desc = 'Search commands' })
      vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })

      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ['<A-Bs>'] = function()
                local keys = vim.api.nvim_replace_termcodes('<C-w>', true, false, true)
                vim.api.nvim_feedkeys(keys, "i", true)
              end
            },
          },
        },
      }
    end
  }
end

return {
  lazy = lazy,
}
