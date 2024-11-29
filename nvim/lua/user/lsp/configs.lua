local m = require("mason")
m.setup()
local status_ok, lsp_installer = pcall(require, "mason-lspconfig")
if not status_ok then
	return
end

local lspconfig = require("lspconfig")

local function getLinuxDistroFromReleaseFile()
    local f = io.open("/etc/os-release", "r")
    if not f then return nil end

    for line in f:lines() do
        if line:match("^ID=") then
            local distroName = line:match("[^=]+") -- Extract value after "=" sign
            return distroName
        end
    end
    f:close()
    return nil
end

-- (proycon) I don't think it should be necessary to add all those explicitly here (kinda conflicts with nvim-lsp-installer), but I can't get it to work otherwise
local servers = { "jsonls", "lua_ls", "pyright", 'html', 'bashls', 'rust_analyzer', 'texlab', 'yamlls', 'jsonls', 'jdtls','kotlin_language_server',  'cssls', 'eslint', 'gopls', 'ansiblels', 'zls' }
-- (proycon) these don't work on arm alpine: 'clangd', 'lemminx', add them conditionally
local distro = getLinuxDistroFromReleaseFile()
if distro ~= "postmarketos" and distro ~= "alpine" then
   table.insert(servers, "clangd")
   table.insert(servers, "lemminx")
end

lsp_installer.setup {
	ensure_installed = servers
}

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
	if has_custom_opts then
	 	opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
	end
	lspconfig[server].setup(opts)
end


