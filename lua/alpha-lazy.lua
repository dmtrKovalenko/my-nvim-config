local function lazy(opts)
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

      if opts.header == "pikachu" then
        dashboard.section.header.val = {
          [[          ▀████▀▄▄              ▄█ ]],
          [[            █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█ ]],
          [[    ▄        █          ▀▀▀▀▄  ▄▀  ]],
          [[   ▄▀ ▀▄      ▀▄              ▀▄▀  ]],
          [[  ▄▀    █     █▀   ▄█▀▄      ▄█    ]],
          [[  ▀▄     ▀▄  █     ▀██▀     ██▄█   ]],
          [[   ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █  ]],
          [[    █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀  ]],
          [[   █   █  █      ▄▄           ▄▀   ]],
        }
      else
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
      end

      dashboard.section.buttons.val = {
        dashboard.button("l", "󱐋 LightSource", "<cmd>e ~/dev/lightsource<CR>:SessionRestore<CR>"),
        dashboard.button("f", " FFrames", "<cmd>e ~/dev/fframes<CR>:SessionRestore<CR>"),
        dashboard.button(
          "--------------------------------------------------",
          " ",
          ":echo 'do the work you lazy ass'<CR>"
        ),
        dashboard.button("p", "  Projects", "<cmd>Telescope projects<CR>"),
        dashboard.button("a", "  New file", "<cmd>ene <BAR> startinsert <CR>"),
        dashboard.button("c", "󰢻  Configuration", "<cmd>e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", "󰩈  Quit Neovim", "<cmd>qa<CR>"),
      }

      local function footer()
        return "Software is like sex: it’s better when it’s free."
      end

      dashboard.section.footer.val = footer()

      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "Include"
      dashboard.section.buttons.opts.hl = "Keyword"

      dashboard.opts.opts.noautocmd = true
      alpha.setup(dashboard.opts)
    end,
  }
end

return {
  lazy = lazy,
}
