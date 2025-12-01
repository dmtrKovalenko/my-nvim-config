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
vim.keymap.set("n", "<D-S-g>", "<cmd>above Git<CR>", { silent = true })

-- Move to next occurrence using native search
vim.keymap.set("n", "<D-n>", "*", { silent = true })
vim.keymap.set("n", "<D-S-n>", "#", { silent = true })

-- Delete a word by alt+backspace
vim.keymap.set({ "i", "c" }, "<A-BS>", "<C-w>", { noremap = true })
vim.keymap.set("n", "<A-BS>", "db", { noremap = true })

-- Select whole buffer
vim.keymap.set("n", "<D-a>", "ggVG", {})

-- Force reload the buffer
vim.keymap.set("n", "<leader>e", "<cmd>e!<cr>", {})

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

vim.keymap.set("n", "<C-g>", function()
  local relative_path = vim.fn.expand "%:."
  if relative_path ~= "" then
    vim.fn.setreg("+", relative_path)
    vim.notify(relative_path, 0)
  end
end, { silent = true, noremap = true, desc = "Show and copy relative file path" })

vim.keymap.set("n", "<C-q>", function()
  local current_win = vim.api.nvim_get_current_win()
  local current_config = vim.api.nvim_win_get_config(current_win)

  -- If current window is floating, close it
  if current_config.relative ~= "" then
    vim.api.nvim_win_close(current_win, false)
    return
  end

  local normal_windows = {}
  local has_outline = false

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == "" then -- Non-floating windows
      table.insert(normal_windows, win)
      local bufnr = vim.api.nvim_win_get_buf(win)
      local filetype = vim.bo[bufnr].filetype
      if filetype == "Outline" then
        has_outline = true
      end
    end
  end

  if #normal_windows == 2 and has_outline then
    vim.cmd "qa"
  else
    -- Use the original <C-w>q behavior
    vim.cmd "quit"
  end
end, { silent = true, noremap = true, nowait = true, desc = "Smart quit" })

vim.keymap.set("n", "<C-D-h>", "<cmd>wincmd h<CR>", { silent = true, nowait = true, desc = "Go to left window" })
vim.keymap.set("n", "<C-D-l>", "<cmd>wincmd l<CR>", { silent = true, nowait = true, desc = "Go to right window" })
vim.keymap.set("n", "<C-D-j>", "<cmd>wincmd j<CR>", { silent = true, nowait = true, desc = "Go to bottom window" })
vim.keymap.set("n", "<C-D-k>", "<cmd>wincmd k<CR>", { silent = true, nowait = true, desc = "Go to top window" })

vim.keymap.set("n", "<C-D-Up>", "<Cmd>resize +2<CR>", { silent = true, nowait = true, desc = "Taller" })
vim.keymap.set("n", "<C-D-Down>", "<Cmd>resize -2<CR>", { silent = true, nowait = true, desc = "Shorter" })
vim.keymap.set("n", "<C-D-Right>", "<Cmd>vertical resize +5<CR>", { silent = true, nowait = true, desc = "Wider" })
vim.keymap.set("n", "<C-D-Left>", "<Cmd>vertical resize -5<CR>", { silent = true, nowait = true, desc = "Narrower" })
vim.keymap.set("n", "<C-D-o>", "<cmd>wincmd o<CR>", { silent = true, nowait = true, desc = "Quit other windows" })

vim.keymap.set(
  "n",
  "<C-D-v>",
  "<cmd>rightbelow vsplit<cr>",
  { silent = true, nowait = true, desc = "Split window vertically" }
)

vim.keymap.set(
  "n",
  "<C-D-s>",
  "<cmd>rightbelow split<cr>",
  { silent = true, nowait = true, desc = "Split window horizontally" }
)

vim.keymap.set("x", "$", function()
  vim.notify "Learn new move you lazy bitch"
end, { silent = true })
vim.keymap.set("x", "0", function()
  vim.notify "Learn new move you lazy bitch"
end, { silent = true })
