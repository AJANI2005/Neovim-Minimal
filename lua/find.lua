-- live grep
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.keymap.set("n", "<leader>g", function()
	vim.ui.input({ prompt = "Grep: " }, function(pattern)
		if pattern then
			vim.cmd("silent grep! " .. vim.fn.fnameescape(pattern))
			vim.cmd("copen")
		end
	end)
end, { silent = true })


-- fuzzy finder
local function fzf(source, callback)
	local tmp = vim.fn.tempname()

	local buf = vim.api.nvim_create_buf(false, true)

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		border = "rounded",
	})

	local command = string.format(
		"%s | fzf --layout=reverse --border > %s",
		source,
		vim.fn.shellescape(tmp)
	)

	vim.api.nvim_buf_call(buf, function()
		vim.fn.jobstart({ "sh", "-c", command }, {
			term = true,

			on_exit = function()
				vim.schedule(function()
					local selected = vim.fn.readfile(tmp)

					vim.fn.delete(tmp)

					if vim.api.nvim_win_is_valid(win) then
						vim.api.nvim_win_close(win, true)
					end

					if selected[1] and selected[1] ~= "" then
						callback(selected[1])
					end
				end)
			end,
		})
	end)

	vim.cmd("startinsert")
end


local function find_files()
	fzf("rg --files", function(file)
		vim.cmd("edit " .. vim.fn.fnameescape(file))
	end)
end

vim.keymap.set("n", "<leader>ff", find_files)
