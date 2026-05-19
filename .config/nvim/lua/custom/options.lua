vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false

-- Homebrew binaries (Apple Silicon / Intel)
vim.env.PATH = vim.fn.stdpath 'data' .. '/mason/bin:' .. vim.env.PATH
if vim.fn.isdirectory '/opt/homebrew/bin' == 1 then
  vim.env.PATH = '/opt/homebrew/bin:' .. vim.env.PATH
elseif vim.fn.isdirectory '/usr/local/bin' == 1 then
  vim.env.PATH = '/usr/local/bin:' .. vim.env.PATH
end

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.termguicolors = true

-- Default indentation: 4 spaces
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

-- Language-specific indentation overrides
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-indent', { clear = true }),
  pattern = 'go',
  callback = function()
    vim.bo.expandtab = false
    vim.bo.tabstop = 8
    vim.bo.shiftwidth = 8
    vim.bo.softtabstop = 8
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-indent', { clear = false }),
  pattern = { 'c', 'cpp' },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
})
