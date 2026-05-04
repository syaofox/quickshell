//@ pragma UseQApplication

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

ShellRoot {
    Theme { id: theme }

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
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        property int pendingIndex: -1
        property int countdown: 0
        property string pendingCmd: ""
        readonly property int countdownTotal: 10

        Timer {
            id: countdownTimer
            interval: 1000
            repeat: true
            onTriggered: {
                win.countdown--
                if (win.countdown <= 0) {
                    countdownTimer.stop()
                    Quickshell.execDetached(win.pendingCmd.split(" "))
                    Qt.quit()
                }
            }
        }

        function cancelPending() {
            countdownTimer.stop()
            pendingIndex = -1
            countdown = 0
            pendingCmd = ""
        }

        function handleAction(cmd, index) {
            if (!win.menuItems[index].confirm) {
                Quickshell.execDetached(cmd.split(" "))
                Qt.quit()
                return
            }
            if (pendingIndex === index) {
                countdownTimer.stop()
                Quickshell.execDetached(cmd.split(" "))
                Qt.quit()
            } else {
                pendingIndex = index
                pendingCmd = cmd
                countdown = countdownTotal
                countdownTimer.start()
            }
        }

        property var menuItems: [
            { label: "Lock",     icon: "\uf023", cmd: "hyprlock",           confirm: false },
            { label: "Reboot",   icon: "\uf2f1", cmd: "systemctl reboot",   confirm: true  },
            { label: "Shutdown", icon: "\uf011", cmd: "systemctl poweroff", confirm: true  },
        ]

        Rectangle {
            anchors.fill: parent
            color: theme.colOverlay

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (win.pendingIndex >= 0) win.cancelPending()
                    else Qt.quit()
                }
            }

            Rectangle {
                anchors.centerIn: parent
                width: 260
                height: 300
                color: theme.colBg
                radius: 12
                border.color: theme.colMuted
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                }

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 12

                    Repeater {
                        model: win.menuItems

                        Rectangle {
                            Layout.preferredWidth: 180
                            Layout.preferredHeight: 44
                            radius: 8

                            property bool isPending: win.pendingIndex === index
                            property bool isHovered: mouseArea.containsMouse

                            color: isPending ? theme.colYellow : (isHovered ? theme.colBtnHover : theme.colBtn)
                            Behavior on color { ColorAnimation { duration: 100 } }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 12

                                Text {
                                    text: modelData.icon
                                    font.family: theme.fontFamily
                                    font.pixelSize: 20
                                    color: isPending ? theme.colBg : theme.colFg
                                }

                                Text {
                                    text: isPending && win.countdown > 0
                                        ? modelData.label + " (" + win.countdown + "s)"
                                        : modelData.label
                                    font.family: theme.fontFamily
                                    font.pixelSize: theme.fontSize
                                    color: isPending ? theme.colBg : theme.colFg
                                    font.bold: true
                                }

                                Item { Layout.fillWidth: true }

                                Text {
                                    text: isPending ? "\uf28e" : "\u25b6"
                                    font.family: theme.fontFamily
                                    font.pixelSize: 12
                                    color: isPending ? theme.colBg : theme.colMuted
                                }
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: win.handleAction(modelData.cmd, index)
                            }
                        }
                    }

                    Item { width: 1; height: 4 }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: win.pendingIndex >= 0 ? "\uf28e 再点一次确认，按 ESC 取消" : ""
                        font.family: theme.fontFamily
                        font.pixelSize: 11
                        color: theme.colYellow
                    }
                }
            }
        }

        Shortcut {
            sequence: "Escape"
            onActivated: {
                if (win.pendingIndex >= 0) win.cancelPending()
                else Qt.quit()
            }
        }
    }
}
