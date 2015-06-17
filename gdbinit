set history save
set history filename ~/.gdb_history

python
import sys
sys.path.insert(0, '/home/matt/distribs/gdb_printers/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
#register_libstdcxx_printers (None)
end

