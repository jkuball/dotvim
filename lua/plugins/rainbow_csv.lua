--- @type LazyPluginSpec[]
local specs = { {
	"https://github.com/mechatroner/rainbow_csv",
	branch = "master", -- the releases are extremely old, just use mainline
	ft = {
		'csv',
		'tsv',
		'csv_semicolon',
		'csv_whitespace',
		'csv_pipe',
		'rfc_csv',
		'rfc_semicolon'
	},
	cmd = {
		'RainbowDelim',
		'RainbowDelimSimple',
		'RainbowDelimQuoted',
		'RainbowMultiDelim'
	}
} }

return specs
