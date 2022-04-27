MAIN = {
  configurations = {},
  packer = require "common.packer",
  ["which-key"] = require "common.which-key"
}
MAIN.packer.provision()
---Load more modules
require "modules.core"

---TODO: require user modules

---TODO: bootstrap neovim
local bootstrap_options = {
  appname = ""
}
---@param opts type(bootstrap_options)
MAIN.bootstrap = function(opts)
  bootstrap_options = vim.tbl_deep_extend("force", bootstrap_options, opts)
  MAIN.packer.startup()
end
