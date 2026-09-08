pragma ComponentBehavior: Bound

import QtQuick
import Quickshell.Services.Pipewire
import shell.services
import "../../components"

Item {
    id: root

    property string kind: "volume"          // volume | mic | brightness
    property bool suppressed: false
    property real us: 1

    readonly property bool isVolume: kind === "volume"
    readonly property bool isMic: kind === "mic"
    readonly property bool isBrightness: kind === "brightness"

    readonly property var device: isVolume ? Pipewire.defaultAudioSink
        : isMic ? Pipewire.defaultAudioSource : null
    readonly property var audio: (device && device.audio) ? device.audio : null
    readonly property bool muted: audio ? audio.muted : false
    readonly property real maxValue: (isVolume && Config.qsbar
        && Config.qsbar.audioBoost === true) ? 1.5 : 1.0
    readonly property real value: isBrightness
        ? OsdFeed.brightness
        : (audio ? Math.max(0, Math.min(root.maxValue, audio.volume)) : 0)
    readonly property bool over: root.value > 1.005

    // Smooth cubic animation on value change
    property real animatedValue: root.value
    Behavior on animatedValue {
        NumberAnimation { duration: 220; easing.type: Easing.OutCubic }
    }

    readonly property string iconName: {
        var pct = Math.round(animatedValue * 100);
        if (isBrightness)
            return pct > 66 ? "brightness-high" : pct > 33 ? "brightness-medium" : "brightness-low";
        if (isMic)
            return (muted || pct <= 0) ? "microphone-sensitivity-muted"
                : pct > 66 ? "microphone-sensitivity-high"
                : pct > 33 ? "microphone-sensitivity-medium"
                : "microphone-sensitivity-low";
        return (muted || pct <= 0) ? "audio-volume-muted"
            : pct > 66 ? "audio-volume-high"
            : pct > 33 ? "audio-volume-medium"
            : "audio-volume-low";
    }

    // --- triggers -----------------------------------------------------------
    property bool flashing: false
    property bool armed: false

    Timer {
        id: armTimer
        interval: 350
        running: true
        onTriggered: root.armed = true
    }

    function flash() {
        if (!root.armed || root.suppressed)
            return;
        root.flashing = true;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: Motion.osdHide
        onTriggered: root.flashing = false
    }

    Connections {
        target: root.audio
        function onVolumeChanged() { root.flash(); }
        function onVolumesChanged() { root.flash(); }
        function onMutedChanged() { root.flash(); }
    }

    Connections {
        target: root.isBrightness ? OsdFeed : null
        function onBrightnessSeqChanged() { root.flash(); }
    }

    implicitWidth: 250 * root.us
    implicitHeight: 38 * root.us

    SymbolIcon {
        id: glyph
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        name: root.iconName
        size: 36 * root.us
        color: Theme.onSurface
    }

    // Value bar with smooth fluid fill
    Rectangle {
        id: trough
        anchors.left: glyph.right
        anchors.leftMargin: 16 * root.us
        anchors.right: pct.left
        anchors.rightMargin: 16 * root.us
        anchors.verticalCenter: parent.verticalCenter
        height: 6 * root.us
        radius: Theme.radiusWidget * root.us
        color: Theme.surfaceContainerLow

        // unity fill
        Rectangle {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * (Math.min(root.animatedValue, 1) / root.maxValue)
            radius: parent.radius
            color: Theme.secondary
            visible: width > 0
        }
        // the stretch past unity, in the error tone
        Rectangle {
            x: Math.round(parent.width / root.maxValue)
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: parent.width * (Math.max(0, root.animatedValue - 1) / root.maxValue)
            radius: parent.radius
            color: Theme.error
            visible: width > 0.5
        }
        // where 100% sits
        Rectangle {
            x: Math.round(parent.width / root.maxValue) - root.us
            anchors.verticalCenter: parent.verticalCenter
            width: 2 * root.us
            height: parent.height + 4 * root.us
            radius: 1 * root.us
            color: Theme.onSurface
            opacity: 0.55
            visible: root.maxValue > 1.005
        }
    }

    Text {
        id: pct
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        width: 46 * root.us
        horizontalAlignment: Text.AlignRight
        text: Math.round(root.animatedValue * 100) + "%"
        color: root.over ? Theme.error : Theme.onSurface
        font.family: Theme.mono
        font.pixelSize: Theme.fontMd * root.us
    }
}
