python
import sys
import os
# Installed: libstdc++6-10-dbg_10.2.0-5ubuntu1~20.04_amd64.deb
sys.path.insert(0, '/usr/share/gcc/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
#register_libstdcxx_printers (None)
end

set verbose off
set print pretty on
set history save
set history filename ~/.gdb_history

set pagination off
set confirm off
set breakpoint pending on

set auto-load safe-path /f/phoenix/phx-fsb

# source ~matt/dotfiles/gdb-dashboard/.gdbinit
