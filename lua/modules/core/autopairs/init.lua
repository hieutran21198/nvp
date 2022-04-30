MAIN.configurations["autopairs"] = {
  packer_module = {
    config = function()
      require("nvim-autopairs").setup {}
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({map_char = {tex = ""}}))
    end
  }
}

MAIN.packer.append {
  ["windwp/nvim-autopairs"] = MAIN.must_require("nvim-autopairs", "autopairs").packer_module
}
