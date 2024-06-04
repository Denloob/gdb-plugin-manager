# GDB pwn manager
A set of scripts for installing and managing GEF, PEDA (+peda-arm) and pwndbg (+splitmind +r2pipe(Ghidra intergration))

---

A partial rewrite of [apogiatzis/gdb-peda-pwndbg-gef](https://github.com/apogiatzis/gdb-peda-pwndbg-gef). \
**Following features were added:**
- Customizable plugin install directory
- Installation of [splitmind](https://github.com/jerdna-regeiz/splitmind) and r2pipe for [the Ghidra integration](https://github.com/pwndbg/pwndbg/blob/dev/FEATURES.md#ghidra)
- Refactor of the scripts for easier extension and modification
- Allow fallback plugin when none selected (especially usefully for pwntools)
- .gdbinit rewritten in python for easier extension
- QoL improvements

## Install
```
git clone https://github.com/Denloob/gdb-pwn-manager.git
cd gdb-pwn-manager
./install.sh
```

You may install the plugins in a custom directory by setting the $GDB_HOME env variable.
It will be used during and after the installation.

After a successful install the following commands will be available to you

```
peda
peda-intel
peda-arm
pwndbg
gef
```

## Update

To update the plugins, run the [update.sh](./update.sh) script. It will run
`git pull` on each of the installed plugins.

## Configuration

### Extending/Adding plugins
If the plugin is a git repo, modify [install.sh](./install.sh) and add a `download`
function call like `download <dirname> <git url> [command to execute after download]`.
Then also modify [update.sh](./update.sh) with a function `update <dirname>`.

Then add to your `.gdbinit` (probably located at `~/.gdbinit`) a function similar
to the other once performing whatever the install procedure is. \
If the install procedure involves using gdb commands (like `source`), `gdb.execute`
can be used.

### Changing default plugin
Open your `.gdbinit` and change the function being called inside the last if statement.
If you want to use plain gdb as default, remove the if statement.

## Uninstall
No uninstall script is provided for safety reasons.
However to uninstall you can delete the following:
- `$GDB_HOME` directory (by default `~/.gdb`)
- gdb run scripts (located at `/usr/bin/`, for names see [gdb_runners/](./gdb_runners))
- .gdbinit (by default `~/.gdbinit`) - Your previous gdbinit is stored at `~/.gdbinit.back_up`
