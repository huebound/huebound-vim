-- Custom plugins for the dream Neovim config
-- These plugins extend kickstart.nvim with additional functionality

return {
  -- ============================================================================
  -- EDITING ENHANCEMENTS
  -- ============================================================================

  -- Commenting: gcc to toggle line, gc + motion to toggle region
  {
    'echasnovski/mini.comment',
    event = 'VeryLazy',
    opts = {},
  },

  -- Hardtime: Block bad habits like hjkl spam
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    opts = {
      max_count = 4, -- Allow up to 4 repeated keys before blocking
      disable_mouse = false,
      hint = true,
      notification = true,
      restricted_keys = {
        ['h'] = { 'n', 'x' },
        ['j'] = { 'n', 'x' },
        ['k'] = { 'n', 'x' },
        ['l'] = { 'n', 'x' },
      },
    },
  },

  -- Flash: Jump anywhere on screen with s + 2 chars
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
    },
  },

  -- ============================================================================
  -- FILE NAVIGATION
  -- ============================================================================

  -- Oil: Edit filesystem like a buffer
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        columns = { 'icon' },
        view_options = {
          show_hidden = true,
        },
      }
      vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory (Oil)' })
    end,
  },

  -- Harpoon: Quick file switching (mark files, jump instantly)
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup {}

      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon: Add file' })
      vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon: Toggle menu' })

      vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon: File 1' })
      vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon: File 2' })
      vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon: File 3' })
      vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon: File 4' })
    end,
  },

  -- ============================================================================
  -- CODE INTELLIGENCE
  -- ============================================================================

  -- Treesitter Context: Show current function/class at top of screen
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    opts = {
      max_lines = 3,
    },
  },

  -- Treesitter Textobjects: Function/class text objects and motions
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VeryLazy',
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup {
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']m'] = '@function.outer',
              [']]'] = '@class.outer',
            },
            goto_next_end = {
              [']M'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_previous_end = {
              ['[M'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
          },
        },
      }
    end,
  },

  -- ============================================================================
  -- DIAGNOSTICS & TOOLS
  -- ============================================================================

  -- Trouble: Better diagnostics list
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'Trouble',
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
      { '<leader>xl', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    },
  },

  -- Undotree: Visualize undo history
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
  },

  -- ============================================================================
  -- GIT
  -- ============================================================================

  -- Diffview: Side-by-side git diffs
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = '[G]it [D]iff view' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = '[G]it file [H]istory' },
    },
  },

  -- ============================================================================
  -- TERMINAL
  -- ============================================================================

  -- Toggleterm: Better terminal + lazygit integration
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        size = function(term)
          if term.direction == 'horizontal' then
            return 15
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
      }

      -- Lazygit terminal
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new {
        cmd = 'lazygit',
        dir = 'git_dir',
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
        on_open = function(term)
          vim.cmd 'startinsert!'
          vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
        end,
      }

      vim.keymap.set('n', '<leader>gg', function() lazygit:toggle() end, { desc = '[G]it lazy[G]it' })
    end,
  },

  -- ============================================================================
  -- SESSION & PERSISTENCE
  -- ============================================================================

  -- Persistence: Auto-save and restore sessions
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = {},
    keys = {
      { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
      { '<leader>ql', function() require('persistence').load { last = true } end, desc = 'Restore Last Session' },
      { '<leader>qd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- ============================================================================
  -- UI POLISH
  -- ============================================================================

  -- Noice: Modern UI for cmdline, messages, notifications
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      -- Minimal config to avoid conflicts
      cmdline = {
        enabled = true,
        view = 'cmdline_popup',
      },
      messages = {
        enabled = true,
      },
      popupmenu = {
        enabled = true,
        backend = 'nui',
      },
      notify = {
        enabled = true,
      },
      lsp = {
        progress = {
          enabled = false, -- Let fidget handle this
        },
        hover = {
          enabled = true,
        },
        signature = {
          enabled = false, -- blink.cmp handles this
        },
        -- Disable the overrides that were causing issues
        override = {},
      },
    },
  },
}
