-- lsp (Language Server Protocol)
local servers = {
	lua_ls = {},
	ts_ls = {},
	pyright = {},
	clangd = {},
	gopls = {},
	rust_analyzer = {},
	jdtls = {},
}

-- create default configs for language servers
local function setup_lsp()
	local result = vim.system({ "curl", "--version" }):wait()
	if result.code ~= 0 then
		print("curl not installed")
		return
	end

	-- create lsp directory
	local lspdir = vim.fn.stdpath("config") .. "/lsp/"
	if not vim.uv.fs_stat(lspdir) then
		vim.fn.mkdir(lspdir, "p")
	end

	-- iterate over servers
	for key, _ in pairs(servers) do
		local path = lspdir .. key .. ".lua"
		if not vim.uv.fs_stat(path) then
			-- download config if it doesnt exist
			result = vim.system({
				"curl",
				"-fsSL",
				"https://raw.githubusercontent.com/neovim/nvim-lspconfig/refs/heads/master/lsp/" .. key .. ".lua",
				"-o",
				path
			}):wait()
			if result.code ~= 0 then
				print(key .. " lsp config could not be installed")
			else
				print(key .. " lsp config was installed")
			end
		end

		-- enable server
		vim.lsp.enable(key)


		-- clean up
		for _, file in ipairs(vim.fn.glob(lspdir .. "/*.lua", false, true)) do
			local server = vim.fn.fnamemodify(file, ":t:r")

			if servers[server] == nil then
				vim.fn.delete(file)

				print(server .. " config file was removed from the lsp folder")
			end
		end
	end
end

setup_lsp()




