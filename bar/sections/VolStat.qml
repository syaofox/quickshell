import QtQuick
import QtQuick
import QtQuick.Layouts

Text {
    property QtObject sectionTheme
    property QtObject sectionStats
    text: "Vol " + sectionStats.volumeLevel + "%"
    color: sectionTheme.colPurple
    font.pixelSize: sectionTheme.fontSize
    font.family: sectionTheme.fontFamily
    font.bold: true
    Layout.rightMargin: 8
}
