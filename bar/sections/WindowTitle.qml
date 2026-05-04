import QtQuick
import QtQuick
import QtQuick.Layouts

Text {
    property QtObject sectionTheme
    property QtObject sectionStats

    text: sectionStats.activeWindow
    color: sectionTheme.colPurple
    font.pixelSize: sectionTheme.fontSize
    font.family: sectionTheme.fontFamily
    font.bold: true
    Layout.fillWidth: true
    Layout.leftMargin: 8
    elide: Text.ElideRight
    maximumLineCount: 1
}
