local M = {}
local uv = vim.uv
local generated_previews = {}
local vite_server
local preview_dir = vim.fn.stdpath("run") .. "/html-preview-" .. vim.fn.getpid()

local function open_file(path)
  vim.notify("Vite not found in PATH. Opening preview directly: " .. path)
  vim.ui.open(path)
end

local function ensure_preview_dir()
  if vim.fn.isdirectory(preview_dir) == 0 and vim.fn.mkdir(preview_dir, "p") == 0 then
    vim.notify("Cannot create HTML preview runtime directory: " .. preview_dir, vim.log.levels.ERROR)
    return false
  end
  return true
end

local function preview_path(path)
  local absolute = vim.fn.fnamemodify(path, ":p")
  local cache_prefix = preview_dir .. "/"
  if absolute:sub(1, #cache_prefix) == cache_prefix then
    return absolute:sub(#cache_prefix + 1)
  end

  if not ensure_preview_dir() then
    return
  end

  local sources_dir = preview_dir .. "/sources"
  if vim.fn.isdirectory(sources_dir) == 0 and vim.fn.mkdir(sources_dir, "p") == 0 then
    vim.notify("Cannot create HTML preview source directory: " .. sources_dir, vim.log.levels.ERROR)
    return
  end

  local source_dir = vim.fn.fnamemodify(absolute, ":h")
  local link = sources_dir .. "/" .. vim.fn.sha256(source_dir)
  local stat = uv.fs_lstat(link)
  if not stat then
    local ok, err = uv.fs_symlink(source_dir, link, { dir = true })
    if not ok then
      vim.notify("Cannot link HTML preview source directory: " .. err, vim.log.levels.ERROR)
      return
    end
  elseif stat.type ~= "link" then
    vim.notify("HTML preview source path is not a symlink: " .. link, vim.log.levels.ERROR)
    return
  end

  return "sources/" .. vim.fn.sha256(source_dir) .. "/" .. vim.fn.fnamemodify(absolute, ":t")
end

local function preview_url(server, path)
  return server.url .. "/" .. vim.uri_encode(path)
end

local function open_pending(server)
  for _, preview in ipairs(server.pending) do
    vim.ui.open(preview_url(server, preview.path))
  end
  server.pending = {}
end

local function stop_vite_server()
  if vite_server and vite_server.process and not vite_server.process:is_closing() then
    vite_server.stopping = true
    vite_server.process:kill("sigterm")
  end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  once = true,
  callback = function()
    stop_vite_server()
    vim.fn.delete(preview_dir, "rf")
  end,
})

local function start_vite(path, fallback)
  local server = { pending = { { path = path, fallback = fallback } } }
  local stdout = uv.new_pipe(false)
  local stderr = uv.new_pipe(false)
  local server_output = ""
  local handle

  local function on_output(_, data)
    if not data then
      return
    end

    vim.schedule(function()
      server_output = server_output .. data
      local url = server_output:match("http://[^%s]+")
      if url and not server.url then
        server.url = url:gsub("/$", "")
        vim.notify("Vite preview server started: " .. server.url)
        open_pending(server)
      end
    end)
  end

  handle = uv.spawn("vite", {
    args = { preview_dir, "--host", "127.0.0.1", "--port", "5173" },
    stdio = { nil, stdout, stderr },
  }, function(code)
    vim.schedule(function()
      if vite_server == server then
        vite_server = nil
        if not server.stopping then
          for _, pending in ipairs(server.pending) do
            open_file(pending.fallback)
          end
          if code ~= 0 then
            vim.notify("Vite server exited; using file preview", vim.log.levels.WARN)
          end
        end
      end
      if not stdout:is_closing() then
        stdout:close()
      end
      if not stderr:is_closing() then
        stderr:close()
      end
      if not handle:is_closing() then
        handle:close()
      end
    end)
  end)

  if not handle then
    stdout:close()
    stderr:close()
    open_file(fallback)
    return
  end

  server.process = handle
  vite_server = server
  stdout:read_start(on_output)
  stderr:read_start(on_output)

end

local function open_preview(path)
  if vim.fn.executable("vite") == 0 then
    open_file(path)
    return
  end

  local server_path = preview_path(path)
  if not server_path then
    open_file(path)
    return
  end

  local server = vite_server
  if not server then
    start_vite(server_path, path)
  elseif server.url then
    vim.ui.open(preview_url(server, server_path))
  else
    table.insert(server.pending, { path = server_path, fallback = path })
  end
end

local function input_path(buf)
  local input = vim.api.nvim_buf_get_name(buf)
  if input == "" then
    vim.notify("Cannot preview unnamed buffer: no input file path", vim.log.levels.ERROR)
    return
  end
  return input
end

local function generated_output_path(buf)
  local input = input_path(buf)
  if not input then
    return
  end

  if not ensure_preview_dir() then
    return
  end

  return preview_dir .. "/" .. vim.fn.sha256(input) .. ".html"
end

local function generate_preview(buf, should_open)
  local state = generated_previews[buf]
  if not state then
    return
  end

  state.open_when_done = state.open_when_done or should_open
  if state.running then
    state.pending = true
    return
  end

  local output = generated_output_path(buf)
  if not output then
    state.open_when_done = false
    return
  end

  state.running = true
  state.generator(output, function(success)
    if generated_previews[buf] ~= state then
      return
    end

    state.running = false
    if state.pending then
      state.pending = false
      local should_open_next = state.open_when_done
      state.open_when_done = false
      generate_preview(buf, should_open_next)
      return
    end

    local should_open_now = state.open_when_done
    state.open_when_done = false
    if success ~= false and should_open_now then
      open_preview(output)
    end
  end)
end

function M.open()
  local buf = vim.api.nvim_get_current_buf()
  local input = input_path(buf)
  if not input then
    return
  end

  if vim.bo[buf].modified then
    vim.cmd.write()
  end

  open_preview(input)
end

function M.pandoc_generator(input_format)
  local buf = vim.api.nvim_get_current_buf()

  return function(output, done)
    if vim.fn.executable("pandoc") == 0 then
      vim.notify("Pandoc executable not found in $PATH", vim.log.levels.ERROR)
      done(false)
      return
    end

    local input = vim.api.nvim_buf_get_name(buf)
    if input == "" then
      vim.notify("Pandoc cannot convert unnamed buffer: no input file path", vim.log.levels.ERROR)
      done(false)
      return
    end

    vim.system({
      "pandoc",
      input,
      "-f",
      input_format,
      "-s",
      "--embed-resources",
      "--resource-path=" .. vim.fn.fnamemodify(input, ":h"),
      "-o",
      output,
    }, { text = true }, function(result)
      vim.schedule(function()
        if result.code ~= 0 then
          vim.notify("Pandoc failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
          done(false)
          return
        end

        done(true)
      end)
    end)
  end
end

---@param generator fun(output: string, done: fun())
function M.open_generated(generator)
  local buf = vim.api.nvim_get_current_buf()
  if not input_path(buf) then
    return
  end

  local state = generated_previews[buf]

  if not state then
    state = { generator = generator, open_after_save = false, open_when_done = false }
    generated_previews[buf] = state

    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = buf,
      callback = function()
        local should_open = state.open_after_save
        state.open_after_save = false
        generate_preview(buf, should_open)
      end,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
      buffer = buf,
      callback = function()
        generated_previews[buf] = nil
      end,
    })
  else
    state.generator = generator
  end

  if vim.bo[buf].modified then
    state.open_after_save = true
    local ok, err = pcall(vim.cmd.write)
    if not ok then
      state.open_after_save = false
      error(err)
    end
    return
  end

  generate_preview(buf, true)
end

return M
