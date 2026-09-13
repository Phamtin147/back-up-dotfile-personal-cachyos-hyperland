import QtQuick

// Disabled: user requested removal of the update icon from the bar
Item {
    id: rootMod
    required property var root
    readonly property color contentColor: root.widgetContentColor("G8", root.seal)

    property bool updateAvailable: false
    property int  pending: 0
    property string channel: ""
    property string installed: ""
    property string latest: ""
    property var commits: []

    visible: false
    implicitWidth: 0
    implicitHeight: 0
}
