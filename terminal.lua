vim.g.mapleader = "="
vim.g.maplocalleader = " "

vim.o.showmode = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.scrollback = 100000
vim.g.kitty_fast_forwarded_modifiers = "super"

vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.splitright = true
vim.o.splitbelow = true

-- As we are running terminal do not show the left column. It makes no sense.
vim.wo.signcolumn = "no"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"
vim.o.termguicolors = true

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local is_kitty = vim.env.KITTY_KITTEN == "true"

vim.opt.title = true
vim.opt.titlestring = '%{winnr("$")}xfish %{fnamemodify(getcwd(), ":~:.")}'

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  {
    "projekt0n/github-nvim-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    cond = function()
      return not is_kitty
    end,
    config = function()
      require("github-theme").setup {}

      vim.cmd "colorscheme github_dark_dimmed"
    end,
  },
  {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    cond = function()
      return not is_kitty
    end,
    opts = {
      options = {
        icons_enabled = false,
        theme = "nightfly",
      },
    },
  },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    config = function()
      require("kitty-scrollback").setup {
        custom = function()
          vim.print "customstuff"
        end,
      }
    end,
  },

  require("telescope-lazy").lazy { onlyLocalSearch = true },
}

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.opt.termguicolors = true

vim.api.nvim_set_keymap("n", "<C-j>", "10j", { silent = true })
vim.api.nvim_set_keymap("v", "<C-j>", "10j", { silent = true })

vim.api.nvim_set_keymap("n", "<C-k>", "10k", { silent = true })
vim.api.nvim_set_keymap("v", "<C-k>", "10k", { silent = true })

-- Exit terminal mode with Esc
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { nowait = true })
vim.api.nvim_set_keymap("n", "<C-c>", "i<C-c>", {})

-- Rebinds the splits to immediately open the the new terminal on the right/bottom.
vim.api.nvim_set_keymap("n", "<C-w>v", ":vsplit<CR><C-w>w:terminal<CR>", { silent = true })
vim.keymap.set({ "n", "t" }, "<A-D-v>", "<C-\\><C-n>:vsplit<CR><C-w>w:terminal<CR>", { silent = true })

vim.api.nvim_set_keymap("n", "<C-w>s", ":split<CR><C-w>w:terminal<CR>", { silent = true })
vim.keymap.set({ "n", "t" }, "<A-D-s>", "<C-\\><C-n>:split<CR><C-w>w:terminal<CR>", { silent = true })

vim.api.nvim_set_keymap("n", "<D-A-l>", "<C-w>l", { silent = true })
vim.api.nvim_set_keymap("n", "<D-A-h>", "<C-w>h", { silent = true })
vim.api.nvim_set_keymap("n", "<D-A-q>", "<C-w>q", { silent = true })
vim.api.nvim_set_keymap("n", "<D-A-j>", "<C-w>j", { silent = true })
vim.api.nvim_set_keymap("n", "<D-A-k>", "<C-w>k", { silent = true })

vim.api.nvim_set_keymap("t", "<D-A-l>", "<Esc><C-w>l", { silent = true })
vim.api.nvim_set_keymap("t", "<D-A-h>", "<Esc><C-w>h", { silent = true })
vim.api.nvim_set_keymap("t", "<D-A-q>", "<Esc><C-w>q", { silent = true })
vim.api.nvim_set_keymap("t", "<D-A-j>", "<Esc><C-w>j", { silent = true })
vim.api.nvim_set_keymap("t", "<D-A-k>", "<Esc><C-w>k", { silent = true })

local editor_command = "nvim"

function OpenInEditor()
  local clipboard_content = vim.fn.getreg "+"
  local command = editor_command .. " " .. clipboard_content

  vim.fn.system(command)
end

-- Create function
function Lightsource_setup()
  -- First terminal in vertical split
  vim.cmd "86 vsplit | terminal just fe-dev"

  -- -- Navigate back to the first window
  -- vim.cmd('wincmd p')

  vim.cmd "24 split | terminal btop --preset 2"
  -- Second terminal in horizontal split - replace 'cli_command1' with your first command

  -- Navigate to the third window (second terminal)
  vim.cmd "wincmd w"
  vim.api.nvim_feedkeys("i", "n", false)
end

-- Register the command
vim.api.nvim_exec(
  [[
  command! LightSourceSetup lua Lightsource_setup()
]],
  false
)

vim.keymap.set("n", "gf", OpenInEditor, { silent = true })

-- Remove background color from the theme to avoid color difference with you terminal emulators
-- (may look bad depends on the different tty app and themes)
vim.cmd "highlight Normal guibg=None"

if not is_kitty then
  -- Finally start the terminal mode whenever new neovim started with this config
  vim.cmd "terminal"
end
