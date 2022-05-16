MAIN.configurations["cmp"] = {
  source_menus = {},
  plugin_setup_params = {
    view = {
      entries = {name = "custom", selection_order = "near_cursor"}
    },
    snippet = {
      expand = function(args)
        local ok, snippy = pcall(require, "snippy")
        if not ok then
          return
        end
        snippy.expand_snippet(args.body)
      end
    }
  },
  packer_module = {
    config = function()
      local c = MAIN.configurations["cmp"]
      local cmp = require "cmp"
      cmp.setup(c.plugin_setup_params)
    end
  },
  keymappings = {}
}

MAIN.configurations["cmp.lspkind"] = {
  packer_module = {
    config = function()
      local lspkind = require "lspkind"
      local c = MAIN.configurations["cmp"]
      lspkind.init(
        {
          mode = "symbol_text",
          preset = "default",
          symbol_map = {
            Text = "",
            Method = "",
            Function = "",
            Constructor = "",
            Field = "ﰠ",
            Variable = "",
            Class = "ﴯ",
            Interface = "",
            Module = "",
            Property = "ﰠ",
            Unit = "塞",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "פּ",
            Event = "",
            Operator = "",
            TypeParameter = ""
          }
        }
      )
      c.plugin_setup_params["formatting"] = {
        format = lspkind.cmp_format(
          {
            mode = "symbol_text",
            menu = ({
              buffer = "[BUF]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              copilot = "[AI]",
              snippy = "[SN]"
            }),
            maxwidth = 50
          }
        )
      }
    end
  }
}

local utils = require "common.utils"

utils.must_require(
  function()
    local cmp = require "cmp"
    local c = MAIN.configurations["cmp"]
    c.plugin_setup_params["mapping"] = {
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), {"i", "s"}),
      ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), {"i", "s"}),
      ["<C-s>"] = cmp.mapping.complete_common_string(),
      ["<C-e>"] = cmp.mapping(
        {
          i = cmp.mapping.abort(),
          c = cmp.mapping.close()
        }
      ),
      ["<CR>"] = cmp.mapping.confirm({select = true})
    }
    c.plugin_setup_params["sources"] =
      cmp.config.sources(
      {
        {name = "copilot"},
        {name = "nvim_lsp"},
        {name = "snippy"},
        {name = "path"},
        {name = "buffer"},
        {name = "treesitter"}
      }
    )
  end,
  "cmp"
)

MAIN.configurations["cmp.cmp-copilot"] = {
  plugin_setup_params = {},
  packer_module = {
    config = function()
    end
  }
}

MAIN.configurations["cmp.cmp-nvim-lua"] = {
  plugin_setup_params = {},
  packer_module = {
    config = function()
    end
  }
}

MAIN.configurations["cmp.cmp-treesitter"] = {
  packer_module = {
    config = function()
    end
  }
}

MAIN.configurations["cmp.cmp-nvim-lsp"] = {
  packer_module = {
    config = function()
    end
  },
  ---@param caps table
  ---@return table updated_caps
  update_capabilities = function(caps)
    return require "cmp_nvim_lsp".update_capabilities(caps)
  end
}

MAIN.configurations["cmp.cmp-buffer"] = {
  packer_module = {
    config = function()
    end
  }
}

MAIN.configurations["cmp.cmp-path"] = {
  packer_module = {
    config = function()
    end
  }
}

MAIN.configurations["cmp.snippy"] = {
  plugin_setup_params = {
    mappings = {
      is = {["<C-j>"] = "expand_or_advance", ["<C-k>"] = "previous"}
    },
    snippets_dirs = {vim.env.HOME .. "/.config/nvim/snippets"},
    hl_group = "Search"
  },
  packer_module = {
    config = function()
      local snippy = require "snippy"
      local c = MAIN.configurations["cmp"]
      snippy.setup(c.plugin_setup_params)
    end
  }
}

MAIN.packer.register {
  ["hrsh7th/cmp-nvim-lsp"] = MAIN.configurations["cmp.cmp-nvim-lsp"].packer_module,
  ["hrsh7th/cmp-buffer"] = MAIN.configurations["cmp.cmp-buffer"].packer_module,
  ["hrsh7th/cmp-path"] = MAIN.configurations["cmp.cmp-path"].packer_module,
  ["github/copilot.vim"] = {},
  ["hrsh7th/cmp-copilot"] = MAIN.configurations["cmp.cmp-copilot"].packer_module,
  ["dcampos/cmp-snippy"] = MAIN.must_require("snippy", "cmp.snippy").packer_module,
  "dcampos/nvim-snippy",
  ["hrsh7th/cmp-nvim-lua"] = MAIN.configurations["cmp.cmp-nvim-lua"].packer_module,
  ["ray-x/cmp-treesitter"] = MAIN.configurations["cmp.cmp-treesitter"].packer_module,
  ["onsails/lspkind.nvim"] = MAIN.must_require("lspkind", "cmp.lspkind").packer_module,
  -- main plugin.
  ["hrsh7th/nvim-cmp"] = MAIN.must_require("cmp", "cmp").packer_module
}
