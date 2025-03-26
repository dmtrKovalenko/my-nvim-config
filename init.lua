vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.kitty_fast_forwarded_modifiers = "super"

local IS_STREAMING = os.getenv "STREAM" ~= nil
if IS_STREAMING then
  vim.print "Subscribe to my twitter @goose_plus_plus"
end

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Default value for tabstop
vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.o.tags = "./tags;"
-- Enale mouse mode
vim.o.mouse = "a"
vim.o.foldmethod = "manual"
vim.o.autochdir = true

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = "unnamedplus"
vim.o.showmode = false

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"
-- Set timeout for key sequences
vim.o.timeout = true
vim.o.timeoutlen = 250

-- Improve default search behavior
vim.o.incsearch = true

-- Set the scolloff
vim.o.scrolloff = 10
-- No highlight current line as cursor
vim.o.cursorline = false

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- set termguicolors to enable highlight groups
vim.o.termguicolors = true

-- Renders spaces as "·"
vim.opt.list = true
vim.opt.listchars = vim.opt.listchars + "space:·"

-- Do not create swap files as this config autosaving everything on disk
vim.opt.swapfile = false
-- Set terminal tab title to `filename (cwd)`
vim.opt.title = true
function GetCurrentIconFile()
  local filename = vim.fn.expand "%:t"
  local icon = require("nvim-web-devicons").get_icon(filename)
  return icon or ""
end
vim.o.titlestring = '%{fnamemodify(getcwd(), ":t")} %{v:lua.GetCurrentIconFile()} %{expand("%:t")}'

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

function _G.close_floating_wins()
  require("edgy").close()
  require("nvterm.terminal").close_all_terms()
end

require("lazy").setup("plugins", {})

-- [[ Custom Autocmds]]
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = "*",
})

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave" }, {
  command = "silent! wa",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "css", "html", "json", "yaml", "markdown" },
  callback = function()
    vim.opt.iskeyword:append { "-", "#", "$" }
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.wrap = false
    vim.opt.linebreak = true
  end,
})

vim.filetype.add { extension = { wgsl = "wgsl" } }

local function open_file_under_cursor_in_the_panel_above()
  local has_telescope, telescope = pcall(require, "telescope.builtin")

  local filename = vim.fn.expand "<cfile>"
  local full_path_with_suffix = vim.fn.expand "<cWORD>"

  vim.api.nvim_command "wincmd k"

  if vim.loop.fs_stat(filename) then
    vim.api.nvim_command(string.format("e %s", full_path_with_suffix))
  elseif has_telescope then
    telescope.find_files {
      prompt_prefix = "🪿 ",
      default_text = full_path_with_suffix,
      wrap_results = true,
      find_command = { "rg", "--files", "--no-require-git" },
    }
  else
    error(string.format("File %s does not exist", filename))
  end
end

-- Opens file under cursor in the panel above
vim.keymap.set("n", "gf", open_file_under_cursor_in_the_panel_above, { silent = true })

-- Set of commands that should be executed on startup
vim.cmd [[command! -nargs=1 Browse silent lua vim.fn.system('open ' .. vim.fn.s3c4048hellescape(<q-args>, 1))]]
vim.cmd [[highlight DiagnosticUnderlineError cterm=undercurl gui=undercurl guisp=#f87171]]

local function smart_delete(key)
  local l = vim.api.nvim_win_get_cursor(0)[1] -- Get the current cursor line number
  local line = vim.api.nvim_buf_get_lines(0, l - 1, l, true)[1] -- Get the content of the current line
  return (line:match "^%s*$" and '"_' or "") .. key -- If the line is empty or contains only whitespace, use the black hole register
end

local keys = { "d", "dd", "x", "c", "s", "C", "X" } -- Define a list of keys to apply the smart delete functionality

-- Set keymaps for both normal and visual modes
for _, key in pairs(keys) do
  vim.keymap.set({ "n", "v" }, key, function()
    return smart_delete(key)
  end, { noremap = true, expr = true, desc = "Smart delete" })
end

require "keymap"
require("language-specific-macro").setupMacro()
