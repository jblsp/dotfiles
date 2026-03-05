return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    "igorlfs/nvim-dap-view",
    "mfussenegger/nvim-dap-python",
  },

  config = function()
    local dap = require("dap")
    local dap_view = require("dap-view")

    local function map(lhs, rhs, desc, opts)
      opts = opts or {}
      opts["desc"] = "DAP: " .. desc
      vim.keymap.set(opts.mode or "n", lhs, rhs, opts)
    end

    map("<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, "Breakpoint Condition")
    map("<leader>db", dap.toggle_breakpoint, "Toggle Breakpoint")
    map("<leader>dc", dap.continue, "Run/Continue")
    map("<leader>dC", dap.run_to_cursor, "Run to Cursor")
    map("<leader>dg", dap.goto_, "Go to Line (No Execute)")
    map("<leader>di", dap.step_into, "Step Into")
    map("<leader>dj", dap.down, "Down")
    map("<leader>dk", dap.up, "Up")
    map("<leader>dl", dap.run_last, "Run Last")
    map("<leader>do", dap.step_out, "Step Out")
    map("<leader>dO", dap.step_over, "Step Over")
    map("<leader>dp", dap.pause, "Pause")
    map("<leader>dr", dap.repl.toggle, "Toggle REPL")
    map("<leader>ds", dap.session, "Session")
    map("<leader>dt", dap.terminate, "Terminate")

    -- Automatically open UI
    dap_view.setup()
    dap.listeners.before.attach["dap-view-config"] = function()
      dap_view.open()
    end
    dap.listeners.before.launch["dap-view-config"] = function()
      dap_view.open()
    end
    dap.listeners.before.event_terminated["dap-view-config"] = function()
      dap_view.close()
    end
    dap.listeners.before.event_exited["dap-view-config"] = function()
      dap_view.close()
    end

    -- Adapters
    require("dap-python").setup("python3")
  end,
}
