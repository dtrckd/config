# Limit the maximum memory consumes by nvim
# to be put in ~/.config/fish/functions/nvim.fish

function nvim --wraps nvim --description "nvim with memory hard-limit via systemd cgroup"
    # Kill nvim if it exceeds MEM_LIMIT_GB GB of RAM (prevents system freeze)
    set MEM_LIMIT_GB 8
    set MEM_LIMIT_BYTES (math $MEM_LIMIT_GB \* 1024 \* 1024 \* 1024)

    if command -q systemd-run
        systemd-run --user --scope \
            -p MemoryMax={$MEM_LIMIT_BYTES} \
            -p MemorySwapMax=0 \
            -- command nvim $argv
    else
        # Fallback: no systemd
        command nvim $argv
    end
end
