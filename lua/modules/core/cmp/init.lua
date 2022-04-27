MAIN.configurations["cmp"] = {
  kinds = {
    Text = "?  ",
    Method = "?  ",
    Function = "?  ",
    Constructor = "?  ",
    Field = "?  ",
    Variable = "?  ",
    Class = "?  ",
    Interface = "?  ",
    Module = "?  ",
    Property = "?  ",
    Unit = "?  ",
    Value = "?  ",
    Enum = "?  ",
    Keyword = "?  ",
    Snippet = "?  ",
    Color = "?  ",
    File = "?  ",
    Reference = "?  ",
    Folder = "?  ",
    EnumMember = "?  ",
    Constant = "?  ",
    Struct = "?  ",
    Event = "?  ",
    Operator = "?  ",
    TypeParameter = "?  "
  },
  source_menus = {},
  plugin_setup_params = {
    sources = {},
    formatting = {
      -- applied codicons
      format = function(_, vim_item)
        local c = MAIN.configurations["cmp"]
        vim_item.kind = (c.kinds[vim_item.kind] or "") .. vim_item.kind
        return vim_item
      end
    }
    ---TODO: configure the plugin
  },
  packer_module = {
    config = function()
      local c = MAIN.configurations["cmp"]
      local cmp = require "cmp"
      cmp.setup(c.plugin_setup_params)
    end
  }
}

MAIN.configurations["cmp.cmp-vsnip"] = {
  plugin_setup_params = {},
  packer_module = {
    config = function()
      local c = MAIN.configurations["cmp"]
      c.plugin_setup_params.snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end
      }
    end
  }
}

MAIN.configurations["cmp.cmp-copilot"] = {
  plugin_setup_params = {},
  packer_module = {
    config = function()
      local c = MAIN.configurations["cmp"]
      table.insert(
        c.plugin_setup_params.sources,
        {
          name = "copilot",
          priority = 2
        }
      )
    end
  }
}

MAIN.configurations["cmp.cmp-nvim-lua"] = {
  plugin_setup_params = {},
  packer_module = {
    config = function()
      local c = MAIN.configurations["cmp"]
      table.insert(
        c.plugin_setup_params.sources,
        {
          name = "nvim-lua",
          type = "lua",
          priority = 1
        }
      )
    end
  }
}

MAIN.configurations["cmp.cmp-treesitter"] = {
  packer_module = {
    config = function()
      local c = MAIN.configurations["cmp"]
      table.insert(
        c.plugin_setup_params.sources,
        {
          name = "treesitter",
          priority = 2
        }
      )
    end
  }
}

MAIN.configurations["cmp.cmp-fish"] = {
  packer_module = {
    ft = "fish",
    config = function()
      local c = MAIN.configurations["cmp"]
      table.insert(
        c.plugin_setup_params.sources,
        {
          name = "fish",
          priority = 3
        }
      )
    end
  }
}

MAIN.configurations["cmp.cmp-tmux"] = {
  packer_module = {
    config = function()
      local c = MAIN.configurations["cmp"]
      table.insert(
        c.plugin_setup_params.sources,
        {
          name = "tmux",
          priority = 4,
          option = {
            all_panes = false,
            label = "[tmux]",
            trigger_characters = {"."},
            trigger_characters_ft = {}
          }
        }
      )
    end
  }
}

MAIN.configurations["cmp.cmp-nvim-lsp"] = {
  packer_module = {
    config = function()
      local c = MAIN.configurations["cmp"]
      table.insert(
        c.plugin_setup_params.sources,
        {
          name = "nvim-lsp",
          priority = 1
        }
      )
      c.source_menus["nvim_lsp"] = "[LSP]"
    end
  },
  ---TODO: use it in setup nvim-lsp
  ---@param caps table
  ---@return table updated_caps
  update_capabilities = function(caps)
    return require "cmp_nvim_lsp".update_capabilities(caps)
  end
}

MAIN.configurations["cmp.cmp-buffer"] = {
  packer_module = {
    config = function()
      local c = MAIN.configurations["cmp"]
      table.insert(
        c.plugin_setup_params.sources,
        {
          name = "buffer"
        }
      )
    end
  }
}

MAIN.configurations["cmp.cmp-path"] = {
  packer_module = {
    config = function()
      local c = MAIN.configurations["cmp"]
      table.insert(
        c.plugin_setup_params.sources,
        {
          name = "path"
        }
      )
    end
  }
}

MAIN.configurations["codicons"] = {
  packer_module = {
    config = function()
      local c = MAIN.configurations["cmp"]
      table.insert(
        c.plugin_setup_params.formatting.format,
        function(vim_item)
          local co = MAIN.configurations["codicons"]
          local codicon = co.codicon_map[vim_item.kind]
          if codicon then
            vim_item.kind = (codicon or "") .. " " .. vim_item.kind
          end
          return vim_item
        end
      )
    end
  },
  codicon_map = {
    ["Text"] = "",
    ["Method"] = "",
    ["Function"] = "",
    ["Constructor"] = "",
    ["Field"] = "",
    ["Variable"] = "",
    ["Class"] = "",
    ["Interface"] = "",
    ["Module"] = "",
    ["Property"] = "",
    ["Unit"] = "",
    ["Value"] = "",
    ["Enum"] = "",
    ["Keyword"] = "",
    ["Snippet"] = "",
    ["Color"] = "",
    ["File"] = "",
    ["Reference"] = "",
    ["Folder"] = "",
    ["EnumMember"] = "",
    ["Constant"] = "",
    ["Struct"] = "",
    ["Event"] = "",
    ["Operator"] = "",
    ["TypeParameter"] = ""
  }
}

MAIN.packer.append {
  ["hrsh7th/cmp-nvim-lsp"] = MAIN.configurations["cmp.cmp-nvim-lsp"].packer_module,
  ["hrsh7th/cmp-buffer"] = MAIN.configurations["cmp.cmp-buffer"].packer_module,
  ["hrsh7th/cmp-path"] = MAIN.configurations["cmp.cmp-path"].packer_module,
  ["hrsh7th/cmp-copilot"] = MAIN.configurations["cmp.cmp-copilot"].packer_module,
  ["hrsh7th/cmp-vsnip"] = MAIN.configurations["cmp.cmp-vsnip"].packer_module,
  "hrsh7th/vim-vsnip",
  ["hrsh7th/cmp-nvim-lua"] = MAIN.configurations["cmp.cmp-nvim-lua"].packer_module,
  ["ray-x/cmp-treesitter"] = MAIN.configurations["cmp.cmp-treesitter"].packer_module,
  ["mtoohey31/cmp-fish"] = MAIN.configurations["cmp.cmp-fish"].packer_module,
  ["andersevenrud/cmp-tmux"] = MAIN.configurations["cmp.cmp-tmux"].packer_module,
  ["mortepau/codicons.nvim"] = MAIN.configurations["codicons"].packer_module,
  -- main plugin.
  ["hrsh7th/nvim-cmp"] = MAIN.configurations["cmp"].packer_module
}