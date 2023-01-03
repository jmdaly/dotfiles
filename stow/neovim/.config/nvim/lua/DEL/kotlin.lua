local nvim_lsp = require('lspconfig')

if 1 == vim.fn.executable("kotlin-language-server") then
   nvim_lsp.kotlin_language_server.setup{}
   -- Hack recommended at
   -- https://github.com/fwcd/kotlin-language-server/issues/284#issuecomment-817835261
   -- to get Kotlin to be able to find gradle when it's not at the root of the
   -- repo
   nvim_lsp.kotlin_language_server.setup{
      settings = {
         kotlin = {
            compiler = {
               jvm = {
                  target = "1.8";
               }
            };
         };
      }
   }
end
