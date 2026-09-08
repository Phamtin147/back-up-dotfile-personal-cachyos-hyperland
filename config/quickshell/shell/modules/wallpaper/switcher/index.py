#!/usr/bin/env python3
import os, sys, glob, hashlib, subprocess, time
from concurrent.futures import ThreadPoolExecutor, ProcessPoolExecutor

home = os.path.expanduser("~")
wpdir = os.path.join(home, "Pictures", "Wallpapers")
livedir = os.path.join(home, "Pictures", "livewalls")
cache = os.path.join(home, ".cache", "ryoku-wp-thumbs")
index_cache = os.path.join(cache, "index.tsv")
os.makedirs(cache, exist_ok=True)

# Instant read from cache
if "--rebuild" not in sys.argv and os.path.exists(index_cache) and os.path.getsize(index_cache) > 0:
    try:
        with open(index_cache, "r") as f:
            sys.stdout.write(f.read())
        sys.exit(0)
    except Exception:
        pass

def process_file(src):
    try:
        if not os.path.isfile(src):
            return None
        h = hashlib.md5(src.encode("utf-8")).hexdigest()
        thumb = os.path.join(cache, f"{h}.png")
        huef = os.path.join(cache, f"{h}.hue")
        
        ext = src.lower().split(".")[-1]
        kind = "live" if ext in ("mp4", "webm", "mkv") else "image"
        
        # Check thumbnail
        if not os.path.exists(thumb) or os.path.getmtime(src) > os.path.getmtime(thumb):
            tmp_thumb = f"{thumb}.tmp.png"
            if kind == "live":
                cmd = ["ffmpeg", "-y", "-loglevel", "error", "-ss", "1", "-i", src, "-frames:v", "1", "-vf", "scale=512:-2", tmp_thumb]
            else:
                cmd = ["magick", f"{src}[0]", "-strip", "-thumbnail", "512x", tmp_thumb]
            subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            if os.path.exists(tmp_thumb) and os.path.getsize(tmp_thumb) > 0:
                os.replace(tmp_thumb, thumb)
                if os.path.exists(huef): os.remove(huef)
            else:
                if os.path.exists(tmp_thumb): os.remove(tmp_thumb)
                
        if not os.path.exists(thumb):
            return None
            
        # Check hue
        if not os.path.exists(huef):
            res = subprocess.run(["magick", thumb, "-resize", "1x1!", "-colorspace", "HSL", "-format", "%[fx:u.r*360] %[fx:u.g*100]", "info:"], stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True)
            txt = res.stdout.strip() if res.returncode == 0 else "0 0"
            with open(huef, "w") as hf:
                hf.write(txt)
                
        hue, sat = 0, 0
        try:
            with open(huef, "r") as hf:
                parts = hf.read().split()
                if len(parts) >= 2:
                    hue, sat = float(parts[0]), float(parts[1])
        except Exception:
            pass
            
        prev = ""
        if kind == "live":
            p = os.path.join(cache, f"{h}.preview.mp4")
            if os.path.exists(p): prev = p
            
        mtime = int(os.path.getmtime(src))
        return f"{kind}\t{mtime}\t{src}\t{thumb}\t{hue}\t{sat}\t{prev}\n"
    except Exception:
        return None

# Find all files
files = []
for base in (wpdir, livedir):
    if os.path.exists(base):
        for root, _, filenames in os.walk(base):
            for f in filenames:
                ext = f.lower().split(".")[-1]
                if ext in ("jpg", "jpeg", "png", "webp", "mp4", "webm", "mkv"):
                    files.append(os.path.join(root, f))

# Process in parallel with 16 workers
results = []
with ThreadPoolExecutor(max_workers=16) as pool:
    for res in pool.map(process_file, files):
        if res:
            results.append(res)

output_text = "".join(results)
with open(index_cache, "w") as f:
    f.write(output_text)

sys.stdout.write(output_text)
