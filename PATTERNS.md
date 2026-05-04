# Quickshell 项目模式参考

## 模块与入口

### 子配置模式
每个独立的 Quickshell 窗口需要一个包含 `shell.qml` 的目录作为配置入口。
新建独立窗口时，创建一个子目录 + `shell.qml` 符号链接：

```
newmodule/
  shell.qml -> ../ActualModule.qml
```

运行：`quickshell --config newmodule/`

### 组件数据流
主状态栏的数据传递：`shell.qml` 中实例化 Theme 和 StatsProvider，通过显式属性传递给 BarContent：

```qml
Theme { id: theme }
StatsProvider { id: stats }

BarContent {
    barTheme: theme
    barStats: stats
    trayWin: win
}
```

BarContent 内用 `barTheme.colFg` / `barStats.cpuUsage` 访问数据。

### 属性命名约定
传递给子组件（跨文件）的属性必须加前缀避免与父作用域 id 冲突：
- `barTheme` ← 不要用 `theme`（与 Theme id 冲突）
- `barStats` ← 不要用 `stats`
- `trayWin`  ← 不要用 `win`

---

## 窗口类型选择

| 用途 | 类型 | 说明 |
|------|------|------|
| 状态栏 | `PanelWindow` | 边缘吸附，anchors top/left/right |
| 浮动覆盖层 | `PanelWindow` + `WlrLayershell` | 全屏覆盖，layer: Overlay |
| 对话框/弹出 | `FloatingWindow` | 浮动窗口，不支持层 Shell |

### 覆盖层窗口（不被 tile）
```qml
import Quickshell.Wayland

PanelWindow {
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    // 半透明遮罩 + 居中内容
}
```

---

## 系统监控模式

### Process + Timer 差分计算
```qml
Item {  // 必须用 Item，QtObject 不能容纳 Process/Timer
    id: stats

    property int someValue: 0
    property var lastValue: 0

    Process {
        id: someProc
        command: ["command", "args"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                // 解析 data
                if (lastValue > 0) {
                    someValue = 计算差值(data - lastValue)
                }
                lastValue = 更新
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: someProc.running = true
    }
}
```

### CPU 使用率（差分 /proc/stat）
```qml
command: ["sh", "-c", "head -1 /proc/stat"]
// 解析 7 列: user nice system idle iowait irq softirq
// idleTime = idle + iowait
// total = sum of all
// cpuUsage = 100 * (totalDiff - idleDiff) / totalDiff
```

### 网络速度（差分 /proc/net/dev）
```qml
command: ["sh", "-c", "awk 'NR>2 && $1!=\"lo:\"{print $2,$10;exit}' /proc/net/dev"]
// rx_bytes tx_bytes
// downMbps = (rx - lastRx) * 8 / 1000000 / dt
// upMbps = (tx - lastTx) * 8 / 1000000 / dt
// 使用阈值 netThreshold 控制更新
```

### 主动窗口 / 布局（Hyprland IPC）
```qml
// 事件驱动 + 回退轮询双保证
Connections {
    target: Hyprland
    function onRawEvent(event) { windowProc.running = true }
}
Timer { interval: 200; repeat: true; onTriggered: windowProc.running = true }
```

---

## 系统托盘

### ObjectModel 委托访问
```qml
Repeater {
    model: SystemTray.items
    delegate: Item {
        // 使用 model.modelData 访问 SystemTrayItem
        source: model.modelData.icon
        onClicked: model.modelData.activate()
    }
}
```

### Nerd Font 图标映射
```qml
property var nerdfontMap: ({
    "fcitx5": "\uf11c",
    "nm-applet": "\uf1eb",
})

property string mappedIcon: nerdfontMap[model.modelData.id] || ""

Image {
    visible: !mappedIcon.length
    source: model.modelData.icon
}
Text {
    visible: mappedIcon.length
    text: mappedIcon
    font.family: barTheme.fontFamily
    font.pixelSize: 16
}
```

### 右键菜单
```qml
MouseArea {
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: (mouse) => {
        if (mouse.button === Qt.LeftButton) model.modelData.activate()
        else if (mouse.button === Qt.RightButton && model.modelData.hasMenu) {
            var pos = mapToItem(null, mouse.x, mouse.y)
            model.modelData.display(win, pos.x, pos.y)
        }
    }
}
```

---

## 进程执行

### 启动独立进程（bar 内部启动其他配置）
```qml
Quickshell.execDetached(["quickshell", "--config", Quickshell.shellPath("../subconfig")])
```

### 按钮执行命令（PowerMenu 模式）
```qml
function run(cmd) {
    Quickshell.execDetached({ command: cmd.split(" ") })
    Qt.callLater(Qt.quit)  // 窗口退出前启动命令
}
```

---

## Pragmas

```qml
//@ pragma UseQApplication  // 平台菜单（系统托盘右键）
//@ pragma AppId my-app-id      // 自定义窗口识别（Hyprland windowrule 匹配）
```

---

## 注意事项

- **避免硬编码路径**：使用 `Quickshell.shellPath()` / `Quickshell.shellDir` 构造相对路径
- **属性绑定循环**：组件属性名不要与父作用域 id 相同
- **QML 文件布局**：同级目录的 `.qml` 文件自动可导入，无需显式 import
