import QtQuick
import QtQuick.Layouts
import Quickshell

Rectangle {
    property QtObject sectionTheme

    Layout.preferredWidth: 24
    Layout.preferredHeight: 24
    color: "transparent"
    Layout.leftMargin: 8
    Layout.rightMargin: 0

    Text {
        anchors.centerIn: parent
        text: "\uf011"
        font.family: sectionTheme.fontFamily
        font.pixelSize: 14
        color: mouseArea.containsMouse ? "#f7768e" : sectionTheme.colFg
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: Quickshell.execDetached(["sh", "-c", "pgrep -f 'quickshell.*powermenu' | grep -v $$ > /dev/null || quickshell --config " + Quickshell.shellPath("../powermenu")])
    }
}
