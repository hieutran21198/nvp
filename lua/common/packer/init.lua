local M = {
  plugins = {}
}

-- Append new plugins to the list of plugins
M.append = function(plugins)
  if type(plugins) == "table" then
    for k, v in pairs(plugins) do
      if type(k) == "number" and type(v) == "string" then
        table.insert(
          M.plugins,
          {
            [v] = {}
          }
        )
      elseif type(k) == "string" and type(v) == "table" then
        local plugin = table.insert(v, 0, k)
        table.insert(M.plugins, plugin)
      end
    end
  end
end

return M
