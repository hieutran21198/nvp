MAIN.configurations["gitblame"] = {
  packer_module = {
    config = function()
      local c = MAIN.configurations["gitblame"]
      vim.g["gitblame_enabled"] = 0
      MAIN.which_key.compile(c.key_mappings)
    end
  },
  key_mappings = {
    {
      mappings = {
        ["<leader>"] = {
          gB = {"<cmd>GitBlameToggle<cr>", "Toogle Blame"}
        }
      },
      options = {
        mode = "n",
        noremap = true,
        silent = true,
        nowait = true
      }
    }
  }
}

MAIN.packer.append {
  ["f-person/git-blame.nvim"] = MAIN.configurations["gitblame"].packer_module
}
