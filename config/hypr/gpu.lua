-- Hyprland Multi-GPU Configuration
-- Primary renderer: AMD Radeon Pro 5300M/5500M (slot 0000:03:00.0) - Connected directly to eDP-1 Retina display (Ultra smooth, zero lag)
-- Secondary renderer: Intel UHD Graphics 630 (slot 0000:00:02.0) - QuickSync Video decoding

hl.env("AQ_DRM_DEVICES", "/dev/dri/ryoku-gpu-0000-03-00-0:/dev/dri/ryoku-gpu-0000-00-02-0")
