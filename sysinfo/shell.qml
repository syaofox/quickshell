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
            command: ["sh", "-c", "fastfetch --json --structure \"OS:Host:Kernel:Uptime:Packages:Shell:CPU:Memory:Disk:LocalIp\" 2>/dev/null | jq -r '
  def gb: . / 1073741824 * 100 | floor / 100;
  (.[] | select(.type == \"OS\")        | \"OS|\\(.result.prettyName)\"),
  (.[] | select(.type == \"Host\")      | \"Host|\\(.result.vendor) \\(.result.name)\"),
  (.[] | select(.type == \"Kernel\")    | \"Kernel|\\(.result.release)\"),
  (.[] | select(.type == \"Uptime\")    | \"Uptime|\\(.result.uptime / 86400 | floor) days, \\(.result.uptime % 86400 / 3600 | floor) hours, \\(.result.uptime % 3600 / 60 | floor) mins\"),
  (.[] | select(.type == \"Packages\")  | \"Packages|\\(.result.pacman) (pacman)\"),
  (.[] | select(.type == \"Shell\")     | \"Shell|\\(.result.prettyName)\"),
  (.[] | select(.type == \"CPU\")       | \"CPU|\\(.result.cpu)\"),
  (.[] | select(.type == \"Memory\")    | \"Memory|\\(.result.used | gb) GiB / \\(.result.total | gb) GiB\"),
  (.[] | select(.type == \"Disk\")      | select(.result[0].mountpoint == \"/\") | \"Disk|\\(.result[0].bytes.used | gb) GiB / \\(.result[0].bytes.total | gb) GiB (\\((.result[0].bytes.used / .result[0].bytes.total * 100 | floor))%)\"),
  (.[] | select(.type == \"LocalIp\")   | select(.result[0].defaultRoute.ipv4) | \"IP|\\(.result[0].ipv4[0:-3])\")
'"]
            stdout: SplitParser {
                onRead: d => {
                    var idx = d.indexOf("|")
                    if (idx < 0) return
                    win.addItem(d.substring(0, idx), d.substring(idx + 1))
                }
            }
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
                width: 580
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
