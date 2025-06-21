return {
  "mfussenegger/nvim-dap",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      dependencies = { "nvim-neotest/nvim-nio" },
      opts = {},
    },
    { "igorlfs/nvim-dap-view", opts = {} },
    "mfussenegger/nvim-dap-python",
  },

  config = function()
    -- Keymappings
    local function map(lhs, rhs, desc, opts)
      opts = opts or {}
      opts["desc"] = "DAP: " .. desc
      vim.keymap.set(opts.mode or "n", lhs, rhs, opts)
    end

    map("<leader>dB", function()
      require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, "Breakpoint Condition")
    map("<leader>db", require("dap").toggle_breakpoint, "Toggle Breakpoint")
    map("<leader>dc", require("dap").continue, "Run/Continue")
    map("<leader>dC", require("dap").run_to_cursor, "Run to Cursor")
    map("<leader>dg", require("dap").goto_, "Go to Line (No Execute)")
    map("<leader>di", require("dap").step_into, "Step Into")
    map("<leader>dj", require("dap").down, "Down")
    map("<leader>dk", require("dap").up, "Up")
    map("<leader>dl", require("dap").run_last, "Run Last")
    map("<leader>do", require("dap").step_out, "Step Out")
    map("<leader>dO", require("dap").step_over, "Step Over")
    map("<leader>dp", require("dap").pause, "Pause")
    map("<leader>dr", require("dap").repl.toggle, "Toggle REPL")
    map("<leader>ds", require("dap").session, "Session")
    map("<leader>dt", require("dap").terminate, "Terminate")

    -- Automatically open UI
    local dap, dv = require("dap"), require("dap-view")
    dap.listeners.before.attach["dap-view-config"] = function()
      dv.open()
    end
    dap.listeners.before.launch["dap-view-config"] = function()
      dv.open()
    end
    dap.listeners.before.event_terminated["dap-view-config"] = function()
      dv.close()
    end
    dap.listeners.before.event_exited["dap-view-config"] = function()
      dv.close()
    end

    -- Adapters
    require("dap-python").setup("python3")
  end,
}
