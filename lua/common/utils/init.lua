return {
  ---@param handler fun()
  ---@param package_name string
  must_require = function(handler, package_name)
    -- if not package.loaded[packageName] then
    --   error("Package '" .. packageName .. "' not found")
    -- end
    local ok, _ = pcall(require, package_name)
    if not ok then
      error("Package '" .. package_name .. "' not found")
    else
      handler()
    end
  end
}
