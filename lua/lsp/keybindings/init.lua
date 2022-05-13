local M = {}

M.assign_to_buffer = function(keymaps, bufnr)
  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end

  for mode, bindings in pairs(keymaps) do
    wk.register()
  end
end

return M
