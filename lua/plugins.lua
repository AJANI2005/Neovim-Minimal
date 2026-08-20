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

