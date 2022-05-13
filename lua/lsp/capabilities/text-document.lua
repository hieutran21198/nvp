return function(cap)
  cap.textDocument.completion.completionItem.snippetSupport = true
  cap.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits"
    }
  }
  return cap
end
