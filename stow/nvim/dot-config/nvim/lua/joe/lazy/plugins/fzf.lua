return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  event = "VeryLazy",
  config = function()
    local function map(lhs, rhs, opts)
      if opts.desc then
        opts.desc = "fzf-lua: " .. opts.desc
      end
      vim.keymap.set(opts.mode or "n", lhs, rhs, opts)
    end

    ---@param picker string
    local function builtin(picker, args)
      return function()
        require("fzf-lua")[picker](args)
      end
    end

    map("<leader>sh", builtin("help_tags"), { desc = "Search help" })
    map("<leader>sk", builtin("keymaps"), { desc = "Search keymaps" })
    map("<leader>sf", builtin("files"), { desc = "Search files" })
    map(
      "<leader>sF",
      builtin("files", {
        prompt = "Dirs> ",
        previewer = vim.NIL,
        cmd = "fd --color=never --type d --hidden --follow --exclude .git",
      }),
      { desc = "Search directories" }
    )
    map("<leader>sn", builtin("files", { cwd = vim.fn.stdpath("config") }), { desc = "Search config files" })
    map("<leader>sw", builtin("grep_cword"), { desc = "Grep current word" })
    map("<leader>sg", builtin("live_grep"), { desc = "Grep cwd" })
    map("<leader>bs", builtin("buffers"), { desc = "Search buffers" })
    map("<leader>/", builtin("blines"), { desc = "Fuzzily search buffer" })
    map("<leader>sc", builtin("colorschemes"), { desc = "Search colorschemes" })
    map("z=", builtin("spell_suggest"), { desc = "Spelling suggestions" })
    map("<leader>:", builtin("command_history"), { desc = "Command history" })
    map("<leader>sd", builtin("diagnostics_document"), { desc = "Search document diagnostics" })
    map("<leader>sD", builtin("diagnostics_workspace"), { desc = "Search workspace diagnostics" })
    map("<leader>sr", builtin("resume"), { desc = "Resume search" })

    -- LSP mappings
    map("g0", builtin("lsp_document_symbols"), { desc = "View document symbols" })
    map("gri", builtin("lsp_implementations"), { desc = "View implementation" })
    map("grr", builtin("lsp_references"), { desc = "View references" })
    map("grd", builtin("lsp_definitions"), { desc = "View definitions" })
    map("grD", builtin("lsp_declarations"), { desc = "View declarations" })
    map("gW", builtin("lsp_workspace_symbols"), { desc = "View workspace symbols" })
    map("grt", builtin("lsp_typedefs"), { desc = "View type definitions" })

    require("fzf-lua").register_ui_select(function(_, items)
      local min_h, max_h = 0.15, 0.70
      local h = (#items + 4) / vim.o.lines
      if h < min_h then
        h = min_h
      elseif h > max_h then
        h = max_h
      end
      return { winopts = { height = h, width = 0.65, row = 0.40 } }
    end)
  end,
}
