-- =============================================================================
-- ~/.config/wezterm/wezterm.lua  —  main entry point
--
-- SOURCE LEGEND:
--   [DOCS]      Official WezTerm docs (wezterm.org) and tmux(1) man page
--   [COMMUNITY] https://www.florianbellmann.com/blog/switch-from-tmux-to-wezterm
--   [GENERATED] Written to fill gaps; caveats noted inline
--
-- UNSUPPORTED TMUX FEATURES (no WezTerm equivalent):
--   - Multiple paste buffers (#, =)         - Preset window layouts (Space, M-1..M-7)
--   - Pane marking (m, M)                   - Activity-aware window nav (M-n, M-p)
--   - Show time (t)                         - Previous tmux messages (~)
--   - True detach/attach (d, D) without wezterm-mux-server
--   - Floating panes (*)
-- =============================================================================

local wezterm = require 'wezterm'
local keybinds = require 'keybinds'
local config  = wezterm.config_builder()

-- [DOCS] Watch keybinds.lua for changes so hot-reload fires on edits to it.
-- Without this, only wezterm.lua changes trigger a reload.
wezterm.add_to_config_reload_watch_list(wezterm.config_dir .. '/keybinds.lua')

-- =============================================================================
-- GLOBAL STATE
-- [GENERATED] Tracks previous pane/workspace to support ';' and 'L' bindings
-- in keybinds.lua. Persists across config reloads via wezterm.GLOBAL.
-- update-status fires every status_update_interval ms (500ms below).
-- =============================================================================

wezterm.GLOBAL.prev_pane_id   = wezterm.GLOBAL.prev_pane_id   or nil
wezterm.GLOBAL.last_pane_id   = wezterm.GLOBAL.last_pane_id   or nil
wezterm.GLOBAL.prev_workspace = wezterm.GLOBAL.prev_workspace or nil
wezterm.GLOBAL.last_workspace = wezterm.GLOBAL.last_workspace or nil

-- =============================================================================
-- GENERAL SETTINGS
-- [GENERATED]
-- =============================================================================

config.scrollback_lines            = 10000
config.audible_bell                = 'Disabled'
config.automatically_reload_config = true
config.status_update_interval      = 500  -- ms; faster polling improves ';' accuracy

-- Tab bar at bottom, like tmux status line
-- [COMMUNITY]
config.enable_tab_bar                 = true
config.tab_bar_at_bottom              = true
config.use_fancy_tab_bar              = false
config.show_new_tab_button_in_tab_bar = false

-- 1-based tab indices to match tmux's default (Prefix+1 = first tab)
-- [DOCS/GENERATED]
config.tab_and_split_indices_are_zero_based = false

-- =============================================================================
-- LEADER KEY  (tmux prefix = Ctrl-b)
-- [DOCS] tmux(1): "a key combination of a prefix key, 'C-b' (Ctrl-b) by default"
-- =============================================================================

config.leader = {
  key                  = 'b',
  mods                 = 'CTRL',
  timeout_milliseconds = 2000,
}

-- =============================================================================
-- EVENT HANDLERS: status bar + global state tracking
-- [COMMUNITY] Status bar layout; [GENERATED] pane/workspace state tracking
-- =============================================================================

wezterm.on('update-status', function(window, pane)
  -- Tmux-style status bar
  window:set_left_status(wezterm.format {
    { Foreground = { Color = '#4fc3f7' } },
    { Text = ' [' .. window:active_workspace() .. '] ' },
    { Foreground = { Color = 'white' } },
  })
  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#aaaaaa' } },
    { Text = ' ' .. wezterm.hostname() .. '  ' },
    { Foreground = { Color = 'white' } },
    { Text = wezterm.strftime('%H:%M  %d-%b-%y ') },
  })

  -- Track previous pane for ';' binding (move to previously active pane)
  local pid = pane:pane_id()
  if wezterm.GLOBAL.last_pane_id ~= pid then
    wezterm.GLOBAL.prev_pane_id = wezterm.GLOBAL.last_pane_id
    wezterm.GLOBAL.last_pane_id = pid
  end

  -- Track previous workspace for 'L' binding (switch to last session)
  local ws = window:active_workspace()
  if wezterm.GLOBAL.last_workspace ~= ws then
    wezterm.GLOBAL.prev_workspace = wezterm.GLOBAL.last_workspace
    wezterm.GLOBAL.last_workspace = ws
  end
end)

-- =============================================================================
-- KEYBINDINGS  (see keybinds.lua)
-- =============================================================================

keybinds.apply(config)

-- =============================================================================
-- PER-OS SETTINGS
-- [GENERATED]
-- =============================================================================

config.window_background_opacity  = 0.85
if wezterm.target_triple:find('windows') then
  -- Change to 'Acrylic' for blur
  config.win32_system_backdrop      = 'Auto'
elseif wezterm.target_triple:find('darwin') then
  config.macos_window_background_blur = 20
else
end

config.colors = {
  background = '#000000',
}

return config
