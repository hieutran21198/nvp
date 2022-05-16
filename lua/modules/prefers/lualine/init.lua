MAIN.configurations["lualine"] = {
  plugin_setup_params = {
    options = {
      theme = "auto",
      icon_enabled = true,
      disabled_filetypes = {"neo-tree"}
    },
    sections = {
      lualine_a = {
        {"b:gitsigns_head", icon = ""},
        {
          "diff",
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed
              }
            end
          end
        }
      },
      lualine_b = {
        {
          "diagnostics",
          sources = {"nvim_diagnostic"},
          sections = {"error", "warn", "info", "hint"}
        }
      },
      lualine_c = {
        {
          "filetype",
          icon_only = true -- Display only an icon for filetype
        },
        {
          "filename",
          file_status = true, -- Displays file status (readonly status, modified status)
          path = 1, -- 0: Just the filename 1: Relative path 2: Absolute pathath
          shorting_target = 40, -- Shortens path to leave 40 spaces in the window
          symbols = {modified = "[]", readonly = " "}
        }
      },
      lualine_x = {
        "encoding",
        "fileformat",
        "filesize"
      },
      lualine_y = {
        "progress"
      },
      lualine_z = {
        "location"
      }
    },
    inactive_sections = {
      lualine_a = {"filename"},
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {"location"}
    },
    tabline = {},
    extensions = {"quickfix", "symbols-outline"}
  },
  packer_module = {
    config = function()
      local lualine = require "lualine"
      local c = MAIN.configurations["lualine"]
      lualine.setup(c.plugin_setup_params)
    end
  }
}
MAIN.packer.register {
  ["nvim-lualine/lualine.nvim"] = MAIN.must_require("lualine", "lualine").packer_module
}
