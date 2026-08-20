-- options
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", }
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.termguicolors = true
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.o.complete = ".,o"
vim.o.completeopt = "menu,menuone,noselect,popup"
vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
vim.o.autocomplete = true
vim.o.pumheight = 12
vim.opt.isfname:append("@-@")

-- diagnostics
vim.diagnostic.config({ virtual_text = true })
-- keymaps
vim.keymap.set("n", "<leader>x", function()
  vim.diagnostic.setqflist()
  vim.lsp.buf.workspace_diagnostics()
  vim.cmd("copen")
end, { silent = true })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "NetRW" })
vim.keymap.set("n", "<leader>so", "<cmd>source %<CR>", { desc = "Source Current File" })
vim.keymap.set("n", "<leader>q", "<cmd>close<CR>", { desc = "Close Window" })
vim.keymap.set("n", "<leader>fb", "<cmd>lua vim.lsp.buf.format()<CR>", { desc = "Format Buffer" })
vim.keymap.set("n", "<C-h>", "<cmd>wincmd h<CR>")
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>wincmd k<CR>")
vim.keymap.set("n", "<C-l>", "<cmd>wincmd l<CR>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line" })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv") -- keep search term centered
vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste without changing buffer" })
vim.keymap.set("n","Q", "<nop>") -- worst place in the universe
-- Substitute
vim.keymap.set({"n"}, "<leader>sw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- substitute selection
vim.keymap.set({"v"}, "<leader>sw", [["hy:%s/\V<C-r>h/<C-r>h/gI<Left><Left><Left>]])

-- split window
vim.keymap.set("n", "<leader>sv", "<C-w>v<C-w>l", { desc = "Split Window Vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s<C-w>j", { desc = "Split Window Horizontally" })

-- Highlight selection on 
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  desc = "highlight selection on yank",
  callback = function()
    vim.highlight.on_yank({ timeout = 200, visual = true })
  end,
})

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- defer centering slightly so it's applied after render
      vim.schedule(function()
        vim.cmd("normal! zz")
      end)
    end
  end,
})

-- import modules in lua directory
require("colorscheme") --custom theme
require("find")        --fuzzy finding and live grep
require("term")        --integrated terminal
require("vscode")      --integration with vscode
require("netrw")       --netrw improvements
require("statusline")  --custom statusline
require("plugins")     --experimental plugins
