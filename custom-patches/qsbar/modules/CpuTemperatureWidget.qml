import QtQuick

Item {
    id: rootMod
    required property var root

    readonly property int temperature: root.barTemperatureC
    readonly property color dynamicColor: rootMod.temperature >= 80 ? "#ef4444"
        : rootMod.temperature >= 68 ? "#eab308"
        : root.widgetIconColor
    readonly property color contentColor: root.widgetContentColor("G16", dynamicColor)

    readonly property string sourceLabel: root.barTemperatureSourceLabel(root.barTemperatureSource)
    readonly property string tooltipText: sourceLabel + " · " + temperature + "°C"

    visible: implicitWidth > 0.5
    implicitWidth: root.modCpuTemperature && root.barTemperatureAvailable
        ? row.implicitWidth + 18
        : 0
    implicitHeight: 28
    opacity: root.modCpuTemperature && root.barTemperatureAvailable ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        UiText {
            visible: false
            text: ""
            color: rootMod.contentColor
            Behavior on color { ColorAnimation { duration: 250 } }
            font.family: root.mono
            font.pixelSize: 13
            font.weight: Font.Light
            font.hintingPreference: Font.PreferFullHinting
        }

        UiText {
            visible: false
            anchors.verticalCenter: parent.verticalCenter
            text: rootMod.temperature + "°"
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
        onClicked: { tip.hide(); root.thermalVisible = !root.thermalVisible }
    }
}
