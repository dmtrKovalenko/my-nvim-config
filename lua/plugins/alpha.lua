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

    dashboard.section.buttons.val = {
      dashboard.button("l", "󱐋 LightSource", "<cmd>e ~/dev/lightsource<CR>:SessionRestore<CR>"),
      dashboard.button("f", "󱔮 FFrames", "<cmd>e ~/dev/fframes<CR>:SessionRestore<CR>"),
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
          recent = true,
          matcher = {
            frecency = true, -- use frecency boosting
            sort_empty = true, -- sort even when the filter is empty
            cwd_bonus = false,
          },
          sort = { fields = { "score:desc", "idx" } },
          win = {
            preview = { minimal = true },
            input = {
              keys = {
                -- every action will always first change the cwd of the current tabpage to the project
                ["<c-e>"] = { { "tcd", "picker_explorer" }, mode = { "n", "i" } },
                ["<c-f>"] = { { "tcd", "picker_files" }, mode = { "n", "i" } },
                ["<c-g>"] = { { "tcd", "picker_grep" }, mode = { "n", "i" } },
                ["<c-r>"] = { { "tcd", "<cmd>SessionRestore<cr>" }, mode = { "n", "i" } },
                ["<c-w>"] = { { "tcd" }, mode = { "n", "i" } },
                ["<c-t>"] = {
                  function(picker)
                    vim.cmd "tabnew"
                    Snacks.notify "New tab opened"
                    picker:close()
                    Snacks.picker.projects()
                  end,
                  mode = { "n", "i" },
                },
              },
            },
          },
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
