function flushdns {
  sudo killall -HUP mDNSResponder
  dscacheutil -flushcache
}

function forwardip {
  sudo sysctl -w net.inet.ip.forwarding=1
}
