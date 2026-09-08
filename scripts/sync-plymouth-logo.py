#!/usr/bin/env python3
import json
import os
import sys
import subprocess
from PIL import Image
import numpy as np

def hex_to_rgb(hex_str):
    hex_str = hex_str.lstrip('#')
    return [int(hex_str[i:i+2], 16) for i in (0, 2, 4)]

def get_accent_color():
    colors_path = os.path.expanduser("~/.cache/ryoku/colors.json")
    if os.path.exists(colors_path):
        try:
            with open(colors_path, "r") as f:
                d = json.load(f)
            # Prefer color13 (vibrant accent) or primary or color2
            candidate = d.get("color13") or d.get("primary") or d.get("color2") or d.get("color10") or "#ffffff"
            rgb = hex_to_rgb(candidate)
            # Ensure sufficient brightness against #171717 (min luminance 0.6)
            lum = (0.299 * rgb[0] + 0.587 * rgb[1] + 0.114 * rgb[2]) / 255.0
            if lum < 0.6:
                # Use lighter variant or boost
                lighter = d.get("color13") or d.get("primaryContainer") or d.get("color5")
                if lighter:
                    rgb = hex_to_rgb(lighter)
            return rgb
        except Exception:
            pass
    return [255, 183, 131] # warm fallback

def sync_logo():
    src_path = os.path.expanduser("~/back-up-dotfile-personal-cachyos/custom-patches/logo-xin.png")
    if not os.path.exists(src_path):
        src_path = "/usr/share/plymouth/themes/ryoku/logo.png"

    img = Image.open(src_path).convert('RGB')
    arr = np.array(img, dtype=float)
    bg = np.array([23.0, 23.0, 23.0]) # #171717

    # Calculate distance from background to get clean alpha mask
    diff = np.linalg.norm(arr - bg, axis=2)
    max_d = diff.max()
    if max_d == 0:
        max_d = 1.0
    alpha = np.clip(diff / max_d, 0.0, 1.0)
    # Enhance contrast
    alpha = np.power(alpha, 1.1)

    target_rgb = np.array(get_accent_color(), dtype=float)
    new_arr = bg * (1.0 - alpha[:, :, None]) + target_rgb * alpha[:, :, None]
    new_arr = np.clip(new_arr, 0, 255).astype(np.uint8)

    out_img = Image.fromarray(new_arr, 'RGB')
    
    cache_path = os.path.expanduser("~/.cache/ryoku/plymouth-logo.png")
    out_img.save(cache_path)
    out_img.save(src_path)

    # Copy to system plymouth theme
    cmd = f"echo '1' | sudo -S cp -f '{cache_path}' /usr/share/plymouth/themes/ryoku/logo.png"
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    print(f"Updated Plymouth shutdown logo to color: RGB {target_rgb.tolist()}")

if __name__ == "__main__":
    sync_logo()
