import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: rootMod
    required property var root

    readonly property int percent: root.systemCpuPercent
    readonly property color dynamicColor: rootMod.percent >= 80 ? "#ef4444"
        : rootMod.percent >= 60 ? "#eab308"
        : root.widgetIconColor
    readonly property color contentColor: root.widgetContentColor("G5", dynamicColor)
    readonly property string tooltipText: "CPU · " + rootMod.percent + "%"

    visible: implicitWidth > 0.5
    implicitWidth: root.modCpu ? (row.implicitWidth + 18) : 0
    implicitHeight: 28
    opacity: root.modCpu ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        IconText {
            anchors.verticalCenter: parent.verticalCenter
            text: "planner_review"
            color: rootMod.contentColor
            Behavior on color { ColorAnimation { duration: 250 } }
            font.pixelSize: 15
            font.weight: Font.DemiBold
            fill: 1
        }

        UiText {
            visible: false
            anchors.verticalCenter: parent.verticalCenter
            text: String(Math.min(100, rootMod.percent)).padStart(2, "0") + "%"
            color: rootMod.contentColor
            Behavior on color { ColorAnimation { duration: 250 } }
            font.family: root.mono
            font.pixelSize: 12
        }
    }

    TooltipMixin { id: tip; root: rootMod.root; owner: rootMod; text: rootMod.tooltipText }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: tip.show()
        onExited: tip.hide()
        onClicked: { tip.hide(); root.cpuVisible = !root.cpuVisible }
    }
}
