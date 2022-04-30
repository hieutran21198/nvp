MAIN.configurations["bufferline"] = {
  plugin_setup_params = {
    options = {
      numbers = function(opts)
        return string.format("%s", opts.id) -- :h bufferline-numbers
      end,
      close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
      right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
      left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
      middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
      indicator_icon = " ",
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 18,
      max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
      tab_size = 18,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
      -- NOTE: this will be called a lot so don't do any heavy processing here
      custom_filter = function(buf_number)
        -- filter out filetypes you don't want to see
        if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
          return true
        end
        -- filter out by buffer name
        if vim.fn.bufname(buf_number) ~= "No Name" then
          return true
        end
        -- filter out based on arbitrary rules
        -- e.g. filter out vim wiki buffer from tabline in your work repo
        if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
          return true
        end
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = " File Explorer",
          highlight = "Directory",
          text_align = "left",
          padding = 1
        }
      },
      show_buffer_icons = true, -- disable filetype icons for buffers
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
      -- can also be a table containing 2 custom separators
      -- [focused and unfocused]. eg: { '|', '|' }
      separator_style = "thin",
      enforce_regular_tabs = false,
      always_show_bufferline = false,
      sort_by = "id"
    }
  },
  packer_module = {
    tag = "*",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      local bufferline = require "bufferline"
      local c = MAIN.configurations["bufferline"]
      bufferline.setup(c.plugin_setup_params)
      MAIN.which_key.compile(c.key_mappings)
    end
  },
  key_mappings = {
    {
      mappings = {
        ["<leader>"] = {
          ["b"] = {
            ["a"] = {
              "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>",
              "Close all but the current buffer"
            },
            l = {"<cmd>BufferLineCloseLeft<cr>", "Close all buffers to the left"},
            N = {"<cmd>BufferLineMovePrev<cr>", "Move buffer prev"},
            n = {"<cmd>BufferLineMoveNext<cr>", "Move buffer next"},
            r = {
              "<cmd>BufferLineCloseRight<cr>",
              "Close all BufferLines to the right"
            },
            x = {
              "<cmd>BufferLineSortByDirectory<cr>",
              "Sort BufferLines automatically by directory"
            },
            e = {
              "<cmd>BufferLineSortByExtension<cr>",
              "Sort BufferLines automatically by extension"
            }
          }
        }
      },
      options = {
        mode = "n",
        noremap = true,
        nowait = true,
        buffer = nil,
        silent = true
      }
    }
  }
}

MAIN.packer.append {
  ["akinsho/bufferline.nvim"] = MAIN.must_require("bufferline", "bufferline").packer_module
}
