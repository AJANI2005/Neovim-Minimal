vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 50
vim.g.netrw_browse_split = 4
vim.g.netrw_altfile = 1
vim.g.netrw_keepdir = 0

local netrw_win
local previous_win

local function is_netrw_win(win)
	if not win or not vim.api.nvim_win_is_valid(win) then
		return false
	end

	local buf = vim.api.nvim_win_get_buf(win)
	return vim.bo[buf].filetype == "netrw"
end

local function is_valid_non_netrw_win(win)
	if not win or not vim.api.nvim_win_is_valid(win) then
		return false
	end

	local buf = vim.api.nvim_win_get_buf(win)
	return vim.bo[buf].filetype ~= "netrw"
end

local function find_non_netrw_win()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if is_valid_non_netrw_win(win) then
			return win
		end
	end
end

local function reset_netrw_position()
	vim.api.nvim_win_call(netrw_win, function()
		vim.cmd("normal! 0") -- move cursor back to the start of the line
	end)
end

local function show_netrw_text(show)
	if not is_netrw_win(netrw_win) then
		return
	end

	if show then
		vim.api.nvim_set_option_value("winhighlight", "", {
			win = netrw_win,
		})
		return
	end

	-- Match the text color to the current background.
	local bg = vim.api.nvim_get_hl(0, {
		name = "Normal",
		link = false,
	}).bg

	vim.api.nvim_set_hl(0, "NetrwInvisible", {
		fg = bg,
	})

	vim.api.nvim_set_option_value(
		"winhighlight",
		table.concat({
			"Normal:NetrwInvisible",
			"Directory:NetrwInvisible",
			"Special:NetrwInvisible",
			"Identifier:NetrwInvisible",
			"String:NetrwInvisible",
			"Statement:NetrwInvisible",
			"Constant:NetrwInvisible",
			"Type:NetrwInvisible",
			"Comment:NetrwInvisible",
			"Number:NetrwInvisible",
			"PreProc:NetrwInvisible",
		}, ","),
		{ win = netrw_win }
	)
end


local function create_netrw()
	previous_win = vim.api.nvim_get_current_win()

	vim.cmd("Lexplore")

	netrw_win = vim.api.nvim_get_current_win()

	vim.api.nvim_win_set_width(
		netrw_win,
		vim.g.netrw_winsize
	)

	show_netrw_text(true)
	reset_netrw_position()
end

local function open_netrw()
	local current_win = vim.api.nvim_get_current_win()

	-- Remember the window we'll return to.
	if current_win == netrw_win then
		previous_win = find_non_netrw_win()
	else
		previous_win = current_win
	end

	vim.api.nvim_win_set_width(
		netrw_win,
		vim.g.netrw_winsize
	)

	show_netrw_text(true)
	reset_netrw_position()

	vim.api.nvim_set_current_win(netrw_win)
end

local function close_netrw()
	local current_win = vim.api.nvim_get_current_win()

	vim.api.nvim_win_set_width(netrw_win, 1)
	show_netrw_text(false)

	-- Find another window if the previous one no longer exists.
	if current_win == netrw_win
			or not is_valid_non_netrw_win(previous_win)
	then
		previous_win = find_non_netrw_win()
	end

	if previous_win then
		vim.api.nvim_set_current_win(previous_win)
	end
end

local function toggle_netrw()
	if not is_netrw_win(netrw_win) then
		create_netrw()
		return
	end

	local width = vim.api.nvim_win_get_width(netrw_win)

	if width == 1 then
		open_netrw()
	else
		close_netrw()
	end
end

vim.keymap.set("n", "<leader>e", toggle_netrw, {
	desc = "NetRW",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function(args)
		-- Keep window navigation working inside netrw.
		vim.keymap.set("n", "<C-h>", "<C-w><C-h>", {
			buffer = args.buf,
			silent = true,
		})

		vim.keymap.set("n", "<C-l>", "<C-w><C-l>", {
			buffer = args.buf,
			silent = true,
		})

		vim.keymap.set("n", "<C-r>", "<C-l>", {
			buffer = args.buf,
			silent = true,
		})
	end,
})

vim.api.nvim_create_autocmd("WinClosed", {
	callback = function()
		vim.schedule(function()
			local wins = vim.api.nvim_list_wins()

			if #wins ~= 1 then
				return
			end

			-- Don't leave netrw as the only window.
			if is_netrw_win(wins[1]) then
				vim.cmd("quit")
			end
		end)
	end,
})
