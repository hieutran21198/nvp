MAIN.configurations["nvim-tree"] = {
  plugin_setup_params = {},
  packer_module = {
    requires = {"kyazdani42/nvim-web-devicons"},
    config = function()
    end
  }
}

MAIN.packer.append {
  ["kyazdani42/nvim-tree.lua"] = MAIN.configurations["nvim-tree"].packer_module
}
