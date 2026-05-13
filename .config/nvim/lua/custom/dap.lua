local dap = require 'dap'
local dapui = require 'dapui'

-- Go debugging with delve
dap.adapters.go = {
  type = 'server',
  port = '${port}',
  host = '127.0.0.1',
  executable = {
    command = vim.fn.expand '$HOME/go/bin/dlv',
    args = { 'dap', '-l', '127.0.0.1:${port}' },
  },
}
dap.configurations.go = {
  {
    type = 'go',
    name = 'Debug (go)',
    request = 'launch',
    mode = 'debug',
    program = '${fileDirname}',
  },
  {
    type = 'go',
    name = 'Debug test (go)',
    request = 'launch',
    mode = 'test',
    program = '${file}',
  },
  {
    type = 'go',
    name = 'Debug package (go)',
    request = 'launch',
    mode = 'test',
    program = './${relativeFileDirname}',
  },
}

-- C/C++ debugging with codelldb
dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  host = '127.0.0.1',
  executable = {
    command = vim.fn.expand '$HOME/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb',
    args = { '--port', '${port}' },
  },
}
dap.configurations.cpp = {
  {
    name = 'Debug C++ file',
    type = 'codelldb',
    request = 'launch',
    program = function()
      local file = vim.fn.expand '%:p'
      local out = vim.fn.expand '%:p:r'
      vim.fn.system('g++ -g -std=c++17 ' .. file .. ' -o ' .. out)
      return out
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  },
}
dap.configurations.c = {
  {
    name = 'Debug C file',
    type = 'codelldb',
    request = 'launch',
    program = function()
      local file = vim.fn.expand '%:p'
      local out = vim.fn.expand '%:p:r'
      vim.fn.system('gcc -g ' .. file .. ' -o ' .. out)
      return out
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
  },
}

-- Keymaps for debugging
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle [B]reakpoint' })
vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[C]ontinue debugging' })
vim.keymap.set('n', '<leader>dn', dap.step_over, { desc = 'Step [N]ext' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Step [I]nto' })
vim.keymap.set('n', '<leader>do', dap.step_out, { desc = 'Step [O]ut' })
vim.keymap.set('n', '<leader>dt', function()
  dapui.toggle()
end, { desc = 'Toggle [T]erminal UI' })
