vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 1

vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")


local netrw_line

vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)

        if vim.bo[buf].filetype ~= "netrw" then
            return
        end

        local row = vim.api.nvim_win_get_cursor(win)[1]
        netrw_line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1]
    end,
})

vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)

        if vim.bo[buf].filetype ~= "netrw" or not netrw_line then
            return
        end

        vim.schedule(function()
            if not vim.api.nvim_win_is_valid(win) then
                return
            end

            local current_buf = vim.api.nvim_win_get_buf(win)

            if vim.bo[current_buf].filetype ~= "netrw" then
                return
            end

            local pattern = "\\V" .. vim.fn.escape(netrw_line, "\\")

            vim.api.nvim_win_call(win, function()
                vim.fn.search(pattern, "W")
            end)
        end)
    end,
})