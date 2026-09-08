pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Perf is the shell's one performance-policy singleton and the single reader of
// ~/.config/ryoku/performance.json (the file Ryoku Settings' Performance page
// writes). It folds four inputs into the effective switches every surface obeys:
//
//   1. the explicit user toggles in performance.json (lowPowerMode is the master),
//   2. the active power profile (PowerProfiles), when powerProfileEffects is on,
//   3. the live battery state (Battery), for invisible savings while discharging,
//   4. Game Mode (Flags.gameMode), which outranks all of them.
//
// Consumers read the derived booleans (blurDisabled, shadowsDisabled, reduceMotion,
// visualizerFrozen, pillFrozen) instead of re-deriving `lowPower || flag`: the
// "lowPowerMode implies ..." and "Power Saver implies ..." rules live here once.
// Motion reads reduceMotion/motionSpeed from here too, so the whole shell shares
// one file watcher rather than a copy per module.
//
// Tiers: only Power Saver forces eye-candy off (it behaves like lowPowerMode).
// Balanced and Performance leave the explicit toggles untouched, so the default
// profile never overrides a user's choice and the desktop stays smooth. Battery
// thrift (slower background polling, and not waking a suspended dGPU) is graceful
// and applies whenever discharging, independent of the profile, because it costs
// the user nothing they can see.
//
// Game Mode is the one tier that ignores the user's explicit toggles, and it is
// meant to: the compositor is already stripped and the CPU is already pinned to
// performance, so leaving the shell's own eye-candy running would spend the
// headroom that was just bought. It is also the only tier where the shell is
// competing with a specific foreground process for the same GPU, which is why it
// goes further than Saver and drops the audio analyser outright rather than
// merely freezing it when idle. Nothing here is persisted: it lasts exactly as
// long as the toggle, and every switch returns to the user's own settings on
// exit.
Singleton {
    id: root

    readonly property bool lowPower: false
    readonly property real motionSpeed: 1.0

    // Power profile -> tier. Keep at peak performance rate across all profiles
    readonly property int tierSaver: 0
    readonly property int tierBalanced: 1
    readonly property int tierPerformance: 2
    readonly property int tier: root.tierPerformance
    readonly property bool saver: false

    readonly property bool onBattery: false
    readonly property bool gaming: false

    // Effective eye-candy switches: Always enabled for silky 60fps animations
    readonly property bool reduceMotion: false
    readonly property bool blurDisabled: false
    readonly property bool shadowsDisabled: false

    readonly property bool audioIdle: !Media.playing
    readonly property bool visualizerFrozen: false
    readonly property bool pillFrozen: false

    readonly property bool ambientMotion: true
    readonly property bool fullRate: true

    readonly property int pollFactor: 1
    readonly property int msaa: 8

    FileView {
        path: (Quickshell.env("XDG_CONFIG_HOME") || (Quickshell.env("HOME") + "/.config")) + "/ryoku/performance.json"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        JsonAdapter {
            id: adapter
            property bool lowPowerMode: false
            property bool reduceMotion: false
            property bool disableBlur: false
            property bool disableShadows: false
            property real motionSpeed: 1.0
            property bool powerProfileEffects: false
        }
    }
}
