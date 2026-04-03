return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  config = function()
    local opencode = require("opencode")

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      lsp = {
        enabled = true,
      },
    }

    vim.keymap.set("n", "<leader>op", function()
      opencode.ask("", { submit = true })
    end, { desc = "Ask opencode…" })
    vim.keymap.set("n", "<leader>oa", function()
      opencode.select()
    end, { desc = "Execute opencode action…" })
    vim.keymap.set({ "n" }, "<leader>ot", function()
      opencode.toggle()
    end, { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "<leader>or", function()
      return opencode.operator("@this ")
    end, { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n", "<leader>ol", function()
      return opencode.operator("@this ") .. "_"
    end, { desc = "Add line to opencode", expr = true })
  end,
}
