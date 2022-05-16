require "modules.core.cmp"
require "modules.core.lsp-config"
require "modules.core.neo-tree"
require "modules.core.formatter"
require "modules.core.autopairs"
require "modules.core.telescope"
require "modules.core.nvim-treesitter"
require "modules.core.comment"
require "modules.core.fterm"

vim.g["mapleader"] = " "

for k, v in pairs(
  {
    vscode_style = "dark",
    vscode_transparent = 1,
    vscode_italic_comment = 1,
    vscode_disable_nvimtree_bg = true
  }
) do
  vim.g[k] = v
end

MAIN.packer.register {
  "Mofiqul/vscode.nvim"
}

local generic_opts_any = {noremap = true, silent = true}
local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  command_mode = generic_opts_any,
  term_mode = {silent = true},
  select_mode = generic_opts_any
}
local mode_adapters = {
  insert_mode = "i",
  normal_mode = "n",
  term_mode = "t",
  visual_mode = "v",
  visual_block_mode = "x",
  command_mode = "c",
  select_mode = "s"
}

for mode, mappings in pairs(
  {
    insert_mode = {
      ["jk"] = "<ESC>",
      ["kj"] = "<ESC>",
      ["jj"] = "<ESC>",
      ["<A-j>"] = "<Esc>:m .+1<CR>==gi",
      ["<A-k>"] = "<Esc>:m .-2<CR>==gi",
      ["<A-Up>"] = "<C-\\><C-N><C-w>k",
      ["<A-Down>"] = "<C-\\><C-N><C-w>j",
      ["<A-Left>"] = "<C-\\><C-N><C-w>h",
      ["<A-Right>"] = "<C-\\><C-N><C-w>l"
    },
    normal_mode = {
      d = '"_d',
      D = '"_D',
      ["<C-h>"] = "<C-w>h",
      ["<C-j>"] = "<C-w>j",
      ["<C-k>"] = "<C-w>k",
      ["<C-l>"] = "<C-w>l",
      ["<C-Up>"] = ":resize -2<CR>",
      ["<C-Down>"] = ":resize +2<CR>",
      ["<C-Left>"] = ":vertical resize -2<CR>",
      ["<C-Right>"] = ":vertical resize +2<CR>",
      ["<S-l>"] = ":BufferNext<CR>",
      ["<S-h>"] = ":BufferPrevious<CR>",
      ["<A-j>"] = ":m .+1<CR>==",
      ["<A-k>"] = ":m .-2<CR>=="
    },
    term_mode = {
      ["<C-h>"] = "<C-\\><C-N><C-w>h",
      ["<C-j>"] = "<C-\\><C-N><C-w>j",
      ["<C-k>"] = "<C-\\><C-N><C-w>k",
      ["<C-l>"] = "<C-\\><C-N><C-w>l"
    },
    visual_mode = {["<"] = "<gv", [">"] = ">gv", d = '"_d', D = '"_D'},
    visual_block_mode = {
      ["K"] = ":move '<-2<CR>gv-gv",
      ["J"] = ":move '>+1<CR>gv-gv",
      ["<A-j>"] = ":m '>+1<CR>gv-gv",
      ["<A-k>"] = ":m '<-2<CR>gv-gv",
      ["<C-o"] = [[:<c-u>let @/=@"<cr>gvy:let [@/,@"]=[@",@/]<cr>/\V<c-r>=substitute(escape(@/,'/\'),'\n','\\n','g')<cr><cr>]]
    }
  }
) do
  local vim_mode = mode_adapters[mode] and mode_adapters[mode] or mode
  for k, v in pairs(mappings) do
    local val = v
    local opts = generic_opts[vim_mode] and generic_opts[vim_mode] or generic_opts_any
    if type(v) == "table" then
      opts = v[2]
      val = v[1]
    end
    vim.api.nvim_set_keymap(vim_mode, k, val, opts)
  end
end
