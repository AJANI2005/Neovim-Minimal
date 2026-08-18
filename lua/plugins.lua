-- Experimental Plugins

-- AI Tab Completion
-- 
local gh = function(x) return 'https://github.com/' .. x end
vim.pack.add({
  gh("monkoose/neocodeium")
})
require("neocodeium").setup({})
vim.keymap.set("i", "<A-f>", function()
  require("neocodeium").accept()
end)
vim.keymap.set("i", "<A-w>", function()
  require("neocodeium").accept_word()
end)
vim.keymap.set("i", "<A-a>", function()
  require("neocodeium").accept_line()
end)
vim.keymap.set("i", "<A-e>", function()
  require("neocodeium").cycle_or_complete()
end)
vim.keymap.set("i", "<A-r>", function()
  require("neocodeium").cycle_or_complete(-1)
end)
vim.keymap.set("i", "<A-c>", function()
  require("neocodeium").clear()
end)

-- LSP
--
-- Plugins
vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/neovim/nvim-lspconfig",
})

-- Set Runtime
vim.env.VIMRUNTIME = "/home/ajani/Downloads/nvim-linux-x86_64/share/nvim/runtime"

-- LSP Servers
local servers = {
  lua_ls = {
    settings = {
      Lua = {
        diagnostics = { globals = { 'vim' } },
        workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME, vim.env.VIMRUNTIME .. "/lua" }, },
      },
    },
  },
  ts_ls = {},
  pyright = {},
  clangd = {},
  gopls = {},
  rust_analyzer = {},
}

-- Mason - LSP installer
require("mason").setup()

-- Mason - LSP integration
require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
  automatic_enable = false,
})

-- Configure and enable servers
for server, config in pairs(servers) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end
