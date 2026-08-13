vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 1

vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")

local netrw_view

vim.api.nvim_create_autocmd("BufWinLeave", {
    callback = function()
        if vim.bo.filetype == "netrw" then
            netrw_view = vim.fn.winsaveview()
        end
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
        if vim.bo.filetype == "netrw" and netrw_view then
            vim.fn.winrestview(netrw_view)
        end
    end,
})