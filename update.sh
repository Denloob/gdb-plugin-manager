#!/bin/bash

# NOTE: if you change the hardcoded GDB_HOME path, you probably want to also change it in update.sh
GDB_HOME="${GDB_HOME:=~/.gdb/}" # You can overwrite the GDB_HOME with an env variable.

update () {
    echo "[+] Updating $1..."
    cd "$GDB_HOME/$1" || return 1
    git pull
    echo "[+] Done: $1"
}

update 'peda'
update 'peda-arm'
update 'pwndbg'
update 'gef'
update 'splitmind'
