return {
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    config = function()
      local jdtls = require 'jdtls'
      local home = vim.fn.expand '$HOME'
      local jdtls_path = vim.fn.systemlist('find ' .. home .. '/.local/share/nvim/mason/packages/jdtls -type f -name jdtls')[1]
      if not jdtls_path then
        vim.notify('jdtls binary not found', vim.log.levels.ERROR)
        return
      end

      local data_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace'

      local bundles = {}
      local java_debug = vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true)
      if java_debug ~= '' then
        table.insert(bundles, java_debug)
      end

      local config = {
        cmd = {
          jdtls_path,
          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ALL',
          '-Xms1g',
          '--add-modules=ALL-SYSTEM',
          '--add-opens',
          'java.base/java.util=ALL-UNNAMED',
          '--add-opens',
          'java.base/java.lang=ALL-UNNAMED',
          '-jar',
          vim.fn.expand '$HOME/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher.jar',
          '-configuration',
          vim.fn.expand '$HOME/.local/share/nvim/mason/packages/jdtls/config_mac',
          '-data',
          data_dir,
        },
        root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }),
        settings = {
          java = {
            signatureHelp = { enabled = true },
            completion = {
              favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
          },
        },
        init_options = {
          bundles = bundles,
        },
      }

      jdtls.start_or_attach(config)
      jdtls.setup_dap { hotcodereplace = 'auto' }
    end,
  },

  {
    'NickvanDyke/opencode.nvim',
    version = '*',
    dependencies = {
      {
        'folke/snacks.nvim',
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...)
                return require('opencode').snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
                },
              },
            },
          },
        },
      },
    },
    config = function()
      vim.g.opencode_opts = {}
      vim.o.autoread = true

      vim.keymap.set({ 'n', 'x' }, '<C-a>', function()
        require('opencode').ask('@this: ', { submit = true })
      end, { desc = 'Ask opencode' })
      vim.keymap.set({ 'n', 'x' }, '<C-x>', function()
        require('opencode').select()
      end, { desc = 'Execute opencode action' })
      vim.keymap.set({ 'n', 't' }, '<leader>o', function()
        require('opencode').toggle()
      end, { desc = 'Toggle opencode' })
      vim.keymap.set({ 'n', 'x' }, 'go', function()
        return require('opencode').operator '@this '
      end, { desc = 'Add range to opencode', expr = true })
      vim.keymap.set('n', 'goo', function()
        return require('opencode').operator '@this ' .. '_'
      end, { desc = 'Add line to opencode', expr = true })
      vim.keymap.set('n', '<leader>ou', function()
        require('opencode').command 'session.half.page.up'
      end, { desc = 'Scroll opencode up' })
      vim.keymap.set('n', '<leader>od', function()
        require('opencode').command 'session.half.page.down'
      end, { desc = 'Scroll opencode down' })

      vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment under cursor', noremap = true })
      vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement under cursor', noremap = true })
    end,
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      require('custom.lsp')
    end,
  },

  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = {}
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        c = { 'clang_format' },
        cpp = { 'clang_format' },
        go = { 'gofumpt' },
        java = { 'google-java-format' },
      },
    },
  },

  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    opts = {
      keymap = {
        preset = 'enter',
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        },
      },
      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
  },

  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('gruvbox').setup {
        contrast = 'soft',
        terminal_colors = true,
      }
      vim.cmd.colorscheme 'gruvbox'
    end,
  },

  {
    'carlos-algms/agentic.nvim',
    opts = {
      provider = 'opencode-acp',
      windows = {
        position = 'right',
        width = '40%',
      },
      diff_preview = {
        enabled = true,
        layout = 'inline',
        center_on_navigate_hunks = true,
      },
      folding = {
        tool_calls = {
          enabled = true,
          threshold = 10,
        },
      },
    },
    keys = {
      {
        '<leader>aa',
        function()
          require('agentic').toggle()
        end,
        mode = { 'n' },
        desc = 'Toggle Agentic Chat',
      },
      {
        '<leader>ac',
        function()
          require('agentic').add_selection_or_file_to_context()
        end,
        mode = { 'n', 'v' },
        desc = 'Add file/selection to Agentic context',
      },
      {
        '<leader>an',
        function()
          require('agentic').new_session()
        end,
        mode = { 'n' },
        desc = 'New Agentic Session',
      },
      {
        '<leader>ar',
        function()
          require('agentic').restore_session()
        end,
        desc = 'Agentic Restore session',
        mode = { 'n' },
      },
    },
  },

  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    opts = {
      interactions = {
        chat = {
          adapter = 'opencode',
        },
        inline = {
          adapter = 'opencode',
        },
      },
      display = {
        chat = {
          show_header_separator = true,
        },
        diff = {
          provider = 'diffchar',
          enabled = true,
        },
      },
    },
    keys = {
      {
        '<leader>ca',
        function()
          require('codecompanion').toggle()
        end,
        mode = { 'n' },
        desc = 'Toggle CodeCompanion Chat',
      },
      {
        '<leader>ci',
        function()
          require('codecompanion').inline()
        end,
        mode = { 'n', 'v' },
        desc = 'CodeCompanion Inline Assistant',
      },
      {
        '<leader>cp',
        function()
          require('codecompanion').actions()
        end,
        mode = { 'n', 'v' },
        desc = 'CodeCompanion Action Palette',
      },
    },
  },

  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()
      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { 'bash', 'c', 'cpp', 'diff', 'go', 'html', 'java', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'query', 'typescript', 'vim', 'vimdoc' },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
      }
    end,
  },

  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      size = 15,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'float',
      close_on_exit = false,
      shell = vim.o.shell,
    },
    config = function(_, opts)
      require('toggleterm').setup(opts)
      local Terminal = require('toggleterm.terminal').Terminal

      local runner = Terminal:new {
        cmd = '',
        dir = 'git_dir',
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
        on_open = function(term)
          vim.cmd 'startinsert!'
        end,
        on_close = function() end,
        count = 99,
      }

      vim.keymap.set('n', '<leader>r', function()
        local ft = vim.bo.filetype
        local cmd = ''

        if ft == 'java' then
          local file = vim.fn.expand '%:t:r'
          local dir = vim.fn.expand '%:p:h'
          local root = vim.fs.root(0, { 'pom.xml', 'build.gradle', 'build.gradle.kts' })
          if root and vim.fn.filereadable(root .. '/pom.xml') == 1 then
            local pom_content = vim.fn.readfile(root .. '/pom.xml')
            local is_spring_boot = false
            for _, line in ipairs(pom_content) do
              if line:match 'spring%-boot' or line:match 'SpringBootApplication' then
                is_spring_boot = true
                break
              end
            end
            if is_spring_boot then
              cmd = 'cd ' .. root .. ' && mvn spring-boot:run'
            else
              cmd = 'cd ' .. root .. ' && mvn compile && mvn exec:java -Dexec.mainClass=' .. file
            end
          elseif root and (vim.fn.filereadable(root .. '/build.gradle') == 1 or vim.fn.filereadable(root .. '/build.gradle.kts') == 1) then
            cmd = 'cd ' .. root .. ' && ./gradlew bootRun'
          else
            cmd = 'cd ' .. dir .. ' && javac ' .. file .. '.java && java ' .. file
          end
        elseif ft == 'cpp' or ft == 'c' then
          local file = vim.fn.expand '%:t:r'
          local ext = ft == 'cpp' and '.cpp' or '.c'
          cmd = 'cd ' .. vim.fn.expand '%:p:h' .. ' && g++ -std=c++17 ' .. file .. ext .. ' -o ' .. file .. ' && ./' .. file
        elseif ft == 'go' then
          local root = vim.fs.root(0, { 'go.mod' })
          if root then
            cmd = 'cd ' .. root .. ' && go run .'
          else
            cmd = 'go run ' .. vim.fn.expand '%'
          end
        elseif ft == 'python' then
          cmd = 'python3 ' .. vim.fn.expand '%'
        elseif ft == 'lua' then
          cmd = 'lua ' .. vim.fn.expand '%'
        else
          vim.notify('No runner configured for ' .. ft, vim.log.levels.WARN)
          return
        end

        runner.cmd = cmd
        runner:toggle()
      end, { desc = '[R]un current file', noremap = true, silent = true })
    end,
  },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        opts = { floating = { border = 'rounded' } },
        config = function(_, opts)
          local dap, dapui = require 'dap', require 'dapui'
          dapui.setup(opts)
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
          end
        end,
      },
      'nvim-neotest/nvim-nio',
    },
    config = function()
      require('custom.dap')
    end,
  },

  require 'kickstart.plugins.neo-tree',
}

-- The { import = 'custom.plugins' } is NOT needed here
-- lazy.nvim automatically loads ALL files in lua/custom/plugins/*.lua
-- This includes: init.lua (this file), leetcode.lua, etc.
