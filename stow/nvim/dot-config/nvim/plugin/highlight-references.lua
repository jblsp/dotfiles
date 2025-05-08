local timer = vim.uv.new_timer()
local TIMEOUT = 250

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("highlight-references-attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      return
    end

    local augroup = vim.api.nvim_create_augroup("highlight-references", { clear = true })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      buffer = event.buf,
      group = augroup,
      callback = function()
        timer:stop()
        vim.lsp.buf.clear_references()

        timer:start(TIMEOUT, 0, function()
          vim.schedule(function()
            vim.lsp.buf.document_highlight()
          end)
        end)
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
