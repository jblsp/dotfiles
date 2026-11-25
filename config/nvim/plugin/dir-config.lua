local group = vim.api.nvim_create_augroup("joe/dir-config", { clear = true })
local icon_ns = vim.api.nvim_create_namespace("joe/dir-icons")

vim.api.nvim_create_autocmd("User", {
  desc = "Filter directory listings",
  group = group,
  pattern = "DirReadPost",
  callback = function(args)
    local dir = vim.api.nvim_buf_get_name(args.buf)
    local is_godot = vim.fs.root(dir, "project.godot") ~= nil
    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
    local visible = vim.tbl_filter(function(line)
      local name = line:gsub("/$", "")
      return name ~= ".DS_Store" and not vim.startswith(name, "._") and not (is_godot and vim.endswith(name, ".uid"))
    end, lines)
    if #visible ~= #lines then
      vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, visible)
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  desc = "Add icons to directory listings",
  group = group,
  pattern = "DirReadPost",
  callback = function(args)
    vim.api.nvim_buf_clear_namespace(args.buf, icon_ns, 0, -1)
    local icons = _G.MiniIcons
    if not vim.g.have_nerd_font or not icons then
      return
    end
    local dir = vim.api.nvim_buf_get_name(args.buf)
    local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
    for row, line in ipairs(lines) do
      if line ~= "" then
        local category = vim.endswith(line, "/") and "directory" or "file"
        local name = line:gsub("/$", ""):gsub("%z", "\n")
        local icon, hl = icons.get(category, vim.fs.joinpath(dir, name))
        vim.api.nvim_buf_set_extmark(args.buf, icon_ns, row - 1, 0, {
          virt_text = { { icon .. " ", hl } },
          virt_text_pos = "inline",
        })
      end
    end
  end,
})
