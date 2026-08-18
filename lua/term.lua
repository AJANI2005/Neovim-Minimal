local float_term_win

local function new_term()
	if vim.bo.buftype == "terminal" then
		vim.cmd("rightbelow vsplit")
	else
		vim.cmd("below split")
	end

	vim.cmd("terminal")
	vim.cmd("startinsert")
end

local function float_term()
	-- Focus existing floating terminal
	if float_term_win and vim.api.nvim_win_is_valid(float_term_win) then
		vim.api.nvim_set_current_win(float_term_win)
		vim.cmd("startinsert")
		return
	end

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)

	local buf = vim.api.nvim_create_buf(false, true)

	float_term_win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2),
		border = "rounded",
		title = " Terminal ",
		title_pos = "center",
	})

	vim.wo[float_term_win].cursorline = true

	vim.cmd("terminal")
	vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>t", new_term, {
	desc = "New Terminal",
})

vim.keymap.set("n", "<leader>o", float_term, {
	desc = "Floating Terminal",
})

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function(args)
		local opts = { buffer = args.buf }

		vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>hi", opts)
		vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>li", opts)
		vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>ki", opts)
		vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>ji", opts)

		vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {
			desc = "Exit terminal mode",
			buffer = args.buf,
		})
	end,
})
