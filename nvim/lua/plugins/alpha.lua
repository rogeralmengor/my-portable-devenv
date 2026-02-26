return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[             ____                                             ]],
      [[            / __ \____  ____  ___  _____                      ]],
      [[           / /_/ / __ \/ __ `/ _ \/ ___/                      ]],
      [[          / _, _/ /_/ / /_/ /  __/ /                          ]],
      [[         /_/ |_|\____/\__, /\___/_/                           ]],
      [[                    /____/                                    ]],
      [[                                                              ]],
      [[        █▄ █ █▀▀ █▀█ █ █ █ █▀▄▀█   █ █▀▄ █▀▀                  ]],
      [[        █ ▀█ ██▄ █▄█ ▀▄▀ █ █ ▀ █   █ █▄▀ ██▄                  ]],
      [[                                                              ]],
      [[      [ LAT: 8.4411° N ] -------- [ LON: 82.4485° W ]         ]],
      [[    ____________________________________________________      ]],
      [[                                                              ]],
      [[    ── 🌍 GIS · 🛰️  Remote Sensing · 📡 SAR · 🗺️  Cartography · 🐍 Python ──    ]],
      [[                                                              ]],
    }

    dashboard.section.header.opts = {
      hl = "RogerPrimary",
      position = "center",
    }

    -- Professional IDE Shortcuts
    dashboard.section.buttons.val = {
      dashboard.button("f", "󰈞  Find File",         ":Telescope find_files<CR>"),
      dashboard.button("r", "󰄉  Recent Projects",    ":Telescope oldfiles<CR>"),
      dashboard.button("g", "󰱽  Grep Workspace",    ":Telescope live_grep<CR>"),
      dashboard.button("l", "󰒲  Plugin Manager",     ":Lazy<CR>"),
      dashboard.button("q", "󰗼  Close IDE",         ":qa<CR>"),
    }

    dashboard.section.footer.val = " Roger Almengor • Geoinformatics Engineer "
    dashboard.section.footer.opts = {
      hl = "RogerSecondary",
      position = "center",
    }

    dashboard.config.layout = {
      { type = "padding", val = 2 },
      dashboard.section.header,
      { type = "padding", val = 2 },
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.config)

    -- Deep Azure & Emerald Theme
    vim.api.nvim_set_hl(0, "RogerPrimary", { fg = "#7aa2f7", bold = true }) 
    vim.api.nvim_set_hl(0, "RogerSecondary", { fg = "#73daca", italic = true })
  end,
}
