import QtQuick
import QtQuick
import QtQuick.Layouts

Text {
    property QtObject sectionTheme
    property QtObject sectionStats
    text: "Disk: " + sectionStats.diskUsage + "%"
    color: sectionTheme.colBlue
    font.pixelSize: sectionTheme.fontSize
    font.family: sectionTheme.fontFamily
    font.bold: true
    Layout.rightMargin: 8
}
