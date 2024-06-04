#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo "[+] Checking for required dependencies..."
if command -v git >/dev/null 2>&1; then
	echo "[-] Git found!"
else
	echo "[-] Git not found! Aborting..."
	echo "[-] Please install git and try again."
fi

if [ -f ~/.gdbinit ] || [ -h ~/.gdbinit ]; then
	echo "[+] backing up gdbinit file"
	cp -i ~/.gdbinit ~/.gdbinit.back_up
fi

GDB_HOME="${GDB_HOME:=$HOME/.gdb/}" # You can overwrite the GDB_HOME with an env variable.

#######################################
# Download a gdb plugin.
# Arguments:
#   $1 - The dirname of the plugin inside $GDB_HOME and it's name, like `plug`
#   $2 - The git url to clone for the plugin, like `https://example.com/plug.git`
#   $3 - [Optional] the command to run after a successful install inside the dir.
#######################################
download() {
	if [ -d "$GDB_HOME/$1" ]; then
		echo "[-] $1 is already installed."
		read -rp "skip? (enter 'y' or 'n') " skip

		if [ "$skip" = 'n' ]; then
			rm -rfi "${GDB_HOME:?}/$1"
		else
			echo "[#] $1 skipped"
			return 0
		fi
	fi

	git clone "$2" "$GDB_HOME/$1"

	if [ $# -ge 3 ]; then
		cd "$GDB_HOME/$1" || return 1
		bash -c "$3"
	fi

	echo "[+] $1 done."
}

download 'peda' 'https://github.com/longld/peda.git'
download 'peda-arm' 'https://github.com/alset0326/peda-arm.git'
download 'pwndbg' 'https://github.com/pwndbg/pwndbg.git' './setup.sh && ./.venv/bin/pip install r2pipe' # after download, setup pwndbg and install r2pipe for ghidra (r2) integration. https://github.com/pwndbg/pwndbg/blob/dev/FEATURES.md#ghidra
download 'gef' 'https://github.com/hugsy/gef.git'
download 'splitmind' 'https://github.com/jerdna-regeiz/splitmind.git'

cd "$SCRIPT_DIR" || {
	echo "$0: error opening '$SCRIPT_DIR'."
	exit 1
}

if [[ -z $GDB_PWN_MANAGER_OVERWRITE ]]; then
echo "[+] Setting .gdbinit..."
read -rp "Overwrite .gdbinit with a default one? (enter 'y' or 'n') " overwrite
else
    overwrite="$GDB_PWN_MANAGER_OVERWRITE"
fi
if [ "$overwrite" = 'y' ]; then
	cp gdbinit ~/.gdbinit
fi

{
	echo "[+] Creating files..."
	chmod +x "$SCRIPT_DIR"/gdb_runners/*
    echo '[*] Copying [ '"$(basename -a "$SCRIPT_DIR"/gdb_runners/* | tr '\n' ' ')"'] to /usr/bin/'
    read -rp "Press Enter to continue or Ctrl+C to cancel"
	sudo cp -i "$SCRIPT_DIR"/gdb_runners/* /usr/bin/
} || {
	echo "[-] Permission denied"
	exit
}

echo "[+] Done"
