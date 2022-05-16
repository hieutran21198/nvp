MAIN.options["transparent"] = false

local on_attach_n = MAIN.configurations["lsp-config"].key_mappings_on_attach["*"]["n"]
local on_attach_n_g = on_attach_n["g"]
local on_attach_n_leader = on_attach_n["<leader>"]
local on_attach_n_leader_l = on_attach_n_leader["l"]

on_attach_n_g["r"] = {"<cmd>lua require 'telescope.builtin'.lsp_references() <Cr>", "LSP references"}
on_attach_n_g["d"] = {"<cmd>lua require 'telescope.builtin'.lsp_definitions() <Cr>", "LSP definitions"}
on_attach_n_g["i"] = {"<cmd>lua require 'telescope.builtin'.lsp_implementations() <Cr>", "LSP implementations"}
on_attach_n_g["t"] = {
  "<cmd>lua require 'telescope.builtin'.lsp_type_implementations()<Cr>",
  "LSP type implementations"
}

on_attach_n_leader_l["s"] = {"<cmd>lua require 'telescope.builtin'.lsp_document_symbols() <Cr>", "LSP document symbols"}
on_attach_n_leader_l["S"] = {
  "<cmd>lua require 'telescope.builtin'.lsp_workspace_symbols() <Cr>",
  "LSP workspace symbols"
}

MAIN.packer.register {
  "rktjmp/lush.nvim",
  "RishabhRD/gruvy",
  ["ray-x/go.nvim"] = {
    config = function()
      local ok, go = pcall(require, "go")
      if not ok then
        return
      end
      go.setup {}

      if MAIN.configurations["lsp-config"].key_mappings_on_attach["gopls"] == nil then
        MAIN.configurations["lsp-config"].key_mappings_on_attach["gopls"] = {
          ["n"] = {
            ["<leader>"] = {
              ["i"] = {
                ["j"] = {"<cmd>GoAddTag json<CR>", "Add JSON tags to struct"},
                ["s"] = {
                  name = "Struct",
                  ["f"] = {"<cmd>GoFillStruct<CR>", "Fill structs"},
                  ["t"] = {":GoAddTag ", "Add Tags"}
                },
                ["f"] = {"<cmd>GoFixPlurals<CR>", "Quick fix function plurals"},
                ["t"] = {
                  ["a"] = {"<cmd>GoAlt!<CR>", "Goto alternative file"}
                }
              }
            }
          }
        }
      end

      vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)
    end
  }
}

MAIN.colorscheme = "gruvy"

require "modules.prefers.todo"
require "modules.prefers.bufferline"
require "modules.prefers.lualine"
require "modules.prefers.gsigns"
require "modules.prefers.gitblame"
require "modules.prefers.diffview"
require "modules.prefers.neogit"
require "modules.prefers.nvim-window"
