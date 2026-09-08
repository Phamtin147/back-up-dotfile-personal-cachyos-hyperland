import QtQuick
import Quickshell
import Quickshell.Io
import Ryoku.Ui.Singletons

Item {
    id: rootMod
    required property var root
    readonly property color contentColor: root.widgetContentColor("G19", root.widgetIconColor)

    property bool dockerActive: false
    property int runningCount: 0
    property int totalCount: 0
    property var containerList: []
    property string tooltipDetails: ""

    readonly property string tooltipText: {
        if (!dockerActive)
            return I18n.tr("Docker daemon is inactive")
        if (runningCount === 0)
            return I18n.tr("Docker · 0 containers running")
        return I18n.tr("Docker · ") + runningCount + I18n.tr(" running") + (tooltipDetails ? (" (" + tooltipDetails + ")") : "")
    }

    visible: implicitWidth > 0.5
    implicitWidth: root.modDocker ? (row.implicitWidth + 18) : 0
    implicitHeight: 28
    opacity: root.modDocker ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 5

        // Docker Whale / Container Glyph (Nerd Font)
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "\uf308" // 
            color: rootMod.dockerActive
                ? (rootMod.runningCount > 0
                    ? (root.widgetHasFill("G19") ? rootMod.contentColor : root.seal)
                    : Qt.rgba(rootMod.contentColor.r, rootMod.contentColor.g, rootMod.contentColor.b, 0.75))
                : Qt.rgba(rootMod.contentColor.r, rootMod.contentColor.g, rootMod.contentColor.b, 0.35)
            font.family: root.mono
            font.pixelSize: 15
            renderType: Text.NativeRendering
            Behavior on color { ColorAnimation { duration: 200 } }
        }

        UiText {
            anchors.verticalCenter: parent.verticalCenter
            visible: rootMod.dockerActive && rootMod.runningCount > 0 && !root.iconOnly("G19")
            text: String(rootMod.runningCount)
            color: root.widgetHasFill("G19") ? rootMod.contentColor : root.seal
            font.family: root.mono
            font.pixelSize: 12
            font.weight: Font.Medium
        }
    }

    Process {
        id: probeProc
        command: [
            "bash", "-c",
            "if ! command -v docker &>/dev/null; then " +
            "  echo 'ERR_NO_DOCKER'; " +
            "elif ! docker info &>/dev/null; then " +
            "  echo 'ERR_INACTIVE'; " +
            "else " +
            "  docker ps -a --format '{{.ID}}\\t{{.Names}}\\t{{.Image}}\\t{{.Status}}\\t{{.State}}' 2>/dev/null; " +
            "fi"
        ]
        running: false
        property string rawOutput: ""

        stdout: SplitParser {
            onRead: function(line) {
                if (line) {
                    if (probeProc.rawOutput.length > 0)
                        probeProc.rawOutput += "\n" + line
                    else
                        probeProc.rawOutput = line
                }
            }
        }

        onExited: {
            var out = probeProc.rawOutput.trim()
            probeProc.rawOutput = ""

            if (out === "ERR_NO_DOCKER" || out === "ERR_INACTIVE") {
                rootMod.dockerActive = false
                rootMod.runningCount = 0
                rootMod.totalCount = 0
                rootMod.containerList = []
                rootMod.tooltipDetails = ""
                root.dockerDaemonActive = false
                root.dockerRunningCount = 0
                root.dockerContainers = []
                return
            }

            rootMod.dockerActive = true
            root.dockerDaemonActive = true

            if (out === "") {
                rootMod.runningCount = 0
                rootMod.totalCount = 0
                rootMod.containerList = []
                rootMod.tooltipDetails = ""
                root.dockerRunningCount = 0
                root.dockerContainers = []
                return
            }

            var lines = out.split("\n")
            var parsed = []
            var running = 0
            var runningNames = []

            for (var i = 0; i < lines.length; i++) {
                var line = lines[i].trim()
                if (!line) continue
                var parts = line.split("\t")
                if (parts.length >= 5) {
                    var id = parts[0]
                    var name = parts[1]
                    var image = parts[2]
                    var status = parts[3]
                    var state = parts[4].toLowerCase()
                    var isRunning = state === "running"

                    if (isRunning) {
                        running++
                        runningNames.push(name)
                    }

                    parsed.push({
                        id: id,
                        name: name,
                        image: image,
                        status: status,
                        state: state,
                        running: isRunning,
                        healthy: status.indexOf("unhealthy") === -1
                    })
                }
            }

            rootMod.totalCount = parsed.length
            rootMod.runningCount = running
            rootMod.containerList = parsed
            rootMod.tooltipDetails = runningNames.slice(0, 3).join(", ") + (runningNames.length > 3 ? "..." : "")

            root.dockerRunningCount = running
            root.dockerContainers = parsed
        }
    }

    Timer {
        interval: (rootMod.visible || root.dockerVisible) ? 3500 : 12000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!probeProc.running) {
                probeProc.rawOutput = ""
                probeProc.running = true
            }
        }
    }

    Connections {
        target: root
        function onDockerVisibleChanged() {
            if (root.dockerVisible && !probeProc.running) {
                probeProc.rawOutput = ""
                probeProc.running = true
            }
        }
    }

    TooltipMixin { id: tip; root: rootMod.root; owner: rootMod; text: rootMod.tooltipText }

    Process {
        id: termRunner
        command: [
            "bash", "-c",
            "if command -v lazydocker &>/dev/null; then " +
            "  kitty --title 'LazyDocker' lazydocker; " +
            "else " +
            "  kitty --title 'Docker Containers' bash -c 'docker ps -a; echo \"\"; read -p \"Press Enter to close...\"'; " +
            "fi"
        ]
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onEntered: tip.show()
        onExited: tip.hide()
        onClicked: (e) => {
            tip.hide()
            if (e.button === Qt.RightButton) {
                termRunner.running = false
                termRunner.running = true
            } else {
                root.dockerVisible = !root.dockerVisible
            }
        }
    }
}
