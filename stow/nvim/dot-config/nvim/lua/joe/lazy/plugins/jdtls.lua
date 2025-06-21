return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  config = function()
    local jdtls = require("jdtls")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      group = vim.api.nvim_create_augroup("jdtls", { clear = true }),
      callback = function()
        local root_dir =
          vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "settings.gradle", "settings.gradle.ks" })

        local proj_args
        if root_dir then
          local proj_cache_path = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fs.basename(root_dir)
          proj_args = {
            "-configuration",
            proj_cache_path .. "/config",
            "-data",
            proj_cache_path .. "/data",
          }
        end

        jdtls.start_or_attach({
          cmd = vim.list_extend({ vim.fn.exepath("jdtls") }, proj_args or {}),

          settings = {
            java = {
              saveActions = { organizeImports = true },
            },
          },

          root_dir = root_dir,

          on_attach = function(_, bufnr)
            local function map(lhs, rhs, desc, opts)
              opts = opts or {}
              local mode = opts.mode
              opts.buffer = bufnr
              opts.desc = "jdtls: " .. desc
              opts.mode = nil
              vim.keymap.set(mode or "n", lhs, rhs, opts)
            end

            map("<localleader>ev", jdtls.extract_variable, "Extract Variable")
            map("<localleader>ec", jdtls.extract_constant, "Extract Constant")
            map("<localleader>em", jdtls.extract_method, "Extract Method")
            map("<localleader>o", jdtls.organize_imports, "Organize imports")
          end,
        })
      end,
    })
  end,
}
