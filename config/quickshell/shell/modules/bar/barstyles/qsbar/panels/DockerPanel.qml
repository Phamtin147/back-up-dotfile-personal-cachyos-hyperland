import QtQuick
import QtQuick.Controls
import "../modules"
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Ryoku.Ui.Singletons

PanelWindow {
    id: dockerPanel
    required property var root

    screen: root.activePopupScreen

    color: "transparent"
    anchors { top: true; bottom: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "ryoku-docker"

    readonly property int barBottom: root.v2BarHeight
    readonly property int gap: 6

    property real reveal: root.dockerVisible ? 1 : 0
    Behavior on reveal {
        NumberAnimation {
            duration: root.dockerVisible ? 160 : 120
            easing.type: root.dockerVisible ? Easing.OutCubic : Easing.InCubic
        }
    }
    visible: reveal > 0.001
    WlrLayershell.keyboardFocus: root.dockerVisible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    Process { id: dockerActionProc }

    function runDockerAction(cmd) {
        dockerActionProc.command = ["bash", "-c", cmd]
        dockerActionProc.running = false
        dockerActionProc.running = true
        // Trigger widget refresh after short delay
        refreshTimer.restart()
    }

    Timer {
        id: refreshTimer
        interval: 1200
        repeat: false
        onTriggered: {
            // Force probe
            if (root.dockerVisible) {
                dockerActionProc.command = ["bash", "-c", "docker ps -a --format '{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.State}}' 2>/dev/null"]
            }
        }
    }

    component ContainerCard: Rectangle {
        id: cardRow
        required property var containerData
        property int itemIndex: 0

        width: parent ? parent.width : 0
        height: 64
        radius: 8
        color: root.fillIdle
        border.color: containerData.running ? Qt.rgba(root.seal.r, root.seal.g, root.seal.b, 0.25) : root.sep
        border.width: 1

        Row {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Status Indicator Dot
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 10
                height: 10
                radius: 5
                color: {
                    if (!containerData.running) return root.sumi
                    if (!containerData.healthy) return root.color03
                    return root.green
                }
            }

            // Container Info
            Column {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 20 - 130
                spacing: 3

                Row {
                    spacing: 6
                    width: parent.width

                    UiText {
                        text: containerData.name
                        color: root.ink
                        font.family: root.mono
                        font.pixelSize: 12
                        font.weight: Font.Bold
                        elide: Text.ElideRight
                    }

                    UiText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "(" + containerData.image + ")"
                        color: root.sumi
                        font.family: root.mono
                        font.pixelSize: 10
                        elide: Text.ElideRight
                    }
                }

                UiText {
                    text: containerData.status
                    color: containerData.running ? root.sumiHi : root.sumi
                    font.family: root.mono
                    font.pixelSize: 10
                    elide: Text.ElideRight
                }
            }

            // Quick Action Buttons
            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 4

                // Restart Button
                Rectangle {
                    width: 26
                    height: 26
                    radius: 6
                    color: restartBtnMa.containsMouse ? root.fillHover : "transparent"
                    border.width: 1
                    border.color: restartBtnMa.containsMouse ? root.seal : root.sep

                    Text {
                        anchors.centerIn: parent
                        text: "󰑐"
                        color: root.ink
                        font.family: root.mono
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: restartBtnMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dockerPanel.runDockerAction("docker restart " + containerData.name)
                    }
                }

                // Logs Button (Terminal)
                Rectangle {
                    width: 26
                    height: 26
                    radius: 6
                    color: logsBtnMa.containsMouse ? root.fillHover : "transparent"
                    border.width: 1
                    border.color: logsBtnMa.containsMouse ? root.seal : root.sep

                    Text {
                        anchors.centerIn: parent
                        text: "󰌱"
                        color: root.ink
                        font.family: root.mono
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: logsBtnMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dockerPanel.runDockerAction("kitty --title 'Logs: " + containerData.name + "' -e docker logs -f " + containerData.name)
                    }
                }

                // Shell / Exec Button
                Rectangle {
                    width: 26
                    height: 26
                    radius: 6
                    color: shellBtnMa.containsMouse ? root.fillHover : "transparent"
                    border.width: 1
                    border.color: shellBtnMa.containsMouse ? root.seal : root.sep

                    Text {
                        anchors.centerIn: parent
                        text: "󰆍"
                        color: root.ink
                        font.family: root.mono
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: shellBtnMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dockerPanel.runDockerAction("kitty --title 'Shell: " + containerData.name + "' -e docker exec -it " + containerData.name + " sh")
                    }
                }

                // Stop / Start Button
                Rectangle {
                    width: 26
                    height: 26
                    radius: 6
                    color: toggleBtnMa.containsMouse ? root.fillHover : "transparent"
                    border.width: 1
                    border.color: toggleBtnMa.containsMouse ? (containerData.running ? root.danger : root.green) : root.sep

                    Text {
                        anchors.centerIn: parent
                        text: containerData.running ? "󰓛" : "󰐊"
                        color: containerData.running ? (toggleBtnMa.containsMouse ? root.danger : root.ink) : root.green
                        font.family: root.mono
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: toggleBtnMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (containerData.running)
                                dockerPanel.runDockerAction("docker stop " + containerData.name)
                            else
                                dockerPanel.runDockerAction("docker start " + containerData.name)
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.dockerVisible = false
    }

    Rectangle {
        id: card
        width: 380
        height: Math.min(520, col.implicitHeight + 24)
        radius: reveal > 0.001 ? root.panelRadius : 0
        color: "transparent"
        border.color: root.panelBorder
        border.width: 0

        PillShadow { theme: root }
        ConnectedPanelSurface {
            root: dockerPanel.root
            ownerActive: dockerPanel.root.dockerVisible
            targetX: dockerPanel.root.dockerBarX
            reveal: dockerPanel.reveal
        }

        x: Math.round(Math.max(6, Math.min(root.dockerBarX - width / 2, parent.width - width - 6)))
        y: root.barPosition === "bottom"
            ? (parent.height - barBottom - gap - height) + 2 * (1 - dockerPanel.reveal)
            : (barBottom + gap) - 2 * (1 - dockerPanel.reveal)
        opacity: dockerPanel.reveal
        focus: root.dockerVisible

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Escape) {
                root.dockerVisible = false
                event.accepted = true
            }
        }

        MouseArea { anchors.fill: parent; onClicked: {} }

        Column {
            id: col
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            // Header Row
            Item {
                width: parent.width
                height: 26

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "\uf308"
                        color: root.seal
                        font.family: root.mono
                        font.pixelSize: 16
                    }

                    UiText {
                        anchors.verticalCenter: parent.verticalCenter
                        text: I18n.tr("DOCKER")
                        color: root.ink
                        font.family: root.mono
                        font.pixelSize: 13
                        font.letterSpacing: 2
                        font.weight: Font.Bold
                    }

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        height: 18
                        width: tagText.implicitWidth + 10
                        radius: 4
                        color: root.dockerDaemonActive ? (root.dockerRunningCount > 0 ? root.fillActive : root.fillIdle) : Qt.rgba(root.danger.r, root.danger.g, root.danger.b, 0.2)

                        UiText {
                            id: tagText
                            anchors.centerIn: parent
                            text: root.dockerDaemonActive ? (root.dockerRunningCount + I18n.tr(" RUNNING")) : I18n.tr("OFFLINE")
                            color: root.dockerDaemonActive ? (root.dockerRunningCount > 0 ? root.seal : root.sumi) : root.danger
                            font.family: root.mono
                            font.pixelSize: 9
                            font.weight: Font.Medium
                        }
                    }
                }

                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 6

                    // Open Terminal / LazyDocker Button
                    Rectangle {
                        width: 26
                        height: 26
                        radius: 6
                        color: termBtnMa.containsMouse ? root.fillHover : "transparent"
                        border.width: 1
                        border.color: termBtnMa.containsMouse ? root.seal : root.sep

                        Text {
                            anchors.centerIn: parent
                            text: "󰆍"
                            color: root.ink
                            font.family: root.mono
                            font.pixelSize: 13
                        }

                        MouseArea {
                            id: termBtnMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                dockerPanel.runDockerAction("if command -v lazydocker &>/dev/null; then kitty --title 'LazyDocker' lazydocker; else kitty --title 'Docker Containers' bash -c 'docker ps -a; echo \"\"; read -p \"Press Enter to close...\"'; fi")
                                root.dockerVisible = false
                            }
                        }
                    }

                    // Close Button
                    UiText {
                        text: "✕"
                        color: closeMa.containsMouse ? root.seal : root.sumi
                        font.pixelSize: 13
                        font.family: root.mono

                        MouseArea {
                            id: closeMa
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.dockerVisible = false
                        }
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: root.sep }

            // Overview Metric Summary
            Row {
                width: parent.width
                height: 28

                Repeater {
                    model: [
                        { label: "RUNNING", value: String(root.dockerRunningCount), color: root.dockerRunningCount > 0 ? root.green : root.sumi },
                        { label: "TOTAL", value: String(root.dockerContainers ? root.dockerContainers.length : 0), color: root.ink },
                        { label: "DAEMON", value: root.dockerDaemonActive ? "ACTIVE" : "STOPPED", color: root.dockerDaemonActive ? root.green : root.danger }
                    ]
                    delegate: Item {
                        required property var modelData
                        width: col.width / 3
                        height: 28

                        UiText {
                            anchors.top: parent.top
                            text: I18n.tr(modelData.label)
                            color: root.sumi
                            font.family: root.mono
                            font.pixelSize: 9
                            font.letterSpacing: 1
                        }

                        UiText {
                            anchors.bottom: parent.bottom
                            text: modelData.value
                            color: modelData.color
                            font.family: root.mono
                            font.pixelSize: 11
                            font.weight: Font.Medium
                        }
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: root.sep }

            // Empty / Offline State
            Column {
                width: parent.width
                spacing: 8
                visible: !root.dockerDaemonActive || (root.dockerContainers && root.dockerContainers.length === 0)

                Item { width: 1; height: 6 }

                UiText {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: !root.dockerDaemonActive ? I18n.tr("Docker daemon is not running") : I18n.tr("No Docker containers found")
                    color: root.sumiHi
                    font.family: root.mono
                    font.pixelSize: 11
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: startDockerText.implicitWidth + 24
                    height: 28
                    radius: 6
                    color: startDockerMa.containsMouse ? root.fillPrimaryHover : root.seal
                    visible: !root.dockerDaemonActive

                    UiText {
                        id: startDockerText
                        anchors.centerIn: parent
                        text: I18n.tr("Start Docker Daemon")
                        color: root.paper
                        font.family: root.mono
                        font.pixelSize: 11
                        font.weight: Font.Bold
                    }

                    MouseArea {
                        id: startDockerMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dockerPanel.runDockerAction("systemctl start docker || pkexec systemctl start docker")
                    }
                }

                Item { width: 1; height: 6 }
            }

            // Container List Flickable
            Flickable {
                width: parent.width
                height: Math.min(320, containerColumn.implicitHeight)
                contentWidth: width
                contentHeight: containerColumn.implicitHeight
                clip: true
                visible: root.dockerDaemonActive && root.dockerContainers && root.dockerContainers.length > 0
                boundsBehavior: Flickable.StopAtBounds

                Column {
                    id: containerColumn
                    width: parent.width
                    spacing: 6

                    Repeater {
                        model: root.dockerContainers || []
                        delegate: ContainerCard {
                            required property var modelData
                            required property int index
                            containerData: modelData
                            itemIndex: index
                        }
                    }
                }
            }

            // Bottom Actions
            Rectangle { width: parent.width; height: 1; color: root.sep }

            Row {
                width: parent.width
                height: 28
                spacing: 8

                Rectangle {
                    width: (parent.width - 8) / 2
                    height: 26
                    radius: 6
                    color: pruneBtnMa.containsMouse ? root.fillHover : root.fillIdle
                    border.width: 1
                    border.color: pruneBtnMa.containsMouse ? root.seal : root.sep

                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Text { text: "󰃢"; color: root.ink; font.family: root.mono; font.pixelSize: 11 }
                        UiText { text: I18n.tr("Prune Unused"); color: root.ink; font.family: root.mono; font.pixelSize: 10 }
                    }

                    MouseArea {
                        id: pruneBtnMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dockerPanel.runDockerAction("docker system prune -f")
                    }
                }

                Rectangle {
                    width: (parent.width - 8) / 2
                    height: 26
                    radius: 6
                    color: termFullBtnMa.containsMouse ? root.fillHover : root.fillIdle
                    border.width: 1
                    border.color: termFullBtnMa.containsMouse ? root.seal : root.sep

                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Text { text: "󰆍"; color: root.ink; font.family: root.mono; font.pixelSize: 11 }
                        UiText { text: I18n.tr("Open Manager"); color: root.ink; font.family: root.mono; font.pixelSize: 10 }
                    }

                    MouseArea {
                        id: termFullBtnMa
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            dockerPanel.runDockerAction("if command -v lazydocker &>/dev/null; then kitty --title 'LazyDocker' lazydocker; else kitty --title 'Docker Containers' bash -c 'docker ps -a; echo \"\"; read -p \"Press Enter to close...\"'; fi")
                            root.dockerVisible = false
                        }
                    }
                }
            }
        }
    }
}
