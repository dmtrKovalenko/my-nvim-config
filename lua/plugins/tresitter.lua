return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    -- Custom treesitter parserrs
    "rescript-lang/tree-sitter-rescript",
    "danielo515/tree-sitter-reason",
    "rescript-lang/vim-rescript", -- do not remove required for subtitler and fframes
    "IndianBoy42/tree-sitter-just",
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        max_lines = 1,
      },
    },
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = {
        "c",
        "cpp",
        "go",
        "lua",
        "python",
        "rust",
        "tsx",
        "vimdoc",
        "vim",
        "rescript",
        "markdown",
        "wgsl",
        "html",
        "ocaml",
      },

      auto_install = true,
      highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
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
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
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
          set_jumps = true, -- whether to set jumps in the jumplist
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
    }

    require("nvim-treesitter.install").compilers = { "gcc", "clang" }
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    parser_config.just = {
      install_info = {
        url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
        files = { "src/parser.c", "src/scanner.cc" },
        branch = "main",
        use_makefile = true, -- this may be necessary on MacOS (try if you see compiler errors)
      },
      maintainers = { "@IndianBoy42" },
    }

    parser_config.rescript = {
      install_info = {
        url = "https://github.com/rescript-lang/tree-sitter-rescript",
        branch = "main",
        files = { "src/parser.c", "src/scanner.c" },
        generate_requires_npm = false,
        requires_generate_from_grammar = true,
        use_makefile = true, -- macOS specific instruction
      },
    }
  end,
}
