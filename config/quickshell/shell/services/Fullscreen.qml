pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root

    property var byWs: ({})

    function probe() {
        root.byWs = {};
    }

    readonly property var watched: ({
        fullscreen: true,
        workspace: true
    })

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (root.watched[event.name])
                Qt.callLater(root.probe);
        }
    }

    Component.onCompleted: root.probe()
}
