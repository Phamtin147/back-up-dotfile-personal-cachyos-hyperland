-- Window rules for Frosted Glass blur across all apps

-- Kitty & Alacritty terminals
hl.window_rule({ name = "kitty-frost", match = { class = "^(kitty|Alacritty)$" }, opacity = "0.85 0.75" })

-- Code / IDEs
hl.window_rule({ name = "code-frost", match = { class = "^(code|Code|VSCodium|antigravity)$" }, opacity = "0.92 0.82" })

-- File managers
hl.window_rule({ name = "files-frost", match = { class = "^(nemo|thunar|org.kde.dolphin|nautilus)$" }, opacity = "0.88 0.78" })

-- Web Browsers
hl.window_rule({ name = "browser-frost", match = { class = "^(brave-browser|Brave-browser|google-chrome|chromium|zen-browser|zen|firefox)$" }, opacity = "0.94 0.84" })

-- Media & Music
hl.window_rule({ name = "spotify-frost", match = { class = "^(Spotify|spotify)$" }, opacity = "0.88 0.78" })

-- Discord / Vesktop
hl.window_rule({ name = "discord-frost", match = { class = "^(discord|Vesktop|vesktop)$" }, opacity = "0.90 0.80" })

-- Float settings / dialogs
hl.window_rule({ name = "dialogs-float", match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol|blueman-manager|nm-connection-editor|swappy)$" }, float = true, center = true })
hl.window_rule({ name = "wifi-float", match = { title = "^(Wi-Fi Manager)$" }, float = true, center = true, size = "700 500" })

