-- lua/custom/plugins/leetcode.lua
return {
  {
    'kawre/leetcode.nvim',
    build = ':TSUpdate html',
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' }, -- Add dependencies
    opts = {
      -- Optional: Add any specific configuration options for leetcode.nvim
      -- e.g., { coderunner = "nvim-treesitter-textobjects", debug = true }
      lang = 'java',
      description = {
        position = 'left', ---@type lc.position
        width = '40%', ---@type lc.size
        show_stats = false, ---@type boolean
      },
    },
    -- Optional: Add a keymap to open leetcode.nvim
    -- keys = {
    --   {
    --     '<leader>ll',
    --     mode = 'n',
    --     desc = 'Open LeetCode',
    --     function()
    --       require('leetcode').open()
    --     end,
    --   },
    -- },
  },
}
