MAIN.configurations["gitsigns"] = {
  plugin_setup_params = {
    keymaps = {
      noremap = false
    },
    signs = {
      add = {
        hl = "GitSignsAdd",
        text = "│",
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn"
      },
      change = {
        hl = "GitSignsChange",
        text = "│",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn"
      },
      delete = {
        hl = "GitSignsDelete",
        text = "_",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn"
      },
      topdelete = {
        hl = "GitSignsDelete",
        text = "‾",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn"
      },
      changedelete = {
        hl = "GitSignsChange",
        text = "~",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn"
      }
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {interval = 1000, follow_files = true},
    attach_to_untracked = true,
    -- git-blame provides also the time in contrast to gitsigns
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_formatter_opts = {relative_time = false},
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1
    },
    diff_opts = {internal = true},
    yadm = {enable = false}
  },
  packer_module = {
    requires = {"nvim-lua/plenary.nvim"},
    tag = "release",
    config = function()
      local gc = require "gitsigns"
      local c = MAIN.configurations["gitsigns"]
      gc.setup(c.plugin_setup_params)

      local mapping_on_attach_n = MAIN.configurations["lsp-config"].key_mappings_on_attach["*"]["n"]
      if mapping_on_attach_n["<leader>"] == nil then
        mapping_on_attach_n["<leader>"] = {}
      end
      mapping_on_attach_n["<leader>"] =
        vim.tbl_deep_extend("force", mapping_on_attach_n["<leader>"], c.key_mappings_on_attach)
    end
  },
  key_mappings_on_attach = {
    gj = {"<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk"},
    gk = {"<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk"},
    gp = {"<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk"},
    gr = {"<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk"},
    gR = {"<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer"},
    gs = {"<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk"},
    gu = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk"
    },
    gd = {
      "<cmd>Gitsigns diffthis HEAD<cr>",
      "Git Diff"
    },
    gc = {"<cmd>Telescope git_commits<cr>", "Checkout commit"},
    gC = {
      "<cmd>Telescope git_bcommits<cr>",
      "Checkout commit(for current file)"
    },
    go = {"<cmd>Telescope git_status<cr>", "Open changed file"},
    gb = {"<cmd>Telescope git_branches<cr>", "Checkout branch"}
  }
}

MAIN.packer.register {
  ["lewis6991/gitsigns.nvim"] = MAIN.must_require("gitsigns", "gitsigns").packer_module
}
