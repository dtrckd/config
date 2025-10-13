function fish_prompt --description 'Write out the prompt'
    set laststatus $status

    if set -l git_branch (command git symbolic-ref HEAD 2>/dev/null | string replace refs/heads/ '')
        set git_branch (set_color -o purple)"$git_branch"
        set git_status ""
        
        # Check for any modifications (excluding untracked files)
        if git status --porcelain | string match -qvr '^\?\?'
            set git_status (set_color yellow)≠
        end

        # Check if git stash is not empty
        if git stash list | string match -qv '^stash@'
            set git_status $git_status(set_color cyan)≡
        end
        
        # Check for ahead/behind
        if set -l count (command git rev-list --count --left-right $upstream...HEAD 2>/dev/null)
            echo $count | read -l ahead behind
            test "$ahead" -gt 0; and set git_status $git_status(set_color red)⬆
            test "$behind" -gt 0; and set git_status $git_status(set_color red)⬇
        end
        
        set git_info " ($git_branch$git_status"(set_color white)")"
    end

    # Disable PWD shortening by default.
    #set -q fish_prompt_pwd_dir_length
    #or set -lx fish_prompt_pwd_dir_length 0

    set_color -b black
    printf '%s%s%s%s%s%s%s%s%s%s%s%s%s%s' (set_color -o white) (set_color green) $USER (set_color white) '@' (set_color 62A) (prompt_hostname) (set_color blue) (prompt_pwd) (set_color white) $git_info (set_color white) (set_color white)
    if test $laststatus -eq 0
        #printf "%s✔%s≻%s " (set_color -o green) (set_color white) (set_color normal)
        printf "%s%s>%s " (set_color -o green) (set_color white) (set_color normal)
    else
        #printf "%s✘%s>%s " (set_color -o red) (set_color white) (set_color normal)
        printf "%s%s>%s " (set_color -o green) (set_color white) (set_color normal)
    end
end
