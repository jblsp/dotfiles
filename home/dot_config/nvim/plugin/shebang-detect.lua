-- Detect shell scripts by shebang lines
vim.filetype.add({
  pattern = {
    [".*"] = function(_, bufnr)
      local first = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1]
      if not first then
        return
      end

      local shell = first:match("^#!.*/env%s+(%S+)") or first:match("^#!.*/(%S+)")
      if shell == "bash" or shell == "zsh" or shell == "sh" then
        return shell
      end
    end,
  },
})
