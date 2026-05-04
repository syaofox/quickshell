import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray

RowLayout {
    property QtObject barTheme
    property QtObject barStats
    property QtObject trayWin

    anchors.fill: parent
    spacing: 0

    property int trayFontSize: 12
    property var nerdfontMap: ({
        "nm-applet": "󰈀",
    })

    Item { width: 8 }

    Rectangle {
        Layout.preferredWidth: 24
        Layout.preferredHeight: 24
        color: "transparent"

        Image {
            anchors {
                fill: parent
                margins: barTheme.iconMargin
            }
            source: "file:///home/syaofox/.config/quickshell/icons/syaofox.png"
            fillMode: Image.PreserveAspectFit
        }

        MouseArea {
            anchors.fill: parent
            onClicked: Quickshell.execDetached(["quickshell", "--config", Quickshell.shellPath("../powermenu")])
        }
    }

    Item { width: 8 }

    Repeater {
        model: 9

        Rectangle {
            Layout.preferredWidth: 20
            Layout.preferredHeight: parent.height
            color: "transparent"

            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property bool hasWindows: workspace !== null

            Text {
                text: index + 1
                color: parent.isActive ? barTheme.colCyan : (parent.hasWindows ? barTheme.colCyan : barTheme.colMuted)
                font.pixelSize: barTheme.fontSize
                font.family: barTheme.fontFamily
                font.bold: true
                anchors.centerIn: parent
            }

            Rectangle {
                width: 20
                height: 3
                color: parent.isActive ? barTheme.colPurple : barTheme.colBg
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
            }
        }
    }

    Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 8
        Layout.rightMargin: 8
        color: barTheme.colMuted
    }

    Text {
        text: barStats.currentLayout
        color: barTheme.colFg
        font.pixelSize: barTheme.fontSize
        font.family: barTheme.fontFamily
        font.bold: true
        Layout.leftMargin: 5
        Layout.rightMargin: 5
    }

    Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 2
        Layout.rightMargin: 8
        color: barTheme.colMuted
    }

    Text {
        text: barStats.activeWindow
        color: barTheme.colPurple
        font.pixelSize: barTheme.fontSize
        font.family: barTheme.fontFamily
        font.bold: true
        Layout.fillWidth: true
        Layout.leftMargin: 8
        elide: Text.ElideRight
        maximumLineCount: 1
    }

    Text {
        text: barStats.kernelVersion
        color: barTheme.colRed
        font.pixelSize: barTheme.fontSize
        font.family: barTheme.fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }

    Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 0
        Layout.rightMargin: 8
        color: barTheme.colMuted
    }

    Text {
        text: "CPU: " + barStats.cpuUsage + "%"
        color: barTheme.colYellow
        font.pixelSize: barTheme.fontSize
        font.family: barTheme.fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }

    Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 0
        Layout.rightMargin: 8
        color: barTheme.colMuted
    }

    Text {
        text: "Mem: " + barStats.memUsage + "%"
        color: barTheme.colCyan
        font.pixelSize: barTheme.fontSize
        font.family: barTheme.fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }

    Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 0
        Layout.rightMargin: 8
        color: barTheme.colMuted
    }

    Text {
        text: "Disk: " + barStats.diskUsage + "%"
        color: barTheme.colBlue
        font.pixelSize: barTheme.fontSize
        font.family: barTheme.fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }

    Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 0
        Layout.rightMargin: 8
        color: barTheme.colMuted
    }

    Text {
        text: "↓" + barStats.netDown + " ↑" + barStats.netUp
        color: barTheme.colGreen
        font.pixelSize: barTheme.fontSize
        font.family: barTheme.fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }

    Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 0
        Layout.rightMargin: 8
        color: barTheme.colMuted
    }

    Text {
        text: "Vol: " + barStats.volumeLevel + "%"
        color: barTheme.colPurple
        font.pixelSize: barTheme.fontSize
        font.family: barTheme.fontFamily
        font.bold: true
        Layout.rightMargin: 8
    }

    Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 0
        Layout.rightMargin: 8
        color: barTheme.colMuted
    }

    Text {
        id: clockText
        text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
        color: barTheme.colCyan
        font.pixelSize: barTheme.fontSize
        font.family: barTheme.fontFamily
        font.bold: true
        Layout.rightMargin: 8

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
        }
    }

    Rectangle {
        Layout.preferredWidth: 1
        Layout.preferredHeight: 16
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: 0
        Layout.rightMargin: 8
        color: barTheme.colMuted
    }

    RowLayout {
        spacing: 0

        Repeater {
            model: SystemTray.items
            delegate: Item {
                implicitWidth: 24
                implicitHeight: 24

                property string mappedIcon: nerdfontMap[model.modelData.id] || ""

                Image {
                    anchors {
                        fill: parent
                        topMargin: 4
                        bottomMargin: 4
                        leftMargin: 0
                        rightMargin: 0
                    }
                    visible: !mappedIcon.length
                    source: model.modelData.icon
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    anchors.centerIn: parent
                    visible: mappedIcon.length
                    text: mappedIcon
                    font.family: barTheme.fontFamily
                    font.pixelSize: trayFontSize
                    color: barTheme.colFg
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: (mouse) => {
                        if (mouse.button === Qt.LeftButton) {
                            model.modelData.activate()
                        } else if (mouse.button === Qt.RightButton && model.modelData.hasMenu) {
                            var pos = mapToItem(null, mouse.x, mouse.y)
                            model.modelData.display(trayWin, pos.x, pos.y)
                        }
                    }
                }
            }
        }
    }

    Item { width: 8 }
}
