set history save
set history filename ~/.gdb_history

python
import sys
import os
# Installed: libstdc++6-10-dbg_10.2.0-5ubuntu1~20.04_amd64.deb
sys.path.insert(0, '/usr/share/gcc-10/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
#register_libstdcxx_printers (None)
end

