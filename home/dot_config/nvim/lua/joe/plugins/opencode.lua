return {
  "nickjvandyke/opencode.nvim",
  version = "*",
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      lsp = {
        enabled = true,
      },
    }

    -- Recommended/example keymaps
    vim.keymap.set("n", "<leader>op", function()
      require("opencode").ask("", { submit = true })
    end, { desc = "Ask opencode…" })
    vim.keymap.set("n", "<leader>oa", function()
      require("opencode").select()
    end, { desc = "Execute opencode action…" })
    vim.keymap.set({ "n" }, "<leader>ot", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "<leader>or", function()
      return require("opencode").operator("@this ")
    end, { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n", "<leader>ol", function()
      return require("opencode").operator("@this ") .. "_"
    end, { desc = "Add line to opencode", expr = true })
  end,
}
