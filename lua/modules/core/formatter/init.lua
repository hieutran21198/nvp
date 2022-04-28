MAIN.formatters = function(fts)
  local c = MAIN.configurations["formatter"]
  if fts ~= nil then
    c.formatters = vim.tbl_deep_extend("force", c.formatters, fts)
  end
  return c.formatters
end

MAIN.format_on_save = function(fts)
  local c = MAIN.configurations["formatter"]
  if fts ~= nil then
    for _, v in ipairs(fts) do
      table.insert(c.format_on_save, v)
    end
  end
  return c.format_on_save
end

local tscommon_formatter = {
  function()
    return {
      exe = "prettier",
      args = {
        "--stdin-filepath",
        vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
      },
      stdin = true
    }
  end
}
for _, v in ipairs({"javascript", "typescript", "typescriptreact", "javascriptreact"}) do
  MAIN.formatters {
    [v] = tscommon_formatter
  }
end

MAIN.configurations["formatter"] = {
  plugin_setup_params = {},
  formatters = {
    lua = {
      function()
        return {exe = "luafmt", args = {"--stdin", "-i", 2}, stdin = true}
      end
    },
    json = {
      function()
        return {
          exe = "prettier",
          args = {
            "--format",
            "json",
            "--stdin-filepath",
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
          },
          stdin = true
        }
      end
    },
    yaml = {
      function()
        return {
          exe = "prettier",
          args = {
            "--format",
            "yaml",
            "--stdin-filepath",
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
          },
          stdin = true
        }
      end
    },
    sh = {
      function()
        return {
          exe = "shfmt",
          args = {
            "-l",
            "-w",
            vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
          },
          stdin = false
        }
      end
    },
    go = {
      function()
        return {
          exe = "goimports",
          args = {"-w", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
          stdin = false
        }
      end
    }
  },
  format_on_save = {
    "*.js",
    "*.jsx",
    "*.ts",
    "*.tsx",
    "*.json",
    "*.yaml",
    "*.lua",
    "*.sh",
    "*.yml"
  },
  packer_module = {
    config = function()
      local formatter = require "formatter"
      local fts = MAIN.formatters()
      MAIN.autocmds.set {
        _FormatterAG = {{"BufWritePost", table.concat(MAIN.format_on_save(), ","), "FormatWrite"}}
      }
      formatter.setup {
        filetype = fts
      }
    end
  }
}
MAIN.packer.append {
  ["mhartington/formatter.nvim"] = MAIN.configurations["formatter"].packer_module
}
