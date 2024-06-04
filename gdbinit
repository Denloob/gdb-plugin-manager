set debuginfod enabled on

python
import functools
from typing import Callable, Any

plugin_initialized = False
def plugin_initializer(f: Callable) -> Callable:
    @functools.wraps(f)
    def wrapper(*args: Any, **kwargs: Any) -> Any:
        global plugin_initialized
        plugin_initialized = True
        return f(*args, **kwargs)

    return wrapper

@plugin_initializer
def init_peda():
    gdb.execute("source ~/.gdb/peda/peda.py")

@plugin_initializer
def init_peda_arm():
    gdb.execute("source ~/.gdb/peda-arm/peda-arm.py")

@plugin_initializer
def init_peda_intel():
    gdb.execute("source ~/.gdb/peda-arm/peda-intel.py")

@plugin_initializer
def init_pwndbg():
    gdb.execute("source ~/.gdb/pwndbg/gdbinit.py")

    gdb.execute("source ~/.gdb/splitmind/gdbinit.py")

    import splitmind
    (splitmind.Mind()
      .below(display="backtrace")
      .right(display="stack")
      .right(display="regs")
      .right(of="main", display="disasm")
      .show("legend", on="disasm")
    ).build()

@plugin_initializer
def init_gef():
    gdb.execute("source ~/.gdb/gef/gef.py")

if not plugin_initialized:
    # Initialize a default plugin if none were executed
    init_pwndbg()
end
