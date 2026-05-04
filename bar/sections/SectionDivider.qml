import QtQuick
import QtQuick.Layouts

import QtQuick
import QtQuick.Layouts

Rectangle {
    property QtObject sectionTheme
    property int marginLeft: 0
    property int marginRight: 8

    Layout.preferredWidth: 1
    Layout.preferredHeight: 16
    Layout.alignment: Qt.AlignVCenter
    Layout.leftMargin: marginLeft
    Layout.rightMargin: marginRight
    color: sectionTheme.colMuted
}
