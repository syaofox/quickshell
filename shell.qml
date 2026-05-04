//@ pragma UseQApplication

import Quickshell
import Quickshell.Wayland
import QtQuick

ShellRoot {
    Theme { id: theme }
    StatsProvider { id: stats }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 30
            color: theme.colBg

            margins {
                top: 0
                bottom: 0
                left: 0
                right: 0
            }

            Rectangle {
                anchors.fill: parent
                color: theme.colBg

                BarContent {
                    barTheme: theme
                    barStats: stats
                    trayWin: win
                }
            }
        }
    }
}
