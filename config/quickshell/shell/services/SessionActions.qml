pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// Fires the session power actions the confirmation dialog confirms. The daemon
// (session.go) runs the documented systemctl command; QML never spawns systemctl
// itself, keeping the shell's state-in-daemon / render-in-QML split. Calls are
// fire-and-forget: reboot and shutdown tear the session down, so no reply is
// awaited. Contract 13 sec 8.
Singleton {
    id: root

    readonly property string sockPath: (Quickshell.env("XDG_RUNTIME_DIR") || "/tmp") + "/ryoku-shell.sock"

    // action is one of "logout" | "reboot" | "shutdown"; the daemon validates it.
    function run(action) {
        switch (action) {
        case "logout":
            Quickshell.execDetached(["sh", "-c", "hyprctl dispatch exit || loginctl terminate-session ${XDG_SESSION_ID:-self} || loginctl terminate-user $USER"]);
            break;
        case "reboot":
            Quickshell.execDetached(["systemctl", "reboot"]);
            break;
        case "shutdown":
            Quickshell.execDetached(["systemctl", "poweroff"]);
            break;
        default:
            ctl.queued += "call session." + action + " {}\n";
            if (ctl.connected)
                ctl.flushQueued();
            else
                ctl.connected = true;
            break;
        }
    }

    Socket {
        id: ctl
        path: root.sockPath
        property string queued: ""

        function flushQueued() {
            if (queued.length === 0)
                return;
            write(queued);
            flush();
            queued = "";
        }

        onConnectionStateChanged: if (connected) flushQueued()
    }
}
