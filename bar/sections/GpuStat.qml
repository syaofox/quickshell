import QtQuick
import QtQuick.Layouts

Text {
    property QtObject sectionTheme
    property QtObject sectionStats

    visible: sectionStats.gpuUsage >= 0
    text: "GPU " + sectionStats.gpuUsage + "% VRAM " + sectionStats.gpuMemUsed + "/" + sectionStats.gpuMemTotal + "MiB"
    color: sectionTheme.colGreen
    font.pixelSize: sectionTheme.fontSize
    font.family: sectionTheme.fontFamily
    font.bold: true
    Layout.rightMargin: 8
}
