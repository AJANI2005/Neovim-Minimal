vim.o.termguicolors = true
vim.g.colors_name = "custom"

local c = {
	bg         = "#1e1e1e",
	bg_dark    = "#181818",
	bg_light   = "#252526",
	fg         = "#d4d4d4",
	fg_dim     = "#808080",

	red        = "#f44747",
	orange     = "#ce9178",
	yellow     = "#dcdcaa",
	green      = "#6a9955",
	cyan       = "#4ec9b0",
	blue       = "#569cd6",
	blue_light = "#9cdcfe",
	purple     = "#c586c0",

	border     = "#3e3e42",
	selection  = "#264f78",
	cursor     = "#aeafad",
}

local highlights = {
	Normal = { fg = c.fg, bg = c.bg },
	NormalFloat = { fg = c.fg, bg = c.bg_light },

	Cursor = { fg = c.bg, bg = c.cursor },
	CursorLine = { bg = c.bg_light },
	CursorColumn = { bg = c.bg_light },

	LineNr = { fg = c.fg_dim },
	CursorLineNr = { fg = c.fg },

	Visual = { bg = c.selection },
	Search = { fg = c.bg, bg = c.yellow },
	IncSearch = { fg = c.bg, bg = c.orange },

	StatusLine = { fg = c.fg, bg = c.bg_light },
	StatusLineNC = { fg = c.fg_dim, bg = c.bg_dark },
	WinSeparator = { fg = c.border },
	VertSplit = { fg = c.border },
	FloatBorder = { fg = c.border, bg = c.bg_light },

	Pmenu = { fg = c.fg, bg = c.bg_light },
	PmenuSel = { fg = c.fg, bg = c.selection },
	PmenuSbar = { bg = c.border },
	PmenuThumb = { bg = c.fg_dim },

	ErrorMsg = { fg = c.red },
	WarningMsg = { fg = c.yellow },
	MoreMsg = { fg = c.green },
	Question = { fg = c.cyan },

	Comment = { fg = c.fg_dim, italic = true },

	Constant = { fg = c.blue_light },
	String = { fg = c.orange },
	Character = { fg = c.orange },
	Number = { fg = c.blue_light },
	Boolean = { fg = c.blue_light },

	Identifier = { fg = c.blue_light },
	Function = { fg = c.yellow },

	Statement = { fg = c.purple },
	Conditional = { fg = c.purple },
	Repeat = { fg = c.purple },
	Operator = { fg = c.fg },
	Keyword = { fg = c.purple },

	Type = { fg = c.cyan },
	Structure = { fg = c.cyan },
	StorageClass = { fg = c.blue },

	Special = { fg = c.cyan },
	Delimiter = { fg = c.fg },

	DiffAdd = { fg = c.green },
	DiffChange = { fg = c.yellow },
	DiffDelete = { fg = c.red },
	DiffText = { fg = c.blue },

	DiagnosticError = { fg = c.red },
	DiagnosticWarn = { fg = c.yellow },
	DiagnosticInfo = { fg = c.blue },
	DiagnosticHint = { fg = c.cyan },

	DiagnosticUnderlineError = { undercurl = true, sp = c.red },
	DiagnosticUnderlineWarn = { undercurl = true, sp = c.yellow },
	DiagnosticUnderlineInfo = { undercurl = true, sp = c.blue },
	DiagnosticUnderlineHint = { undercurl = true, sp = c.cyan },

	LspReferenceText = { bg = c.bg_light },
	LspReferenceRead = { bg = c.bg_light },
	LspReferenceWrite = { bg = c.bg_light },

	Folded = { fg = c.fg_dim, bg = c.bg_light },
	FoldColumn = { fg = c.fg_dim, bg = c.bg },

	Title = { fg = c.blue_light, bold = true },
}

for group, opts in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, opts)
end
