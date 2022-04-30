MAIN.configurations["todo"] = {
  plugin_setup_params = {},
  keymappings = {
    {
      mappings = {
        ["<leader>d"] = {"<cmd>TodoTelescope<cr>", "TODO list"}
      },
      options = {
        mode = "n",
        noremap = true,
        nowait = true
      }
    }
  },
  packer_module = {
    config = function()
      local c = MAIN.configurations["todo"]
      require("todo-comments").setup(c.plugin_setup_params)
      MAIN.which_key.compile(c.keymappings)
    end
  }
}
MAIN.packer.append {
  ["folke/todo-comments.nvim"] = MAIN.must_require("todo-comments", "todo").packer_module
}
