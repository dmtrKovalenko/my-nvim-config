local function define_colors()
  vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#b91c1c' })
  vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
  vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bold = true })

  vim.fn.sign_define('DapBreakpoint', {
    text = '🔴',
    numhl = 'DapBreakpoint'
  })
  vim.fn.sign_define('DapBreakpointCondition', {
    text = '🔴', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint'
  })
  vim.fn.sign_define('DapBreakpointRejected', {
    text = '🔘', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint'
  })
  vim.fn.sign_define('DapStopped', {
    text = '🟢',
    linehl = 'DapStopped',
    numhl = 'DapStopped'
  })
  vim.fn.sign_define('DapLogPoint', {
    text = '🟣',
    linehl = 'DapLogPoint',
    numhl = 'DapLogPoint'
  })
end

local function setup_default_configurations()
  local dap = require('dap')
  local lldb_configuration = {
    {
      name = 'Launch',
      type = 'lldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
    },
  }

  dap.configurations.c = lldb_configuration
  dap.configurations.cpp = lldb_configuration
  dap.configurations.rust = lldb_configuration
end

local function lazy(_options)
  return {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'nvim-telescope/telescope-dap.nvim',
        config = function() require('telescope').load_extension('dap') end
      },
      {
        'rcarriga/nvim-dap-ui',
        types = true
      },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      local nvim_tree = require('nvim-tree.api')
      dapui.setup();

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
        nvim_tree.tree.close()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
        nvim_tree.tree.open()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
        nvim_tree.tree.open()
      end

      define_colors()
      vim.keymap.set('n', '<F6>', function() dap.step_over() end)
      vim.keymap.set('n', '<F7>', function() dap.step_into() end)
      vim.keymap.set('n', '<F8>', function() dap.step_out() end)
      vim.keymap.set('n', '<F9>', function() dap.toggle_breakpoint() end)
      vim.keymap.set('n', '<F10>', function() dap.terminate() end)

      dap.adapters.lldb = {
        type = 'executable',
        command = '/opt/homebrew/opt/llvm/bin/lldb-vscode', -- adjust as needed, must be absolute path
        name = 'lldb'
      }

      vim.keymap.set('n', '<F5>', function()
        -- when debug is called firstly try to read and/or update launch.json confiugration
        -- from the local project which will override all the default configurations
        if vim.fn.filereadable('.vscode/launch.json') then
          require('dap.ext.vscode').load_launchjs(nil, { lldb = { 'rust', 'c', 'cpp' } })
        else
          setup_default_configurations()
        end

        require('dap').continue()
      end)
    end
  }
end

return {
  lazy = lazy,
}
