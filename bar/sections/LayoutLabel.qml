import QtQuick
import QtQuick
import QtQuick.Layouts

Text {
    property QtObject sectionTheme
    property QtObject sectionStats

    text: sectionStats.currentLayout
    color: sectionTheme.colFg
    font.pixelSize: sectionTheme.fontSize
    font.family: sectionTheme.fontFamily
    font.bold: true
    Layout.leftMargin: 5
    Layout.rightMargin: 5
}
