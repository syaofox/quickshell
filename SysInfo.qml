//@ pragma UseQApplication

import Quickshell
import Quickshell.Io
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

        property var sysInfoItems: []

        function addItem(key, value) {
            if (!value) return
            var v = value.length > 45 ? value.substring(0, 42) + "..." : value
            win.sysInfoItems = win.sysInfoItems.concat([{ key: key, value: v }])
        }

        Process {
            command: ["sh", "-c", "hostnamectl | grep 'Operating System' | cut -d: -f2- | sed 's/^ //'"]
            stdout: SplitParser { onRead: d => { if (d) win.addItem("OS", d.trim()) } }
            Component.onCompleted: running = true
        }

        Process {
            command: ["sh", "-c", "hostnamectl | grep 'Hardware Vendor' | cut -d: -f2- | sed 's/^ //'"]
            stdout: SplitParser { onRead: d => { if (d) win.addItem("Host", d.trim()) } }
            Component.onCompleted: running = true
        }

        Process {
            command: ["uname", "-r"]
            stdout: SplitParser { onRead: d => { if (d) win.addItem("Kernel", d.trim()) } }
            Component.onCompleted: running = true
        }

        Process {
            command: ["sh", "-c", "uptime -p | sed 's/^up //'"]
            stdout: SplitParser { onRead: d => { if (d) win.addItem("Uptime", d.trim()) } }
            Component.onCompleted: running = true
        }

        Process {
            command: ["sh", "-c", "pacman -Q 2>/dev/null | wc -l"]
            stdout: SplitParser { onRead: d => { if (d) win.addItem("Packages", d.trim() + " (pacman)") } }
            Component.onCompleted: running = true
        }

        Process {
            command: ["sh", "-c", "basename $SHELL"]
            stdout: SplitParser { onRead: d => { if (d) win.addItem("Shell", d.trim()) } }
            Component.onCompleted: running = true
        }

        Process {
            command: ["sh", "-c", "head -n 1 /proc/cpuinfo | cut -d: -f2- | sed 's/^ //'"]
            stdout: SplitParser { onRead: d => { if (d) win.addItem("CPU", d.trim().replace(/\s+/g, ' ')) } }
            Component.onCompleted: running = true
        }

        Process {
            command: ["sh", "-c", "free -h | grep Mem | awk '{print $3\"/\"$2}'"]
            stdout: SplitParser { onRead: d => { if (d) win.addItem("Memory", d.trim()) } }
            Component.onCompleted: running = true
        }

        Process {
            command: ["sh", "-c", "df -h / | tail -1 | awk '{print $3\"/\"$2\" (\"$5\")\"}'"]
            stdout: SplitParser { onRead: d => { if (d) win.addItem("Disk", d.trim()) } }
            Component.onCompleted: running = true
        }

        Process {
            command: ["sh", "-c", "hostname -I 2>/dev/null | awk '{print $1}'"]
            stdout: SplitParser { onRead: d => { if (d) win.addItem("IP", d.trim()) } }
            Component.onCompleted: running = true
        }

        Rectangle {
            anchors.fill: parent
            color: theme.colOverlay

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }

            Rectangle {
                anchors.centerIn: parent
                width: 460
                implicitHeight: infoRow.childrenRect.height + 48
                color: theme.colBg
                radius: 12
                border.color: theme.colMuted
                border.width: 1

                MouseArea {
                    anchors.fill: parent
                }

                RowLayout {
                    id: infoRow
                    anchors {
                        top: parent.top
                        left: parent.left
                        right: parent.right
                        margins: 24
                    }
                    spacing: 20

                    Item {
                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 200

                        Image {
                            anchors.fill: parent
                            anchors.topMargin: 4
                            source: "file:///home/syaofox/.config/quickshell/icons/syaofox.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        spacing: 2

                        Item { width: 1; height: 1; visible: win.sysInfoItems.length === 0 }

                        Loader {
                            Layout.fillWidth: true
                            active: win.sysInfoItems.length === 0
                            sourceComponent: Text {
                                text: "Fetching system info..."
                                font.family: theme.fontFamily
                                font.pixelSize: theme.fontSize
                                color: theme.colMuted
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        Repeater {
                            model: win.sysInfoItems

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 24
                                color: "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 6

                                    Text {
                                        text: modelData.key + ":"
                                        font.family: theme.fontFamily
                                        font.pixelSize: theme.fontSize
                                        color: theme.colBlue
                                        font.bold: true
                                        Layout.alignment: Qt.AlignVCenter
                                    }

                                    Text {
                                        text: modelData.value
                                        font.family: theme.fontFamily
                                        font.pixelSize: theme.fontSize
                                        color: theme.colFg
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        Shortcut {
            sequence: "Escape"
            onActivated: Qt.quit()
        }
    }
}
