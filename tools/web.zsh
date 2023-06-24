function http-serve {
    if [[ -z $(/usr/bin/which http-server) ]] && echo "http-server: Not Found\nRecommend: npm install -g http-server" && return 1
    
    PORT="${PORT:-3005}"
    http-server $@ &
    PID=$!

    open http://localhost:${PORT}

    wait $PID
}
