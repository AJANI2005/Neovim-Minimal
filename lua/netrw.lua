vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 1

vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")


local current_file

vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)

        if vim.bo[buf].filetype ~= "netrw" then
            return
        end

        current_file = vim.fn.expand("%:t")
    end,
})

vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        local buf = vim.api.nvim_win_get_buf(0)

        if vim.bo[buf].filetype ~= "netrw" or not current_file then
            return
        end

        vim.schedule(function()
            vim.fn.search("\\V" .. vim.fn.escape(current_file, "\\"), "W")
        end)
    end,
})