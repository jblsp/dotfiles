return function(format)
  return function(input, output, done)
    if vim.fn.executable("pandoc") == 0 then
      vim.notify("HTML preview requires pandoc in $PATH", vim.log.levels.ERROR)
      done(false)
      return
    end
    vim.system({
      "pandoc",
      input,
      "-f",
      format,
      "-s",
      "--embed-resources",
      "--resource-path=" .. vim.fn.fnamemodify(input, ":h"),
      "-o",
      output,
    }, { text = true }, function(result)
      vim.schedule(function()
        if result.code ~= 0 then
          vim.notify("Pandoc failed:\n" .. (result.stderr or ""), vim.log.levels.ERROR)
        end
        done(result.code == 0)
      end)
    end)
  end
end
