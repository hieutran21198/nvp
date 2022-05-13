local M = {
  capabilityUpdaters = {},
}

M.makeCapabilities = function(cap)
  if cap == nil then
    cap = vim.lsp.protocol.make_client_capabilities()
  end

  for _, updater in pairs(M.capabilityUpdaters) do
    cap = updater(cap)
  end

  return cap
end

return M
