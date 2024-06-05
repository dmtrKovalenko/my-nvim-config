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
        dashboard.button("l", "󱐋 LightSource", ":e ~/dev/lightsource<CR>:Telescope find_files<cr>"),
        dashboard.button("f", " FFrames", ":e ~/dev/fframes<CR>:Telescope find_files<cr>"),
        dashboard.button(
          "--------------------------------------------------",
          " ",
          ":echo 'do the work you lazy ass'<CR>"
        ),
        -- dashboard.button("r", "  Projects", ":Telescope projects <CR>"),
        dashboard.button("s", "  Search all files", ":Telescope find_files <CR>"),
        dashboard.button("a", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("p", "  Projects", ":Telescope projects<cr>"),
        dashboard.button("c", "󰢻  Configuration", ":e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", "󰩈  Quit Neovim", ":qa<CR>"),
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
