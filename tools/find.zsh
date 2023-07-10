function find-directory {
    local usage=(
        "Syntax: $0 --depth 2 dir-name"
        "        [-d|--depth]                       - Optional: Specify the folder depth to scan, to disable choose -1 [Default: 2]"
    )

    local dir="$1"
    local maxdepth
    local depth

    zmodload zsh/zutil
    zparseopts -D -E -F -K -- \
        {h,-help}=help \
        {d,-depth}:=depth \
    || return 1

    [[ "$depth" != "-1" ]] && { maxdepth="-maxdepth ${depth[-1]}" }
    [[ -z "$depth" ]] && { maxdepth="-maxdepth 2" }

    echo find . $maxdepth -type d -name "$dir" -not -path '*/node_modules/*'
}
