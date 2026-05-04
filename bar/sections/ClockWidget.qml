import QtQuick
import QtQuick.Layouts

Text {
    property QtObject sectionTheme

    id: clockText
    text: Qt.formatDateTime(new Date(), "ddd MM-dd HH:mm")
    color: sectionTheme.colCyan
    font.pixelSize: sectionTheme.fontSize
    font.family: sectionTheme.fontFamily
    font.bold: true
    Layout.rightMargin: 8

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clockText.text = Qt.formatDateTime(new Date(), "ddd MM-dd HH:mm")
    }
}
