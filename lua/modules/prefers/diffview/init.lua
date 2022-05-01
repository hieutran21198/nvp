MAIN.configurations["diffview"] = {
  plugin_setup_params = {
    diff_binaries = false, -- Show diffs for binaries
    use_icons = true, -- Requires nvim-web-devicons
    file_panel = {
      width = 35
    },
    key_bindings = {}
  },
  packer_module = {
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles"
    },
    config = function()
      local dv = require "diffview"
      local c = MAIN.configurations["diffview"]
      dv.setup(c.plugin_setup_params)
    end
  }
}

local utils = require "common.utils"

utils.must_require(
  function()
    local cb = require "diffview.config".diffview_callback

    local c = MAIN.configurations["diffview"]
    c.plugin_setup_params.key_bindings = {
      disable_defaults = false,
      view = {
        ["<tab>"] = cb("select_next_entry"), -- Open the diff for the next file
        ["<s-tab>"] = cb("select_prev_entry"), -- Open the diff for the previous file
        ["<leader>e"] = cb("focus_files"), -- Bring focus to the files panel
        ["<leader>b"] = cb("toggle_files") -- Toggle the files panel.
      },
      file_panel = {
        ["j"] = cb("next_entry"), -- Bring the cursor to the next file entry
        ["<down>"] = cb("next_entry"),
        ["k"] = cb("prev_entry"), -- Bring the cursor to the previous file entry.
        ["<up>"] = cb("prev_entry"),
        ["<cr>"] = cb("select_entry"), -- Open the diff for the selected entry.
        ["o"] = cb("select_entry"),
        ["<2-LeftMouse>"] = cb("select_entry"),
        ["-"] = cb("toggle_stage_entry"), -- Stage / unstage the selected entry.
        ["S"] = cb("stage_all"), -- Stage all entries.
        ["U"] = cb("unstage_all"), -- Unstage all entries.
        ["R"] = cb("refresh_files"), -- Update stats and entries in the file list.
        ["<tab>"] = cb("select_next_entry"),
        ["<s-tab>"] = cb("select_prev_entry"),
        ["<leader>e"] = cb("focus_files"),
        ["<leader>b"] = cb("toggle_files")
      }
    }
  end,
  "diffview"
)

MAIN.packer.append {
  ["sindrets/diffview.nvim"] = MAIN.must_require("diffview", "diffview").packer_module
}
