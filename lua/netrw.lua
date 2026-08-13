vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 1

local function find_netrw()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)

        if vim.bo[buf].filetype == "netrw" then
            return win
        end
    end
end

local function toggle_netrw()
    local netrw_win = find_netrw()

    -- Toggle closed
    if netrw_win then
        vim.api.nvim_win_close(netrw_win, true)
        return
    end

    local file = vim.fn.expand("%:p")
    local cwd = vim.fn.getcwd()

    -- Search for the current filename
    vim.fn.setreg("/", vim.fn.fnamemodify(file, ":t"))

    -- Open netrw at the current file's directory
    vim.cmd("Lexplore " .. vim.fn.fnameescape(vim.fn.expand("%:p:h")))

    netrw_win = find_netrw()
    if not netrw_win then
        return
    end

    vim.api.nvim_set_current_win(netrw_win)

    -- How many directories are between CWD and the file?
    local relative_dir = vim.fn.fnamemodify(file, ":h")
    relative_dir = vim.fn.fnamemodify(relative_dir, ":.")

    -- Walk back toward CWD using netrw's internal function
    local depth = 0

    for _ in relative_dir:gmatch("[/\\]") do
        depth = depth + 1
    end

    for _ = 1, depth do
        vim.fn["netrw#Call"]("NetrwBrowseUpDir", 1)
    end

    -- Find the current file in the resulting tree
    vim.cmd("normal! n")

    -- Center it
    vim.cmd("normal! zz")

    -- Return focus to the editor
    vim.cmd("wincmd p")
end

vim.keymap.set("n", "<leader>pv", toggle_netrw)