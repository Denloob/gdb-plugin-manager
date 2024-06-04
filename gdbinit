set debuginfod enabled on

python
import os

GDB_HOME=os.environ.get("GDB_HOME", "~/.gdb/")

def init_peda():
    gdb.execute(f"source {GDB_HOME}/peda/peda.py")

def init_peda_arm():
    gdb.execute(f"source {GDB_HOME}/peda-arm/peda-arm.py")

def init_peda_intel():
    gdb.execute(f"source {GDB_HOME}/peda-arm/peda-intel.py")

def init_pwndbg():
    gdb.execute(f"source {GDB_HOME}/pwndbg/gdbinit.py")

    gdb.execute(f"source {GDB_HOME}/splitmind/gdbinit.py")

    import splitmind
    (splitmind.Mind()
      .below(display="backtrace")
      .right(display="stack")
      .right(display="regs")
      .right(of="main", display="disasm")
      .show("legend", on="disasm")
    ).build()

def init_gef():
    gdb.execute(f"source {GDB_HOME}/gef/gef.py")

if "GDB_PWN_MANAGER" not in os.environ:
    # Initialize a default plugin if none were executed
    init_pwndbg()
end
