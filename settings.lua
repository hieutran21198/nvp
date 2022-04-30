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

MAIN.packer.append {
  "rktjmp/lush.nvim",
  "RishabhRD/gruvy"
}

MAIN.colorscheme = "gruvy"

require "modules.prefers.todo"
require "modules.prefers.bufferline"
require "modules.prefers.lualine"
require "modules.prefers.gsigns"
require "modules.prefers.gitblame"
