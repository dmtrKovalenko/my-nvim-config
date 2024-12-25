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

-- Enale mouse mode
vim.o.mouse = "a"
vim.o.foldmethod = "manual"
vim.o.autochdir = true

-- Sync clipboard between OS and Neovim.
--  move this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
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
-- Highlight current line as cursor
vim.o.cursorline = true

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
  return icon or "✌️"
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

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<D-e>", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<D-S-m>", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_lsp_attach = function(client, bufnr)
  local lsp_map = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { remap = true, buffer = bufnr, desc = desc, silent = true })
  end

  -- if vim.bo.filetype == "rust" then
  --   lsp_map("<D-.>", ":RustLsp codeAction<CR>", "[C]ode [A]ction")
  --   vim.keymap.set("n", "<F4>", ":RustLsp debuggables<CR>", { silent = true, desc = "Rust: Debuggables" })
  -- else
  --   lsp_map("<D-.>", require("actions-preview").code_actions, "[C]ode [A]ction")
  -- end
  lsp_map("<D-.>", require("actions-preview").code_actions, "[C]ode [A]ction")

  lsp_map("<D-r>", require("renamer").rename, "[R]e[n]ame")

  lsp_map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  lsp_map("gD", vim.lsp.buf.definition, "[G]oto [D]eclaration")
  lsp_map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  lsp_map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

  lsp_map("<D-g>", "<C-]>", "[G]oto [D]efinition")
  lsp_map("<D-A-g>", vim.lsp.buf.type_definition, "Type [D]efinition")

  lsp_map("<D-i>", vim.lsp.buf.hover, "Hover Documentation")
  lsp_map("<D-u>", vim.lsp.buf.signature_help, "Signature Documentation")

  lsp_map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  lsp_map("<leader>lr", function()
    vim.cmd "LspRestart"
  end, "Lsp [R]eload")
  lsp_map("<leader>li", function()
    vim.cmd "LspInfo"
  end, "Lsp [R]eload")
  lsp_map("<leader>lh", function()
    local bufFitler = { bufnr }
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
  end, "Lsp toggle inlay [h]ints")
end

-- Enable the following language servers
local servers = {
  clangd = {
    filetypes = { "c", "cpp", "proto" },
    cmd = {
      "clangd",
      "--background-index",
      "--query-driver=/Users/dmtrkovalenko/.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-gcc",
      "--offset-encoding=utf-16",
    },
  },
  eslint = {
    filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  },
  html = { filetypes = { "html", "twig", "hbs" } },
  lua_ls = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
  typos_lsp = {
    single_file_support = false,
    init_options = { diagnosticSeverity = "WARN" },
  },
  grammarly = {
    -- Grammarly language server requires node js 16.4 ¯\_(ツ)_/¯
    -- https://github.com/neovim/nvim-lspconfig/issues/2007
    cmd = {
      "n",
      "run",
      "16.4",
      "/Users/dmtrkovalenko/.local/share/nvim/mason/bin/grammarly-languageserver",
      "--stdio",
    },
    filetypes = { "markdown", "text", "hgcommit", "gitcommit" },
  },
  bashls = {
    settings = {
      includeAllWorkspaceSymbols = true,
    },
  },
  pylsp = {},
  astro = {},
  dhall_lsp_server = {},
  marksman = {},
  taplo = {},
}

-- Setup neovim lua configuration
require("neodev").setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- it then vim cmp overrides only completion part of the text document. leave all other preassigned
capabilities.textDocument.completion =
  require("cmp_nvim_lsp").default_capabilities(capabilities).textDocument.completion

-- optimizes cpu usage source https://github.com/neovim/neovim/issues/23291
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

local signs = { Error = "󰚌 ", Warn = " ", Hint = "󱧡 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local border = {
  { "╭", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╮", "FloatBorder" },
  { "│", "FloatBorder" },
  { "╯", "FloatBorder" },
  { "─", "FloatBorder" },
  { "╰", "FloatBorder" },
  { "│", "FloatBorder" },
}

local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border,
  }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border,
  }),
}

-- Your existing floating preview override
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

require("typescript-tools").setup {
  on_attach = on_lsp_attach,
  handlers = handlers,
}

vim.g.rustaceanvim = {
  -- LSP configuration
  server = {
    on_attach = on_lsp_attach,
    default_settings = {
      -- rust-analyzer language server configuration
      ["rust-analyzer"] = {
        check = {
          allTargets = false,
        },
        files = {
          excludeDirs = { "target", "node_modules", ".git", ".sl" },
        },
      },
    },
  },
  dap = {
    adapter = {
      type = "executable",
      command = "/opt/homebrew/opt/llvm/bin/lldb-vscode", -- adjust as needed, must be absolute path
      name = "lldb",
    },
  },
}

-- Ensure the servers above are installed
local mason_lspconfig = require "mason-lspconfig"

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require("lspconfig")[server_name].setup {
      capabilities = capabilities,
      on_attach = on_lsp_attach,
      settings = servers[server_name],
      single_file_support = (servers[server_name] or {}).single_file_support,
      filetypes = (servers[server_name] or {}).filetypes,
      cmd = (servers[server_name] or {}).cmd,
      init_options = (servers[server_name] or {}).init_options,
    }
  end,
}

-- In order to enforce using the ocaml lsp from the current switch/sandbox/esy env avoid using mason
-- and configure ocaml lsp manually.
require("lspconfig").ocamllsp.setup {
  capabilities = capabilities,
  on_attach = on_lsp_attach,
  handlers = handlers,
  settings = {},
}

require("lspconfig").relay_lsp.setup {
  handlers = handlers,
  capabilities = capabilities,
  on_attach = on_lsp_attach,
  cmd = { "yarn", "relay-compiler", "lsp" },
  settings = {},
}

-- Set all the overrides and the extensions for the things that are available in native vim
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- My lovely vertical navigation speedups (do not add them to the jumplist)
vim.keymap.set("n", "<C-j>", "<cmd>keepjumps normal! }<CR>", { silent = true, remap = true })
vim.keymap.set("v", "<C-j>", "}", { silent = true, remap = true })
vim.keymap.set("n", "<C-k>", "<cmd>keepjumps normal! {<CR>", { silent = true, remap = true })
vim.keymap.set("v", "<C-k>", "{", { silent = true, remap = true })
vim.keymap.set({ "n", "v" }, "-", "$", { silent = true })

-- Move lines up and down
-- Normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
-- Visual mode
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv=gv", { noremap = true, silent = true })

-- Make backspace work as black hole cut
vim.keymap.set("n", "<backspace>", '"_dh', { noremap = true })
vim.keymap.set("v", "<backspace>", '"_d', { noremap = true })

-- Write file on cmd+s
vim.keymap.set("n", "<D-s>", "w<CR>", { silent = true })
-- Open git
vim.keymap.set("n", "<A-g>", "<cmd>Git<CR>", { silent = true })
vim.keymap.set("n", "<D-S-g>", "<cmd>Git<CR>", { silent = true })

-- Move to next occurrence using native search
vim.keymap.set("n", "<D-n>", "*", { silent = true })
vim.keymap.set("n", "<D-S-n>", "#", { silent = true })

-- Delete a word by alt+backspace
vim.keymap.set({ "i", "c" }, "<A-BS>", "<C-w>", { noremap = true })
vim.keymap.set("n", "<A-BS>", "db", { noremap = true })

-- Select whole buffer
vim.keymap.set("n", "<D-a>", "ggVG", {})

-- Comment out lines
vim.keymap.set("n", "<D-_>", "gcc", {})
vim.keymap.set("v", "<D-_>", "gc", {})

-- Clear line with cd
vim.keymap.set("n", "cd", "0D", {})

-- Switch between buffers
vim.keymap.set("n", "H", "<cmd>bprevious<CR>", { silent = true })
vim.keymap.set("n", "L", "<cmd>bnext<CR>", { silent = true })

vim.keymap.set({ "n", "v" }, "<C-h>", "b", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-l>", "w", { silent = true })

-- Duplicate lines
vim.keymap.set("v", "<D-C-Up>", "y`>p`<", { silent = true })
vim.keymap.set("n", "<D-C-Up>", "Vy`>p`<", { silent = true })
vim.keymap.set("v", "<D-C-Down>", "y`<kp`>", { silent = true })
vim.keymap.set("n", "<D-C-Down>", "Vy`<p`>", { silent = true })

-- Map default <C-w> to the cmd+alt
vim.keymap.set("n", "<D-A-v>", "<C-w>v<C-w>w", { silent = true })
vim.keymap.set("n", "<D-A-s>", "<C-w>s<C-w>j", { silent = true })
vim.keymap.set("n", "<D-A-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<D-A-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<D-A-q>", "<C-w>q", { silent = true })
vim.keymap.set("n", "<D-A-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<D-A-k>", "<C-w>k", { silent = true })

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set({ "n" }, "<D-s>", "<cmd>w<CR>", { silent = true, desc = "Save file" })

-- Swap the p and P to not mess up the clipbard with replaced text
-- but leave the ability to paste the text
vim.keymap.set("x", "p", "P", {})
vim.keymap.set("x", "P", "p", {})

-- Exit terminal mode with Esc
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { nowait = true })

-- A bunch of useful shortcuts for one-time small actions bound on leader
vim.keymap.set("n", "<leader>n", "<cmd>nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<leader><leader>", "zz", { silent = true })
vim.keymap.set("n", "<A-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<A-s>", [[y:%s/<C-r>"/<C-r>"/gI<Left><Left><Left>]])

-- A bunch of remaps for the command lilne mode
vim.keymap.set({ "c", "i" }, "<C-a>", "<Home>", { silent = true })
vim.keymap.set({ "c", "i" }, "<C-e>", "<End>", { silent = true })
vim.keymap.set({ "c", "i" }, "<A-Bs>", "<C-w>", { noremap = true })

--  Pull one line down useful rempaps from the numeric line
vim.keymap.set("n", "<C-t>", "%", { remap = true })

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
vim.cmd [[command! -nargs=1 Browse silent lua vim.fn.system('open ' .. vim.fn.shellescape(<q-args>, 1))]]
vim.cmd [[highlight DiagnosticUnderlineError cterm=undercurl gui=undercurl guisp=#f87171]]

-- Simulate netrw gx without netrw
-- Map 'gx' to open the file or URL under cursor
vim.keymap.set("n", "gx", function()
  local target = vim.fn.expand "<cfile>"
  vim.fn.system(string.format("open '%s'", target))
end, { silent = false })

require("refactoring-macro").setupMacro()

if os.getenv "PRESENTATION" then
  vim.cmd "LspStop"
  vim.o.relativenumber = false
  vim.o.cursorline = false
end
