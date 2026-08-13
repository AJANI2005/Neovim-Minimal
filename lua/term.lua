local function new_term()
	if vim.bo.buftype == "terminal" then
		vim.cmd("rightbelow vsplit")
	else
		vim.cmd("below split")
	end

	vim.cmd("terminal")
	vim.cmd("startinsert")
end


vim.keymap.set("n", "<leader>t", new_term, { desc = "New Terminal", })

vim.api.nvim_create_autocmd("TermOpen", {
	callback = function(args)
		local opts = { buffer = args.buf }

		vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>hi", opts)
		vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>li", opts)
		vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
		vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)
		vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {
			desc = "Exit terminal mode",
			buffer = args.buf,
		})
	end,
})
