vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.showmode = false
vim.o.wrap = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.scrollback = 100000
vim.g.kitty_fast_forwarded_modifiers = "super"

vim.o.mouse = "a"
vim.opt.termguicolors = true
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

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
local ssh_prefix = require("ssh_helper").ssh_prefix

vim.opt.title = true
vim.opt.titlestring = ssh_prefix .. '%{winnr("$")}xfish %{fnamemodify(getcwd(), ":~:.")}'

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
  "nvim-tree/nvim-web-devicons",
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
    priority = 1000,
    "nvim-lualine/lualine.nvim",
    cond = function()
      return not is_kitty
    end,
    opts = {
      options = {
        theme = "auto",
        icons_enabled = true,
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
  require "plugins/oil",
  require "plugins/hop",
}

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

require "keymap"

vim.api.nvim_set_keymap("n", "<C-j>", "10j", { silent = true })
vim.api.nvim_set_keymap("v", "<C-j>", "10j", { silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "10k", { silent = true })
vim.api.nvim_set_keymap("v", "<C-k>", "10k", { silent = true })

-- Rebinds the splits to immediately open the the new terminal on the right/bottom.
vim.api.nvim_set_keymap("n", "<C-w>v", "<cmd>vsplit<CR><C-w>w:terminal<CR>", { silent = true })
vim.keymap.set({ "n", "t" }, "<A-D-v>", "<C-\\><C-n>:vsplit<CR><C-w>w:terminal<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<C-w>s", "<cmd>split<CR><C-w>w:terminal<CR>", { silent = true })
vim.keymap.set({ "n", "t" }, "<A-D-s>", "<C-\\><C-n>:split<CR><C-w>w:terminal<CR>", { silent = true })

function Lightsource_setup()
  vim.opt.titlestring = ssh_prefix .. "󱐋 LightSource"
  vim.cmd "vsplit | terminal fish -C 'just fe-dev'"
  vim.cmd "28 split | terminal fish -C 'btop --preset 2'"
  vim.cmd "wincmd h"
  vim.cmd "6 split | terminal fish -C 'SPICEDB_SCHEMA_FILE=./spicedb/schema.zed SPICEDB_GRPC_PRESHARED_KEY=insecure-key SPICEDB_DATASTORE_CONN_URI=postgresql://postgres@127.0.0.1/lightsource_spicedb docker/spicedb/entrypoint.sh'"

  vim.opt_local.number = false
  vim.opt_local.relativenumber = false

  -- Navigate to the third window (second terminal)
  vim.cmd "wincmd w"
  vim.cmd "wincmd h"
  vim.api.nvim_feedkeys("i", "n", false)
end

-- Register the command
vim.cmd [[
  command! LightSourceSetup lua Lightsource_setup()
]]

-- Remove background color from the theme to avoid color difference with you terminal emulators
-- (may look bad depends on the different tty app and themes)
vim.cmd "highlight Normal guibg=None"

if not is_kitty then
  -- Finally start the terminal mode whenever new neovim started with this config
  vim.cmd "terminal"
end
