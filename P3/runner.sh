#!/bin/bash

#config files need to be in a routing method folder and need to match the target name
TARGETS=("all" "_aleconte-1" "_aleconte-2" "_aleconte-3" "_aleconte-4" "host_aleconte-1" "host_aleconte-2" "host_aleconte-3")

if [ ! $# -eq 1 ]; then
    echo "Usage: $0 {targets}"
    echo "Available targets: "
    echo ${TARGETS[@]}
    exit 1
fi


declare -A containermap

function update_container_hostnames() {
    for container in $(docker ps -q); do
        containermap[$(docker inspect --format '{{.Config.Hostname}}' $container)]="$container"
    done
}

function wait_on_container_start() {
    update_container_hostnames

    printf "%s" "->Waiting for $1 to start"
    until (test "${containermap[$1]}" && docker ps -q | grep -q "${containermap[$1]}")
    do
        update_container_hostnames

        printf "."
        sleep 2
    done
    printf "\n"
}

# $1 -> target hostname $2 -> script path
function wait_and_exec() {
    wait_on_container_start $1
    cat $2/$1.sh | docker exec -i ${containermap[$1]} bash
}

SCRIPT_PATH="$(dirname $0)/confs"
for arg in ${@:1}; do
    case $arg in
        "all"|"router_aleconte-1")
            wait_and_exec "_aleconte-1" $SCRIPT_PATH
            ;;&
        "all"|"router_aleconte-2")
            wait_and_exec "_aleconte-2" $SCRIPT_PATH
            ;;&
        "all"|"router_aleconte-3")
            wait_and_exec "_aleconte-3" $SCRIPT_PATH
            ;;&
        "all"|"router_aleconte-4")
            wait_and_exec "_aleconte-4" $SCRIPT_PATH
            ;;&
        "all"|"host_aleconte-1")
            wait_and_exec "host_aleconte-1" $SCRIPT_PATH
            ;;&
        "all"|"host_aleconte-2")
            wait_and_exec "host_aleconte-2" $SCRIPT_PATH
            ;;&
        "all"|"host_aleconte-3")
            wait_and_exec "host_aleconte-3" $SCRIPT_PATH
            ;;
    esac
done