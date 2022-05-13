local lsp = require "lua.lsp"

table.insert(lsp.capabilities, require "lua.lsp.capabilities.text-document")
