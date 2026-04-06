local util = require("joe.util")

return {
  src = "gh:lewis6991/gitsigns.nvim",
  version = vim.version.range("*"),
  config = function()
    local gitsigns = require("gitsigns")

    gitsigns.setup({
      on_attach = function(bufnr)
        local map = util.mapper("Git", bufnr)

        map("]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end)

        map("[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end)

        map("<leader>ga", gitsigns.stage_hunk, "Stage hunk")
        map("<leader>gr", gitsigns.reset_hunk, "Reset hunk")

        map("<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, nil, { mode = "v" })

        map("<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, nil, { mode = "v" })

        map("<leader>gA", gitsigns.stage_buffer, "Stage buffer")
        map("<leader>gR", gitsigns.reset_buffer, "Reset buffer")
        map("<leader>gp", gitsigns.preview_hunk, "Preview hunk")

        map("<leader>gb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame line")

        map("<leader>gd", gitsigns.diffthis, "Vimdiff current file")

        map("<leader>hQ", function()
          gitsigns.setqflist("all")
        end)
        map("<leader>hq", gitsigns.setqflist)

        -- Text object
        map("ih", gitsigns.select_hunk, nil, { mode = { "o", "x" } })
      end,
    })
  end,
}
