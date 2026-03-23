#!/usr/bin/env bash
# nvim-watchdog: kill nvim instances exceeding memory threshold
# Usage: nvim-watchdog [threshold_percent]  (default: 60)
# Run as background daemon:  nvim-watchdog &
# Or enable the systemd timer (see README at bottom)

THRESHOLD_PCT=${1:-60}
CHECK_INTERVAL=30  # seconds between checks

get_total_ram_kb() {
    awk '/MemTotal/ {print $2}' /proc/meminfo
}

get_nvim_rss_kb() {
    local pid=$1
    # Sum RSS of nvim + all its children (LSP servers, etc.)
    local total=0
    for p in $pid $(pgrep -P "$pid" 2>/dev/null); do
        local rss
        rss=$(awk '/VmRSS/ {print $2}' /proc/$p/status 2>/dev/null || echo 0)
        total=$((total + rss))
    done
    echo $total
}

log() {
    echo "[nvim-watchdog $(date '+%H:%M:%S')] $*"
}

notify() {
    DISPLAY=${DISPLAY:-:0} notify-send -u critical -t 10000 "nvim-watchdog" "$*" 2>/dev/null \
        || wall "nvim-watchdog: $*" 2>/dev/null \
        || true
}

log "Starting. Threshold: ${THRESHOLD_PCT}% RAM. Check interval: ${CHECK_INTERVAL}s"

while true; do
    total_kb=$(get_total_ram_kb)
    threshold_kb=$(( total_kb * THRESHOLD_PCT / 100 ))

    for pid in $(pgrep -x nvim 2>/dev/null); do
        rss_kb=$(get_nvim_rss_kb "$pid")
        pct=$(( rss_kb * 100 / total_kb ))

        if (( rss_kb > threshold_kb )); then
            cmdline=$(cat /proc/$pid/cmdline 2>/dev/null | tr '\0' ' ' | head -c 80)
            msg="nvim PID $pid using ${pct}% RAM ($(( rss_kb / 1024 ))MB / $(( total_kb / 1024 ))MB) — KILLING: $cmdline"
            log "$msg"
            notify "$msg"
            kill -TERM "$pid" 2>/dev/null
            sleep 3
            kill -KILL "$pid" 2>/dev/null  # force if still alive
        fi
    done

    sleep "$CHECK_INTERVAL"
done

# --- SETUP OPTIONS ---
#
# Option A: systemd cgroup (BEST — OS-enforced, kills only nvim scope)
# -----------------------------------------------------------------------
# Add to ~/.config/fish/functions/nvim.fish:
#
#   function nvim --wraps nvim
#       set MEM_GB 8  # adjust to your taste
#       systemd-run --user --scope \
#           -p MemoryMax=(math $MEM_GB \* 1024 \* 1024 \* 1024) \
#           -p MemorySwapMax=0 \
#           -- command nvim $argv
#   end
#
#
# Option B: systemd user timer (runs this script automatically)
# -----------------------------------------------------------------------
# Create ~/.config/systemd/user/nvim-watchdog.service:
#
#   [Unit]
#   Description=Kill nvim on memory excess
#
#   [Service]
#   ExecStart=/home/dtrckd/src/config/snippets/nvim-watchdog.sh 60
#   Restart=always
#
#   [Install]
#   WantedBy=default.target
#
# Then:
#   systemctl --user enable --now nvim-watchdog
