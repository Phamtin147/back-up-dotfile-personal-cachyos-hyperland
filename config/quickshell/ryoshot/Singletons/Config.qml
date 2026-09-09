pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: config

    property int blurRadius: 64
    property int mosaicBlock: 12
    property real zoomFactor: 2.0
    property bool copyOnSave: false
    property string saveDir: ""
    property var lastSel: null

    property bool isLoaded: false

    property var toolStyle: ({})
    signal loaded()

    readonly property string dir: (Quickshell.env("XDG_CONFIG_HOME")
        || (Quickshell.env("HOME") + "/.config")) + "/ryoku"
    readonly property string path: dir + "/ryoshot.json"

    property bool dirReady: false
    property bool savePending: false

    function save() {
        if (!config.dirReady) {
            config.savePending = true;
            mkdir.running = true;
            return;
        }
        flush();
    }

    function flush() {
        store.setText(JSON.stringify({
            blurRadius: config.blurRadius,
            mosaicBlock: config.mosaicBlock,
            zoomFactor: config.zoomFactor,
            copyOnSave: config.copyOnSave,
            saveDir: config.saveDir,
            toolStyle: config.toolStyle,
            lastSel: config.lastSel
        }, null, 2));
    }

    FileView {
        id: store
        path: config.path
        blockLoading: true
        atomicWrites: true
        printErrors: false
        onLoaded: {
            try {
                var c = JSON.parse(text());
                if (typeof c.blurRadius === "number") config.blurRadius = c.blurRadius;
                if (typeof c.mosaicBlock === "number") config.mosaicBlock = c.mosaicBlock;
                if (typeof c.zoomFactor === "number") config.zoomFactor = c.zoomFactor;
                if (typeof c.copyOnSave === "boolean") config.copyOnSave = c.copyOnSave;
                if (typeof c.saveDir === "string") config.saveDir = c.saveDir;
                if (c.toolStyle && typeof c.toolStyle === "object") config.toolStyle = c.toolStyle;
                if (c.lastSel && typeof c.lastSel === "object") config.lastSel = c.lastSel;
            } catch (e) {
                console.log("ryoshot: config parse failed, using defaults: " + e);
            }
            config.isLoaded = true;
            config.loaded();
        }

        onLoadFailed: (error) => {
            if (error === FileViewError.FileNotFound) config.save();
            config.loaded();
        }
        onSaveFailed: (err) => console.log("ryoshot: config write failed: " + err)
    }

    Process {
        id: mkdir
        command: ["mkdir", "-p", config.dir]
        onExited: {
            config.dirReady = true;
            if (config.savePending) { config.savePending = false; config.flush(); }
        }
    }

    Component.onCompleted: mkdir.running = true
}
