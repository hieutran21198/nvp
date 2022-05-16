MAIN.configurations["comment"] = {
  plugin_setup_params = {},
  packer_module = {
    config = function()
      local c = MAIN.configurations["comment"]
      local comment = require "nvim_comment"
      comment.setup(c.plugin_setup_params)
    end
  }
}
MAIN.packer.register {
  ["terrortylor/nvim-comment"] = MAIN.must_require("nvim_comment", "comment").packer_module
}
