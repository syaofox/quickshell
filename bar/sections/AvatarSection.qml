import QtQuick
import Quickshell
import QtQuick.Layouts

Rectangle {
    property QtObject sectionTheme

    Layout.preferredWidth: 24
    Layout.preferredHeight: 24
    color: "transparent"

    Image {
        anchors {
            fill: parent
            margins: sectionTheme.iconMargin
        }
        source: "file:///home/syaofox/.config/quickshell/icons/syaofox.png"
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["sh", "-c", "pgrep -f 'quickshell.*sysinfo' | grep -v $$ > /dev/null || quickshell --config " + Quickshell.shellPath("../sysinfo")])
    }
}
