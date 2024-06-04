set debuginfod enabled on

python
def init_peda():
    gdb.execute("source ~/.gdb/peda/peda.py")

def init_peda_arm():
    gdb.execute("source ~/.gdb/peda-arm/peda-arm.py")

def init_peda_intel():
    gdb.execute("source ~/.gdb/peda-arm/peda-intel.py")

def init_pwndbg():
    gdb.execute("source ~/.gdb/pwndbg/gdbinit.py")

def init_gef():
    gdb.execute("source ~/.gdb/gef/gef.py")
end
