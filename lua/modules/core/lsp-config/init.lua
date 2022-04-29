MAIN.configurations["lsp-config"] = {
  plugin_setup_params = {},
  -- server_name: opts (https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
  lsp_opts = {},
  on_attach_temp = {},
  updater_capabilities = MAIN.configurations["cmp.cmp-nvim-lsp"].update_capabilities,
  key_mappings_on_attach = {
    ["*"] = {
      ["n"] = {
        K = {"<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover"},
        g = {
          r = {"<cmd>lua vim.lsp.buf.references()<CR>", "References"},
          d = {"<cmd>lua vim.lsp.buf.definition()<cr>", "Definitions"},
          D = {"<cmd>lua vim.lsp.buf.declaration()<cr>", "Declarations"},
          I = {"<cmd>lua vim.lsp.buf.Implementation()<cr>", "Implementations"},
          a = {"<cmd>lua vim.lsp.buf.code_action()<cr>", "Actions"}
        },
        ["["] = {
          g = {
            "<cmd>lua vim.diagnostic.goto_prev()<CR>",
            "LSP goto previous"
          }
        },
        ["]"] = {
          g = {
            "<cmd>lua vim.diagnostic.goto_next()<CR>",
            "LSP goto next"
          }
        },
        ["<leader>"] = {
          l = {
            name = "LSP",
            a = {"<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Actions"},
            d = {"<cmd>lua vim.diagnostic.open_float()<cr>", "Diagnostics"},
            f = {"<cmd>lua vim.lsp.buf.formatting()<cr>", "Format buffer"}
          }
        },
        ["<F2>"] = {"<cmd>lua vim.lsp.buf.rename()<cr>", "Rename"}
      }
    }
  },
  packer_module = {}
}

MAIN.configurations["lsp-config.installer"] = {
  plugin_setup_params = {},
  settings = {
    ui = {
      icons = {
        server_installed = "◍",
        server_pending = "◍",
        server_uninstalled = "◍"
      },
      keymaps = {
        toggle_server_expand = "<CR>",
        install_server = "i",
        update_server = "u",
        uninstall_server = "d"
      }
    },
    install_root_dir = vim.env.HOME .. "/.local/share/nvim/lsp_servers",
    pip = {install_args = {}},
    max_concurrent_installers = 4
  },
  packer_module = {
    config = function()
      local lsp_installer = require "nvim-lsp-installer"
      local c = MAIN.configurations["lsp-config.installer"]

      lsp_installer.settings(c.settings)
      lsp_installer.on_server_ready(
        function(server)
          local opts = {}

          local lsp_config = MAIN.configurations["lsp-config"]
          opts.capabilities = lsp_config.updater_capabilities(vim.lsp.protocol.make_client_capabilities())

          for server_name, server_opts in pairs(lsp_config.lsp_opts) do
            if server_name == server.name then
              opts = server_opts
            end
          end

          if opts.on_attach ~= nil then
            if lsp_config.on_attach_temp[server.name] == nil then
              lsp_config.on_attach_temp[server.name] = opts.on_attach
            end
          end

          local set_key_mappings_on_attach = function(keymappings, bufnr)
            for mode, keymaps in pairs(keymappings) do
              MAIN["which-key"].compile_with_options(
                keymaps,
                {
                  mode = mode,
                  buffer = bufnr,
                  silent = true,
                  noremap = true,
                  nowait = true
                }
              )
            end
          end

          opts.on_attach = function(client, bufnr)
            local common_key_mappings_on_attach = lsp_config.key_mappings_on_attach["*"]
            local key_mappings_based_on_language = lsp_config.key_mappings_on_attach[server.name]

            set_key_mappings_on_attach(
              vim.tbl_deep_extend("force", common_key_mappings_on_attach, key_mappings_based_on_language),
              bufnr
            )

            lsp_config.on_attach_temp[server.name](client, bufnr)
          end
          server:setup(opts)
        end
      )
    end
  }
}

MAIN.packer.append {
  ["williamboman/nvim-lsp-installer"] = MAIN.must_require("nvim-lsp-installer","lsp-config.installer").packer_module,
  ["neovim/nvim-lspconfig"] = MAIN.configurations["lsp-config"].packer_module
}
