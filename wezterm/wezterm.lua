local wezterm = require("wezterm")
local config = wezterm.config_builder()

wezterm.on("update-right-status", function(window, pane)
  local cwd = ""
  local hostname = ""
  local home = os.getenv("HOME")
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    if type(cwd_uri) == "userdata" then
      cwd = string.gsub(cwd_uri.file_path, home, "~", 1)
      hostname = cwd_uri.host or wezterm.hostname()
    end

    local dot = hostname:find("[.]")
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == "" then
      hostname = wezterm.hostname()
    end
  end

  local workspace = wezterm.mux.get_active_workspace()
  workspace = string.match(workspace, "[^/\\]+$")
  wezterm.log_info("workspace: " .. workspace)

  wezterm.log_info(wezterm.hostname())

  window:set_right_status(wezterm.format({
    { Background = { Color = "#2C363C" } },
    { Foreground = { Color = "#F0EDEC" } },
    { Text = "    " .. cwd .. " " },

    { Background = { Color = "#2C363C" } },
    { Foreground = { Color = "#F0EDEC" } },
    { Text = "    " .. workspace .. " " },
  }))
end)

wezterm.on("window-config-reloaded", function(window, pane)
  -- window:toast_notification("wezterm", "configuration reloaded!", nil, 4000)
end)

config.window_padding = {
  left = "1cell",
  right = "1cell",
  top = "0.5cell",
  bottom = "0.5cell",
}
config.adjust_window_size_when_changing_font_size = false

config.color_scheme = "zenwritten_light"
config.font = wezterm.font_with_fallback({ "Maple Mono NF", "JetBrains Mono", "Fira Code" })
config.line_height = 1.15
config.font_size = 14

-- config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = false
config.tab_max_width = 20
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1500 }

local act = wezterm.action

config.keys = {
  -- pane split
  {
    key = "s",
    mods = "LEADER",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "v",
    mods = "LEADER",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "Enter",
    mods = "LEADER",
    action = act.TogglePaneZoomState,
  },
  {
    key = "h",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "l",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Right"),
  },
  {
    key = "k",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Up"),
  },
  {
    key = "j",
    mods = "LEADER",
    action = act.ActivatePaneDirection("Down"),
  },
  -- pane move
  {
    key = "S",
    mods = "LEADER",
    action = act.PaneSelect({ mode = "SwapWithActive" }),
  },
  -- pane resize
  {
    key = "H",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Left", 5 }),
  },
  {
    key = "J",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Down", 5 }),
  },
  {
    key = "K",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Up", 5 }),
  },
  {
    key = "L",
    mods = "ALT",
    action = act.AdjustPaneSize({ "Right", 5 }),
  },
  -- close pane
  {
    key = "q",
    mods = "LEADER",
    action = act.CloseCurrentPane({ confirm = true }),
  },
  -- reload configuration
  {
    key = "R",
    mods = "LEADER",
    action = act.ReloadConfiguration,
  },
  -- tab
  {
    key = "r",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Rename tab",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  {
    key = "t",
    mods = "LEADER",
    action = act.SpawnCommandInNewTab({
      cwd = wezterm.home_dir,
    }),
  },
  {
    key = "}",
    mods = "LEADER",
    action = act.MoveTabRelative(1),
  },
  {
    key = "{",
    mods = "LEADER",
    action = act.MoveTabRelative(-1),
  },
  {
    key = "]",
    mods = "LEADER",
    action = act.ActivateTabRelative(1),
  },
  {
    key = "[",
    mods = "LEADER",
    action = act.ActivateTabRelative(-1),
  },
  {
    key = "Q",
    mods = "LEADER",
    action = act.CloseCurrentTab({ confirm = true }),
  },
  {
    key = "T",
    mods = "LEADER",
    action = act.ShowTabNavigator,
  },
  {
    key = "`",
    mods = "LEADER",
    action = wezterm.action.ActivateLastTab,
  },
  -- move cursor by word
  {
    key = "LeftArrow",
    mods = "OPT",
    action = act.SendKey { key = 'b', mods = 'ALT' },
  },
  {
    key = "RightArrow",
    mods = "OPT",
    action = act.SendKey { key = 'f', mods = 'ALT' },
  },
  -- workspace
  {
    key = "W",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Enter name for new workspace",
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace({
              name = line,
            }),
            pane
          )
        end
      end),
    }),
  },
  {
    key = ",",
    mods = "LEADER",
    action = act.PromptInputLine({
      description = "Rename current workspace",
      action = wezterm.action_callback(function(window, panel, line)
        local old = window:active_workspace()
        wezterm.mux.rename_workspace(old, line)
        window:toast_notification("rename workspace from " .. old, " to " .. line, nil, 4000)
        wezterm.emit("format-window-title", window, panel)
      end),
    }),
  },
  {
    key = "w",
    mods = "LEADER",
    action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
  },
  -- debug
  {
    key = "D",
    mods = "LEADER",
    action = wezterm.action.ShowDebugOverlay,
  },
  {
    key = "y",
    mods = "LEADER",
    action = wezterm.action.ActivateCopyMode,
  },
  -- window
  {
    key = "n",
    mods = "LEADER",
    action = wezterm.action.SpawnWindow,
  },
  {
    key = "p",
    mods = "LEADER",
    action = act.PasteFrom 'Clipboard'
  }
}

for i = 1, 9 do
  -- LEADER + number to activate that tab
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1),
  })
end

wezterm.on("format-window-title", function()
  return wezterm.mux.get_active_workspace()
end)

return config
