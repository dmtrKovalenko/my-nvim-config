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
-- Exit insert mode with jj when using normal keyboard
vim.keymap.set("i", "jj", "<Esc>", { nowait = true })

-- A bunch of useful shortcuts for one-time small actions bound on leader
vim.keymap.set("n", "<leader>n", "<cmd>nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<leader><leader>", "zz", { silent = true })
vim.keymap.set("n", "<A-s>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<A-r>", [[y:%s/<C-r>"/<C-r>"/gI<Left><Left><Left>]])
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
  local status, err = pcall(function()
    local word = vim.fn.expand "<cword>"
    local search_pattern = "\\<" .. word .. "\\>:"

    if vim.fn.searchpos(search_pattern, "n")[1] ~= 0 then
      vim.fn.setreg("/", search_pattern)
      vim.cmd "normal! n"
      vim.cmd "normal! zz"
    elseif vim.fn.searchpos("\\<" .. word .. "\\>", "n")[1] ~= 0 then
      local basic_pattern = "\\<" .. word .. "\\>"
      vim.fn.setreg("/", basic_pattern)
      vim.cmd "normal! n"
      vim.cmd "normal! zz"
    else
      vim.notify(string.format("Pattern '%s' not found", word), "warn", { title = "Search failed" })
    end
  end)

  if not status then
    vim.api.nvim_echo({ { string.format("Search failed: %s", err), "ErrorMsg" } }, false, {})
  end
end, { remap = true, desc = "Naive file local jump to definition attempt" })
