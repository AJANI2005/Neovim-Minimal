-- LSP
vim.env.VIMRUNTIME = "/home/ajani/Downloads/nvim-linux-x86_64/share/nvim/runtime"

local lspconfig_dir = vim.fn.stdpath("config") .. "/lsp"
vim.fn.mkdir(lspconfig_dir, "p")

local servers = {
  "lua_ls",
  "ts_ls",
  "pyright",
  "clangd",
  "gopls",
  "rust_analyzer",
}

local repo_url =
  "https://raw.githubusercontent.com/neovim/nvim-lspconfig/master/lsp/"

for _, server in ipairs(servers) do
  local file = lspconfig_dir .. "/" .. server .. ".lua"

  if vim.fn.filereadable(file) == 0 then
    vim.fn.system({
      "curl",
      "-fsSL",
      repo_url .. server .. ".lua",
      "-o",
      file,
    })

    if vim.v.shell_error ~= 0 then
      vim.notify(
        "Failed to download LSP config: " .. server,
        vim.log.levels.ERROR
      )
    end
  end
end

-- Your overrides
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME .. "/lua",
        },
      },
    },
  },
})

-- Enable servers
for _, server in ipairs(servers) do
  vim.lsp.enable(server)
end

