function http-serve {
    PORT="${PORT:-3005}"
    http-server $@ &
    PID=$!

    open http://localhost:${PORT}

    wait $PID
}
