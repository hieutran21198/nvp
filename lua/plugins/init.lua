local M = {
  plugins = {}
}

M.set = function(plugins)
  for _, v in pairs(plugins) do
    table.insert(M.plugins, v)
  end
end

return M
