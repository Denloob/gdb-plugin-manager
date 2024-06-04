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

# NOTE: if you change the hardcoded GDB_HOME path, you probably want to also change it in update.sh
GDB_HOME="${GDB_HOME:=~/.gdb/}" # You can overwrite the GDB_HOME with an env variable.

#######################################
# Download a gdb plugin.
# Arguments:
#   $1 - The dirname of the plugin inside $GDB_HOME and it's name, like `plug`
#   $2 - The git url to clone for the plugin, like `https://example.com/plug.git`
#   $3 - [Optional] the command to run after a successful install inside the dir.
#######################################
download() {
	if [ -d "$GDB_HOME/$1" ]; then
		echo "[-] $1 found"
		read -rp "skip download to continue? (enter 'y' or 'n') " skip

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
download 'pwndbg' 'https://github.com/pwndbg/pwndbg.git' './setup.sh'
download 'gef' 'https://github.com/hugsy/gef.git'

cd "$SCRIPT_DIR" || {
	echo "$0: error opening '$SCRIPT_DIR'."
	exit 1
}

echo "[+] Setting .gdbinit..."
read -rp "Overwrite .gdbinit with a default one? (enter 'y' or 'n') " overwrite
if [ "$overwrite" = 'y' ]; then
	cp gdbinit ~/.gdbinit
fi

{
	echo "[+] Creating files..."
	chmod +x peda peda-arm peda-intel pwndbg gef
	sudo cp -i peda peda-arm peda-intel pwndbg gef /usr/bin/
} || {
	echo "[-] Permission denied"
	exit
}

echo "[+] Done"
