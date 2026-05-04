//@ pragma UseQApplication

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

ShellRoot {
    PanelWindow {
        id: win
        visible: true
        color: "transparent"

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        WlrLayershell.layer: WlrLayer.Overlay

        function run(cmd) {
            Quickshell.execDetached(cmd.split(" "))
            Qt.callLater(Qt.quit)
        }

        Rectangle {
            anchors.fill: parent
            color: "#80000000"

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }

            Rectangle {
                anchors.centerIn: parent
                width: 260
                height: 300
                color: "#1a1b26"
                radius: 12
                border.color: "#444b6a"
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12

                    Repeater {
                        model: [
                            { label: "Lock",     icon: "\uf023", cmd: "hyprlock" },
                            { label: "Reboot",   icon: "\uf2f1", cmd: "systemctl reboot" },
                            { label: "Shutdown", icon: "\uf011", cmd: "systemctl poweroff" },
                        ]

                        Rectangle {
                            Layout.preferredWidth: 180
                            Layout.preferredHeight: 44
                            color: "#2a2b3e"
                            radius: 8

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 12

                                Text {
                                    text: modelData.icon
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 20
                                    color: "#a9b1d6"
                                }

                                Text {
                                    text: modelData.label
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 14
                                    color: "#a9b1d6"
                                    font.bold: true
                                }

                                Item { Layout.fillWidth: true }

                                Text {
                                    text: "\u25b6"
                                    color: "#444b6a"
                                    font.pixelSize: 12
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: parent.color = "#3a3b4e"
                                onExited: parent.color = "#2a2b3e"
                                onClicked: win.run(modelData.cmd)
                            }
                        }
                    }
                }
            }
        }
    }
}
