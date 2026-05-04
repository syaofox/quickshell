# Quickshell — AGENTS.md

## What this is

A Quickshell status bar for Hyprland (Wayland). No build system, no tests.

## Current structure

- `bar/shell.qml` — entrypoint (ShellRoot + PanelWindow per screen)
- `bar/Theme.qml` — color/font constants (QtObject)
- `bar/StatsProvider.qml` — system monitoring (Item container holding Process + Timer + Connections; not QtObject — QtObject cannot host those child types)
- `bar/BarContent.qml` — status bar layout (RowLayout; receives data via `barTheme`, `barStats`, `trayWin` properties; delegates to `bar/sections/`)
- `bar/sections/` — individual bar section components (AvatarSection, WorkspaceBar, SectionDivider, LayoutLabel, WindowTitle, KernelStat, CpuStat, MemStat, DiskStat, NetStat, VolStat, GpuStat, ClockWidget, TrayWidget, PowerButton)
- `PowerMenu.qml` — standalone floating shutdown menu (Lock/Reboot/Shutdown; run via `quickshell --config powermenu/` or Hyprland keybind)
- `powermenu/shell.qml` — symlink to `../PowerMenu.qml` (required because quickshell only accepts directories as config paths)
- `SysInfo.qml` — standalone floating system info overlay (parses `fastfetch --pipe` output)
- `sysinfo/shell.qml` — symlink to `../SysInfo.qml`
- `icons/` — PNG assets

Modularity is expected to grow; additional `.qml` files or subdirectories may appear without changing the run command.

## Run

```sh
quickshell --config bar/
```

## Runtime dependencies

- `quickshell` (v0.3.0) — framework binary, not a library
- `hyprctl` (part of Hyprland)
- `wpctl` (part of PipeWire) — volume monitoring
- `jq` — parsing hyprctl JSON output
- JetBrainsMono Nerd Font — hardcoded in `bar/Theme.qml`

## Architecture

- **Entrypoint:** `bar/shell.qml` — single `ShellRoot` with one `PanelWindow` per screen (via `Variants { model: Quickshell.screens }`)
- **System monitoring:** `Process` components run shell commands; 2s `Timer` re-triggers them for polling
- **Window/layout updates:** dual strategy — `Connections` on `Hyprland.rawEvent` for instant updates + a 200ms backup `Timer` for edge cases
- **CPU calculation:** differential — reads `/proc/stat`, compares idle vs total delta between 2s ticks
- **Network speed:** differential — reads `/proc/net/dev` via `awk`; delta in Mbps with configurable threshold (`netThreshold`)
- **Layout detection:** derived from `hyprctl activewindow -j` (floating/fullscreen/tiled), not the actual Hyprland layout algorithm
- **Adding modules:** create separate `.qml` component files and import them into `bar/shell.qml` (standard QML import mechanics)

## Pragmas

- `//@ pragma UseQApplication` at `bar/shell.qml:1` — required for platform menus (system tray right-click context menu). Without it, tray menus will error.

## Gotchas

- **Property name collision:** BarContent properties are named `barTheme`/`barStats`/`trayWin` to avoid binding loops when ids `theme`/`stats`/`win` exist in the parent scope. Section components receive them as `sectionTheme`/`sectionStats`/`sectionWin` for the same reason.
- **Hardcoded user path** at `bar/BarContent.qml`: `source: "file:///home/syaofox/.config/quickshell/icons/syaofox.png"` — will fail on any other system. Should be made relative or configurable.
- No `.gitignore` exists — build artifacts or local config could be accidentally committed.
- CPU stat parsing relies on `/proc/stat` line order (`head -1`); unusual kernel configs could produce different column layouts.
- Volume queries `@DEFAULT_AUDIO_SINK@` only — no microphone/input monitoring.

## No CI / no lint / no tests / no formatter config

Do not look for or expect any of these. The project has none.

## Skill / Pattern Reference

`PATTERNS.md` — established project conventions for components, windows, monitoring, system tray, process execution, and property passing. Check this first before implementing new features.

## Reference

- Quickshell types: https://quickshell.org/docs/v0.3.0/types/
- QtQuick docs: https://doc.qt.io/qt-6/qtquick-qmlmodule.html
