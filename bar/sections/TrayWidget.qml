import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray

RowLayout {
    property QtObject sectionTheme
    property QtObject sectionWin
    property int trayFontSize: 16

    spacing: 0

    property var nerdfontMap: ({
        "fcitx5": "\uf11c",
        "nm-applet": "\uf1eb",
    })

    Repeater {
        model: SystemTray.items

        delegate: Item {
            implicitWidth: 24
            implicitHeight: 24

            property string mappedIcon: nerdfontMap[model.modelData.id] || ""

            Image {
                anchors {
                    fill: parent
                    topMargin: 4; bottomMargin: 4
                    leftMargin: 0; rightMargin: 0
                }
                visible: !mappedIcon.length
                source: model.modelData.icon
                fillMode: Image.PreserveAspectFit
            }

            Text {
                anchors.centerIn: parent
                visible: mappedIcon.length
                text: mappedIcon
                font.family: sectionTheme.fontFamily
                font.pixelSize: trayFontSize
                color: sectionTheme.colFg
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        model.modelData.activate()
                    } else if (mouse.button === Qt.RightButton && model.modelData.hasMenu) {
                        var pos = mapToItem(null, mouse.x, mouse.y)
                        model.modelData.display(sectionWin, pos.x, pos.y)
                    }
                }
            }
        }
    }
}
