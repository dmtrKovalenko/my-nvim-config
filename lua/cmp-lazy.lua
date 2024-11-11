-- Autocompletion and snippets configuration
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      "L3MON4D3/LuaSnip",
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
  },
  config = function()
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    -- Loads all the snippets installed by extensions in vscode.
    -- require('luasnip.loaders.from_vscode').lazy_load()
    require("luasnip.loaders.from_vscode").load { paths = "~/.config/nvim/snippets" }

    luasnip.config.set_config {
      region_check_events = "InsertEnter",
      delete_check_events = "InsertLeave",
    }

    luasnip.config.setup {}

    -- Make sure that we can work with luasnip and copilot at the same time
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      sources = cmp.config.sources {
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer", keyword_length = 5 },
      },
      preselect = cmp.PreselectMode.None,
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          -- copied from cmp-under, but I don't think I need the plugin for this.
          -- I might add some more of my own.
          function(entry1, entry2)
            local _, entry1_under = entry1.completion_item.label:find "^_+"
            local _, entry2_under = entry2.completion_item.label:find "^_+"
            entry1_under = entry1_under or 0
            entry2_under = entry2_under or 0
            if entry1_under > entry2_under then
              return false
            elseif entry1_under < entry2_under then
              return true
            end
          end,
          cmp.config.compare.sort_text,
          cmp.config.compare.recently_used,
          cmp.config.compare.kind,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      performance = { max_view_entries = 15 },
      mapping = cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-Enter>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
          -- provide a value for copilot to fallback if there is no suggestion to accept. If no suggestion accept mimic normal tab behavior.
          local tab_shift_width = vim.opt.shiftwidth:get()
          local copilot_keys = vim.fn["copilot#Accept"](string.rep(" ", tab_shift_width))

          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
            vim.api.nvim_feedkeys(copilot_keys, "i", true)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(falljack)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
    }
  end,
}
