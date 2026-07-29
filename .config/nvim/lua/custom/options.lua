vim.o.number = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.showcmd = false

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
vim.o.timeoutlen = 100
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }
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

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom-treesitter', { clear = true }),
  callback = function(args)
    local ok = pcall(vim.treesitter.start, args.buf)
    if not ok then return end
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('auto-checktime', { clear = true }),
  callback = function()
    vim.cmd('checktime')
  end,
})

-- -- Transparency toggle
-- local bg_saved = {}
-- local groups = { 'Normal', 'NormalFloat', 'SignColumn', 'FoldColumn' }
-- vim.api.nvim_create_user_command('TransparencyToggle', function()
--   if vim.g.transparent_enabled then
--     for _, g in ipairs(groups) do
--       local saved = bg_saved[g] or {}
--       pcall(vim.api.nvim_set_hl, 0, g, { bg = saved.bg, ctermbg = saved.ctermbg })
--     end
--     vim.g.transparent_enabled = false
--   else
--     for _, g in ipairs(groups) do
--       local ok, info = pcall(vim.api.nvim_get_hl, 0, { id = g })
--       if ok then
--         bg_saved[g] = { bg = info.bg, ctermbg = info.ctermbg }
--       end
--       pcall(vim.api.nvim_set_hl, 0, g, { bg = 'NONE', ctermbg = 'NONE' })
--     end
--     vim.g.transparent_enabled = true
--   end
-- end, {})
-- vim.keymap.set('n', '<leader>tt', '<cmd>TransparencyToggle<CR>', { desc = 'Toggle transparency' })

