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
            f = {"<cmd>lua vim.lsp.buf.formatting()<cr>", "Format buffer"},
            r = {"<cmd>LspRestart<cr>", "Restart LSP clients"}
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
            if keymappings == nil then
              return
            end

            for mode, keymaps in pairs(keymappings) do
              MAIN.which_key.compile_with_options(
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

            local key_mappings_based_on_language = lsp_config.key_mappings_on_attach[server.name] or {}

            set_key_mappings_on_attach(
              vim.tbl_deep_extend("force", common_key_mappings_on_attach, key_mappings_based_on_language),
              bufnr
            )

            if lsp_config.on_attach_temp[server.name] ~= nil then
              lsp_config.on_attach_temp[server.name](client, bufnr)
            end
          end
          server:setup(opts)
        end
      )
    end
  }
}

MAIN.configurations["lsp-config.signature"] = {
  plugin_setup_params = {
    debug = false, -- set to true to enable debug logging
    log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
    -- default is  ~/.cache/nvim/lsp_signature.log
    verbose = false, -- show debug line number
    bind = true, -- This is mandatory, otherwise border config won't get registered.
    -- If you want to hook lspsaga or other signature handler, pls set to false
    doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
    -- set to 0 if you DO NOT want any API comments be shown
    -- This setting only take effect in insert mode, it does not affect signature help in normal
    -- mode, 10 by default
    floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
    floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
    -- will set to true when fully tested, set to false will use whichever side has more space
    -- this setting will be helpful if you do not want the PUM and floating win overlap
    floating_window_off_x = 1, -- adjust float windows x position.
    floating_window_off_y = 1, -- adjust float windows y position.
    fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
    hint_enable = true, -- virtual hint enable
    hint_prefix = "🐼 ", -- Panda for parameter
    hint_scheme = "String",
    hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
    max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
    -- to view the hiding contents
    max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    handler_opts = {
      border = "rounded" -- double, rounded, single, shadow, none
    },
    always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58
    auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
    extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
    zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom
    padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc
    transparency = nil, -- disabled by default, allow floating win transparent value 1~100
    shadow_blend = 36, -- if you using shadow as border use this set the opacity
    shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
    timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
    toggle_key = nil -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
  },
  packer_module = {
    requires = {"neovim/nvim-lspconfig"},
    config = function()
      local c = MAIN.configurations["lsp-config.signature"]
      local signature = require "lsp_signature"
      signature.setup(c.plugin_setup_params)
    end
  }
}

MAIN.packer.append {
  ["williamboman/nvim-lsp-installer"] = MAIN.must_require("nvim-lsp-installer", "lsp-config.installer").packer_module,
  ["neovim/nvim-lspconfig"] = MAIN.configurations["lsp-config"].packer_module,
  ["ray-x/lsp_signature.nvim"] = MAIN.must_require("lsp_signature", "lsp-config.signature").packer_module
}
