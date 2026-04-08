#!/usr/bin/env bash

# ============================================================
#  SOUND NUCLEAR RESET - Self contained autonomous script
#  Resets PulseAudio / PipeWire / ALSA and sets volume to 100%
#  Usage: chmod +x sound_reset.sh && ./sound_reset.sh
# ============================================================
#
# | Feature | Detail |
# |---|---|
# | 🔍 **Auto-detect** | Finds PipeWire / PulseAudio / both automatically |
# | 📦 **Auto-install** | Installs missing tools via apt/dnf/pacman/zypper |
# | 💀 **Full kill** | Graceful stop → force kill → verify |
# | 🗑️ **Full wipe** | All configs, cache, state files |
# | 🔧 **ALSA reset** | Hardware layer reset + unmute all channels |
# | 🧩 **Kernel modules** | Unload and reload audio drivers |
# | 🔄 **Smart restart** | systemd first, direct fallback |
# | ⏳ **Wait loop** | Waits up to 15s for server to be ready |
# | 🔊 **100% volume** | Sinks + Sources + App streams + Mic streams |
# | 📊 **Status report** | Full summary at the end |

# ── Colors ──────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── Logging helpers ──────────────────────────────────────────
step()  { echo -e "\n${BLUE}${BOLD}[>>]${NC} ${BOLD}$1${NC}"; }
ok()    { echo -e "  ${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "  ${YELLOW}[!]${NC} $1"; }
info()  { echo -e "  ${CYAN}[-]${NC} $1"; }
fail()  { echo -e "  ${RED}[✗]${NC} $1"; }
skip()  { echo -e "  ${YELLOW}[~]${NC} $1 ${YELLOW}(skipped)${NC}"; }

# ── Check if command exists ──────────────────────────────────
has() { command -v "$1" &>/dev/null; }

# ── Run command silently, return status ──────────────────────
silent() { "$@" &>/dev/null; return $?; }

# ── Banner ───────────────────────────────────────────────────
clear
echo -e "${RED}${BOLD}"
echo "  ╔══════════════════════════════════════════════╗"
echo "  ║                                              ║"
echo "  ║       🔊  SOUND SYSTEM NUCLEAR RESET  🔊     ║"
echo "  ║                                              ║"
echo "  ║   Resets ALL audio layers to clean state     ║"
echo "  ║   Sets ALL volumes to 100%                   ║"
echo "  ║                                              ║"
echo "  ╚══════════════════════════════════════════════╝"
echo -e "${NC}"
sleep 1

# ════════════════════════════════════════════════════════════
# STEP 1 — Auto install missing tools
# ════════════════════════════════════════════════════════════
step "Checking and installing required tools..."

# Detect package manager
if has apt-get;       then PKG_INSTALL="sudo apt-get install -y"
elif has dnf;         then PKG_INSTALL="sudo dnf install -y"
elif has pacman;      then PKG_INSTALL="sudo pacman -S --noconfirm"
elif has zypper;      then PKG_INSTALL="sudo zypper install -y"
else
    warn "No supported package manager found — skipping auto-install"
    PKG_INSTALL=""
fi

install_if_missing() {
    local cmd="$1"
    local pkg="${2:-$1}"
    if ! has "$cmd"; then
        if [ -n "$PKG_INSTALL" ]; then
            info "Installing $pkg..."
            silent $PKG_INSTALL "$pkg" && ok "$pkg installed" || warn "Could not install $pkg"
        else
            skip "$cmd not found and cannot auto-install"
        fi
    else
        ok "$cmd already available"
    fi
}

install_if_missing pactl        pulseaudio-utils
install_if_missing amixer       alsa-utils
install_if_missing alsactl      alsa-utils
install_if_missing pavucontrol  pavucontrol

# ════════════════════════════════════════════════════════════
# STEP 2 — Detect what is running
# ════════════════════════════════════════════════════════════
step "Detecting active sound system..."

HAS_PIPEWIRE=false
HAS_PULSE=false
HAS_WIREPLUMBER=false

if systemctl --user is-active --quiet pipewire 2>/dev/null \
   || pgrep -x pipewire &>/dev/null; then
    HAS_PIPEWIRE=true
    ok "PipeWire detected"
fi

if systemctl --user is-active --quiet wireplumber 2>/dev/null \
   || pgrep -x wireplumber &>/dev/null; then
    HAS_WIREPLUMBER=true
    ok "WirePlumber detected"
fi

if pgrep -x pulseaudio &>/dev/null \
   || silent pulseaudio --check; then
    HAS_PULSE=true
    ok "PulseAudio detected"
fi

if ! $HAS_PIPEWIRE && ! $HAS_PULSE; then
    warn "No active sound server found — will attempt full restart anyway"
fi

# ════════════════════════════════════════════════════════════
# STEP 3 — Kill everything
# ════════════════════════════════════════════════════════════
step "Killing all sound servers and related processes..."

# Graceful stop via systemd
for svc in wireplumber pipewire-pulse pipewire pulseaudio; do
    if systemctl --user is-active --quiet "$svc" 2>/dev/null; then
        silent systemctl --user stop "$svc" \
            && ok "Stopped systemd service: $svc" \
            || warn "Could not stop $svc via systemd"
    fi
done

# Graceful PulseAudio kill
silent pulseaudio -k && ok "PulseAudio killed gracefully"

sleep 1

# Force kill anything remaining
for proc in pulseaudio pipewire wireplumber; do
    if pgrep -x "$proc" &>/dev/null; then
        silent pkill -9 -x "$proc" \
            && ok "Force killed: $proc" \
            || warn "Could not force kill: $proc"
    fi
done

sleep 1
ok "All sound processes terminated"

# ════════════════════════════════════════════════════════════
# STEP 4 — Wipe all configs and state
# ════════════════════════════════════════════════════════════
step "Wiping configs, cache and state files..."

wipe() {
    local path="$1"
    # Expand ~ properly
    path="${path/#\~/$HOME}"
    if [ -e "$path" ]; then
        rm -rf "$path" \
            && ok "Removed: $path" \
            || warn "Could not remove: $path"
    else
        skip "$path does not exist"
    fi
}

# PulseAudio
wipe "$HOME/.config/pulse"
wipe "$HOME/.pulse"
wipe "$HOME/.pulse-cookie"

# PipeWire
wipe "$HOME/.local/state/pipewire"

# WirePlumber
wipe "$HOME/.local/state/wireplumber"

# General audio cache
wipe "$HOME/.cache/pipewire"

# ════════════════════════════════════════════════════════════
# STEP 5 — Reset ALSA (low level hardware layer)
# ════════════════════════════════════════════════════════════
step "Resetting ALSA (hardware layer)..."

if has alsactl; then
    silent sudo alsactl restore \
        && ok "ALSA state restored from saved state" \
        || warn "ALSA restore failed — trying init..."
    silent sudo alsactl init \
        && ok "ALSA initialized to defaults" \
        || warn "ALSA init failed (non-critical)"
else
    skip "alsactl not found"
fi

if has amixer; then
    # Unmute and max out every common ALSA control
    for ctrl in Master PCM Speaker Headphone "Front"; do
        if amixer get "$ctrl" &>/dev/null; then
            silent amixer set "$ctrl" 100% unmute \
                && ok "ALSA '$ctrl' → 100%, unmuted"
        fi
    done
    # Mic / capture
    for ctrl in Capture Mic "Mic Boost" "Internal Mic"; do
        if amixer get "$ctrl" &>/dev/null; then
            silent amixer set "$ctrl" 100% cap \
                && ok "ALSA '$ctrl' (mic) → 100%, enabled"
        fi
    done
else
    skip "amixer not found"
fi

# ════════════════════════════════════════════════════════════
# STEP 6 — Reload kernel audio modules
# ════════════════════════════════════════════════════════════
step "Reloading kernel audio modules..."

AUDIO_MODULES=(snd_hda_intel snd_usb_audio snd_hda_codec snd_ac97_codec)

for mod in "${AUDIO_MODULES[@]}"; do
    if lsmod | grep -q "^${mod}"; then
        silent sudo rmmod "$mod" \
            && info "Unloaded: $mod" \
            || warn "Could not unload $mod (may be in use)"
        sleep 0.5
        silent sudo modprobe "$mod" \
            && ok "Reloaded: $mod" \
            || warn "Could not reload $mod"
    else
        skip "$mod not loaded"
    fi
done

sleep 1

# ════════════════════════════════════════════════════════════
# STEP 7 — Restart sound servers
# ════════════════════════════════════════════════════════════
step "Restarting sound servers..."

if $HAS_PIPEWIRE; then
    # Start PipeWire stack in correct order
    for svc in pipewire pipewire-pulse wireplumber; do
        silent systemctl --user start "$svc" \
            && ok "Started: $svc" \
            || warn "Could not start $svc via systemd — trying direct..."
        sleep 0.8
    done
    # Fallback: start directly if systemd failed
    if ! pgrep -x pipewire &>/dev/null; then
        silent pipewire &
        sleep 1
        ok "PipeWire started directly"
    fi
    if ! pgrep -x wireplumber &>/dev/null; then
        silent wireplumber &
        sleep 1
        ok "WirePlumber started directly"
    fi
fi

if $HAS_PULSE && ! $HAS_PIPEWIRE; then
    silent pulseaudio --start \
        && ok "PulseAudio started" \
        || warn "PulseAudio failed to start"
    sleep 1
fi

# ════════════════════════════════════════════════════════════
# STEP 8 — Wait for sound server to be ready
# ════════════════════════════════════════════════════════════
step "Waiting for sound server to be ready..."

MAX_WAIT=15
WAITED=0
until pactl info &>/dev/null; do
    if [ "$WAITED" -ge "$MAX_WAIT" ]; then
        fail "Sound server did not respond after ${MAX_WAIT}s"
        warn "You may need to log out and back in"
        break
    fi
    info "Waiting... (${WAITED}/${MAX_WAIT}s)"
    sleep 1
    (( WAITED++ ))
done

if pactl info &>/dev/null; then
    ok "Sound server is responding!"
fi

# ════════════════════════════════════════════════════════════
# STEP 9 — Set ALL volumes to 100%
# ════════════════════════════════════════════════════════════
step "Setting ALL volumes to 100% and unmuting..."

VOL=65536  # 65536 = 100% in PulseAudio units

if pactl info &>/dev/null; then

    # ── Output sinks (speakers / headphones / HDMI)
    info "Setting output sinks..."
    while IFS= read -r sink; do
        [ -z "$sink" ] && continue
        silent pactl set-sink-mute   "$sink" 0
        silent pactl set-sink-volume "$sink" $VOL \
            && ok "Output '$sink' → 100%, unmuted" \
            || warn "Could not set volume for sink: $sink"
    done < <(pactl list short sinks | awk '{print $2}')

    # ── Input sources (microphones) — skip monitors
    info "Setting input sources (microphones)..."
    while IFS= read -r source; do
        [ -z "$source" ] && continue
        [[ "$source" == *".monitor"* ]] && continue
        silent pactl set-source-mute   "$source" 0
        silent pactl set-source-volume "$source" $VOL \
            && ok "Mic '$source' → 100%, unmuted" \
            || warn "Could not set volume for source: $source"
    done < <(pactl list short sources | awk '{print $2}')

    # ── Active app streams (sink inputs)
    info "Setting active application streams..."
    while IFS= read -r input_id; do
        [ -z "$input_id" ] && continue
        silent pactl set-sink-input-mute   "$input_id" 0
        silent pactl set-sink-input-volume "$input_id" $VOL \
            && ok "App stream #$input_id → 100%, unmuted" \
            || warn "Could not set app stream #$input_id"
    done < <(pactl list short sink-inputs | awk '{print $1}')

    # ── Active mic streams (source outputs)
    info "Setting active mic streams..."
    while IFS= read -r output_id; do
        [ -z "$output_id" ] && continue
        silent pactl set-source-output-mute   "$output_id" 0
        silent pactl set-source-output-volume "$output_id" $VOL \
            && ok "Mic stream #$output_id → 100%, unmuted" \
            || warn "Could not set mic stream #$output_id"
    done < <(pactl list short source-outputs | awk '{print $1}')

else
    warn "pactl not available — volume control skipped"
    warn "ALSA volumes were already set to 100% in step 5"
fi

# ════════════════════════════════════════════════════════════
# STEP 10 — Final status report
# ════════════════════════════════════════════════════════════
echo ""
echo -e "${GREEN}${BOLD}"
echo "  ╔══════════════════════════════════════════════╗"
echo "  ║                                              ║"
echo "  ║          ✅  RESET COMPLETE  ✅              ║"
echo "  ║                                              ║"
echo "  ╚══════════════════════════════════════════════╝"
echo -e "${NC}"

step "Current audio status:"

if pactl info &>/dev/null; then
    echo ""
    info "Server  : $(pactl info | grep 'Server Name'   | cut -d: -f2- | xargs)"
    info "Version : $(pactl info | grep 'Server Version'| cut -d: -f2- | xargs)"
    info "Sink    : $(pactl info | grep 'Default Sink'  | cut -d: -f2- | xargs)"
    info "Source  : $(pactl info | grep 'Default Source'| cut -d: -f2- | xargs)"

    echo ""
    info "── Active Sinks (output) ──────────────────────"
    pactl list sinks | grep -E "^\s*(Name|Volume|Mute|Description):" \
        | sed 's/^[[:space:]]*/  /'

    echo ""
    info "── Active Sources (mic/input) ─────────────────"
    pactl list sources | grep -E "^\s*(Name|Volume|Mute|Description):" \
        | grep -v -A2 "monitor" \
        | sed 's/^[[:space:]]*/  /'
fi

echo ""
echo -e "  ${CYAN}Tip:${NC} Run ${BOLD}pavucontrol${NC} for a graphical mixer"
echo -e "  ${CYAN}Tip:${NC} Run ${BOLD}alsamixer${NC} for a terminal mixer"
echo -e "  ${YELLOW}Note:${NC} If sound still broken → ${BOLD}log out and back in${NC}"
echo ""
