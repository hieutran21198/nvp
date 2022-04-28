MAIN = {
  configurations = {},
  packer = require "common.packer",
  which_key = require "common.which-key",
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
    line_wrap_cursor_movement = true,
    transparent = false,
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
          ["P"] = {
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
          ["R"] = {
            "<cmd>lua MAIN.reload()<cr>",
            "Reload neovim"
          },
          ["c"] = {
            name = "C prefix",
            ["h"] = {'<cmd>let @/=""<cr>', "Hightlight"}
          },
          ["w"] = {"<cmd>w<cr>", "Write to file"},
          ["q"] = {"<cmd>bd<cr>", "Quit"},
          ["b"] = {"<cmd>Buffers<CR>", "Opened buffers"}
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

local bootstrap_options = {
  user_config_filepath = vim.env.HOME .. "/.config/nvim/settings.lua"
}

---@param opts table
MAIN.bootstrap = function(opts)
  local utils = require "common.utils"

  if opts ~= nil then
    bootstrap_options = vim.tbl_deep_extend("force", bootstrap_options, opts)
  end

  MAIN.packer.provision()
  ---Load more modules
  require "modules.core"

  ---Load user config
  MAIN.require_user_config(bootstrap_options.user_config_filepath)

  utils.new_augroups(MAIN.augroups)
  utils.set_options(MAIN.options)
  utils.set_g(MAIN.g)
  MAIN.which_key.compile(MAIN.key_mappings)
  ---Load plugins
  MAIN.packer.startup()

  vim.cmd[[ PackerCompile ]]
end
