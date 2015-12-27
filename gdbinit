set history save
set history filename ~/.gdb_history

python
import sys
import os
sys.path.insert(0, '%s/distribs/gdb_printers/python'%(os.environ['HOME']))
from libstdcxx.v6.printers import register_libstdcxx_printers
#register_libstdcxx_printers (None)
end

