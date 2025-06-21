return {
  "lewis6991/gitsigns.nvim",
  version = "*",
  lazy = false,
  config = function()
    local gitsigns = require("gitsigns")

    local function next_hunk()
      if vim.wo.diff then
        vim.cmd.normal({ "]h", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end

    local function prev_hunk()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end

    local function map(lhs, rhs, desc, opts)
      opts = opts or {}
      local mode = opts.mode
      opts.desc = "Git: " .. desc
      opts.mode = nil
      vim.keymap.set(mode or "n", lhs, rhs, opts)
    end

    map("]h", next_hunk, "Next hunk")
    map("[h", prev_hunk, "Previous hunk")
    map("<leader>ga", gitsigns.stage_hunk, "Stage hunk")
    map("<leader>gr", gitsigns.reset_hunk, "Reset hunk", { mode = "v" })
    map("<leader>ga", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Stage hunk", { mode = "v" })
    map("<leader>gr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Reset hunk", { mode = "v" })
    map("<leader>gA", gitsigns.stage_buffer, "Stage buffer")
    map("<leader>gR", gitsigns.reset_buffer, "Reset buffer")
    map("<leader>gp", gitsigns.preview_hunk, "Preview hunk")
    map("<leader>gb", function()
      gitsigns.blame_line({ full = true })
    end, "Blame line")
    map("<leader>gd", gitsigns.diffthis, "Vimdiff current file")

    require("gitsigns").setup({})
  end,
}
