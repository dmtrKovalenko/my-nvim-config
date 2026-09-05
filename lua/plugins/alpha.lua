return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local status_ok, alpha = pcall(require, "alpha")
    if not status_ok then
      return
    end

    local dashboard = require "alpha.themes.dashboard"

    local function pickRandomElement(table)
      -- Check if the table is empty
      if #table == 0 then
        return nil
      end

      -- Generate a random index
      local randomIndex = math.random(1, #table)

      -- Return the element at the random index
      return table[randomIndex]
    end

    dashboard.section.header.val = {
      [[                                                               ]],
      [[            ██████████                                         ]],
      [[        ▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒████████                ██████         ]],
      [[      ▓▓▓▓▒▒▓▓▓▓▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒██              ██▓▓▒▒██       ]],
      [[      ▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒████              ██▓▓▒▒██     ]],
      [[    ▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▓▓██            ██▓▓▒▒██     ]],
      [[    ▓▓▒▒  ▒▒▒▒▒▒▒▒▒▒  ██▓▓▓▓▒▒▒▒▒▒▒▒▓▓██            ██▓▓▒▒██   ]],
      [[    ▓▓▒▒██▒▒▒▒▒▒▒▒▒▒████▓▓▓▓▒▒▒▒▒▒▒▒▓▓██            ██▓▓▒▒██   ]],
      [[    ▓▓▒▒██▒▒▒▒▒▒▒▒▒▒████▓▓▓▓▒▒▒▒▒▒▒▒▓▓██            ██▓▓▒▒██   ]],
      [[      ▓▓░░▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒██            ██▓▓▓▓▒▒██   ]],
      [[      ▓▓▒▒▒▒▒▒▒▒░░░░▓▓▓▓▓▓▓▓▒▒▒▒▒▒██        ██████████▒▒██     ]],
      [[    ▓▓  ▒▒██▒▒░░░░░░░░░░░░▓▓▓▓▒▒██      ████▒▒▒▒▒▒▒▒▓▓██       ]],
      [[    ▓▓██████░░░░░░░░░░░░░░▒▒▓▓▓▓████████▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓██     ]],
      [[    ▓▓░░░░░░░░░░░░░░▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██     ]],
      [[      ▓▓▓▓▓▓░░░░▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓██   ]],
      [[          ▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██   ]],
      [[                ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▓▓██   ]],
      [[                ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▓▓██   ]],
      [[                  ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓████████▓▓██▒▒▒▒▒▒████ ]],
      [[                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓██    ▓▓▓▓▓▓▓▓██▒▒▒▒▒▒██ ]],
      [[                  ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ▓▓▓▓▓▓████  ▒▒  ▒▒██ ]],
      [[                ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██    ▓▓▓▓▓▓██    ▒▒  ░░██ ]],
      [[                ▒▒  ▒▒██    ▒▒▒▒▒▒▒▒█    ░░░░░░██     ▒▒  ░░█  ]],
      [[              ██      ▒▒  ░░██          ░░░░░░██     ▒▒   ░░█  ]],
      [[              ▒▒  ▒▒▒▒██    ▒▒  ▒▒██    ▒▒▒▒▒▒▒▒    ▒▒  ░░▒▒   ]],
      [[              ▒▒▒▒▒▒▒▒    ▒▒  ▒▒▒▒██                ▒▒▒▒▒▒▒▒   ]],
      [[                          ▒▒▒▒▒▒▒▒                             ]],
    }

    local function openProject(path)
      return function()
        vim.cmd("cd " .. path)
        require("persistence").load()
        vim.cmd "Outline"
      end
    end

    dashboard.section.buttons.val = {
      dashboard.button("l", "󱐋 LightSource", openProject "~/dev/lightsource"),
      dashboard.button("f", "󰱼 fff", openProject "~/dev/fff.nvim"),
      dashboard.button("v", "󱔮 FFrames", openProject "~/dev/fframes"),
      dashboard.button(
        "--------------------------------------------------",
        " ",
        ":echo 'do the work you lazy ass'<CR>"
      ),
      dashboard.button("p", "  Projects", function()
        Snacks.picker.projects {
          finder = "recent_projects",
          format = "file",
          dev = { "~/dev" },
          patterns = { ".git" },
          matcher = {
            frecency = true,
            sort_empty = true,
            cwd_bonus = false,
          },
          sort = { fields = { "score:desc", "idx" } },
        }
      end),
      dashboard.button("a", "  New file", "<cmd>ene <BAR> startinsert <CR>"),
      dashboard.button("c", "󰢻  Configuration", "<cmd>e ~/.config/nvim/init.lua<CR>"),
      dashboard.button("q", "󰩈  Quit Neovim", "<cmd>qa<CR>"),
    }

    local function footer()
      return pickRandomElement {
        "Programming isn't about what you know; it's about what you can figure out.",
        "Code is like humor. When you have to explain it, it's bad.",
        "First, solve the problem. Then, write the code.",
        "Software is like sex: it’s better when it’s free.",
        "Talk is cheap. Show me the code.",
        "Theory and practice sometimes clash. And when that happens, theory loses.",
        "Intelligence is the ability to avoid doing work, yet getting the work done.",
        "The function of good software is to make the complex appear to be simple.",
      }
    end

    dashboard.section.footer.val = footer()

    dashboard.section.footer.opts.hl = "Type"
    dashboard.section.header.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Keyword"

    dashboard.opts.opts.noautocmd = true
    alpha.setup(dashboard.opts)
  end,
}
