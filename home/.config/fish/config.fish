if status is-interactive
    fastfetch
    fish_add_path .local/bin
    fish_add_path .cargo/bin

    alias xs="sudo nixos-rebuild switch"
    alias xr="sudo nix-collect-garbage -d"
    alias xu="sudo nixos-rebuild switch --upgrade"


    alias e="nvim"
    alias se="sudo -E -s nvim"
end
