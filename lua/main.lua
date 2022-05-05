MAIN = {
  configurations = {},
  packer = require "common.packer",
  which_key = require "common.which-key",
  colorscheme = "vscode",
  g = {
    mapleader = " "
  },
  augroups = {
    _general_config = {
      {"textyankpost", "*", "lua require('vim.highlight').on_yank({higroup = 'search', timeout = 200})"},
      {"bufwinenter", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o"},
      {"bufread", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o"},
      {"bufnewfile", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o"},
      {"filetype", "qf", "set nobuflisted"}
    },
    _filetypechanges = {
      {"bufwinenter", ".tf", "setlocal filetype=terraform"},
      {"bufread", "*.tf", "setlocal filetype=terraform"},
      {"bufnewfile", "*.tf", "setlocal filetype=terraform"},
      {"bufwinenter", ".zsh", "setlocal filetype=sh"},
      {"bufread", "*.zsh", "setlocal filetype=sh"},
      {"bufnewfile", "*.zsh", "setlocal filetype=sh"},
      {"bufwinenter", ".fish", "setlocal filetype=sh"},
      {"bufread", "*.fish", "setlocal filetype=sh"},
      {"bufnewfile", "*.fish", "setlocal filetype=sh"}
    },
    _git = {{"filetype", "gitcommit", "setlocal wrap"}, {"filetype", "gitcommit", "setlocal spell"}},
    _markdown = {{"filetype", "markdown", "setlocal wrap"}, {"filetype", "markdown", "setlocal spell"}},
    _auto_resize = {{"vimresized", "*", "wincmd ="}},
    _general_lsp = {{"filetype", "lspinfo", "nnoremap <silent> <buffer> q :q<cr>"}}
  },
  options = {
    laststatus = 2,
    textwidth = 120,
    transparent = false,
    background = "dark",
    line_wrap_cursor_movement = true,
    backup = false,
    clipboard = "unnamedplus",
    cmdheight = 2,
    colorcolumn = "99999",
    completeopt = {"menuone", "noselect", "noinsert"},
    conceallevel = 0,
    fileencoding = "utf-8",
    hidden = true,
    hlsearch = true,
    ignorecase = true,
    mouse = "a",
    pumheight = 10,
    showmode = false,
    showtabline = 2,
    smartcase = true,
    smartindent = true,
    splitbelow = true,
    splitright = true,
    swapfile = false,
    termguicolors = true,
    timeoutlen = 100,
    title = true,
    undodir = vim.fn.stdpath "cache" .. "/undo",
    undofile = true,
    updatetime = 300,
    writebackup = false,
    expandtab = true,
    shiftwidth = 2,
    tabstop = 2,
    cursorline = true,
    number = true,
    relativenumber = false,
    numberwidth = 4,
    signcolumn = "yes",
    wrap = false,
    spell = false,
    spelllang = "en",
    scrolloff = 8,
    sidescrolloff = 8,
    autowrite = true,
    syntax = "on",
    foldmethod = "indent",
    foldlevelstart = 10,
    fillchars = "fold: ",
    foldenable = true,
    guifont = "Hack Nerd Font Mono:h18"
  },
  key_mappings = {
    {
      mappings = {
        ["<leader>"] = {
          ["p"] = {
            name = "Packer",
            ["i"] = {"<cmd>PackerInstall<cr>", "Install components"},
            ["c"] = {"<cmd>PackerCompile<cr>", "Compile"},
            ["C"] = {"<cmd>PackerClean<cr>", "Clean"},
            ["s"] = {"<cmd>PackerSync<cr>", "Sync"},
            ["l"] = {"<cmd>PackerLoad<cr>", "Load components"},
            ["p"] = {"<cmd>PackerProfile<cr>", "Profiling"},
            ["S"] = {"<cmd>PackerStatus<cr>", "Status"},
            ["u"] = {"<cmd>PackerUpdate<cr>", "Update"}
          },
          ["b"] = {
            name = "Buffer management",
            ["c"] = {'<cmd>let @/=""<cr>', "Clear highlights"},
            ["d"] = {"<cmd>Bdelete!<CR>", "Close Buffer"},
            ["w"] = {"<cmd>write<CR>", "Write to file"}
          },
          ["g"] = {
            name = "Git management"
          },
          ["f"] = {
            name = "File management"
          },
          ["s"] = {
            name = "Searching"
          },
          ["i"] = {
            name = "Key mappings by specific language"
          },
          ["n"] = {
            name = "NVP",
            ["r"] = {
              "<cmd>lua MAIN.reload()<cr>",
              "Reload NVP"
            }
          },
          ["w"] = {
            name = "Window",
            p = {"<c-w>x", "Swap"},
            q = {"<cmd>:q<cr>", "Close"},
            s = {"<cmd>:split<cr>", "Horizontal Split"},
            t = {"<c-w>t", "Move to new tab"},
            ["="] = {"<c-w>=", "Equally size"},
            v = {"<cmd>:vsplit<cr>", "Verstical Split"}
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
  }
}

---@param user_config_filepath string
MAIN.require_user_config = function(user_config_filepath)
  local utils = require "common.utils"
  if utils.file_exists(user_config_filepath) then
    utils.load_file(user_config_filepath)
  end
end

---@return table MAIN.configurations[configurations_name]
MAIN.must_require = function(package_name, configurations_name)
  local ok, _ = pcall(require, package_name)
  if not ok then
    local packer_module = {}

    if type(MAIN.configurations[configurations_name].packer_module) == "table" then
      for k, v in pairs(MAIN.configurations[configurations_name].packer_module) do
        if k ~= "config" and k ~= "setup" then
          packer_module[k] = v
        end
      end
    end
    return {
      packer_module = packer_module
    }
  end
  return MAIN.configurations[configurations_name]
end

MAIN.reload = function()
  dofile(vim.env.HOME .. "/.config/nvim/lua/main.lua")

  local prefix_dirs = {"^common", "^modules.core"}
  for name, _ in pairs(package.loaded) do
    if name ~= "main" then
      for _, dir in ipairs(prefix_dirs) do
        if name:match(dir) then
          package.loaded[name] = nil
        end
      end
    end
  end

  if vim.fn.delete(vim.env.HOME .. "/.local/share/nvim/plugin/packer_compiled.lua") ~= 0 then
    print("cannot delete cached compile plugins")
  end

  MAIN.bootstrap({reload = true})
end

local bootstrap_options = {
  user_config_filepath = vim.env.HOME .. "/.config/nvim/settings.lua",
  reload = false
}

---@param opts table
MAIN.bootstrap = function(opts)
  local utils = require "common.utils"

  if opts ~= nil then
    bootstrap_options = vim.tbl_deep_extend("force", bootstrap_options, opts)
  end

  if bootstrap_options.reload == false then
    MAIN.packer.provision()
  end
  ---Load more modules
  require "modules.core"

  ---Load user config
  MAIN.require_user_config(bootstrap_options.user_config_filepath)

  utils.new_augroups(MAIN.augroups)
  utils.set_options(MAIN.options)
  utils.set_g(MAIN.g)
  MAIN.which_key.compile(MAIN.key_mappings)
  ---Load plugins
  if bootstrap_options.reload == false then
    MAIN.packer.startup()
  end

  vim.cmd [[ PackerCompile ]]

  if MAIN.colorscheme ~= "" then
    vim.cmd("colorscheme " .. MAIN.colorscheme)
  end
end

MAIN.truthy = function()
  for package_name, packer_module in pairs(MAIN.configurations) do
    local ok, packaged = pcall(require, package_name)
    if ok and packer_module.config == nil then
      packer_module.config = function()
        local c = MAIN.configurations[package_name]
        if c.plugin_setup_params ~= nil then
          packaged.setup(c.plugin_setup_params)
        end
        if c.key_mappings ~= nil then
          MAIN.which_key.compile(c.key_mappings)
        end
      end
    end
  end
end
