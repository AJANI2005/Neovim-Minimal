local function open_in_vscode()
	local file = vim.fn.expand("%:p")
	local cwd = vim.fn.getcwd()

	local line = vim.fn.line(".")
	local col = vim.fn.col(".") - 1

	if vim.fn.has("wsl") == 1 then
		file = vim.fn.system({ "wslpath", "-w", file }):gsub("%s+$", "")
		cwd = vim.fn.system({ "wslpath", "-w", cwd }):gsub("%s+$", "")
	end

	vim.fn.jobstart({
		"code",
		"--reuse-window",
		cwd,
		"--goto",
		string.format("%s:%d:%d", file, line, col),
	}, {
		detach = true,
	})
end

vim.keymap.set("n", "<leader>vc", open_in_vscode, {
	desc = "Open in VS Code",
})
