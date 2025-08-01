local util = require("lspconfig.util")

local jsonnet_common_paths = function(root_dir)
	local paths = { root_dir .. "/lib", root_dir .. "/vendor" }
	return table.concat(paths, ":")
end

return {
	default_config = {
		cmd = { "jsonnet-language-server" },
		filetypes = { "jsonnet", "libsonnet" },
		single_file_support = true,
		root_dir = function(fname)
			return util.root_pattern("jsonnetfile.json")(fname)
				or vim.fs.dirname(vim.fs.find(".git", { path = fname, upward = true })[1])
		end,
		on_new_config = function(new_config, root_dir)
			if not new_config.cmd_env then new_config.cmd_env = {} end
			if not new_config.cmd_env.JSONNET_PATH then
				new_config.cmd_env.JSONNET_PATH = jsonnet_common_paths(root_dir)
			end
		end,
	},
	docs = {
		description = [[
https://github.com/grafana/jsonnet-language-server

A Language Server Protocol (LSP) server for Jsonnet.

The language server can be installed with `go`:
```sh
go install github.com/grafana/jsonnet-language-server@latest
```
]],
	},
}
