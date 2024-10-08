if status is-interactive
    fastfetch
    fish_add_path .local/bin
    fish_add_path .cargo/bin

    alias xs="sudo pacman -S"
    alias xr="sudo pacman -Rs"
    alias xu="sudo pacman -Suy"


    alias e="nvim"
    alias se="sudo -E -s nvim"
end
