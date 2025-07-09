#!/bin/sh

set -eu

target_platforms="debian-amd64 ubuntu-amd64 alpine"

SUDO_DOCKER=""
if [ $(test -r /var/run/docker.sock; echo "$?") -ne 0 ]; then
    SUDO_DOCKER="sudo"
fi

validate_bin_name() {
    case "$1" in
        *[!a-zA-Z0-9._-]* | "" ) return 1 ;;
        * ) return 0 ;;
    esac
}

list_dirs() {
    for d in */; do
        case "$d" in
            binaries/) continue ;;
            */) echo "${d%/}" ;;
        esac
    done
}

build_target() {
    platform="$1"
    target="$2"

    if ! validate_bin_name "$target"; then
        echo "Invalid BIN_NAME: $target"
        exit 1
    fi

    BIN_NAME="$target"
    IMAGE_NAME="static-builder-$platform"
    CONTAINER_NAME="tmp_$BIN_NAME"

    # $SUDO_DOCKER docker build --build-arg BIN_NAME="$BIN_NAME" \
    #     --build-context target="./$BIN_NAME" -t "$IMAGE_NAME" .
    $SUDO_DOCKER docker build --build-arg BIN_NAME="$BIN_NAME" \
        -t "$IMAGE_NAME" -f "Dockerfile.$platform" .
    $SUDO_DOCKER docker create --name "$CONTAINER_NAME" "$IMAGE_NAME" >/dev/null
    $SUDO_DOCKER docker cp "$CONTAINER_NAME:/$BIN_NAME" "./binaries/$BIN_NAME"
    $SUDO_DOCKER docker rm "$CONTAINER_NAME" >/dev/null
  
    chmod +x "./binaries/$BIN_NAME"
    printf '\nFinished building %s\n' "$BIN_NAME"
}

switch_input() {
    values=$(printf '%s\n' "$@" | sort | tr '\n' ' ')
    values=${values%" "}
    i=1

    for name in $values; do
        echo "  [$i] $name" 1>&2
        eval "opt_$i=\"\$name\""
        i=$((i + 1))
    done

    total=$((i - 1))

    while :; do
        printf "#? " 1>&2
        read choice

        case "$choice" in
            ''|*[!0-9]*)
                echo "Invalid choice" 1>&2
                continue
                ;;
        esac

        if [ "$choice" -ge 1 ] && [ "$choice" -le "$total" ]; then
            eval "target=\$opt_$choice"
            echo "$target"
            break
        else
            echo "Invalid choice" 1>&2
        fi
    done
}

main() {
    echo "Select platform to use:"
    platform=$(switch_input $target_platforms)

    echo "Select a target to build:"
    target=$(switch_input $(list_dirs))

    build_target "$platform" "$target"
}

main
