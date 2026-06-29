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
          '-Dlog.level=WARNING',
          '-Xms1g',
          '-Xmx4g',
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
      require 'custom.lsp'
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
        python = { 'ruff_format' },
        c = { 'clang_format' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
        cpp = { 'clang_format' },
        go = { 'gofumpt' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        -- java = { 'google-java-format' },
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
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { 'select_and_accept', 'fallback' },
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
    'zaldih/themery.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('themery').setup {
        themes = {
          { name = 'Cyberdream (default)', colorscheme = 'cyberdream', before = [[ require('cyberdream').setup { transparent = true, italic_comments = true, hide_fillchars = false, borderless_telescope = true, terminal_colors = true, cache = false, variant = 'default', highlights = {}, colors = {}, extensions = { telescope = true, notify = true, mini = true } } ]] },
          { name = 'Cyberdream (highcontrast)', colorscheme = 'cyberdream', before = [[ require('cyberdream').setup { transparent = true, italic_comments = true, hide_fillchars = false, borderless_telescope = true, terminal_colors = true, cache = false, variant = 'highcontrast', highlights = {}, colors = {}, extensions = { telescope = true, notify = true, mini = true } } ]] },
          { name = 'Nightfox (Nordfox)', colorscheme = 'nordfox', before = [[ require('nightfox').setup { options = { transparent = true } } ]] },
          { name = 'Nightfox (Carbonfox)', colorscheme = 'carbonfox', before = [[ require('nightfox').setup { options = { transparent = true } } ]] },
          { name = 'Nightfox (Nordfox opaque)', colorscheme = 'nordfox', before = [[ require('nightfox').setup { options = { transparent = false } } ]] },
          { name = 'Tokyonight (Storm)', colorscheme = 'tokyonight', before = [[ require('tokyonight').setup { style = 'storm', transparent = true } ]] },
          { name = 'Catppuccin (Macchiato)', colorscheme = 'catppuccin', before = [[ require('catppuccin').setup { flavour = 'macchiato', transparent_background = true } ]] },
          { name = 'Catppuccin (Macchiato opaque)', colorscheme = 'catppuccin', before = [[ require('catppuccin').setup { flavour = 'macchiato', transparent_background = false } ]] },
          { name = 'Catppuccin (Latte)', colorscheme = 'catppuccin', before = [[ require('catppuccin').setup { flavour = 'latte', transparent_background = false } ]] },
          { name = 'Onedark (Darker)', colorscheme = 'onedark', before = [[ require('onedark').setup { style = 'darker', transparent = true } ]] },
          { name = 'Kanagawa (Dragon)', colorscheme = 'kanagawa', before = [[ require('kanagawa').setup { theme = 'dragon', transparent = true } ]] },
          { name = 'Kanagawa (Wave)', colorscheme = 'kanagawa', before = [[ require('kanagawa').setup { theme = 'wave', transparent = false } ]] },
          { name = 'Monokai Pro', colorscheme = 'monokai-pro', before = [[ require('monokai-pro').setup { transparent_background = true } ]] },
          { name = 'Rose Pine (Moon)', colorscheme = 'rose-pine', before = [[ require('rose-pine').setup { variant = 'moon' } ]] },
          { name = 'Embark', colorscheme = 'embark' },
          { name = 'Seoul256', colorscheme = 'seoul256', before = [[ vim.g.seoul256_background = 239 ]] },
          { name = 'Solarized Osaka', colorscheme = 'solarized-osaka' },
          { name = 'Bluloco Dark', colorscheme = 'bluloco-dark', before = [[ require('bluloco').setup { style = 'dark', transparent = true } ]] },
          { name = 'Bluloco Light', colorscheme = 'bluloco-light', before = [[ require('bluloco').setup { style = 'light', transparent = false } ]] },
          { name = 'Aquavium', colorscheme = 'Aquavium', before = [[ require('Aquavium').setup { transparent = true } ]] },
          { name = 'Ayu Dark', colorscheme = 'ayu-dark', before = [[ require('ayu').setup { overrides = { Normal = { bg = "None" }, NormalFloat = { bg = "none" }, SignColumn = { bg = "None" } } } ]] },
          { name = 'Ayu Mirage', colorscheme = 'ayu-mirage', before = [[ require('ayu').setup { mirage = true, overrides = { Normal = { bg = "None" }, NormalFloat = { bg = "none" }, SignColumn = { bg = "None" } } } ]] },
          { name = 'Ayu Light', colorscheme = 'ayu-light', before = [[ require('ayu').setup {} ]] },
          { name = 'One Monokai', colorscheme = 'one_monokai', before = [[ require('one_monokai').setup { transparent = true } ]] },
          { name = 'Monokai Nightasty', colorscheme = 'monokai-nightasty', before = [[ require('monokai-nightasty').setup { dark_style_background = 'transparent' } ]] },
          { name = 'Monokai Nightasty Light', colorscheme = 'monokai-nightasty', before = [[ vim.o.background = 'light'; require('monokai-nightasty').setup { light_style_background = 'default' } ]] },
          { name = 'Cyberdream (Light)', colorscheme = 'cyberdream', before = [[ require('cyberdream').setup { transparent = false, italic_comments = true, hide_fillchars = false, borderless_telescope = true, terminal_colors = true, cache = false, variant = 'light', highlights = {}, colors = {}, extensions = { telescope = true, notify = true, mini = true } } ]] },
          { name = 'Nightfox (Dayfox)', colorscheme = 'dayfox', before = [[ require('nightfox').setup { options = { transparent = false } } ]] },
          { name = 'Nightfox (Dawnfox)', colorscheme = 'dawnfox', before = [[ require('nightfox').setup { options = { transparent = false } } ]] },
          { name = 'Tokyonight (Day)', colorscheme = 'tokyonight', before = [[ vim.o.background = 'light'; require('tokyonight').setup { style = 'day', transparent = false } ]] },
          { name = 'Onedark (Light)', colorscheme = 'onedark', before = [[ require('onedark').setup { style = 'light', transparent = false } ]] },
          { name = 'Kanagawa (Lotus)', colorscheme = 'kanagawa-lotus', before = [[ require('kanagawa').setup { theme = 'lotus', transparent = false } ]] },
          { name = 'Monokai Pro Light', colorscheme = 'monokai-pro-light', before = [[ require('monokai-pro').setup { transparent_background = false } ]] },
          { name = 'Rose Pine (Dawn)', colorscheme = 'rose-pine-dawn', before = [[ vim.o.background = 'light'; require('rose-pine').setup { variant = 'dawn' } ]] },
          { name = 'Seoul256 Light', colorscheme = 'seoul256-light', before = [[ vim.g.seoul256_light_background = 256 ]] },
          { name = 'PaperColor Dark', colorscheme = 'PaperColor', before = [[ vim.o.background = 'dark'; vim.g.PaperColor_Theme_Options = { theme = { default = { transparent_background = 1 } } } ]] },
          { name = 'PaperColor Light', colorscheme = 'PaperColor', before = [[ vim.o.background = 'light'; vim.g.PaperColor_Theme_Options = { theme = { default = { transparent_background = 0 } } } ]] },
          { name = 'Iceberg', colorscheme = 'iceberg', before = [[ vim.o.background = 'dark' ]] },
          { name = 'Iceberg Light', colorscheme = 'iceberg', before = [[ vim.o.background = 'light' ]] },
          { name = 'Gruvbox Dark', colorscheme = 'gruvbox', before = [[ require('gruvbox').setup { transparent_mode = true }; vim.o.background = 'dark' ]] },
          { name = 'Gruvbox Light', colorscheme = 'gruvbox', before = [[ require('gruvbox').setup { transparent_mode = false }; vim.o.background = 'light' ]] },
          { name = 'Dracula', colorscheme = 'dracula' },
          { name = 'Koda Dark', colorscheme = 'koda-dark', before = [[ require('koda').setup { transparent = true } ]] },
          { name = 'Koda Light', colorscheme = 'koda-light', before = [[ require('koda').setup { transparent = false } ]] },
          { name = 'Koda Moss', colorscheme = 'koda-moss', before = [[ require('koda').setup { transparent = true } ]] },
          { name = 'Koda Glade', colorscheme = 'koda-glade', before = [[ require('koda').setup { transparent = false } ]] },
          { name = 'Zenburn', colorscheme = 'zenburn', before = [[ vim.o.background = 'dark' ]] },
          { name = 'Zenburn Light', colorscheme = 'zenburn', before = [[ vim.o.background = 'light' ]] },
          { name = 'Gruvbox Material', colorscheme = 'gruvbox-material', before = [[ vim.g.gruvbox_material_background = 'medium'; vim.g.gruvbox_material_palette = 'material'; vim.g.gruvbox_material_transparent_background = 1 ]] },
          { name = 'Gruvbox Material Hard', colorscheme = 'gruvbox-material', before = [[ vim.g.gruvbox_material_background = 'hard'; vim.g.gruvbox_material_palette = 'material'; vim.g.gruvbox_material_transparent_background = 1 ]] },
          { name = 'Gruvbox Material Soft', colorscheme = 'gruvbox-material', before = [[ vim.g.gruvbox_material_background = 'soft'; vim.g.gruvbox_material_palette = 'material'; vim.g.gruvbox_material_transparent_background = 1 ]] },
          { name = 'Gruvbox Material (Mix)', colorscheme = 'gruvbox-material', before = [[ vim.g.gruvbox_material_background = 'medium'; vim.g.gruvbox_material_palette = 'mix'; vim.g.gruvbox_material_transparent_background = 1 ]] },
          { name = 'Gruvbox Material (Original)', colorscheme = 'gruvbox-material', before = [[ vim.g.gruvbox_material_background = 'medium'; vim.g.gruvbox_material_palette = 'original'; vim.g.gruvbox_material_transparent_background = 1 ]] },
          { name = 'Gruvbox Material Light', colorscheme = 'gruvbox-material', before = [[ vim.o.background = 'light'; vim.g.gruvbox_material_background = 'medium'; vim.g.gruvbox_material_palette = 'material'; vim.g.gruvbox_material_transparent_background = 0 ]] },
          { name = 'Gruvbox Material Hard Light', colorscheme = 'gruvbox-material', before = [[ vim.o.background = 'light'; vim.g.gruvbox_material_background = 'hard'; vim.g.gruvbox_material_palette = 'material'; vim.g.gruvbox_material_transparent_background = 0 ]] },
          { name = 'Gruvbox Material Soft Light', colorscheme = 'gruvbox-material', before = [[ vim.o.background = 'light'; vim.g.gruvbox_material_background = 'soft'; vim.g.gruvbox_material_palette = 'material'; vim.g.gruvbox_material_transparent_background = 0 ]] },
          { name = 'Gruvbox Material Mix Light', colorscheme = 'gruvbox-material', before = [[ vim.o.background = 'light'; vim.g.gruvbox_material_background = 'medium'; vim.g.gruvbox_material_palette = 'mix'; vim.g.gruvbox_material_transparent_background = 0 ]] },
          { name = 'Gruvbox Material Original Light', colorscheme = 'gruvbox-material', before = [[ vim.o.background = 'light'; vim.g.gruvbox_material_background = 'medium'; vim.g.gruvbox_material_palette = 'original'; vim.g.gruvbox_material_transparent_background = 0 ]] },
          { name = 'Onedarkpro (Default)', colorscheme = 'onedark', before = [[ require('onedarkpro').setup { options = { transparency = true } } ]] },
          { name = 'Onedarkpro (Vivid)', colorscheme = 'onedark_vivid', before = [[ require('onedarkpro').setup { options = { transparency = true } } ]] },
          { name = 'Onedarkpro (Dark)', colorscheme = 'onedark_dark', before = [[ require('onedarkpro').setup { options = { transparency = true } } ]] },
          { name = 'Onedarkpro (Vaporwave)', colorscheme = 'vaporwave', before = [[ require('onedarkpro').setup { options = { transparency = true } } ]] },
          { name = 'Onedarkpro (Light)', colorscheme = 'onelight', before = [[ require('onedarkpro').setup { options = { transparency = false } } ]] },
        },
        livePreview = true,
      }
    end,
  },

  { 'scottmckendry/cyberdream.nvim' },
  { 'EdenEast/nightfox.nvim' },
  { 'navarasu/onedark.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'catppuccin/nvim', name = 'catppuccin' },
  { 'folke/tokyonight.nvim' },
  { 'loctvl842/monokai-pro.nvim' },
  { 'rose-pine/neovim', name = 'rose-pine' },
  { 'embark-theme/vim', name = 'embark' },
  { 'junegunn/seoul256.vim' },
  { 'craftzdog/solarized-osaka.nvim' },
  { 'uloco/bluloco.nvim', dependencies = { 'rktjmp/lush.nvim' } },
  { 'T-b-t-nchos/Aquavium.nvim' },
  { 'Shatur/neovim-ayu' },
  { 'cpea2506/one_monokai.nvim' },
  { 'polirritmico/monokai-nightasty.nvim' },
  { 'NLKNguyen/papercolor-theme' },
  { 'cocopon/iceberg.vim' },
  { 'ellisonleao/gruvbox.nvim' },
  { 'dracula/vim' },
  { 'oskarnurm/koda.nvim' },
  { 'jnurmine/Zenburn' },
  { 'sainnhe/gruvbox-material' },
  { 'olimorris/onedarkpro.nvim', priority = 1000 },
  {
    'xiyaowong/transparent.nvim',
    cmd = 'TransparentToggle',
    opts = {
      extra_groups = { 'NormalFloat', 'NvimTreeNormal' },
    },
    keys = {
      { '<leader>tt', '<cmd>TransparentToggle<CR>', desc = '[T]oggle [T]ransparency' },
    },
  },

  {
    'carlos-algms/agentic.nvim',
    opts = {
      provider = 'opencode-acp',
      windows = {
        position = 'right',
        width = '30%',
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
          window = {
            layout = 'float',
            border = 'rounded',
            height = 0.8,
            width = 0.5,
          },
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
    opts = {
      ensure_installed = {
        'go',
        'bash',
        'python',
        'cpp',
        'c',
        'vim',
        'java',
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      -- indent = { enable = true },
    },
    config = function(_, opts)
      require('nvim-treesitter.config').setup(opts)
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
      require 'custom.dap'
    end,
  },

  require 'kickstart.plugins.neo-tree',

  -- {
  --   'yetone/avante.nvim',
  --   event = 'VeryLazy',
  --   lazy = false,
  --   version = false,
  --   opts = {
  --     mode = 'agentic',
  --     provider = 'opencode',
  --     acp_providers = {
  --       ['opencode'] = {
  --         command = 'opencode',
  --         args = { 'acp' },
  --       },
  --     },
  --     input = {
  --       provider = 'native',
  --     },
  --     behaviour = {
  --       auto_add_current_file = true,
  --       auto_apply_diff_after_generation = true,
  --       auto_focus_on_diff_view = false,
  --       acp_follow_agent_locations = true,
  --     },
  --     windows = {
  --       position = 'right',
  --       width = 0.4,
  --     },
  --   },
  --   build = 'make',
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'MunifTanjim/nui.nvim',
  --   },
  --   keys = {
  --     {
  --       '<leader>Av',
  --       function()
  --         require('avante.api').ask()
  --       end,
  --       mode = { 'n', 'v' },
  --       desc = 'Avante Ask',
  --     },
  --     {
  --       '<leader>Ae',
  --       function()
  --         require('avante.api').edit()
  --       end,
  --       mode = { 'n', 'v' },
  --       desc = 'Avante Edit',
  --     },
  --     {
  --       '<leader>As',
  --       function()
  --         require('avante.api').stop()
  --       end,
  --       mode = { 'n', 'i' },
  --       desc = 'Avante Stop',
  --     },
  --     {
  --       '<leader>AM',
  --       function()
  --         require('avante.api').select_acp_model()
  --       end,
  --       mode = { 'n' },
  --       desc = 'Avante ACP Model',
  --     },
  --     {
  --       '<leader>Am',
  --       function()
  --         require('avante.api').select_acp_mode()
  --       end,
  --       mode = { 'n' },
  --       desc = 'Avante ACP Mode',
  --     },
  --   },
  -- },
}

-- The { import = 'custom.plugins' } is NOT needed here
-- lazy.nvim automatically loads ALL files in lua/custom/plugins/*.lua
-- This includes: init.lua (this file), leetcode.lua, etc.
