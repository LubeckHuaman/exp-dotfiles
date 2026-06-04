return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      indent = {
        highlight = {
          'IndentRainbow1',
          'IndentRainbow2',
          'IndentRainbow3',
          'IndentRainbow4',
          'IndentRainbow5',
          'IndentRainbow6',
        },
        smart_indent_cap = false,
      },
      scope = { enabled = false },
    },
    config = function(_, opts)
      vim.api.nvim_set_hl(0, 'IndentRainbow1', { fg = '#c94f6d' })
      vim.api.nvim_set_hl(0, 'IndentRainbow2', { fg = '#dbc074' })
      vim.api.nvim_set_hl(0, 'IndentRainbow3', { fg = '#81b29a' })
      vim.api.nvim_set_hl(0, 'IndentRainbow4', { fg = '#719cd6' })
      vim.api.nvim_set_hl(0, 'IndentRainbow5', { fg = '#9d79d6' })
      vim.api.nvim_set_hl(0, 'IndentRainbow6', { fg = '#c94f6d' })
      require('ibl').setup(opts)
    end,
  },
}
