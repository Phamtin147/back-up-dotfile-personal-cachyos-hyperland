pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property real brightness: 0.5
    property int brightnessSeq: 0

    function readLiveBrightness() {
        readProc.running = false;
        readProc.running = true;
    }

    Process {
        id: readProc
        command: ["bash", "-c", "brightnessctl -d gmux_backlight -m 2>/dev/null | cut -d, -f4 | tr -d %"]
        stdout: StdioCollector {
            onStreamFinished: {
                var pct = parseInt(this.text.trim());
                if (!isNaN(pct) && pct >= 0) {
                    root.brightness = Math.max(0, Math.min(1, pct / 100.0));
                    root.brightnessSeq++;
                }
            }
        }
    }

    function set(val) {
        var v = parseFloat(val);
        if (!isNaN(v)) {
            if (v > 1.0) v = v / 100.0;
            root.brightness = Math.max(0, Math.min(1, v));
            root.brightnessSeq++;
        }
    }

    Component.onCompleted: readLiveBrightness()
}
