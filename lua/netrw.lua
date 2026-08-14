vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_keepdir = 1

vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")

local netrw_line
vim.api.nvim_create_autocmd('BufLeave', {
  callback = function(args)
    if vim.bo[args.buf].filetype == "netrw" then
      netrw_line = vim.fn.line(".")
    end
  end
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = "netrw",
  callback = function(args)
    vim.schedule(
      function()
        if vim.bo[args.buf].filetype == "netrw" then
          if netrw_line and
              netrw_line >= 1 and netrw_line <= vim.api.nvim_buf_line_count(args.buf)
          then
            vim.api.nvim_win_set_cursor(0, { netrw_line, 0 })
          end
        end
      end
    )
  end
})
