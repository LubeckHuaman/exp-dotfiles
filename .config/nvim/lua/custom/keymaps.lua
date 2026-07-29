vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Disable Tab in normal mode (Tab = <C-i> = jumplist forward)
vim.keymap.set('n', '<Tab>', '<Nop>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move focus to the upper window' })

-- Toggle autocomplete (blink.cmp) with persistence
local state_file = vim.fn.stdpath('data') .. '/blink_cmp_state'
vim.g.blink_cmp_enabled = vim.fn.filereadable(state_file) == 1 and vim.fn.readfile(state_file)[1] == '1'

vim.api.nvim_create_user_command('BlinkToggle', function()
  vim.g.blink_cmp_enabled = not vim.g.blink_cmp_enabled
  vim.fn.writefile({ vim.g.blink_cmp_enabled and '1' or '0' }, state_file)
  vim.notify('Autocomplete: ' .. (vim.g.blink_cmp_enabled and 'ON' or 'OFF'))
end, {})
vim.keymap.set('n', '<leader>ua', '<cmd>BlinkToggle<CR>', { desc = 'Toggle autocomplete' })

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
