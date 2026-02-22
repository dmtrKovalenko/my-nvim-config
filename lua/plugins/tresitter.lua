return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        max_lines = 1,
      },
    },
  },
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "c",
      "cpp",
      "go",
      "lua",
      "python",
      "rust",
      "tsx",
      "typescript",
      "javascript",
      "vimdoc",
      "vim",
      "markdown",
      "html",
      "css",
      "json",
      "yaml",
      "bash",
    },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = "<c-s>",
        node_decremental = "<S-space>",
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["ap"] = "@parameter.outer",
          ["ip"] = "@parameter.inner",
          ["au"] = "@attribute.outer",
          ["iu"] = "@attribute.inner",
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["as"] = "@statement.outer",
          ["is"] = "@statement.inner",
          ["av"] = "@assignment.outer",
          ["iv"] = "@assignment.inner",
          ["in"] = "@assignment.lhs",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]["] = "@function.outer",
          ["]c"] = "@class.outer",
        },
        goto_next_end = {
          ["]}"] = "@function.outer",
          ["]C"] = "@class.outer",
        },
        goto_previous_start = {
          ["[{"] = "@function.outer",
          ["[c"] = "@class.outer",
        },
        goto_previous_end = {
          ["[}"] = "@function.outer",
          ["[C"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<A-p>"] = "@parameter.inner",
        },
        swap_previous = {
          ["<A-P>"] = "@parameter.inner",
        },
      },
    },
  },
  config = function(_, opts)
    require("nvim-treesitter.install").compilers = { "gcc", "clang" }
    require("nvim-treesitter.configs").setup(opts)
  end,
}
