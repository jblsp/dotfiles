local util = require("joe.util")

return {
  src = "gh:ibhagwan/fzf-lua",
  config = function()
    local fzf = require("fzf-lua")

    local map = util.mapper("fzf")

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
    map("<leader>sC", fzf.awesome_colorschemes, "Search online colorschemes")
    map("z=", fzf.spell_suggest, "Spelling suggestions")
    map("<leader>:", fzf.command_history, "Command history")
    map("<leader>sd", fzf.diagnostics_document, "Search document diagnostics")
    map("<leader>sD", fzf.diagnostics_workspace, "Search workspace diagnostics")
    map("<leader>sr", fzf.resume, "Resume search")
    map("<leader>sp", "<cmd>FzfLua<cr>", "Search builtin pickers")
    map("<leader>so", fzf.nvim_options, "Search options")
    map("<leader>gra", fzf.lsp_code_actions, "Search options")

    -- LSP mappings
    map("g0", fzf.lsp_document_symbols, "View document symbols")
    map("gW", fzf.lsp_workspace_symbols, "View workspace symbols")

    fzf.register_ui_select(function(_, items)
      local min_h, max_h = 0.15, 0.70
      local h = (#items + 4) / vim.o.lines
      if h < min_h then
        h = min_h
      elseif h > max_h then
        h = max_h
      end
      return { winopts = { height = h, width = 0.65, row = 0.40 } }
    end)

    fzf.setup({
      { "borderless_full", "hide" },
      blines = { "ivy" },
      colorschemes = {
        winopts = { width = 0.35 },
      },
      awesome_colorschemes = {
        winopts = { col = 0.5, width = 0.58, row = 0.40, height = 0.5 },
      },
    })
  end,
}
