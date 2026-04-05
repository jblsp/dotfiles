local util = require("joe.util")

return {
  src = "gh:rmagatti/auto-session",
  config = function()
    local AutoSession = require("auto-session")

    vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

    vim.keymap.set("n", "<leader>ss", "<cmd>AutoSession search<cr>", { desc = "Search sessions" })
    vim.api.nvim_create_user_command("SmartRestart", function()
      vim.cmd("AutoSession save")
      vim.cmd.restart("AutoSession restore")
    end, { desc = "Restart and preserve session" })

    AutoSession.setup({
      auto_restore = false,
      auto_create = util.in_git_project,
      use_git_branch = true,
      suppressed_dirs = {
        "/",
        "~/",
        "~/Projects",
        "~/Downloads",
      },
      bypass_save_filetypes = {
        "netrw",
        "oil",
      },
      session_lens = {
        picker = "fzf",
        picker_opts = {
          height = 0.5,
          width = 0.6,
        },
      },
    })
  end,
}
