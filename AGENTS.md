# Quickshell — AGENTS.md

## What this is

A Quickshell status bar for Hyprland (Wayland). No build system, no tests.

## Current structure

- `shell.qml` — entrypoint and (so far) the only QML file
- `icons/` — PNG assets

Modularity is expected to grow; additional `.qml` files or subdirectories may appear without changing the run command.

## Run

```sh
quickshell shell.qml
```

## Runtime dependencies

- `quickshell` (v0.3.0) — framework binary, not a library
- `hyprctl` (part of Hyprland)
- `wpctl` (part of PipeWire) — volume monitoring
- `jq` — parsing hyprctl JSON output
- JetBrainsMono Nerd Font — hardcoded in `shell.qml:22`

## Architecture

- **Entrypoint:** `shell.qml` — single `ShellRoot` with one `PanelWindow` per screen (via `Variants { model: Quickshell.screens }`)
- **System monitoring:** `Process` components run shell commands; 2s `Timer` re-triggers them for polling
- **Window/layout updates:** dual strategy — `Connections` on `Hyprland.rawEvent` for instant updates + a 200ms backup `Timer` for edge cases
- **CPU calculation:** differential — reads `/proc/stat`, compares idle vs total delta between 2s ticks
- **Layout detection:** derived from `hyprctl activewindow -j` (floating/fullscreen/tiled), not the actual Hyprland layout algorithm
- **Adding modules:** create separate `.qml` component files and import them into `shell.qml` (standard QML import mechanics)

## Pragmas

- `//@ pragma UseQApplication` at `shell.qml:1` — required for platform menus (system tray right-click context menu). Without it, tray menus will error.

## Gotchas

- **Hardcoded user path** at `shell.qml:231`: `source: "file:///home/syaofox/.config/quickshell/icons/syaofox.png"` — will fail on any other system. Should be made relative or configurable.
- No `.gitignore` exists — build artifacts or local config could be accidentally committed.
- CPU stat parsing relies on `/proc/stat` line order (`head -1`); unusual kernel configs could produce different column layouts.
- Volume queries `@DEFAULT_AUDIO_SINK@` only — no microphone/input monitoring.

## No CI / no lint / no tests / no formatter config

Do not look for or expect any of these. The project has none.

## Reference

- Quickshell types: https://quickshell.org/docs/v0.3.0/types/
- QtQuick docs: https://doc.qt.io/qt-6/qtquick-qmlmodule.html
