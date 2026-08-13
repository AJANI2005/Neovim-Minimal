-- options
vim.cmd("colorscheme default")
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

vim.o.complete = ".,o"
vim.o.completeopt = "menu,menuone,noselect,popup"
vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
vim.o.autocomplete = true
vim.o.pumheight = 12

-- diagnostics
vim.diagnostic.config({ virtual_text = true })


-- keymaps
vim.keymap.set("n", "<leader>d", function()
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


-- restore cursor
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function()
        if vim.bo.buftype ~= "" then
            return
        end

        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local line_count = vim.api.nvim_buf_line_count(0)

        if mark[1] > 0 and mark[1] <= line_count then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- import modules in lua directory
require("lsp")	   --language server protocol
require("find")    --fuzzy finding and live grep
require("term")    --integrated terminal
require("vscode")  --integration with vscode
require("netrw")