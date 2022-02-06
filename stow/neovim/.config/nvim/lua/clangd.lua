local nvim_lsp = require('lspconfig')

local clang_path = '/usr'

-- Clangd Config file is at /home/matt/.config/clangd/config.yaml

local gcc_drivers = {
  '/usr/bin/**/clang-*',
  '/opt/phoenix/phx-fsb/output/phoenix_hi/package/sdp710-qc/stage/host/linux/x86_64/usr/bin/ntoaarch64-*',
  '/opt/phoenix/phx-fsb/output/phoenix_hi/package/sdp710-qc/stage/host/linux/x86_64/usr/bin/q++'
}
function listvalues(s)
    local t = { }
    for k,v in ipairs(s) do
        t[#t+1] = tostring(v)
    end
    return table.concat(t,",")
end
local gcc_driver_str = listvalues(gcc_drivers)

-- Set up clangd
nvim_lsp.clangd.setup{
  cmd = {
    clang_path .. "/bin/clangd",
    "--clang-tidy",
    "--suggest-missing-includes",
    "--background-index",
    "--header-insertion=iwyu",
    -- '--query-driver="' .. gcc_driver_str .. '"',
  },
  on_attach = on_attach,
}
