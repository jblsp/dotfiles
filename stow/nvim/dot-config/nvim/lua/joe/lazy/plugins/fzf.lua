return {
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  event = "VeryLazy",
  config = function()
    local fzf = require("fzf-lua")

    local function map(lhs, rhs, desc, opts)
      opts = opts or {}
      opts.desc = "fzf-lua: " .. desc
      vim.keymap.set(opts.mode or "n", lhs, rhs, opts)
    end

    map("<leader>sh", fzf.help_tags, "Search help")
    map("<leader>sk", fzf.keymaps, "Search keymaps")
    map("<leader>sf", fzf.files, "Search files")
    map("<leader>sF", function()
      fzf.files({
        prompt = "Dirs> ",
        previewer = vim.NIL,
        cmd = "fd --color=never --type d --hidden --follow --exclude .git",
      })
    end, "Search directories")
    map("<leader>sn", function()
      fzf.files({ cwd = vim.fn.stdpath("config") })
    end, "Search config files")
    map("<leader>sw", fzf.grep_cword, "Grep current word")
    map("<leader>sg", fzf.live_grep, "Grep cwd")
    map("<leader>bs", fzf.buffers, "Search buffers")
    map("<leader>/", fzf.blines, "Fuzzily search buffer")
    map("<leader>sc", fzf.colorschemes, "Search colorschemes")
    map("z=", fzf.spell_suggest, "Spelling suggestions")
    map("<leader>:", fzf.command_history, "Command history")
    map("<leader>sd", fzf.diagnostics_document, "Search document diagnostics")
    map("<leader>sD", fzf.diagnostics_workspace, "Search workspace diagnostics")
    map("<leader>sr", fzf.resume, "Resume search")

    -- LSP mappings
    map("g0", fzf.lsp_document_symbols, "View document symbols")
    map("gri", fzf.lsp_implementations, "View implementation")
    map("grr", fzf.lsp_references, "View references")
    map("grd", fzf.lsp_definitions, "View definitions")
    map("grD", fzf.lsp_declarations, "View declarations")
    map("gW", fzf.lsp_workspace_symbols, "View workspace symbols")
    map("grt", fzf.lsp_typedefs, "View type definitions")

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
