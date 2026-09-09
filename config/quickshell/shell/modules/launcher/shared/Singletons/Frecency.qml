pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Launch-frequency store shared with the legacy pill launcher's file, so usage
// history carries across the rework. A flat {id: count} map; bump on launch,
// read for the ranking tiebreak.
Singleton {
    id: root

    readonly property string file: (Quickshell.env("XDG_STATE_HOME") || (Quickshell.env("HOME") + "/.local/state")) + "/ryoku/launcher-usage.json"
    property var usage: ({})

    function get(id) {
        var c = id ? root.usage[id] : 0;
        return typeof c === "number" ? c : 0;
    }

    FileView {
        id: store
        path: root.file
        blockLoading: true
        atomicWrites: true
        printErrors: false
    }

    FileView {
        id: fuzzelStore
        path: (Quickshell.env("XDG_CACHE_HOME") || (Quickshell.env("HOME") + "/.cache")) + "/fuzzel"
        blockLoading: true
        atomicWrites: true
        printErrors: false
    }

    function syncFuzzel() {
        var lines = [];
        for (var k in root.usage) {
            var entryId = String(k);
            if (!entryId.endsWith(".desktop")) entryId += ".desktop";
            lines.push(entryId + " " + root.usage[k]);
        }
        if (lines.length > 0) {
            fuzzelStore.setText(lines.join("\n") + "\n");
        }
    }

    function bump(id) {
        if (!id)
            return;
        root.usage[id] = (root.usage[id] || 0) + 1;
        store.setText(JSON.stringify(root.usage));
        syncFuzzel();
        Dispatcher.notifyAsync();
    }

    Component.onCompleted: {
        var raw = store.text();
        try {
            root.usage = raw && raw.length ? JSON.parse(raw) : ({});
        } catch (e) {
            root.usage = ({});
        }
        // If fuzzel cache exists, also import any entries
        var fuzzRaw = fuzzelStore.text();
        if (fuzzRaw && fuzzRaw.length) {
            var fLines = fuzzRaw.split("\n");
            for (var i = 0; i < fLines.length; i++) {
                var parts = fLines[i].trim().split(/\s+/);
                if (parts.length >= 2) {
                    var appId = parts[0].replace(/\.desktop$/, "");
                    var cnt = parseInt(parts[1], 10) || 0;
                    if (cnt > (root.usage[appId] || 0)) {
                        root.usage[appId] = cnt;
                    }
                }
            }
            store.setText(JSON.stringify(root.usage));
        }
        syncFuzzel();
        Dispatcher.notifyAsync();
    }
}
