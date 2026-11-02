local M = {
  generators = {
    pandoc = require("joe.html-preview.generators.pandoc"),
  },
}
local directory = vim.fn.stdpath("run") .. "/html-preview-" .. vim.fn.getpid()
local previews = {}
local server
local closing = false

local function fail(message)
  vim.notify(message, vim.log.levels.ERROR)
end

local function open_pending()
  for _, path in ipairs(server.pending) do
    vim.ui.open(server.url .. "/" .. vim.uri_encode(path))
  end
  server.pending = {}
end

local function serve(path)
  if server then
    table.insert(server.pending, path)
    if server.url then
      open_pending()
    end
    return
  end

  local current = { pending = { path }, output = "" }
  server = current
  local function output(_, data)
    if not data then
      return
    end
    vim.schedule(function()
      if closing or server ~= current or current.url then
        return
      end
      current.output = current.output .. data
      local url = current.output:match("http://127%.0%.0%.1:%d+/")
      if url then
        current.url = url:gsub("/$", "")
        open_pending()
      end
    end)
  end

  local ok, process = pcall(vim.system, {
    "vite",
    directory,
    "--host",
    "127.0.0.1",
    "--port",
    "5173",
    "--clearScreen",
    "false",
  }, { stdout = output, stderr = output }, function(result)
    vim.schedule(function()
      if closing or server ~= current then
        return
      end
      server = nil
      fail("Vite preview server exited (" .. result.code .. "):\n" .. current.output)
    end)
  end)
  if not ok then
    server = nil
    fail("Cannot start Vite: " .. tostring(process))
    return
  end
  current.process = process
  vim.defer_fn(function()
    if not closing and server == current and not current.url then
      server = nil
      current.process:kill(15)
      fail("Vite preview server did not start:\n" .. current.output)
    end
  end, 10000)
end

local function generate(buf, state)
  if state.running then
    state.pending = true
    return
  end
  state.running = true
  local temporary = state.output .. ".tmp.html"
  local function done(success)
    if closing or previews[buf] ~= state then
      vim.fn.delete(temporary)
      return
    end
    state.running = false
    if success then
      local ok, err = vim.uv.fs_rename(temporary, state.output)
      if not ok then
        fail("Cannot publish HTML preview: " .. err)
        success = false
      end
    end
    vim.fn.delete(temporary)
    if state.pending then
      state.pending = false
      generate(buf, state)
    else
      if success and state.open then
        serve(vim.fn.fnamemodify(state.output, ":t"))
      end
      state.open = false
    end
  end
  local ok, err = pcall(state.generator, vim.api.nvim_buf_get_name(buf), temporary, done)
  if not ok then
    fail("HTML preview generation failed: " .. tostring(err))
    done(false)
  end
end

---@param generator? fun(input: string, output: string, done: fun(success: boolean))
function M.open(generator)
  if vim.fn.executable("vite") == 0 then
    fail("HTML preview requires vite in $PATH")
    return
  end
  local buf = vim.api.nvim_get_current_buf()
  local input = vim.api.nvim_buf_get_name(buf)
  if input == "" then
    fail("Cannot preview an unnamed buffer")
    return
  end
  if vim.bo[buf].modified then
    vim.cmd.write()
  end
  vim.fn.mkdir(directory .. "/sources", "p")

  if not generator then
    local source = vim.fn.fnamemodify(input, ":h")
    local relative = "sources/" .. vim.fn.sha256(source)
    local link = directory .. "/" .. relative
    if not vim.uv.fs_lstat(link) then
      local ok, err = vim.uv.fs_symlink(source, link, { dir = true })
      if not ok then
        fail("Cannot link HTML preview source: " .. err)
        return
      end
    end
    serve(relative .. "/" .. vim.fn.fnamemodify(input, ":t"))
    return
  end

  local state = previews[buf]
  if not state then
    state = { output = directory .. "/" .. buf .. ".html" }
    previews[buf] = state
    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = buf,
      callback = function()
        generate(buf, state)
      end,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
      buffer = buf,
      once = true,
      callback = function()
        previews[buf] = nil
      end,
    })
  end
  state.generator = generator
  state.open = true
  generate(buf, state)
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  once = true,
  callback = function()
    closing = true
    if server and server.process then
      server.process:kill(15)
    end
    vim.fn.delete(directory, "rf")
  end,
})

return M
