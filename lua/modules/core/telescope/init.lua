local utils = require "common.utils"

MAIN.configurations["telescope"] = {
  keymappings = {
    {
      mappings = {
        ["<leader>"] = {
          -- searching
          sr = {"<cmd>lua require'telescope.builtin'.resume{}<cr>", "Resume last search action"},
          st = {"<cmd>Telescope live_grep<cr>", "Search text inside the current workspace"},
          ss = {"<cmd>Telescope grep_string<cr>", "Text under cursor"},
          sh = {"<cmd>Telescope help_tags<cr>", "Find helps"},
          sm = {"<cmd>Telescope man_pages<cr>", "Man Pages"},
          sR = {"<cmd>Telescope registers<cr>", "Registers"},
          sk = {"<cmd>Telescope keymaps<cr>", "Keymaps"},
          sc = {"<cmd>Telescope commands<cr>", "Commands"},
          sp = {"<cmd>Telescope projects<cr>", "Projects"},
          sC = {"<cmd>Telescope colorscheme<cr>", "Colorscheme"},
          -- buffer
          bb = {"<cmd>Telescope buffers<cr>", "Openned buffers"},
          bh = {"<cmd>lua require'telescope.builtin'.highlights()<cr>", "All buffer's highlights"},
          -- files
          ff = {"<cmd>Telescope find_files<cr>", "Find file by name"},
          fo = {"<cmd>Telescope oldfiles<cr>", "List recently openned files"},
          -- git
          gg = {"<cmd>Telescope git_status<cr>", "Open changed file"},
          gb = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
          gc = {"<cmd>Telescope git_commits<cr>", "Checkout commit"},
          gC = {
            "<cmd>Telescope git_bcommits<cr>",
            "Checkout commit(for current file)"
          }
        }
      },
      options = {
        mode = "n",
        buffer = nil,
        silent = true,
        noremap = true,
        nowait = true
      }
    }
  },
  plugin_setup_params = {
    defaults = {
      mappings = {},
      preview = {hide_on_startup = true},
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "-u"
      }
    },
    prompt_prefix = " ",
    selection_caret = " ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      width = 1,
      prompt_position = "bottom",
      preview_cutoff = 120,
      horizontal = {mirror = false},
      vertical = {mirror = false}
    },
    file_ignore_patterns = {},
    path_display = {shorten = 5},
    winblend = 0,
    border = {},
    borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
    color_devicons = true,
    use_less = true,
    set_env = {["COLORTERM"] = "truecolor"}
  },
  packer_module = {
    config = function()
      local c = MAIN.configurations["telescope"]
      local telescope = require("telescope")
      telescope.setup(c.plugin_setup_params)
      MAIN.which_key.compile(c.keymappings)
    end
  }
}

utils.must_require(
  function()
    local actions = require("telescope.actions")
    local action_layout = require("telescope.actions.layout")
    local c = MAIN.configurations["telescope"]

    c.plugin_setup_params.defaults.mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-p>"] = action_layout.toggle_preview
      }
    }
  end,
  "telescope"
)

MAIN.configurations["telescope.project"] = {
  packer_module = {
    config = function()
      require("project_nvim").setup {}
      require("telescope").load_extension("projects")
    end
  }
}

MAIN.packer.append {
  ["ahmedkhalf/project.nvim"] = MAIN.must_require("project_nvim", "telescope.project").packer_module,
  ["nvim-telescope/telescope.nvim"] = MAIN.must_require("telescope", "telescope").packer_module
}
