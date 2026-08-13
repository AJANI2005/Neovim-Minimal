vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 1

vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")

local netrw_state = {}

vim.api.nvim_create_autocmd("BufWinLeave", {
    pattern = "*",
    callback = function(args)
        if vim.bo[args.buf].filetype ~= "netrw" then
            return
        end

        local win = vim.fn.bufwinid(args.buf)
        if win == -1 then
            return
        end

        netrw_state.dir = vim.b[args.buf].netrw_curdir
        netrw_state.cursor = vim.api.nvim_win_get_cursor(win)
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    pattern = "*",
    callback = function(args)
        if vim.bo[args.buf].filetype ~= "netrw" then
            return
        end

        if not netrw_state.dir then
            return
        end

        if vim.b[args.buf].netrw_curdir ~= netrw_state.dir then
            return
        end

        local win = vim.fn.bufwinid(args.buf)
        if win == -1 then
            return
        end

        local line_count = vim.api.nvim_buf_line_count(args.buf)
        local line = netrw_state.cursor[1]

        if line >= 1 and line <= line_count then
            vim.api.nvim_win_set_cursor(win, netrw_state.cursor)
        end
    end,
})