vim.keymap.set("n", "<D-e>", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<D-S-m>", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

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

vim.keymap.set("n", "<C-s>", "<cmd>rightbelow vsplit<cr>", { silent = true })
vim.keymap.set("n", "<leader>ss", "<cmd>rightbelow split<cr>", { silent = true })

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
-- Exit insert mode with jj when using normal keyboard
vim.keymap.set("i", "jj", "<Esc>", { nowait = true })

-- A bunch of useful shortcuts for one-time small actions bound on leader
vim.keymap.set("n", "<leader>n", "<cmd>nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<leader><leader>", "zz", { silent = true })
vim.keymap.set("n", "<A-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("x", "<A-s>", [[y:%s/<C-r>"/<C-r>"/gI<Left><Left><Left>]])
-- Multiword step by step repeated editing
vim.keymap.set("n", "<C-n>", "*Ncgn")
vim.keymap.set("x", "<C-n>", [[y/\V<C-R>=escape(@", '/\')<CR><CR>Ncgn]])

-- A bunch of remaps for the command lilne mode
vim.keymap.set({ "c", "i" }, "<C-a>", "<Home>", { silent = true })
vim.keymap.set({ "c", "i" }, "<C-e>", "<End>", { silent = true })
vim.keymap.set({ "c", "i" }, "<A-Bs>", "<C-w>", { noremap = true })

--  Pull one line down useful rempaps from the numeric line
vim.keymap.set("n", "<C-t>", "%", { remap = true })

vim.keymap.set("n", "<S-h>", "<cmd>e#<cr>", { silent = true })

-- Map 'gx' to open the file or URL under cursor
vim.keymap.set("n", "gx", function()
  local target = vim.fn.expand "<cfile>"
  vim.fn.system(string.format("open '%s'", target))
end, { silent = false })

vim.keymap.set("n", "gd", function()
  local word = vim.fn.expand "<cword>"
  local save_cursor = vim.api.nvim_win_get_cursor(0)
  local win_id = vim.api.nvim_get_current_win()

  vim.api.nvim_win_set_cursor(win_id, { 1, 0 })

  local patterns = {
    -- Word followed by exactly one colon (to handle Type:: syntax aka rust & Haskell)
    colon = "\\<" .. word .. "\\>\\s*:\\([^:]\\|$\\)",
    basic = "\\<" .. word .. "\\>",
    flexible = word,
  }

  -- Search function that handles both position finding and cursor setting
  local function try_search(pattern)
    local line, col = unpack(vim.fn.searchpos(pattern, "n"))
    if line > 0 then
      vim.api.nvim_win_set_cursor(win_id, { line, col - 1 })
      vim.fn.setreg("/", pattern)
      return true
    end
    return false
  end

  local found = try_search(patterns.colon) or try_search(patterns.basic) or try_search(patterns.flexible)

  if found then
    vim.opt.hlsearch = true
    vim.cmd "normal! zz"
  else
    vim.api.nvim_win_set_cursor(win_id, save_cursor)
    vim.notify(string.format("Pattern '%s' not found", word), "warn", { title = "Search Failed" })
  end
end, { remap = true, desc = "Naive file local jump to definition attempt" })
