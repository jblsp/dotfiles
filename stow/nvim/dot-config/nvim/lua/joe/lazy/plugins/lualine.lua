return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  dependencies = { "echasnovski/mini.icons" },
  config = function(_, opts)
    require("mini.icons").mock_nvim_web_devicons()
    require("lualine").setup(opts)
    vim.o.showmode = false
  end,
  opts = {
    options = {
      component_separators = "",
      section_separators = "",
      refresh = {
        statusline = 35,
        winbar = 35,
        tabline = 35,
      },
    },
    sections = {
      lualine_a = {
        "mode",
      },
      lualine_b = {},
      lualine_c = {
        "filename",
        {
          "diagnostics",
          cond = function()
            return vim.diagnostic.is_enabled()
          end,
        },
      },
      lualine_x = {
        "filetype",
        {
          "encoding",
          fmt = function(s)
            return string.upper(s)
          end,
        },
        {
          "fileformat",
          symbols = {
            unix = "LF",
            dos = "CRLF",
            mac = "CR",
          },
        },
        {
          "location",
          fmt = function(s)
            return string.gsub(s, "%s+", "")
          end,
        },
      },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {
      lualine_a = { { "tabs", symbols = { modified = "" } } },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {
        function()
          return vim.uv.cwd()
        end,
        "branch",
      },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
