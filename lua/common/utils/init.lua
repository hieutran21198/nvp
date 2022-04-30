return {
  ---@param handler fun()
  ---@param package_name string
  must_require = function(handler, package_name)
    local ok, _ = pcall(require, package_name)
    if not ok then
      return
    else
      handler()
    end
  end,
  package_already = function(package_name)
    local ok, _ = pcall(require, package_name)
    if not ok then
      return false
    end
    return true
  end,
  ---@param name string
  ---@return boolean
  file_exists = function(name)
    local f = io.open(name, "r")
    if f ~= nil then
      io.close(f)
      return true
    end
    return false
  end,
  ---@param filepath string
  load_file = function(filepath)
    local lf, error = pcall(vim.cmd, "luafile " .. filepath)
    if not lf then
      print(error)
    end
  end,
  ---@param cmds table<string, string>
  set_autocmds = function(cmds)
    for _, cmd in ipairs(cmds) do
      vim.cmd(cmd)
    end
  end,
  ---@param cmds table<string, string>
  new_augroups = function(cmds)
    for group, def in pairs(cmds) do
      vim.cmd("augroup " .. group)
      vim.cmd("autocmd!")
      for _, v in pairs(def) do
        local cmd = table.concat(vim.tbl_flatten {"autocmd", v}, " ")
        vim.cmd(cmd)
      end
      vim.cmd "augroup END"
    end
  end,
  ---@param options table
  set_options = function(options)
    for k, v in pairs(options) do
      local cmd = vim.cmd

      if k == "line_wrap_cursor_movement" then
        if v == true then
          cmd "set whichwrap+=<,>,[,],h,l"
        end
      elseif k == "transparent" then
        if v == true then
          cmd "au ColorScheme * hi Normal ctermbg=none guibg=none"
          cmd "au ColorScheme * hi SignColumn ctermbg=none guibg=none"
          cmd "au ColorScheme * hi NormalNC ctermbg=none guibg=none"
          cmd "au ColorScheme * hi MsgArea ctermbg=none guibg=none"
          cmd "au ColorScheme * hi TelescopeBorder ctermbg=none guibg=none"
          cmd "au ColorScheme * hi NvimTreeNormal ctermbg=none guibg=none"
          cmd "let &fcs='eob: '"
        end
      else
        vim.opt[k] = v
      end
    end
  end,
  ---@param options table
  set_g = function(options)
    for k, v in pairs(options) do
      vim.g[k] = v
    end
  end
}
