MAIN.configurations["nvim-window"] = {
  plugin_setup_params = {
    -- The characters available for hinting windows.
    chars = {"a", "s", "f", "g", "h", "j", "k", "l"},
    -- A group to use for overwriting the Normal highlight group in the floating
    -- window. This can be used to change the background color.
    normal_hl = "Normal",
    -- The highlight group to apply to the line that contains the hint characters.
    -- This is used to make them stand out more.
    hint_hl = "Bold",
    -- The border style to use for the floating window.
    border = "single"
  },
  key_mappings = {
    {
      mappings = {
        ["<leader>"] = {
          ww = {
            "<cmd>lua require('nvim-window').pick()<cr>",
            "Choose window to jump"
          }
        }
      },
      options = {
        mode = "n",
        silent = true,
        noremap = true,
        nowait = true
      }
    }
  },
  packer_module = {
    config = function()
      local nvim_window = require("nvim-window")
      local c = MAIN.configurations["nvim-window"]
      nvim_window.setup(c.plugin_setup_params)
      MAIN.which_key.compile(c.key_mappings)
    end
  }
}

MAIN.packer.append {
  ["https://gitlab.com/yorickpeterse/nvim-window.git"] = MAIN.must_require("nvim-window", "nvim-window").packer_module
}
