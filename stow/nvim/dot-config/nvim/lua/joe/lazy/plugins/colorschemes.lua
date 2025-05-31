---@class Colorscheme.Spec
---@field name? string
---@field opts? table
---@field config? function
---@field setup? boolean

local function get_name(url)
  local name = url

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
    return url:gsub("%W+", "_")
  end
end

---@param short_url string
---@param clrs_spec? Colorscheme.Spec
local function make_spec(short_url, clrs_spec)
  clrs_spec = clrs_spec or {}

  if not clrs_spec.name then
    clrs_spec["name"] = get_name(short_url)
  end

  local lazy_spec = {
    [1] = short_url,
    main = clrs_spec.name,
    name = clrs_spec.name,
    lazy = true,
    opts = clrs_spec.opts or clrs_spec.setup ~= false and {},
  }

  return lazy_spec
end

return {
  make_spec("EdenEast/nightfox.nvim"),
  make_spec("Shatur/neovim-ayu", { name = "ayu" }),
  make_spec("catppuccin/nvim"),
  make_spec("folke/tokyonight.nvim"),
  make_spec("rebelot/kanagawa.nvim"),
  make_spec("rose-pine/neovim"),
  make_spec("sainnhe/everforest", { setup = false }),
  make_spec("sainnhe/gruvbox-material", { setup = false }),
  make_spec("sainnhe/sonokai", { setup = false }),
  make_spec("vague2k/vague.nvim"),
  make_spec("bluz71/vim-moonfly-colors", { setup = false }),
  make_spec("bluz71/vim-nightfly-colors", { setup = false }),
  make_spec("cdmill/neomodern.nvim"),
}
