vim.g.highlight_references = false

local TIMEOUT = 250

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("highlight-references-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and not client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      return
    end

    local timer = vim.uv.new_timer()
    local highlighted = false

    local augroup = vim.api.nvim_create_augroup("highlight-references", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = event.buf,
      group = augroup,
      callback = function()
        timer:stop()
        if highlighted then
          vim.lsp.buf.clear_references()
        end

        if vim.g.highlight_references then
          timer:start(TIMEOUT, 0, function()
            vim.schedule(function()
              vim.lsp.buf.document_highlight()
              highlighted = true
            end)
          end)
        end
      end,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("highlight-references-detach", { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = event2.buf })
      end,
    })
  end,
})
