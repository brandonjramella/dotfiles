-- =============================================================================
-- ~/.config/wezterm/keybinds.lua  —  all key bindings
--
-- Loaded by wezterm.lua via:  local keybinds = require 'keybinds'
--                              keybinds.apply(config)
--
-- SOURCE LEGEND:
--   [DOCS]      Official WezTerm docs (wezterm.org) and tmux(1) man page
--   [COMMUNITY] https://www.florianbellmann.com/blog/switch-from-tmux-to-wezterm
--   [GENERATED] Written to fill gaps; caveats noted inline
-- =============================================================================

local wezterm = require 'wezterm'
local act     = wezterm.action

local M = {}

-- =============================================================================
-- KEY BINDINGS
-- Organized to match the tmux(1) man page DEFAULT KEY BINDINGS section order.
-- Each binding annotated with its tmux description and WezTerm mapping notes.
-- =============================================================================

local keys = {

  -- ── C-b ──────────────────────────────────────────────────────────────────
  -- [DOCS] "Send the prefix key (C-b) through to the application."
  {
    key    = 'b',
    mods   = 'LEADER|CTRL',
    action = act.SendKey { key = 'b', mods = 'CTRL' },
  },

  -- ── C-o ──────────────────────────────────────────────────────────────────
  -- [DOCS] "Rotate the panes in the current window forwards."
  -- [GENERATED] RotatePanes 'Clockwise' is the closest WezTerm equivalent.
  -- Note: tmux rotates pane CONTENTS; WezTerm rotates layout positions.
  -- Behavior is visually identical in practice.
  {
    key    = 'o',
    mods   = 'LEADER|CTRL',
    action = act.RotatePanes 'Clockwise',
  },

  -- ── C-z ──────────────────────────────────────────────────────────────────
  -- [DOCS] "Suspend the tmux client."
  -- [GENERATED] WezTerm has no true suspend-to-background. act.Hide hides the
  -- window; there is no 'fg' equivalent to bring it back. Closest available.
  {
    key    = 'z',
    mods   = 'LEADER|CTRL',
    action = act.Hide,
  },

  -- ── ! ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Break the current pane out of the window."
  -- [GENERATED] pane:move_to_new_tab() is the WezTerm equivalent.
  {
    key    = '!',
    mods   = 'LEADER',
    action = wezterm.action_callback(function(_, pane)
      pane:move_to_new_tab()
    end),
  },

  -- ── " ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Split the current pane into two, top and bottom."
  {
    key    = '"',
    mods   = 'LEADER',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- ── # ────────────────────────────────────────────────────────────────────
  -- [DOCS] "List all paste buffers."
  -- [GENERATED] WezTerm has no multi-buffer clipboard; no equivalent exists.
  {
    key    = '#',
    mods   = 'LEADER',
    action = act.Nop,
  },

  -- ── $ ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Rename the current session."
  -- [GENERATED] WezTerm sessions = workspaces.
  {
    key    = '$',
    mods   = 'LEADER',
    action = act.PromptInputLine {
      description = 'Rename workspace (session):',
      action = wezterm.action_callback(function(window, _, line)
        if line then
          wezterm.mux.rename_workspace(window:active_workspace(), line)
        end
      end),
    },
  },

  -- ── % ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Split the current pane into two, left and right."
  {
    key    = '%',
    mods   = 'LEADER',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },

  -- ── & ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Kill the current window."
  {
    key    = '&',
    mods   = 'LEADER',
    action = act.CloseCurrentTab { confirm = true },
  },

  -- ── ' ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Prompt for a window index to select."
  -- [GENERATED] Input is 1-based to match tmux.
  {
    key    = "'",
    mods   = 'LEADER',
    action = act.PromptInputLine {
      description = 'Go to tab (1-based index):',
      action = wezterm.action_callback(function(window, pane, line)
        local idx = tonumber(line)
        if idx then
          window:perform_action(act.ActivateTab(idx - 1), pane)
        end
      end),
    },
  },

  -- ── ( ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Switch the attached client to the previous session."
  -- [GENERATED] Cycles workspaces in list order; tmux has a defined prev session.
  {
    key    = '(',
    mods   = 'LEADER',
    action = act.SwitchWorkspaceRelative(-1),
  },

  -- ── ) ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Switch the attached client to the next session."
  {
    key    = ')',
    mods   = 'LEADER',
    action = act.SwitchWorkspaceRelative(1),
  },

  -- ── * ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Create a new floating pane."
  -- [GENERATED] WezTerm does not support floating panes. Nop.
  {
    key    = '*',
    mods   = 'LEADER',
    action = act.Nop,
  },

  -- ── , ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Rename the current window."
  {
    key    = ',',
    mods   = 'LEADER',
    action = act.PromptInputLine {
      description = 'Rename tab (window):',
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- ── - ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Delete the most recently copied buffer of text."
  -- [GENERATED] WezTerm has no multi-buffer clipboard. Nop.
  {
    key    = '-',
    mods   = 'LEADER',
    action = act.Nop,
  },

  -- ── . ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Prompt for an index to move the current window."
  -- [GENERATED] Index is 0-based in WezTerm's MoveTab.
  {
    key    = '.',
    mods   = 'LEADER',
    action = act.PromptInputLine {
      description = 'Move tab to index (0-based):',
      action = wezterm.action_callback(function(window, pane, line)
        local idx = tonumber(line)
        if idx then
          window:perform_action(act.MoveTab(idx), pane)
        end
      end),
    },
  },

  -- ── 0–9 ──────────────────────────────────────────────────────────────────
  -- [DOCS] "Select windows 0 to 9."
  -- [GENERATED] ActivateTab is 0-based internally; Prefix+1 → first tab.
  -- Prefix+0 selects the last tab (tmux selects window 0; best available).
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0)  },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1)  },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2)  },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3)  },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(4)  },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(5)  },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(6)  },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(7)  },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(8)  },
  { key = '0', mods = 'LEADER', action = act.ActivateTab(-1) }, -- last tab

  -- ── : ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Enter the tmux command prompt."
  -- [GENERATED] WezTerm's command palette is the closest equivalent.
  {
    key    = ':',
    mods   = 'LEADER',
    action = act.ActivateCommandPalette,
  },

  -- ── ; ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Move to the previously active pane."
  -- [GENERATED] Uses GLOBAL.prev_pane_id tracked in wezterm.lua update-status.
  -- Only searches panes within the current tab (not across tabs).
  {
    key    = ';',
    mods   = 'LEADER',
    action = wezterm.action_callback(function(window, _)
      local prev_id = wezterm.GLOBAL.prev_pane_id
      if prev_id == nil then return end
      for _, p in ipairs(window:active_tab():panes()) do
        if p:pane_id() == prev_id then
          p:activate()
          return
        end
      end
    end),
  },

  -- ── = ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Choose which buffer to paste interactively from a list."
  -- [GENERATED] WezTerm has no multi-buffer clipboard. Nop.
  {
    key    = '=',
    mods   = 'LEADER',
    action = act.Nop,
  },

  -- ── ? ────────────────────────────────────────────────────────────────────
  -- [DOCS] "List all key bindings."
  -- [GENERATED] ShowLauncherArgs with KEY_ASSIGNMENTS shows bindings.
  {
    key    = '?',
    mods   = 'LEADER',
    action = act.ShowLauncherArgs { flags = 'KEY_ASSIGNMENTS' },
  },

  -- ── D ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Choose a client to detach."
  -- [GENERATED] Only meaningful with wezterm-mux-server.
  {
    key    = 'D',
    mods   = 'LEADER',
    action = act.ShowLauncherArgs { flags = 'DOMAINS' },
  },

  -- ── L ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Switch the attached client back to the last session."
  -- [GENERATED] Uses GLOBAL.prev_workspace tracked in wezterm.lua update-status.
  {
    key    = 'L',
    mods   = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      local prev = wezterm.GLOBAL.prev_workspace
      if prev then
        window:perform_action(act.SwitchToWorkspace { name = prev }, pane)
      end
    end),
  },

  -- ── [ ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Enter copy mode to copy text or view the history."
  {
    key    = '[',
    mods   = 'LEADER',
    action = act.ActivateCopyMode,
  },

  -- ── ] ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Paste the most recently copied buffer of text."
  {
    key    = ']',
    mods   = 'LEADER',
    action = act.PasteFrom 'Clipboard',
  },

  -- ── c ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Create a new window."
  {
    key    = 'c',
    mods   = 'LEADER',
    action = act.SpawnTab 'CurrentPaneDomain',
  },

  -- ── d ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Detach the current client."
  -- [GENERATED] Only works with wezterm-mux-server; otherwise a no-op.
  {
    key    = 'd',
    mods   = 'LEADER',
    action = act.DetachDomain 'CurrentPaneDomain',
  },

  -- ── f ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Prompt to search for text in open windows."
  -- [GENERATED] Searches current pane scrollback; tmux searches all windows.
  {
    key    = 'f',
    mods   = 'LEADER',
    action = act.Search 'CurrentSelectionOrEmptyString',
  },

  -- ── i ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Display some information about the current window."
  -- [GENERATED] ShowDebugOverlay shows pane/tab/window details.
  {
    key    = 'i',
    mods   = 'LEADER',
    action = act.ShowDebugOverlay,
  },

  -- ── l ────────────────────────────────────────────────────────────────────
  -- [DOCS] tmux default: "Move to the previously selected window" (ActivateLastTab)
  -- [GENERATED] DELIBERATE DEVIATION: 'l' is vi pane-right to complete h/j/k/l.
  -- ActivateLastTab is intentionally unbound. Use n/p to cycle tabs instead.
  {
    key    = 'l',
    mods   = 'LEADER',
    action = act.ActivatePaneDirection 'Right',
  },

  -- ── m / M ────────────────────────────────────────────────────────────────
  -- [DOCS] "Mark the current pane." / "Clear the marked pane."
  -- [GENERATED] WezTerm has no pane marking concept. Nop.
  { key = 'm', mods = 'LEADER', action = act.Nop },
  { key = 'M', mods = 'LEADER', action = act.Nop },

  -- ── n ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Change to the next window."
  {
    key    = 'n',
    mods   = 'LEADER',
    action = act.ActivateTabRelative(1),
  },

  -- ── o ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Select the next pane in the current window."
  {
    key    = 'o',
    mods   = 'LEADER',
    action = act.ActivatePaneDirection 'Next',
  },

  -- ── p ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Change to the previous window."
  {
    key    = 'p',
    mods   = 'LEADER',
    action = act.ActivateTabRelative(-1),
  },

  -- ── q ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Briefly display pane indexes."
  -- [GENERATED] PaneSelect shows a labeled overlay; press the label to jump.
  {
    key    = 'q',
    mods   = 'LEADER',
    action = act.PaneSelect {},
  },

  -- ── r ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Force redraw of the attached client."
  -- [GENERATED] Sends Ctrl-L; most shells/apps respond with a full redraw.
  {
    key    = 'r',
    mods   = 'LEADER',
    action = act.SendString '\x0c',
  },

  -- ── s ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Select a new session for the attached client interactively."
  {
    key    = 's',
    mods   = 'LEADER',
    action = act.ShowLauncherArgs { flags = 'WORKSPACES' },
  },

  -- ── t ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Show the time."
  -- [GENERATED] Time is already in the right status bar. Nop.
  {
    key    = 't',
    mods   = 'LEADER',
    action = act.Nop,
  },

  -- ── w ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Choose the current window interactively."
  {
    key    = 'w',
    mods   = 'LEADER',
    action = act.ShowTabNavigator,
  },

  -- ── x ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Kill the current pane."
  {
    key    = 'x',
    mods   = 'LEADER',
    action = act.CloseCurrentPane { confirm = true },
  },

  -- ── z ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Toggle zoom state of the current pane."
  {
    key    = 'z',
    mods   = 'LEADER',
    action = act.TogglePaneZoomState,
  },

  -- ── { ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Swap the current pane with the previous pane."
  -- [GENERATED] RotatePanes rotates all panes; tmux swaps just two. Closest available.
  {
    key    = '{',
    mods   = 'LEADER',
    action = act.RotatePanes 'CounterClockwise',
  },

  -- ── } ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Swap the current pane with the next pane."
  -- [GENERATED] Same caveat as { above.
  {
    key    = '}',
    mods   = 'LEADER',
    action = act.RotatePanes 'Clockwise',
  },

  -- ── ~ ────────────────────────────────────────────────────────────────────
  -- [DOCS] "Show previous messages from tmux, if any."
  -- [GENERATED] ShowDebugOverlay shows WezTerm internal messages.
  {
    key    = '~',
    mods   = 'LEADER',
    action = act.ShowDebugOverlay,
  },

  -- ── Page Up ──────────────────────────────────────────────────────────────
  -- [DOCS] "Enter copy mode and scroll one page up."
  -- [GENERATED] Multiple fires ActivateCopyMode then PageUp sequentially.
  {
    key    = 'PageUp',
    mods   = 'LEADER',
    action = act.Multiple {
      act.ActivateCopyMode,
      act.CopyMode 'PageUp',
    },
  },

  -- ── Arrow keys ───────────────────────────────────────────────────────────
  -- [DOCS] "Change to the pane above, below, to the left, or to the right."
  { key = 'UpArrow',    mods = 'LEADER', action = act.ActivatePaneDirection 'Up'    },
  { key = 'DownArrow',  mods = 'LEADER', action = act.ActivatePaneDirection 'Down'  },
  { key = 'LeftArrow',  mods = 'LEADER', action = act.ActivatePaneDirection 'Left'  },
  { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -- ── M-1 to M-7 ───────────────────────────────────────────────────────────
  -- [DOCS] "Arrange panes in one of the seven preset layouts."
  -- [GENERATED] WezTerm has no preset layout system. Nop.
  { key = '1', mods = 'LEADER|ALT', action = act.Nop },
  { key = '2', mods = 'LEADER|ALT', action = act.Nop },
  { key = '3', mods = 'LEADER|ALT', action = act.Nop },
  { key = '4', mods = 'LEADER|ALT', action = act.Nop },
  { key = '5', mods = 'LEADER|ALT', action = act.Nop },
  { key = '6', mods = 'LEADER|ALT', action = act.Nop },
  { key = '7', mods = 'LEADER|ALT', action = act.Nop },

  -- ── Space ────────────────────────────────────────────────────────────────
  -- [DOCS] "Arrange the current window in the next preset layout."
  -- [GENERATED] No preset layout system in WezTerm. Nop.
  { key = 'Space', mods = 'LEADER', action = act.Nop },

  -- ── M-n / M-p ────────────────────────────────────────────────────────────
  -- [DOCS] "Move to the next/previous window with a bell or activity marker."
  -- [GENERATED] WezTerm has no activity-aware tab switching. Nop.
  { key = 'n', mods = 'LEADER|ALT', action = act.Nop },
  { key = 'p', mods = 'LEADER|ALT', action = act.Nop },

  -- ── M-o ──────────────────────────────────────────────────────────────────
  -- [DOCS] "Rotate the panes in the current window backwards."
  { key = 'o', mods = 'LEADER|ALT', action = act.RotatePanes 'CounterClockwise' },

  -- ── C-Up / C-Down / C-Left / C-Right ─────────────────────────────────────
  -- [DOCS] "Resize the current pane in steps of one cell."
  { key = 'UpArrow',    mods = 'LEADER|CTRL', action = act.AdjustPaneSize { 'Up',    1 } },
  { key = 'DownArrow',  mods = 'LEADER|CTRL', action = act.AdjustPaneSize { 'Down',  1 } },
  { key = 'LeftArrow',  mods = 'LEADER|CTRL', action = act.AdjustPaneSize { 'Left',  1 } },
  { key = 'RightArrow', mods = 'LEADER|CTRL', action = act.AdjustPaneSize { 'Right', 1 } },

  -- ── M-Up / M-Down / M-Left / M-Right ─────────────────────────────────────
  -- [DOCS] "Resize the current pane in steps of five cells."
  { key = 'UpArrow',    mods = 'LEADER|ALT', action = act.AdjustPaneSize { 'Up',    5 } },
  { key = 'DownArrow',  mods = 'LEADER|ALT', action = act.AdjustPaneSize { 'Down',  5 } },
  { key = 'LeftArrow',  mods = 'LEADER|ALT', action = act.AdjustPaneSize { 'Left',  5 } },
  { key = 'RightArrow', mods = 'LEADER|ALT', action = act.AdjustPaneSize { 'Right', 5 } },

  -- ==========================================================================
  -- BONUS: vi-style pane navigation (h/j/k completes the set; l is above)
  -- [GENERATED] h/j/k are not tmux defaults; no conflict with the man page.
  -- ==========================================================================
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left'  },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down'  },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up'    },

  -- Convenience split alias (not a tmux default)
  -- [GENERATED]
  { key = '|', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- F11: toggle fullscreen (direct, no leader)
  -- [GENERATED]
  { key = 'F11', mods = 'NONE', action = act.ToggleFullScreen },

  -- Word movement (direct, no leader — readline-style passthrough)
  -- [GENERATED]
  { key = 'LeftArrow',  mods = 'CTRL', action = act.SendKey { key = 'b', mods = 'ALT' } },
  { key = 'RightArrow', mods = 'CTRL', action = act.SendKey { key = 'f', mods = 'ALT' } },
}

-- =============================================================================
-- COPY MODE KEY TABLE
-- [DOCS] Default copy_mode table reproduced verbatim from wezterm.org/copymode.html
--
-- [GENERATED] Additions (marked below):
--   - 'Enter' → yank and close    (default: MoveToStartOfNextLine)
--   - '/'     → open search       (tmux vi: search forward)
--   - 'n'/'N' → NextMatch/Prior   (tmux vi: navigate matches)
-- =============================================================================

local key_tables = {
  copy_mode = {
    -- [DOCS] ── default copy_mode table ──────────────────────────────────────
    { key = 'Tab',    mods = 'NONE',  action = act.CopyMode 'MoveForwardWord'                        },
    { key = 'Tab',    mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord'                       },
    {
      key    = 'Enter',
      mods   = 'NONE',
      -- [GENERATED] Yank + close instead of default MoveToStartOfNextLine
      action = act.Multiple {
        { CopyTo   = 'ClipboardAndPrimarySelection' },
        { CopyMode = 'Close'                        },
      },
    },
    {
      key    = 'Escape',
      mods   = 'NONE',
      action = act.Multiple {
        { CopyMode = 'Close'          },
      },
    },
    { key = 'Space', mods = 'NONE',  action = act.CopyMode { SetSelectionMode = 'Cell' }             },
    { key = '$',     mods = 'NONE',  action = act.CopyMode 'MoveToEndOfLineContent'                  },
    { key = '$',     mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent'                  },
    { key = ',',     mods = 'NONE',  action = act.CopyMode 'JumpReverse'                             },
    { key = '0',     mods = 'NONE',  action = act.CopyMode 'MoveToStartOfLine'                       },
    { key = ';',     mods = 'NONE',  action = act.CopyMode 'JumpAgain'                               },
    { key = 'F',     mods = 'NONE',  action = act.CopyMode { JumpBackward = { prev_char = false } }  },
    { key = 'F',     mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = false } }  },
    { key = 'G',     mods = 'NONE',  action = act.CopyMode 'MoveToScrollbackBottom'                  },
    { key = 'G',     mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom'                  },
    { key = 'H',     mods = 'NONE',  action = act.CopyMode 'MoveToViewportTop'                       },
    { key = 'H',     mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop'                       },
    { key = 'L',     mods = 'NONE',  action = act.CopyMode 'MoveToViewportBottom'                    },
    { key = 'L',     mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom'                    },
    { key = 'M',     mods = 'NONE',  action = act.CopyMode 'MoveToViewportMiddle'                    },
    { key = 'M',     mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle'                    },
    { key = 'O',     mods = 'NONE',  action = act.CopyMode 'MoveToSelectionOtherEndHoriz'            },
    { key = 'O',     mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz'            },
    { key = 'T',     mods = 'NONE',  action = act.CopyMode { JumpBackward = { prev_char = true } }   },
    { key = 'T',     mods = 'SHIFT', action = act.CopyMode { JumpBackward = { prev_char = true } }   },
    { key = 'V',     mods = 'NONE',  action = act.CopyMode { SetSelectionMode = 'Line' }             },
    { key = 'V',     mods = 'SHIFT', action = act.CopyMode { SetSelectionMode = 'Line' }             },
    { key = '^',     mods = 'NONE',  action = act.CopyMode 'MoveToStartOfLineContent'                },
    { key = '^',     mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent'                },
    { key = 'b',     mods = 'NONE',  action = act.CopyMode 'MoveBackwardWord'                        },
    { key = 'b',     mods = 'ALT',   action = act.CopyMode 'MoveBackwardWord'                        },
    { key = 'b',     mods = 'CTRL',  action = act.CopyMode 'PageUp'                                  },
    {
      key    = 'c',
      mods   = 'CTRL',
      action = act.Multiple {
        { CopyMode = 'Close'          },
      },
    },
    { key = 'd',  mods = 'CTRL', action = act.CopyMode { MoveByPage = 0.5 }                         },
    { key = 'e',  mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd'                          },
    { key = 'f',  mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = false } }       },
    { key = 'f',  mods = 'ALT',  action = act.CopyMode 'MoveForwardWord'                             },
    { key = 'f',  mods = 'CTRL', action = act.CopyMode 'PageDown'                                    },
    { key = 'g',  mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop'                         },
    {
      key    = 'g',
      mods   = 'CTRL',
      action = act.Multiple {
        { CopyMode = 'Close'          },
      },
    },
    { key = 'h',  mods = 'NONE', action = act.CopyMode 'MoveLeft'                                    },
    { key = 'j',  mods = 'NONE', action = act.CopyMode 'MoveDown'                                    },
    { key = 'k',  mods = 'NONE', action = act.CopyMode 'MoveUp'                                      },
    { key = 'l',  mods = 'NONE', action = act.CopyMode 'MoveRight'                                   },
    { key = 'm',  mods = 'ALT',  action = act.CopyMode 'MoveToStartOfLineContent'                    },
    { key = 'o',  mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd'                     },
    {
      key    = 'q',
      mods   = 'NONE',
      action = act.Multiple {
        { CopyMode = 'Close'          },
      },
    },
    { key = 't',  mods = 'NONE', action = act.CopyMode { JumpForward = { prev_char = true } }        },
    { key = 'u',  mods = 'CTRL', action = act.CopyMode { MoveByPage = -0.5 }                         },
    { key = 'v',  mods = 'NONE', action = act.CopyMode { SetSelectionMode = 'Cell' }                 },
    { key = 'v',  mods = 'CTRL', action = act.CopyMode { SetSelectionMode = 'Block' }                },
    { key = 'w',  mods = 'NONE', action = act.CopyMode 'MoveForwardWord'                             },
    {
      key    = 'y',
      mods   = 'NONE',
      action = act.Multiple {
        { CopyTo   = 'ClipboardAndPrimarySelection' },
        { CopyMode = 'Close'                        },
      },
    },
    { key = 'PageUp',     mods = 'NONE', action = act.CopyMode 'PageUp'                              },
    { key = 'PageDown',   mods = 'NONE', action = act.CopyMode 'PageDown'                            },
    { key = 'End',        mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent'              },
    { key = 'Home',       mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine'                   },
    { key = 'LeftArrow',  mods = 'NONE', action = act.CopyMode 'MoveLeft'                            },
    { key = 'LeftArrow',  mods = 'ALT',  action = act.CopyMode 'MoveBackwardWord'                    },
    { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight'                           },
    { key = 'RightArrow', mods = 'ALT',  action = act.CopyMode 'MoveForwardWord'                     },
    { key = 'UpArrow',    mods = 'NONE', action = act.CopyMode 'MoveUp'                              },
    { key = 'DownArrow',  mods = 'NONE', action = act.CopyMode 'MoveDown'                            },
    -- [DOCS] ── end of default copy_mode table ────────────────────────────────

    -- [GENERATED] ── tmux vi additions not in WezTerm default ─────────────────
    -- '/' opens search overlay (tmux vi: / searches forward through scrollback)
    { key = '/', mods = 'NONE',  action = act.Search { CaseSensitiveString = '' } },
    -- 'n'/'N' navigate search matches
    { key = 'n', mods = 'NONE',  action = act.CopyMode 'NextMatch'  },
    { key = 'N', mods = 'NONE',  action = act.CopyMode 'PriorMatch' },
    { key = 'N', mods = 'SHIFT', action = act.CopyMode 'PriorMatch' },
  },

  -- ===========================================================================
  -- SEARCH MODE KEY TABLE
  -- [GENERATED] Separate from copy_mode; tuned for vi feel.
  -- Enter accepts and returns to copy mode; Escape cancels.
  -- ===========================================================================

  search_mode = {
    { key = 'Enter',     mods = 'NONE',  action = act.CopyMode 'AcceptPattern'  },
    { key = 'Escape',    mods = 'NONE',  action = act.CopyMode 'Close'          },
    { key = 'n',         mods = 'CTRL',  action = act.CopyMode 'NextMatch'      },
    { key = 'p',         mods = 'CTRL',  action = act.CopyMode 'PriorMatch'     },
    { key = 'n',         mods = 'NONE',  action = act.CopyMode 'NextMatch'      },
    { key = 'N',         mods = 'NONE',  action = act.CopyMode 'PriorMatch'     },
    { key = 'N',         mods = 'SHIFT', action = act.CopyMode 'PriorMatch'     },
    { key = 'r',         mods = 'CTRL',  action = act.CopyMode 'CycleMatchType' },
    { key = 'u',         mods = 'CTRL',  action = act.CopyMode 'ClearPattern'   },
    { key = 'PageUp',    mods = 'NONE',  action = act.CopyMode 'PriorMatchPage' },
    { key = 'PageDown',  mods = 'NONE',  action = act.CopyMode 'NextMatchPage'  },
    { key = 'UpArrow',   mods = 'NONE',  action = act.CopyMode 'PriorMatch'     },
    { key = 'DownArrow', mods = 'NONE',  action = act.CopyMode 'NextMatch'      },
  },
}

-- =============================================================================
-- MODULE EXPORT
-- Call keybinds.apply(config) from wezterm.lua to apply everything.
-- =============================================================================

function M.apply(config)
  config.keys       = keys
  config.key_tables = key_tables
end

return M