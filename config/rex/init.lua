local terminal = "com.superlogical.terminal"

local function pane_cwd(ctx)
  if not ctx.block_id then return end
  local process = rex.block.call(terminal, "process", { block_id = ctx.block_id })
  if process then
    return (process.foreground or {}).cwd or (process.child or {}).cwd
  end
end

rex.action{
  name = "lazygit_popup",
  title = "Open Lazygit Popup",
  run = function(ctx)
    return assert(rex.session.new_layer{
      bounds = { 0.01, 0.025, 0.98, 0.95 },
      focus = true,
      layout = rex.layout.block{
        flavor = terminal .. ".shell",
        options = { command = { "lazygit" }, cwd = pane_cwd(ctx), interactive = true },
      },
    })
  end,
}

rex.bind("shift+cmd+l", "lazygit_popup")
