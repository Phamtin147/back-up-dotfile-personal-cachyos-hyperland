pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

// Four rounded black corners at the monitor screen boundaries (Top-Left, Top-Right, Bottom-Left, Bottom-Right)
// providing clean, modern rounded screen bezels.
PanelWindow {
    id: root

    required property var modelData

    property real radius: 18
    property color cornerColor: "#000000"

    screen: root.modelData
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "ryoku-screen-corners"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    anchors { top: true; bottom: true; left: true; right: true }

    // Empty mask ensures complete click-through for all mouse events
    mask: Region {}

    // Top-Left Corner
    Canvas {
        id: cTL
        width: root.radius
        height: root.radius
        anchors.top: parent.top
        anchors.left: parent.left
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            ctx.fillStyle = root.cornerColor;
            ctx.beginPath();
            ctx.moveTo(0, root.radius);
            ctx.arcTo(0, 0, root.radius, 0, root.radius);
            ctx.lineTo(0, 0);
            ctx.closePath();
            ctx.fill();
        }
        Connections {
            target: root
            function onRadiusChanged() { cTL.requestPaint(); }
            function onCornerColorChanged() { cTL.requestPaint(); }
        }
    }

    // Top-Right Corner
    Canvas {
        id: cTR
        width: root.radius
        height: root.radius
        anchors.top: parent.top
        anchors.right: parent.right
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            ctx.fillStyle = root.cornerColor;
            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.arcTo(root.radius, 0, root.radius, root.radius, root.radius);
            ctx.lineTo(root.radius, 0);
            ctx.closePath();
            ctx.fill();
        }
        Connections {
            target: root
            function onRadiusChanged() { cTR.requestPaint(); }
            function onCornerColorChanged() { cTR.requestPaint(); }
        }
    }

    // Bottom-Right Corner
    Canvas {
        id: cBR
        width: root.radius
        height: root.radius
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            ctx.fillStyle = root.cornerColor;
            ctx.beginPath();
            ctx.moveTo(root.radius, 0);
            ctx.arcTo(root.radius, root.radius, 0, root.radius, root.radius);
            ctx.lineTo(root.radius, root.radius);
            ctx.closePath();
            ctx.fill();
        }
        Connections {
            target: root
            function onRadiusChanged() { cBR.requestPaint(); }
            function onCornerColorChanged() { cBR.requestPaint(); }
        }
    }

    // Bottom-Left Corner
    Canvas {
        id: cBL
        width: root.radius
        height: root.radius
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        renderTarget: Canvas.FramebufferObject
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            ctx.fillStyle = root.cornerColor;
            ctx.beginPath();
            ctx.moveTo(root.radius, root.radius);
            ctx.arcTo(0, root.radius, 0, 0, root.radius);
            ctx.lineTo(0, root.radius);
            ctx.closePath();
            ctx.fill();
        }
        Connections {
            target: root
            function onRadiusChanged() { cBL.requestPaint(); }
            function onCornerColorChanged() { cBL.requestPaint(); }
        }
    }
}
