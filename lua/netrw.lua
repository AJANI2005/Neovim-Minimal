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

        log("BufWinLeave triggered")

        local win = vim.fn.bufwinid(args.buf)

        if win == -1 then
            log("No window found for buffer " .. args.buf)
            return
        end

        local dir = vim.b[args.buf].netrw_curdir
        local cursor = vim.api.nvim_win_get_cursor(win)

        log("Saving dir: " .. tostring(dir))
        log("Saving cursor: " .. vim.inspect(cursor))

        netrw_state.dir = dir
        netrw_state.cursor = cursor
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(args)
        if vim.bo[args.buf].filetype ~= "netrw" then
            return
        end

        log("BufWinEnter triggered")

        local dir = vim.b[args.buf].netrw_curdir

        log("Current dir: " .. tostring(dir))
        log("Saved dir: " .. tostring(netrw_state.dir))

        if not netrw_state.dir then
            log("Nothing saved")
            return
        end

        if dir ~= netrw_state.dir then
            log("Directory mismatch")
            return
        end

        local win = vim.fn.bufwinid(args.buf)

        if win == -1 then
            log("No window found")
            return
        end

        local line_count = vim.api.nvim_buf_line_count(args.buf)
        local line = netrw_state.cursor[1]

        log("Saved cursor: " .. vim.inspect(netrw_state.cursor))
        log("Line count: " .. line_count)

        if line < 1 or line > line_count then
            log("Saved cursor is outside buffer")
            return
        end

        vim.api.nvim_win_set_cursor(win, netrw_state.cursor)

        log("Cursor restored")
    end,
})