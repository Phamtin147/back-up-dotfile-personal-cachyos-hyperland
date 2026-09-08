pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import shell.services
import Ryoku.Ui.Singletons

PanelWindow {
    id: win

    required property var modelData
    required property string kind
    readonly property real us: Tokens.uiScaleFor(modelData ? modelData.name : "")
    readonly property real pad: 14 * win.us
    readonly property real osdScale: Config.barStyle === "nacre"
        ? Config.normalizedNacre.osdScale : 1
    readonly property real slide: 16 * win.us

    readonly property bool monFullscreen: {
        var mons = Hyprland.monitors.values;
        for (var i = 0; i < mons.length; i++)
            if (mons[i].name === (modelData ? modelData.name : ""))
                return mons[i].activeWorkspace ? (Fullscreen.byWs[mons[i].activeWorkspace.id] === true) : false;
        return false;
    }

    property real prog: (osd.flashing && !win.monFullscreen) ? 1 : 0
    Behavior on prog { NumberAnimation { duration: Motion.effects; easing.type: Easing.OutCubic } }

    screen: modelData
    visible: win.prog > 0.01 || osd.flashing
    color: "transparent"
    exclusionMode: ExclusionMode.Normal
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.namespace: "ryoku-osd"

    // Anchored at Top Center (just below the top bar)
    anchors.top: true
    anchors.left: true
    anchors.right: true
    margins.top: 48 * win.osdScale * win.us

    implicitHeight: box.height * win.osdScale + win.slide * win.osdScale

    Rectangle {
        id: box
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: osd.implicitWidth + win.pad * 2
        height: osd.implicitHeight + win.pad * 2
        radius: Theme.radiusWindow * win.us
        color: Theme.surface
        opacity: Theme.windowOpacity * win.prog
        border.width: Theme.borderWidth
        border.color: Theme.outline
        antialiasing: true
        scale: win.osdScale
        transformOrigin: Item.Top
        transform: Translate { y: (win.prog - 1) * win.slide * win.osdScale }

        Osd {
            id: osd
            anchors.fill: parent
            anchors.margins: win.pad
            kind: win.kind
            us: win.us
            suppressed: win.monFullscreen
        }
    }

    mask: Region {}
}
