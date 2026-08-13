vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 1

vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")

local netrw_state = {}

local function log(msg)
    vim.notify("[netrw] " .. msg, vim.log.levels.INFO)
end

vim.api.nvim_create_autocmd("BufWinLeave", {
    callback = function(args)
        if vim.bo[args.buf].filetype ~= "netrw" then
            return
        end

        local win = vim.fn.bufwinid(args.buf)

        if win == -1 then
            log("No window found while saving")
            return
        end

        netrw_state.dir = vim.b[args.buf].netrw_curdir
        netrw_state.cursor = vim.api.nvim_win_get_cursor(win)

        log("Saved dir: " .. tostring(netrw_state.dir))
        log("Saved cursor: " .. vim.inspect(netrw_state.cursor))
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(args)
        if vim.bo[args.buf].filetype ~= "netrw" then
            return
        end

        vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(args.buf) then
                return
            end

            local win = vim.fn.bufwinid(args.buf)

            if win == -1 then
                log("No window found while restoring")
                return
            end

            local dir = vim.b[args.buf].netrw_curdir

            log("Entered dir: " .. tostring(dir))
            log("Saved dir: " .. tostring(netrw_state.dir))

            if dir ~= netrw_state.dir then
                log("Directory mismatch")
                return
            end

            local line_count = vim.api.nvim_buf_line_count(args.buf)
            local cursor = netrw_state.cursor

            if not cursor then
                log("No saved cursor")
                return
            end

            if cursor[1] < 1 or cursor[1] > line_count then
                log("Cursor is out of range")
                return
            end

            log("Restoring cursor: " .. vim.inspect(cursor))

            vim.api.nvim_win_set_cursor(win, cursor)

            log("Cursor restored")
        end)
    end,
})