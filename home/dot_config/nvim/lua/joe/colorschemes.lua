local M = {}

local specs = {
  { "EdenEast/nightfox.nvim" },
  { "Shatur/neovim-ayu", { name = "ayu" } },
  { "catppuccin/nvim" },
  { "folke/tokyonight.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "rose-pine/neovim" },
  { "sainnhe/everforest", { setup = false } },
  { "sainnhe/gruvbox-material", { setup = false } },
  { "sainnhe/sonokai", { setup = false } },
  { "vague2k/vague.nvim" },
  { "bluz71/vim-moonfly-colors", { setup = false } },
  { "bluz71/vim-nightfly-colors", { setup = false } },
  { "cdmill/neomodern.nvim" },
}

---@param short_url string
---@return string
local function infer_name(short_url)
  local name = short_url

  name = name:sub(-4) == ".git" and name:sub(1, -5) or name
  name = name:sub(-5) == ".nvim" and name:sub(1, -6) or name

  local slash = name:reverse():find("/", 1, true)

  if slash then
    local repo_name = name:sub(#name - slash + 2)

    -- if the repo name is in this list, then take the org name instead
    local org_names = { "nvim", "neovim" }
    if vim.tbl_contains(org_names, repo_name) then
      return name:sub(1, #name - slash)
    else
      return repo_name
    end
  else
    return short_url:gsub("%W+", "_")[1]
  end
end

---@param short_url string
---@return string
local function get_url(short_url)
  if not vim.startswith(short_url, "http") then
    return "https://github.com/" .. short_url .. ".git"
  end
  return short_url
end

---@param clrs_spec? joe.colorschemes.Spec
---@return LazySpec
local function make_lazy_spec(clrs_spec)
  clrs_spec = clrs_spec or {}

  local name = clrs_spec.name or infer_name(clrs_spec[1])

  local lazy_spec = {
    url = get_url(clrs_spec[1]),
    main = name,
    name = name,
    lazy = true,
    opts = clrs_spec.opts or clrs_spec.setup ~= false and {},
  }

  return lazy_spec
end

function M.get_lazy_specs()
  return vim.iter(specs):map(make_lazy_spec):totable()
end

return M
