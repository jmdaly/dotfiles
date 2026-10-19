#!/bin/sh
# DAP adapter for omp: runs gdb in the running devcontainer of the current host folder.
# omp starts adapters in the session cwd, so that folder picks the container. The
# working dir is wherever the container mounts that folder (e.g. /workspaces/<repo>).
# ponytail: exact-folder match only; walk up parents if sessions start in subdirs.
set -eu
host=$(pwd -P)
id=$(docker ps -q --filter "label=devcontainer.local_folder=$host" | head -n 1)
[ -n "$id" ] || { echo "no running devcontainer for $host" >&2; exit 1; }
dest=$(docker inspect -f "{{range .Mounts}}{{if eq .Source \"$host\"}}{{.Destination}}{{end}}{{end}}" "$id")
# rust-gdb adds Rust pretty-printers; plain gdb for containers without Rust.
exec docker exec -i -w "${dest:-/}" "$id" sh -c 'exec "$(command -v rust-gdb || echo gdb)" -q -i dap'
