import QtQuick
import QtQuick.Layouts
import Quickshell
import "sections" as Sections

RowLayout {
    property QtObject barTheme
    property QtObject barStats
    property QtObject trayWin

    anchors.fill: parent
    spacing: 0

    Item { width: 8 }

    Sections.AvatarSection { sectionTheme: barTheme }
    Item { width: 8 }
    Sections.WorkspaceBar { sectionTheme: barTheme }

    Sections.SectionDivider { sectionTheme: barTheme; marginLeft: 8; marginRight: 8 }
    Sections.LayoutLabel { sectionTheme: barTheme; sectionStats: barStats }
    Sections.SectionDivider { sectionTheme: barTheme; marginLeft: 2; marginRight: 8 }
    Sections.WindowTitle { sectionTheme: barTheme; sectionStats: barStats }

    Sections.KernelStat { sectionTheme: barTheme; sectionStats: barStats }
    Sections.SectionDivider { sectionTheme: barTheme }
    Sections.CpuStat { sectionTheme: barTheme; sectionStats: barStats }
    Sections.SectionDivider { sectionTheme: barTheme }
    Sections.MemStat { sectionTheme: barTheme; sectionStats: barStats }
    Sections.SectionDivider { sectionTheme: barTheme }
    Sections.DiskStat { sectionTheme: barTheme; sectionStats: barStats }
    Sections.SectionDivider { sectionTheme: barTheme }
    Sections.NetStat { sectionTheme: barTheme; sectionStats: barStats }
    Sections.SectionDivider { sectionTheme: barTheme }
    Sections.VolStat { sectionTheme: barTheme; sectionStats: barStats }
    Sections.SectionDivider { sectionTheme: barTheme }
    Sections.ClockWidget { sectionTheme: barTheme }
    Sections.SectionDivider { sectionTheme: barTheme }

    Sections.TrayWidget { sectionTheme: barTheme; sectionWin: trayWin; trayFontSize: 12 }
    Sections.SectionDivider { sectionTheme: barTheme; marginRight: 0 }
    Sections.PowerButton { sectionTheme: barTheme }

    Item { width: 8 }
}
