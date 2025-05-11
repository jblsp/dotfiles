return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  cmd = "FzfLua",
  keys = function()
    ---@param picker string
    local function builtin(picker, args)
      return function()
        require("fzf-lua")[picker](args)
      end
    end

    return {
      { "<leader>sh", builtin("help_tags"), desc = "Search help" },
      { "<leader>sk", builtin("keymaps"), desc = "Search keymaps" },
      { "<leader>sf", builtin("files"), desc = "Search files" },
      { "<leader>sw", builtin("grep_cword"), desc = "Grep current word" },
      { "<leader>sg", builtin("live_grep"), desc = "Grep cwd" },
      { "<leader>bs", builtin("buffers"), desc = "Search buffers" },
      { "<leader>/", builtin("blines"), desc = "Fuzzily search buffer" },
      { "<leader>sc", builtin("colorschemes"), desc = "Search colorschemes" },
      { "z=", builtin("spell_suggest"), desc = "Spelling suggestions" },
      { "gri", builtin("lsp_implementations"), desc = "View implementation" },
      { "g0", builtin("lsp_document_symbols"), desc = "View document symbols" },
      { "grr", builtin("lsp_references"), desc = "View references" },
      { "<leader>:", builtin("command_history"), desc = "Command history" },
    }
  end,
  config = function()
    require("fzf-lua").register_ui_select(function(_, items)
      local min_h, max_h = 0.15, 0.70
      local h = (#items + 4) / vim.o.lines
      if h < min_h then
        h = min_h
      elseif h > max_h then
        h = max_h
      end
      return { winopts = { height = h, width = 0.60, row = 0.40 } }
    end)
  end,
}
