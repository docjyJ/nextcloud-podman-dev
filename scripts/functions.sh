#!/bin/bash

function get_podman_compose_command() {
    podman-compose version >/dev/null 2>/dev/null && DCC='podman-compose'
    podman compose version >/dev/null 2>/dev/null && DCC='podman compose'
    if [ -z "$DCC" ]; then
        return
    fi
    echo "$DCC"
}

function podman_compose() {
    DCC=$(get_podman_compose_command)
    if [ -z "$DCC" ]; then
        echo "❌ Install podman-compose before running this script"
        exit 1
    fi
    $DCC "$@"
}
