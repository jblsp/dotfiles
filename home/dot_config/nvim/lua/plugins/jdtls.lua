local util = require("joe.util")

return {
  src = "cb:mfussenegger/nvim-jdtls",
  config = function()
    local jdtls = require("jdtls")

    vim.api.nvim_create_autocmd("LspAttach", {
      pattern = "*.java",
      group = vim.api.nvim_create_augroup("jdtls-config", { clear = true }),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- Only proceed if the attached LSP is jdtls
        if client == nil or client.name ~= "jdtls" then
          return
        end

        local map = util.mapper("jdtls", ev.buf)

        map("<localleader>ev", jdtls.extract_variable, "Extract Variable")
        map("<localleader>ec", jdtls.extract_constant, "Extract Constant")
        map("<localleader>em", jdtls.extract_method, "Extract Method")
        map("<localleader>o", jdtls.organize_imports, "Organize imports")
      end,
    })
  end,
}
