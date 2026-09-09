//@ pragma UseQApplication

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import shell.services
import "../../../../services/lib/screens.js" as Screens
import Ryoku.Ui.Singletons
import "../../shared/Singletons"

// OkShell's applications-only launcher in Ryoku's live palette. It deliberately
// stays independent of the shared command-palette providers.
Scope {
    id: root

    // ── palette: the live matugen roles ─────────────────────────────────────
    property var pal: ({})       // colors.json: the live wallpaper palette
    property var named: null     // shell.json themePalette: the active coded theme
    // Resolve like the pill's Theme: a selected coded theme wins, then the live
    // wallpaper palette, then the compiled default. Without the coded-theme layer
    // the launcher only tracked the wallpaper and ignored the fixed presets.
    function role(k, d) {
        if (root.named && typeof root.named[k] === "string" && root.named[k].length > 0)
            return root.named[k];
        const v = root.pal[k];
        return (typeof v === "string" && v.length > 0) ? v : d;
    }
    readonly property color cSurface: role("surface", "#16110b")
    readonly property color cOnSurface: role("onSurface", "#e8e0d4")
    readonly property color cOnSurfaceVar: role("onSurfaceVariant", "#b9b0a4")
    readonly property color cPrimary: role("primary", "#e2342a")
    readonly property color cOutline: role("outline", "#8a8178")

    FileView {
        path: (Quickshell.env("XDG_CACHE_HOME") || (Quickshell.env("HOME") + "/.cache")) + "/ryoku/colors.json"
        blockLoading: true
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            try {
                const t = text();
                root.pal = t && t.length ? (JSON.parse(t) || {}) : {};
            } catch (e) {
                root.pal = {};
            }
        }
    }

    // the active coded theme's palette, resolved by the daemon into shell.json's
    // top-level themePalette key (absent for the dynamic Wallpaper/Default variants).
    FileView {
        path: (Quickshell.env("XDG_CONFIG_HOME") || (Quickshell.env("HOME") + "/.config")) + "/ryoku/shell.json"
        blockLoading: true
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            try {
                const o = JSON.parse(text());
                root.named = (o && typeof o.themePalette === "object" && o.themePalette !== null)
                    ? o.themePalette : null;
            } catch (e) {
                root.named = null;
            }
        }
    }

    // ── tokens ──────────────────────────────────────────────────────────────
    // the sidebar's push: a clean positional slide, no spring and no scale.
    // Mirrors Motion.push / Motion.pushCurve in the pill's Singletons.
    readonly property int pushMs: 140
    readonly property int pushCurve: Easing.OutQuad
    readonly property var spring: [0.38, 1.21, 0.22, 1, 1, 1]

    readonly property int rad: 14
    readonly property int fontSm: 14
    readonly property int fontMd: 16
    readonly property int panelW: 600
    readonly property int barH: 52
    readonly property int rowH: 48
    readonly property int pad: 10
    readonly property int elev: 0
    readonly property int listMax: 480
    readonly property int maxPanelH: root.listMax + root.pad * 2
    readonly property int restY: 80
    readonly property int slideIn: 16      // OkShell's selected padding-left

    readonly property color cardBg: Qt.rgba(cOnSurface.r, cOnSurface.g, cOnSurface.b, 0.06)
    readonly property color onBg: Qt.rgba(cPrimary.r, cPrimary.g, cPrimary.b, 0.20)
    readonly property color lineC: Qt.rgba(cOutline.r, cOutline.g, cOutline.b, 0.30)
    readonly property color onLine: Qt.rgba(cPrimary.r, cPrimary.g, cPrimary.b, 0.55)
    readonly property color dimInk: Qt.rgba(cOnSurfaceVar.r, cOnSurfaceVar.g, cOnSurfaceVar.b, 0.85)

    // ── state ───────────────────────────────────────────────────────────────
    property bool openRequested: false
    readonly property bool shown: openRequested || closeSettler.running
    property string query: ""
    property int sel: 0
    property bool showHidden: false
    property string monitor: ""
    // true for a beat after the query changes, so selection animations do not
    // fire on delegates the model just recycled underneath them
    property bool settling: false
    onQueryChanged: { root.sel = 0; root.settling = true; settleT.restart(); }
    onRowsChanged: { root.sel = 0; }
    Timer { id: settleT; interval: 90; onTriggered: root.settling = false }
    Timer {
        id: closeSettler
        interval: root.pushMs
    }

    // sorted by recent usage and search match quality
    readonly property var catalogue: {
        const all = DesktopEntries.applications.values
            .filter(a => root.showHidden || !a.noDisplay);
        return all;
    }
    readonly property var rows: {
        const all = root.catalogue;
        const q = root.query.trim().toLowerCase();
        const hit = q.length === 0
            ? all.slice()
            : all.filter(a => {
                const an = (a.name || "").toLowerCase();
                const ag = (a.genericName || "").toLowerCase();
                const ai = (a.id || "").toLowerCase();
                return an.includes(q) || ag.includes(q) || ai.includes(q);
            });
        hit.sort((a, b) => {
            const ua = Frecency.get(a.id) || 0;
            const ub = Frecency.get(b.id) || 0;
            if (q.length === 0) {
                // When empty query: sort by recent usage first (descending), then alphabetically
                if (ua !== ub) return ub - ua;
                return (a.name || "").toLowerCase().localeCompare((b.name || "").toLowerCase());
            } else {
                // When searching:
                // If both are exact/prefix matches vs substring matches
                const an = (a.name || "").toLowerCase(), bn = (b.name || "").toLowerCase();
                const ap = an.startsWith(q) ? 0 : 1, bp = bn.startsWith(q) ? 0 : 1;
                if (ap !== bp) return ap - bp;
                // For matches with same prefix status, prioritize recent / frequently used apps
                if (ua !== ub) return ub - ua;
                return an.localeCompare(bn);
            }
        });
        return hit;
    }
    readonly property int listH: Math.min(root.listMax, root.rows.length * root.rowH)
    readonly property int panelH: root.rows.length > 0 ? root.listH + root.pad * 2 : 0

    // ── lifecycle ───────────────────────────────────────────────────────────
    function show(mon) {
        closeSettler.stop();
        root.monitor = mon || "";
        root.query = "";
        root.sel = 0;
        root.openRequested = true;
    }
    function hide() {
        if (!root.openRequested)
            return;
        closeSettler.restart();
        root.openRequested = false;
    }
    function toggle(mon) {
        root.openRequested ? root.hide() : root.show(mon);
    }
    function step(d) {
        if (root.rows.length === 0)
            return;
        root.sel = Math.max(0, Math.min(root.rows.length - 1, root.sel + d));
    }
    function run() {
        const e = root.rows[root.sel];
        if (!e)
            return;
        root.hide();
        Frecency.bump(e.id);
        AppLaunch.run(e, null);
    }


    function stateDump() {
        return {
            open: openRequested,
            query: query,
            selectedIndex: sel,
            resultCount: rows.length,
            showHidden: showHidden
        };
    }

    // a 1px lit line along a card's top edge, inset by the radius
    component Sumi: Rectangle {
        property real r: root.rad
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: r
        anchors.rightMargin: r
        height: 1
        color: Qt.rgba(root.cOnSurface.r, root.cOnSurface.g, root.cOnSurface.b, 0.10)
    }

    Variants {
        model: Screens.uniqueByName(Quickshell.screens)

        PanelWindow {
            id: win
            required property var modelData
            screen: modelData
            // stays mapped until the slide-out finishes, or the exit never plays
            visible: (root.shown || win.p > 0.001)
                && (root.monitor.length === 0 || root.monitor === String(modelData.name))
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "launcher"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            anchors { top: true; bottom: true; left: true; right: true }

            // keeps the surface mapped for the length of the slide-out
            property real p: root.openRequested ? 1 : 0
            Behavior on p {
                NumberAnimation { duration: root.pushMs; easing.type: root.pushCurve }
            }

            // Dim backdrop overlay & Fullscreen Click-Outside to Dismiss
            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.35 * win.p)

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.ArrowCursor
                    onClicked: root.hide()
                }
            }

            Item {
                id: contentWrap
                width: root.panelW
                height: root.barH + 10 + root.panelH
                anchors.horizontalCenter: parent.horizontalCenter
                y: root.restY
                opacity: win.p
                scale: 0.98 + 0.02 * win.p

                Behavior on opacity {
                    NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
                }
                Behavior on scale {
                    NumberAnimation { duration: 120; easing.type: Easing.OutQuad }
                }

                // Prevent click on launcher card from dismissing
                MouseArea {
                    anchors.fill: parent
                    preventStealing: true
                }

                // ── search row ──────────────────────────────────────────────
                Item {
                    id: barWrap
                    width: root.panelW
                    height: root.barH
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 0

                    Rectangle {
                        id: bar
                        anchors.fill: parent
                        radius: root.rad
                        color: Qt.rgba(root.cSurface.r, root.cSurface.g, root.cSurface.b, 0.88)
                        border.width: 1
                        border.color: root.lineC
                        Sumi {}

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 14
                            anchors.rightMargin: 9
                            spacing: 10

                            Text {
                                text: "search"
                                font.family: "Material Symbols Rounded"
                                font.pixelSize: 20
                                color: root.cOnSurface
                            }
                            TextInput {
                                id: field
                                Layout.fillWidth: true
                                focus: win.visible
                                color: root.cOnSurface
                                font.pixelSize: root.fontMd
                                selectByMouse: true
                                onTextChanged: { root.query = text; root.sel = 0; }
                                Connections {
                                    target: root
                                    function onShownChanged() {
                                        if (root.shown) { field.text = ""; field.forceActiveFocus(); }
                                    }
                                }
                                Text {
                                    anchors.verticalCenter: parent.verticalCenter
                                    visible: field.text.length === 0
                                    text: I18n.tr("Search")
                                    color: root.dimInk
                                    font: field.font
                                }
                                Keys.onEscapePressed: root.hide()
                                Keys.onReturnPressed: root.run()
                                Keys.onEnterPressed: root.run()
                                Keys.onDownPressed: root.step(1)
                                Keys.onUpPressed: root.step(-1)
                                Keys.onPressed: (e) => {
                                    if (e.key === Qt.Key_PageDown) { root.step(8); e.accepted = true; }
                                    else if (e.key === Qt.Key_PageUp) { root.step(-8); e.accepted = true; }
                                }
                            }
                            // OkShell's eye: reveal the entries marked NoDisplay
                            Rectangle {
                                Layout.preferredWidth: 34
                                Layout.preferredHeight: 34
                                radius: root.rad - 4
                                color: root.showHidden ? root.onBg : root.cardBg
                                border.width: 1
                                border.color: root.showHidden ? root.onLine : root.lineC
                                Behavior on color { ColorAnimation { duration: 200 } }
                                Text {
                                    anchors.centerIn: parent
                                    text: root.showHidden ? "visibility" : "visibility_off"
                                    font.family: "Material Symbols Rounded"
                                    font.pixelSize: 18
                                    color: root.cOnSurface
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: { root.showHidden = !root.showHidden; root.sel = 0; }
                                }
                            }
                        }
                    }
                }

                // ── the list ────────────────────────────────────────────────
                Item {
                    id: panelWrap
                    width: root.panelW
                    height: root.panelH
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: root.elev + root.barH + 10
                    visible: root.panelH > 1
                    Behavior on height {
                        NumberAnimation {
                            duration: 280
                            easing.type: Easing.BezierSpline
                            easing.bezierCurve: root.spring
                        }
                    }


                    Rectangle {
                        id: panel
                        anchors.fill: parent
                        radius: root.rad
                        color: Qt.rgba(root.cSurface.r, root.cSurface.g, root.cSurface.b, 0.88)
                        border.width: 1
                        border.color: root.lineC
                        clip: true
                        Sumi {}

                        ListView {
                            id: list
                            anchors.fill: parent
                            anchors.margins: root.pad
                            model: ScriptModel { values: root.rows }
                            currentIndex: root.sel
                            highlightFollowsCurrentItem: true
                            preferredHighlightBegin: 0
                            preferredHighlightEnd: height
                            highlightRangeMode: ListView.ApplyRange
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds
                            cacheBuffer: root.rowH * 8

                            // the plate slides between rows rather than fading
                            highlight: Rectangle {
                                radius: root.rad
                                color: root.onBg
                                border.width: 1
                                border.color: root.onLine
                                Sumi {}
                            }
                            highlightMoveDuration: root.settling ? 0 : 260
                            highlightResizeDuration: 0

                            delegate: Item {
                                id: li
                                required property int index
                                required property var modelData
                                width: ListView.view.width
                                height: root.rowH
                                readonly property bool on: index === root.sel

                                MouseArea {
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: { root.sel = li.index; root.run(); }
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    // OkShell's cue: the selected row's content
                                    // slides right, 200ms ease-in-out.
                                    anchors.leftMargin: 12 + (li.on ? root.slideIn : 0)
                                    anchors.rightMargin: 14
                                    spacing: 12
                                    Behavior on anchors.leftMargin {
                                        enabled: !root.settling
                                        NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
                                    }

                                    IconImage {
                                        implicitSize: 24
                                        source: Quickshell.iconPath((li.modelData && li.modelData.icon) || "application-x-executable", true)
                                    }
                                    Text {
                                        Layout.fillWidth: true
                                        text: li.modelData ? li.modelData.name : ""
                                        color: root.cOnSurface
                                        font.pixelSize: root.fontSm
                                        font.weight: Font.DemiBold
                                        elide: Text.ElideRight
                                    }
                                    Text {
                                        visible: li.on
                                        text: I18n.tr("Run")
                                        color: root.dimInk
                                        font.pixelSize: root.fontSm - 2
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
