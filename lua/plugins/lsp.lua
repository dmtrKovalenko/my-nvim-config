return {
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup {
        formatters_by_ft = {
          lua = { "stylua" },
          rust = { "rustfmt" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          python = { "isort", "black" },
          javascript = { "prettierd", "prettier", stop_after_first = true },
          markdown = { "prettierd", "prettier", stop_after_first = true },
          typescript = { "prettierd", "prettier", stop_after_first = true },
          typescriptreact = { "prettierd", "prettier", stop_after_first = true },
          css = { "prettierd", "prettier", stop_after_first = true },
          svg = { "xmlformat" },
          json = { "prettierd", "prettier", stop_after_first = true },
          yaml = { "prettierd", "prettier", stop_after_first = true },
          graphql = { "prettierd", "prettier", stop_after_first = true },
          rescript = { "rescript-format" },
          ocaml = { "ocamlformat" },
          sql = { "pg_format" },
          proto = { "clang-format" },
          ocaml_mlx = { "ocamlformat_mlx" },
        },
      }

      local function format()
        require("conform").format {
          lsp_fallback = true,
        }
      end

      vim.keymap.set({ "n", "i" }, "<F12>", format, { desc = "Format", silent = true })
      vim.keymap.set({ "n", "i" }, "<C-f>", format, { desc = "Format", silent = true })

      vim.api.nvim_create_user_command("Format", format, { desc = "Format current buffer with LSP" })
    end,
  },
  {
    -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      -- Additional lua configuration, makes nvim stuff amazing!
      "folke/neodev.nvim",
      "ocaml-mlx/ocaml_mlx.nvim", {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
      },
      {
        "mrcjkb/rustaceanvim",
        lazy = false,
      },
      {
        "aznhe21/actions-preview.nvim",
        event = "LspAttach",
        opts = {
          diff = {
            algorithm = "patience",
            ignore_whitespace = true,
          },
        },
      },
      {
        "luckasRanarison/tailwind-tools.nvim",
        name = "tailwind-tools",
        build = ":UpdateRemotePlugins",
        event = "LspAttach",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "nvim-telescope/telescope.nvim", -- optional
          "neovim/nvim-lspconfig", -- optional
        },
        opts = {
          custom_filetypes = "rescript",
        },
      },
    },
    config = function()
      local on_lsp_attach = function(client, bufnr)
        local lsp_map = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end

          vim.keymap.set("n", keys, func, { remap = true, buffer = bufnr, desc = desc, silent = true })
        end

        -- if vim.bo.filetype == "rust" then
        --   lsp_map("<D-.>", ":RustLsp codeAction<CR>", "[C]ode [A]ction")
        --   vim.keymap.set("n", "<F4>", ":RustLsp debuggables<CR>", { silent = true, desc = "Rust: Debuggables" })
        -- else
        --   lsp_map("<D-.>", require("actions-preview").code_actions, "[C]ode [A]ction")
        -- end
        lsp_map("<D-.>", require("actions-preview").code_actions, "[C]ode [A]ction")

        lsp_map("<D-r>", vim.lsp.buf.rename, "[R]e[n]ame")

        lsp_map("gD", vim.lsp.buf.definition, "[G]oto [D]eclaration")
        lsp_map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")

        lsp_map("<D-g>", "<C-]>", "[G]oto [D]efinition")
        lsp_map("<D-A-g>", vim.lsp.buf.type_definition, "Type [D]efinition")

        lsp_map("<D-i>", vim.lsp.buf.hover, "Hover Documentation")
        lsp_map("<D-u>", vim.lsp.buf.signature_help, "Signature Documentation")

        -- Various picker for lsp related stuff
        lsp_map("gr", Snacks.picker.lsp_references, "[G]oto [R]eferences")
        lsp_map("gi", Snacks.picker.lsp_implementations, "[G]oto [I]mplementations")
        lsp_map("gt", Snacks.picker.lsp_type_definitions, "[G]oto [T]ype Definitions")
        lsp_map("<D-l>", Snacks.picker.lsp_workspace_symbols, "[S]earch [S]ymbols")
        lsp_map("<leader>ss", Snacks.picker.lsp_symbols, "[S]earch [S]ymbols")

        lsp_map("<leader>lr", function()
          vim.cmd "LspRestart"
        end, "Lsp [R]eload")
        lsp_map("<leader>li", function()
          vim.cmd "LspInfo"
        end, "Lsp [R]eload")
        lsp_map("<leader>lh", function()
          local bufFitler = { bufnr }
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
        end, "Lsp toggle inlay [h]ints")
      end

      -- Enable the following language servers
      local servers = {
        clangd = {
          filetypes = { "c", "cpp", "proto" },
          cmd = {
            "clangd",
            "--background-index",
            "--query-driver=/Users/dmtrkovalenko/.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-gcc",
            "--offset-encoding=utf-16",
          },
        },
        eslint = {
          filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        },
        html = { filetypes = { "html", "twig", "hbs" } },
        lua_ls = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        typos_lsp = {
          single_file_support = false,
          init_options = { diagnosticSeverity = "WARN" },
        },
        bashls = {
          settings = {
            includeAllWorkspaceSymbols = true,
          },
        },
        pylsp = {},
        astro = {},
        dhall_lsp_server = {},
        marksman = {},
        taplo = {},
      }

      -- Setup neovim lua configuration
      require("neodev").setup()

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
      -- it then vim cmp overrides only completion part of the text document. leave all other preassigned

      -- optimizes cpu usage source https://github.com/neovim/neovim/issues/23291
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      local signs = { Error = "󰚌 ", Warn = " ", Hint = "󱧡 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      local border = {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
      }

      local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = border,
        }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = border,
        }),
      }

      -- Your existing floating preview override
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or border
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      require("typescript-tools").setup {
        on_attach = on_lsp_attach,
        handlers = handlers,
      }

      vim.g.rustaceanvim = {
        -- LSP configuration
        server = {
          on_attach = on_lsp_attach,
          logfile = "/tmp/rustaceanvim.log",
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              check = {
                allTargets = false,
              },
              files = {
                excludeDirs = { "target", "node_modules", ".git", ".sl" },
              },
            },
          },
        },
        dap = {},
      }

      -- Ensure the servers above are installed
      local mason_lspconfig = require "mason-lspconfig"

      mason_lspconfig.setup {
        ensure_installed = vim.tbl_keys(servers),
      }

      mason_lspconfig.setup_handlers {
        ["rust_analyzer"] = function() end,
        function(server_name)
          if server_name ~= "rust-analyzer" then
            require("lspconfig")[server_name].setup {
              capabilities = capabilities,
              on_attach = on_lsp_attach,
              settings = servers[server_name],
              single_file_support = (servers[server_name] or {}).single_file_support,
              filetypes = (servers[server_name] or {}).filetypes,
              cmd = (servers[server_name] or {}).cmd,
              init_options = (servers[server_name] or {}).init_options,
            }
          end
        end,
      }

      -- In order to enforce using the ocaml lsp from the current switch/sandbox/esy env avoid using mason
      -- and configure ocaml lsp manually.
      require("lspconfig").ocamllsp.setup {
        capabilities = capabilities,
        on_attach = on_lsp_attach,
        handlers = handlers,
        settings = {},
      }

      require("lspconfig").relay_lsp.setup {
        handlers = handlers,
        capabilities = capabilities,
        on_attach = on_lsp_attach,
        cmd = { "yarn", "relay-compiler", "lsp" },
        settings = {},
      }
    end,
  },
}
