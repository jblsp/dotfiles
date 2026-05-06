local bufdelete = require("joe.bufdelete")
local clipboard = require("joe.clipboard")
local extui = require("vim._core.ui2")
local plugins = require("joe.plugins")
local sudowrite = require("joe.sudowrite")
local util = require("joe.util")

local g = vim.g
local k = vim.keycode
local lsp = vim.lsp
local set = vim.keymap.set
local o = vim.o

-- Globals
g.colors_name = "tokyonight"
g.mapleader = k("<space>")
g.maplocalleader = k("\\")

-- Options
o.confirm = true -- Confirm to save changes when exiting modified buffer
o.cursorline = true -- Highlight current line
o.cursorlineopt = "number" -- Only highlight number of current line
o.foldlevel = 99
o.ignorecase = true -- Case-insensitive searching
o.linebreak = true
o.mouse = "a"
o.mousemodel = "extend"
o.number = true -- Line numbers
o.relativenumber = true
o.scrolloff = 8
o.signcolumn = "yes" -- Always enable sign column
o.smartcase = true -- Case sensitive searching if \C or one or more capital letters in search
o.smartindent = true
o.smoothscroll = true -- scroll by screen line rather than by text line when 'wrap' is set
o.spelllang = "en"
o.undofile = true -- Save undo history for files
o.undolevels = 2500
o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
o.wrap = false

-- LSP
lsp.enable({
  "bashls",
  "clangd",
  "cssls",
  "gdscript",
  "gopls",
  "html",
  "jdtls",
  "json",
  "jsonls",
  "lua_ls",
  "phpactor",
  "pyright",
  "tinymist",
  "tombi",
  "ts_ls",
  "yamlls",
})
lsp.config("*", {
  root_markers = { ".git" },
})
lsp.config("jdtls", {
  settings = {
    java = {
      saveActions = { organizeImports = true },
    },
  },
})

-- extui
extui.enable({})

-- Optional built-in plugins
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.difftool")
vim.cmd.packadd("nvim.tohtml")

-- Commands:
vim.api.nvim_create_user_command("Sudowrite", sudowrite.write, { desc = "Write buffer as sudo" })

vim.api.nvim_create_user_command("PackUpdate", function(args)
  if args.args == "" then
    vim.pack.update()
  else
    vim.pack.update(vim.split(args.args, " "))
  end
end, { desc = "Update vim.pack plugin(s)" })

vim.api.nvim_create_user_command("PackList", function()
  vim.pack.update(nil, { offline = true })
end, { desc = "List installed vim.pack plugins" })

vim.api.nvim_create_user_command("PackSync", function(args)
  if args.args == "" then
    vim.pack.update(nil, { target = "lockfile" })
  else
    vim.pack.update(vim.split(args.args, " "), { target = "lockfile" })
  end
end, { desc = "Sync vim.pack plugins to lockfile" })

vim.api.nvim_create_user_command("PackClean", function()
  local inactive = vim
    .iter(vim.pack.get())
    :filter(function(x)
      return not x.active
    end)
    :map(function(x)
      return x.spec.name
    end)
    :totable()

  vim.pack.del(inactive)
end, { desc = "Delete inactive vim.pack plugins" })

-- Keymaps:

-- escape removes search highlights, and stops snippets
set("n", "<Esc>", function()
  vim.cmd("noh")
  vim.snippet.stop()
  return "<esc>"
end)

-- buffers
set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
set("n", "<leader>bl", "<cmd>b#<cr>", { desc = "Last buffer" })
set("n", "<leader>bD", "<cmd>bd<cr>", { desc = "Delete buffer and close window" })
set("n", "<leader>bW", "<cmd>bw<cr>", { desc = "Wipeout buffer and close window" })
set("n", "<leader>bd", bufdelete.delete, { desc = "Delete buffer" })
set("n", "<leader>bw", function()
  bufdelete.delete({ wipe = true })
end, { desc = "Wipeout buffer" })
set("n", "<leader>bo", bufdelete.other, { desc = "Delete all other buffers" })
set("n", "<leader>bO", function()
  bufdelete.other({ wipe = true })
end, { desc = "Wipeout all other buffers" })
set("n", "<leader>br", "<cmd>e!<cr>", { desc = "Reload buffer" })

-- tabs
set("n", "[t", "<cmd>tabprev<cr>", { desc = "Previous tab" })
set("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab" })
set("n", "<leader>td", "<cmd>tabclose<cr>", { desc = "Close tab" })
set("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
set("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })

-- Clipboard
set("n", "<leader>cc", function()
  clipboard.copy(vim.fn.getreg('"'))
end, { desc = 'Copy anon register (") to system clipboard' })
set({ "n", "x" }, "<leader>cy", '"+y', { desc = "Yank to system clipboard" })
set("n", "<leader>cf", function()
  clipboard.copy(vim.fn.expand("%"))
end, { desc = "Copy filepath to system clipboard" })

-- Comments
set("n", "gcn", "yygccp", { remap = true, desc = "Duplicate line and comment out original" })
set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment below" })
set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment above" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Open explorer
set("n", "<leader>e", function()
  local ok, oil = pcall(require, "oil")
  if ok then
    oil.open()
    return
  end
  vim.cmd.edit(".")
end, { desc = "Explore directory of current buffer", silent = true })
set("n", "<leader>E", "<cmd>e .<cr>", { desc = "Explore current working directory" })

-- Quickfix List
set("n", "<leader>qd", function()
  if #vim.diagnostic.count() == 0 and not util.qf_window_open() then
    vim.notify("No diagnostics to report", vim.log.levels.INFO)
  end
  vim.diagnostic.setqflist({ open = true })
end, { desc = "Open workspace diagnostics in quickfix list" })

-- Undotree
set("n", "<leader>u", "<cmd>Undotree<cr>", { desc = "Toggle Undotree" })

-- Load Plugins
plugins.setup({
  "gh:typicode/bg.nvim",
  "gh:rafamadriz/friendly-snippets",
  "gh:tpope/vim-endwise",
  "gh:folke/tokyonight.nvim",
  "gh:alker0/chezmoi.vim",
  {
    src = "gh:neovim/nvim-lspconfig",
    version = vim.version.range("*"),
  },
  {
    src = "gh:saghen/blink.cmp",
    version = vim.version.range("1.*"),
    config = function()
      require("blink.cmp").setup({
        completion = {
          menu = { draw = { treesitter = { "lsp" } } },
        },
        cmdline = {
          keymap = {
            ["<Tab>"] = { "show", "accept" },
          },
          completion = { menu = { auto_show = true } },
        },
      })
    end,
  },
  {
    src = "gh:ibhagwan/fzf-lua",
    config = function()
      local fzf = require("fzf-lua")

      local map = util.mapper("fzf")

      map("<leader>sh", fzf.help_tags, "Search help")
      map("<leader>sk", fzf.keymaps, "Search keymaps")
      map("<leader>sf", fzf.files, "Search files")
      map("<leader>sF", function()
        fzf.files({
          prompt = "Dirs> ",
          previewer = vim.NIL,
          cmd = "fd --color=never --type d --hidden --follow --exclude .git",
        })
      end, "Search directories")
      map("<leader>sn", function()
        fzf.files({ cwd = vim.fn.stdpath("config") })
      end, "Search config files")
      map("<leader>sw", fzf.grep_cword, "Grep current word")
      map("<leader>sg", fzf.live_grep, "Grep cwd")
      map("<leader>bs", fzf.buffers, "Search buffers")
      map("<leader>/", fzf.blines, "Fuzzily search buffer")
      map("<leader>sc", fzf.colorschemes, "Search colorschemes")
      map("<leader>sC", fzf.awesome_colorschemes, "Search online colorschemes")
      map("z=", fzf.spell_suggest, "Spelling suggestions")
      map("<leader>:", fzf.command_history, "Command history")
      map("<leader>sd", fzf.diagnostics_document, "Search document diagnostics")
      map("<leader>sD", fzf.diagnostics_workspace, "Search workspace diagnostics")
      map("<leader>sr", fzf.resume, "Resume search")
      map("<leader>sp", "<cmd>FzfLua<cr>", "Search builtin pickers")
      map("<leader>so", fzf.nvim_options, "Search options")
      map("<leader>gra", fzf.lsp_code_actions, "Search options")

      -- LSP mappings
      map("g0", fzf.lsp_document_symbols, "View document symbols")
      map("gW", fzf.lsp_workspace_symbols, "View workspace symbols")

      fzf.register_ui_select(function(_, items)
        local min_h, max_h = 0.15, 0.70
        local h = (#items + 4) / vim.o.lines
        if h < min_h then
          h = min_h
        elseif h > max_h then
          h = max_h
        end
        return { winopts = { height = h, width = 0.65, row = 0.40 } }
      end)

      fzf.setup({
        { "borderless_full", "hide" },
        blines = { "ivy" },
        colorschemes = {
          winopts = { width = 0.35 },
        },
        awesome_colorschemes = {
          winopts = { col = 0.5, width = 0.58, row = 0.40, height = 0.5 },
        },
      })
    end,
  },
  {
    src = "gh:mason-org/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "●",
            package_uninstalled = "○",
          },
        },
      })

      local mason_api = require("mason.api.command")
      local mason_registry = require("mason-registry")

      local ensure_installed = {
        "bash-language-server",
        "black",
        "clang-format",
        "css-lsp",
        "gdscript-formatter",
        "gopls",
        "html-lsp",
        "isort",
        "jdtls",
        "json-lsp",
        "lua-language-server",
        "marksman",
        "prettier",
        "pyright",
        "shfmt",
        "stylua",
        "tinymist",
        "tombi",
        "typescript-language-server",
        "yaml-language-server",
      }

      vim.schedule(function()
        local pkg_set = {}
        for _, pkg in ipairs(mason_registry.get_installed_package_names()) do
          pkg_set[pkg] = true
        end

        local to_install = vim.tbl_filter(function(pkg)
          return not pkg_set[pkg]
        end, ensure_installed)

        if #to_install ~= 0 then
          mason_api.MasonInstall(to_install)
        end
      end)
    end,
  },
  {
    src = "gh:stevearc/oil.nvim",
    deps = {
      {
        src = "gh:nvim-mini/mini.icons",
        config = function()
          require("mini.icons").setup()
        end,
      },
    },
    config = function()
      require("oil").setup({
        default_file_explorer = true,
        keymaps = {
          ["<esc>"] = {
            "actions.close",
            mode = "n",
          },
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name, _)
            if vim.tbl_contains({ ".DS_Store" }, name) then
              return true
            end
            if vim.g.in_godot_project then
              if vim.endswith(name, ".uid") then
                return true
              end
            end
          end,
        },
      })
    end,
  },
  {
    src = "gh:stevearc/conform.nvim",
    config = function()
      local conform = require("conform")

      local map = vim.keymap.set

      vim.o.formatexpr = [[v:lua.require'conform'.formatexpr()]]

      map("n", "<leader>f", function()
        conform.format()
        vim.cmd.w()
      end, { desc = "Format and write buffer" })
      map("n", "<leader>F", conform.format, { desc = "Format buffer" })

      -- manually set filetype for some filetypes on shfmt
      conform.formatters.shfmt = {
        append_args = function(self, ctx)
          local lang = "auto"
          if vim.bo[ctx.buf].filetype == "bash" then
            lang = "bash"
          elseif vim.bo[ctx.buf].filetype == "zsh" then
            lang = "zsh"
          end
          return { "-ln", lang }
        end,
      }

      conform.setup({
        notify_on_error = true,
        notify_no_formatters = true,
        default_format_opts = {
          lsp_format = "never",
          async = true,
        },
        formatters_by_ft = {
          sh = { "shfmt" },
          bash = { "shfmt" },
          c = { "clang-format" },
          cpp = { "clang-format" },
          cs = { lsp_format = "fallback" },
          css = { "prettier" },
          gdscript = { "gdscript-formatter" },
          go = { "gofmt" },
          html = { "prettier" },
          java = { lsp_format = "fallback" },
          javascript = { "prettier" },
          javascriptreact = { "prettier" },
          json = { "prettier" },
          jsonc = { lsp_format = "fallback" },
          lua = { "stylua" },
          markdown = { "prettier" },
          -- nix = { "alejandra" },
          -- php = { "php_cs_fixer" },
          python = { "black", "isort" },
          toml = { "tombi" },
          typescript = { "prettier" },
          yaml = { "prettier" },
          zsh = { "shfmt" },
        },
      })
    end,
  },
  {
    src = "gh:nvim-mini/mini.ai",
    version = vim.version.range("*"),
    config = function()
      require("mini.ai").setup({
        n_lines = 500,
      })
    end,
  },
  {
    src = "gh:nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        multiwindow = true,
        line_numbers = true,
        max_lines = 4,
      })
    end,
  },
  {
    src = "cb:mfussenegger/nvim-dap",
    deps = {
      { src = "gh:igorlfs/nvim-dap-view" },
      { src = "gh:mfussenegger/nvim-dap-python" },
    },
  },
  {
    src = "gh:j-hui/fidget.nvim",
    version = vim.version.range("*"),
    config = function()
      local fidget = require("fidget")
      local notification = require("fidget.notification")

      fidget.setup({
        progress = {
          display = {
            done_icon = "󰸞",
            done_ttl = 5,
          },
        },
        notification = {
          override_vim_notify = true,
          window = {
            winblend = 45,
            -- y_padding = 1,
          },
          configs = {
            default = (function()
              local notif_config = notification.default_config

              -- Remove title from notifications
              notif_config.name = nil
              notif_config.icon = nil

              return vim.tbl_extend("force", notif_config, { ttl = 7.5 })
            end)(),
          },
        },
      })
    end,
  },
  {
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
  },
  {
    src = "gh:saghen/blink.indent",
    version = vim.version.range("2.*"),
    config = function()
      require("blink.indent").setup({
        blocked = {
          filetypes = { include_defaults = true, "markdown", "text" },
        },
      })
    end,
  },
  {
    src = "cb:mfussenegger/nvim-jdtls",
    config = function()
      local jdtls = require("jdtls")

      vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*.java",
        group = vim.api.nvim_create_augroup("jdtls-config", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- Only proceed if the attached LSP is jdtls
          if client == nil or client.name ~= "jdtls" then
            return
          end

          local map = util.mapper("jdtls", ev.buf)

          map("<localleader>ev", jdtls.extract_variable, "Extract Variable")
          map("<localleader>ec", jdtls.extract_constant, "Extract Constant")
          map("<localleader>em", jdtls.extract_method, "Extract Method")
          map("<localleader>o", jdtls.organize_imports, "Organize imports")
        end,
      })
    end,
  },
  {
    src = "gh:nvim-mini/mini.move",
    version = vim.version.range("*"),
    config = function()
      require("mini.move").setup()
    end,
  },
  {
    src = "gh:nvim-treesitter/nvim-treesitter",
    before = function()
      vim.api.nvim_create_autocmd("PackChanged", {
        callback = function(ev)
          local name, kind = ev.data.spec.name, ev.data.kind
          if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then
              vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
          end
        end,
      })
    end,
    config = function()
      local treesitter = require("nvim-treesitter")

      local all_parsers = treesitter.get_available()

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match)
          local parsers = treesitter.get_installed()
          if not vim.list_contains(parsers, lang) and vim.list_contains(all_parsers, lang) then
            if vim.list_contains(all_parsers, lang) then
              -- :wait makes it synchronous so the autocmd in plugin/treesitter.lua runs after the parser is installed
              treesitter.install(lang):wait(1000 * 60 * 5)
            end
          end
          if lang ~= nil and vim.treesitter.query.get(lang, "indents") then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  -- {
  --   src = "gh:nickjvandyke/opencode.nvim",
  --   version = vim.version.range("*"),
  --   config = function()
  --     local opencode = require("opencode")
  --
  --     vim.g.opencode_opts = {
  --       lsp = {
  --         enabled = true,
  --         handlers = {
  --           hover = {
  --             enabled = false,
  --           },
  --         },
  --       },
  --     }
  --
  --     local map = util.mapper("Opencode")
  --
  --     map("<leader>oa", function()
  --       opencode.ask("", { submit = true })
  --     end, "Ask")
  --     map("<leader>ot", function()
  --       opencode.toggle()
  --     end, "Toggle")
  --     map("<leader>or", function()
  --       return opencode.operator("@this ")
  --     end, "Add range", { mode = { "n", "x" }, expr = true })
  --     map("<leader>ol", function()
  --       return opencode.operator("@this ") .. "_"
  --     end, "Add line", { expr = true })
  --     map("<leader>o<tab>", function()
  --       opencode.command("agent.cycle")
  --     end, "Cycle agent")
  --     map("<leader>u<tab>", function()
  --       opencode.command("session.undo")
  --     end, "Undo last action")
  --     map("<leader>U<tab>", function()
  --       opencode.command("session.redo")
  --     end, "Redo last undone action")
  --     map("<leader>os", function()
  --       opencode.command("session.select")
  --     end, "Select session")
  --     map("<leader>on", function()
  --       opencode.command("session.new")
  --     end, "New session")
  --     map("<leader>oi", function()
  --       opencode.command("session.interrupt")
  --     end, "Interrupt current session")
  --   end,
  -- },
  {
    src = "gh:stevearc/quicker.nvim",
    config = function()
      require("quicker").setup()
    end,
  },
  {
    src = "gh:nvim-mini/mini.splitjoin",
    version = vim.version.range("*"),
    config = function()
      require("mini.splitjoin").setup()
    end,
  },
  {
    src = "gh:nvim-mini/mini.surround",
    version = vim.version.range("*"),
    config = function()
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      })
    end,
  },
  {
    src = "gh:chomosuke/typst-preview.nvim",
    version = vim.version.range("1.*"),
    config = function()
      require("typst-preview").setup()

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typst" },
        group = vim.api.nvim_create_augroup("typst-preview-maps", { clear = true }),
        callback = function(ev)
          local map = util.mapper("typst-preview", ev.buf)

          map("<localleader>p", "<cmd>TypstPreviewToggle<cr>", "Preview current file")
        end,
      })
    end,
  },
  {
    src = "gh:jannis-baum/vivify.vim",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown" },
        group = vim.api.nvim_create_augroup("vivify-maps", { clear = true }),
        callback = function(ev)
          local map = util.mapper("Vivify", ev.buf)
          map("<localleader>p", "<cmd>Vivify<cr>", "Preview buffer")
        end,
      })
    end,
  },
  {
    src = "gh:windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
})
