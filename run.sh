#!/bin/sh

set -eu

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
  done | sort
}

build_target() {
  dir="$1"

  if ! validate_bin_name "$dir"; then
    echo "Invalid BIN_NAME: $dir"
    exit 1
  fi

  BIN_NAME="$dir"
  IMAGE_NAME="static-builder"
  CONTAINER_NAME="tmp_$BIN_NAME"

  $SUDO_DOCKER docker build --build-arg BIN_NAME="$BIN_NAME" \
      --build-context target="./$BIN_NAME" -t "$IMAGE_NAME" .
  $SUDO_DOCKER docker create --name "$CONTAINER_NAME" "$IMAGE_NAME" >/dev/null
  $SUDO_DOCKER docker cp "$CONTAINER_NAME:/$BIN_NAME" "./binaries/$BIN_NAME"
  $SUDO_DOCKER docker rm "$CONTAINER_NAME" >/dev/null
  
  chmod +x "./binaries/$BIN_NAME"
  printf '\nFinished building %s\n' "$BIN_NAME"
}

main() {
  echo "Select a target to build:"
  i=1

  for name in $(list_dirs); do
    echo "  [$i] $name"
    eval "opt$i='$name'"
    i=$((i+1))
  done

  printf "Choice: "
  read choice
  eval "target=\$opt$choice"

  if [ -n "$target" ]; then
    build_target "$target"
  else
    echo "Invalid choice"
    exit 1
  fi
}

main
