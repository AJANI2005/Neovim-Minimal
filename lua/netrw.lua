vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 1

vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")

local netrw_state = {}

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 1

local function is_netrw(win)
    if not vim.api.nvim_win_is_valid(win) then
        return false
    end

    local buf = vim.api.nvim_win_get_buf(win)
    return vim.bo[buf].filetype == "netrw"
end

vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
        local win = vim.api.nvim_get_current_win()

        if not is_netrw(win) then
            return
        end

        local buf = vim.api.nvim_win_get_buf(win)

        netrw_state.dir = vim.b[buf].netrw_curdir
        netrw_state.cursor = vim.api.nvim_win_get_cursor(win)
    end,
})

vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        local win = vim.api.nvim_get_current_win()

        if not is_netrw(win) then
            return
        end

        local buf = vim.api.nvim_win_get_buf(win)

        if not netrw_state.dir or not netrw_state.cursor then
            return
        end

        if vim.b[buf].netrw_curdir ~= netrw_state.dir then
            return
        end

        vim.defer_fn(function()
            if not vim.api.nvim_win_is_valid(win) or not is_netrw(win) then
                return
            end

            local line = netrw_state.cursor[1]
            local line_count = vim.api.nvim_buf_line_count(buf)

            if line >= 1 and line <= line_count then
                vim.api.nvim_win_set_cursor(win, netrw_state.cursor)
            end
        end, 50)
    end,
})

vim.keymap.set("n", "<leader>pv", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if is_netrw(win) then
            vim.api.nvim_win_hide(win)
            return
        end
    end

    vim.cmd("Lexplore")
end, {
    desc = "Toggle netrw",
})