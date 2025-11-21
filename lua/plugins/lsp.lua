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

      local function format_and_save()
        vim.cmd "stopinsert"
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        format()
        vim.cmd "write"
      end

      vim.keymap.set({ "n", "i" }, "<F12>", format, { desc = "Format", silent = true })
      vim.keymap.set({ "n", "i" }, "<C-f>", format_and_save, { desc = "Format", silent = true })

      vim.api.nvim_create_user_command("Format", format, { desc = "Format current buffer with LSP" })
    end,
  },
  {
    -- LSP Configuration & Plugins
    "williamboman/mason.nvim",
    lazy = false,
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      "ocaml-mlx/ocaml_mlx.nvim",
      "neovim/nvim-lspconfig",
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
        event = "BufWinEnter",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
        },
        opts = {
          custom_filetypes = "rescript",
        },
      },
      {
        "rachartier/tiny-code-action.nvim",
        dependencies = {
          { "nvim-lua/plenary.nvim" },
        },
        event = "LspAttach",
        opts = {
          backend = "delta",
          picker = {
            "snacks",
            opts = {
              layout = {
                preset = "dropdown",
              },
            },
          },
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

        lsp_map("<D-.>", function()
          require("tiny-code-action").code_action {}
        end, "Code Action")
        lsp_map("<D-i>", function()
          if client.name == "rust-analyzer" then
            vim.cmd.RustLsp { "hover", "actions" }
          else
            vim.lsp.buf.hover()
          end
        end, "Hover Documentation")
        lsp_map("<D-r>", vim.lsp.buf.rename, "Rename")
        lsp_map("gD", vim.lsp.buf.definition, "Goto Declaration")
        lsp_map("gi", vim.lsp.buf.implementation, "Goto Implementation")
        lsp_map("<D-g>", "<C-]>", "[G]oto [D]efinition")
        lsp_map("<D-u>", vim.lsp.buf.signature_help, "Signature Documentation")

        -- Various picker for lsp related stuff
        lsp_map("gr", Snacks.picker.lsp_references, "[G]oto [R]eferences")
        lsp_map("gi", Snacks.picker.lsp_implementations, "[G]oto [I]mplementations")
        lsp_map("<A-t>", Snacks.picker.lsp_type_definitions, "[G]oto [T]ype Definitions")
        lsp_map("<D-l>", Snacks.picker.lsp_workspace_symbols, "Search workspace symbols")
        lsp_map("<leader>ss", Snacks.picker.lsp_symbols, "[S]earch [S]ymbols")

        lsp_map("<leader>lr", function()
          vim.cmd "LspRestart"
        end, "Lsp [R]eload")
        lsp_map("<leader>li", function()
          vim.cmd "LspInfo"
        end, "Lsp [R]eload")
        lsp_map("<leader>lh", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), { bufnr })
        end, "Lsp toggle inlay [h]ints")
      end

      -- vim.diagnostic.config { virtual_lines = true }
      vim.diagnostic.config { virtual_text = true }

      -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
      -- optimizes cpu usage source https://github.com/neovim/neovim/issues/23291
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      vim.diagnostic.config {
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰚌 ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󱧡 ",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          },
          texthl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          },
        },
      }

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

      -- Set up global defaults first
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_lsp_attach,
        handlers = handlers,
        root_markers = { ".git" },
      })

      -- Servers with custom command or settings need vim.lsp.config()
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--offset-encoding=utf-16",
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("bashls", {
        settings = { includeAllWorkspaceSymbols = true },
      })

      vim.lsp.config("typos_lsp", {
        single_file_support = false,
        init_options = { diagnosticSeverity = "WARN" },
      })

      vim.lsp.config("ts_ls", {
        on_attach = on_lsp_attach,
      })

      vim.lsp.enable "dhall_lsp_server"
      vim.lsp.enable "marksman"
      vim.lsp.enable "taplo"
      vim.lsp.enable "astro"
      vim.lsp.enable "eslint"
      vim.lsp.enable "html"
      vim.lsp.enable "pylsp"
      vim.lsp.enable "zls"
      vim.lsp.enable "ocamllsp"
      vim.lsp.enable "ts_ls"
      vim.lsp.enable "lua_ls"

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
              cargo = {
                targetDir = true,
              },
              files = {
                excludeDirs = { "target", "node_modules", ".git", ".sl" },
              },
            },
          },
        },
        dap = {},
      }

      require("mason").setup()
    end,
  },
}
