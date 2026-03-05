-- In Godot settings, set external editor flags to: --server /tmp/godot.pipe --remote-expr "nvim_command('e {file} | call cursor({line},{col})')"
vim.api.nvim_create_autocmd({ "DirChanged", "VimEnter" }, {
  desc = "Autocmd to start a server when cwd is in a Godot project",
  callback = function()
    local pipe = "/tmp/godot.pipe"

    vim.g.in_godot_project = false
    local proj_root = vim.fs.root(0, "project.godot")
    if proj_root == nil then
      if vim.loop.fs_stat(pipe) ~= nil and vim.list_contains(vim.fn.serverlist(), pipe) then
        vim.fn.serverstop(pipe)
        vim.notify("Closing pipe at " .. pipe, vim.log.levels.INFO)
      end
      return
    end

    vim.g.in_godot_project = true
    vim.notify("Found Godot project at " .. proj_root, vim.log.levels.INFO)

    if vim.loop.fs_stat(pipe) == nil then
      vim.fn.serverstart(pipe)
      vim.notify("Opening pipe at " .. pipe, vim.log.levels.INFO)
    end
  end,
})
