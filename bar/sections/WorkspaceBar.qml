import QtQuick
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    property QtObject sectionTheme
    spacing: 0

    Repeater {
        model: 9

        Rectangle {
            Layout.preferredWidth: 20
            Layout.preferredHeight: parent.parent.height
            color: "transparent"

            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property bool hasWindows: workspace !== null

            Text {
                text: index + 1
                color: parent.isActive ? sectionTheme.colCyan : (parent.hasWindows ? sectionTheme.colCyan : sectionTheme.colMuted)
                font.pixelSize: sectionTheme.fontSize
                font.family: sectionTheme.fontFamily
                font.bold: true
                anchors.centerIn: parent
            }

            Rectangle {
                width: 20
                height: 3
                color: parent.isActive ? sectionTheme.colPurple : sectionTheme.colBg
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
            }
        }
    }
}
