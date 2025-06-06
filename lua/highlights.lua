local M = {}

M.add = {
  -- nvdash
  NvDashLazy = {
    fg = "#ff34b3",
    -- bg = "#201148",
  },

  -- quickscope highlight colors
  EyelinerPrimary = {
    fg = "#afff5f",
    underline = true,
    bold = true,
  },
  EyelinerSecondary = {
    fg = "#5fffff",
    underline = true,
  },
  EyelinerDimmed = {
    fg = "#444b6a",
  },

  -- virt-column color
  VirtColumn = {
    fg = "#992975",
  },

  -- statusline git-branch color
  GitBranch = {
    fg = "#bb9af7",
    -- bg = "#1f202b",
    bg = "#1d1e29",
  },

  -- neo-tree
  NeoTreeNormal = { bg = "#16161e" },
  NeoTreeNormalNC = { bg = "#16161e" },
  NeoTreeTitle = { fg = "#16161e" },
  NeoTreeRootName = { underline = false, bold = true },

  NeoTreeCursorLine = { bg = "#292e42" },
  -- NeoTreeDirectoryName = { fg = "#c0caf5" },

  NeoTreeGitStaged = { fg = "#7ece6a" },
  NeoTreeGitUnstaged = { fg = "#e0af68" },

  NeoTreeGitAdded = { fg = "#7ece6a" },
  NeoTreeGitDeleted = { fg = "#f7768e" },

  NeoTreeGitModified = { fg = "#e0af68" },
  NeoTreeGitUntracked = { fg = "#b4f9f8" },

  -- treesitter
  ["@type"] = { fg = "#7dcfff" },
  ["@type.definition"] = { fg = "#bb9af7" },
  ["@type.qualifier"] = { fg = "#bb9af7" },
  ["@attribute"] = { fg = "#b4f9f8" },
  ["@boolean"] = { fg = "#ff9e64" },
  ["@number"] = { fg = "#ff9e64" },
  ["@class.name"] = { fg = "#c0caf5" },
  ["@function.type"] = { fg = "#9abdf5" },
  ["@text.todo"] = { bg = "#e0af68", fg = "#2f1519", bold = true },
  ["@text.danger"] = { bg = "#f7778e", fg = "#2f3549", bold = true },
  ["@text.warning"] = { bg = "#ff9364", fg = "#2f3549", bold = true },
  ["@text.note"] = { bg = "#73daca", fg = "#2f3549", bold = true },
  ["@namespace.identifier"] = { fg = "#0db9d7" },
  ["doxygenParam"] = { fg = "#73daca", bold = true },

  -- telescope
  TelescopePromptCounter = { fg = "#e0af68", bold = true },

  -- tab
  TabLine = {
    -- bg = "#24283b",
    bg = "#16161e",
    fg = "#787c99",
  },
  TabLineFill = {
    bg = "#16161e",
    fg = "#787c99",
  },
  TabLineSel = {
    bg = "#444b6a",
    -- fg = "#73daca",
    fg = "#7dcfff",
    underline = true,
    bold = true,
  },

  -- hlslens
  HlSearchLens = {
    bg = "#2f3549",
    fg = "#787c99",
  },
  HlSearchLensNear = {
    fg = "#060606",
    bg = "#ff9364",
  },

  -- winbar
  WinbarTitle = {
    fg = "#a9b1d6",
    bg = "none",
    bold = true,
  },

  -- gitsigns
  GitSignDiffAdd = { fg = "#7ece6a", bg = "none" },
  GitSignDiffChange = { fg = "#e0af68", bg = "none" },
  GitSignDiffDelete = { fg = "#f7768e", bg = "none" },
  GitSignDiffText = { fg = "#c0caf5", bg = "none" },

  -- diffview
  DiffviewDiffAddAsDelete = { bg = "#3f2d3d", fg = "none" },
  DiffviewDiffDelete = { bg = "none", fg = "#3b4252" },

  -- Left panel
  -- "DiffChange:DiffAddAsDelete",
  -- "DiffText:DiffDeleteText",
  DiffAddAsDelete = { bg = "#37222c", fg = "none" },
  DiffDeleteText = { bg = "#4b1818", fg = "none" },

  -- Right panel
  -- "DiffChange:DiffAdd",
  -- "DiffText:DiffAddText",
  DiffAddText = { bg = "#1c5458", fg = "none" },

  -- noice
  NoiceCmdlinePopupBorder = { fg = "#7dcfff" },
  NoiceCmdlinePopupTitle = { fg = "#7dcfff", bold = true },
}

M.override = {
  -- nvdash
  -- #55e7ff,#00ccfd,#ff34b3,#2011a2,#201148
  NvDashAscii = {
    bg = "#2011a2",
    fg = "#00ccfd",
    -- bg = "#ff34b3",
    -- fg = "#201148",
  },

  NvDashButtons = {
    bg = "#16161e",
    fg = "#7dcfff",
  },

  -- default highlight groups
  Comment = {
    fg = "#4caf50",
    italic = false,
  },
  NonText = {
    fg = "#ff2233",
  },
  WinSeparator = {
    fg = "#16161e",
  },

  -- nvimtree
  NvimTreeRootFolder = {
    fg = "#0db9d7",
  },
  NvimTreeSpecialFile = {
    fg = "#bb9af7",
  },
  NvimTreeFolderName = {
    fg = "#c0caf5",
  },
  NvimTreeGitNew = {
    fg = "#b4f9f8",
  },
  NvimTreeGitDirty = {
    fg = "#e0af68",
  },

  -- treesitter
  ["@type.builtin"] = { fg = "#bb9af7" },
  ["@namespace"] = { fg = "#c0caf5" },
  ["@field"] = { fg = "#9abdf5" },
  ["@property"] = { fg = "#73daca" },
  ["@constant.builtin"] = { fg = "#ff9e64" },
  ["@character"] = { fg = "#9ece6a" },
  ["StorageClass"] = { fg = "#bb9af7" },

  -- indent-blankline
  -- IndentBlanklineChar = { fg= "#444b6a" },
  IndentBlanklineContextChar = { fg = "#787c99" },

  -- diffview
  DiffAdd = { bg = "#20303b", fg = "none" },
  DiffChange = { bg = "#242a40", fg = "none" },
  DiffDelete = { bg = "#37222c" },
  DiffText = { bg = "#30404b", fg = "none" },

  -- status line
  DiffAdded = { bg = "#1d1e29" },
  DiffModified = { bg = "#1d1e29" },
  DiffRemoved = { bg = "#1d1e29" },

  -- nvchad ui statusline
  St_cwd = { fg = "#2ac3de" },

  -- document highlight using LSP
  LspReferenceRead = { bg = "#2f3549", fg = "none" },
  LspReferenceText = { bg = "#2f3549", fg = "none" },
  LspReferenceWrite = { bg = "#2f3549", fg = "none" },

  -- navic breadcrumb
  NavicText = { bg = "none", fg = "#b4f9f8" },
  NavicIconsFile = { bg = "none" },
  NavicIconsModule = { bg = "none" },
  NavicIconsNamespace = { bg = "none" },
  NavicIconsPackage = { bg = "none" },
  NavicIconsClass = { bg = "none" },
  NavicIconsMethod = { bg = "none" },
  NavicIconsProperty = { bg = "none" },
  NavicIconsField = { bg = "none" },
  NavicIconsConstructor = { bg = "none" },
  NavicIconsEnum = { bg = "none" },
  NavicIconsInterface = { bg = "none" },
  NavicIconsFunction = { bg = "none" },
  NavicIconsVariable = { bg = "none" },
  NavicIconsConstant = { bg = "none" },
  NavicIconsString = { bg = "none" },
  NavicIconsNumber = { bg = "none" },
  NavicIconsBoolean = { bg = "none" },
  NavicIconsArray = { bg = "none" },
  NavicIconsObject = { bg = "none" },
  NavicIconsKey = { bg = "none" },
  NavicIconsNull = { bg = "none" },
  NavicIconsEnumMember = { bg = "none" },
  NavicIconsStruct = { bg = "none" },
  NavicIconsEvent = { bg = "none" },
  NavicIconsOperator = { bg = "none" },
  NavicIconsTypeParameter = { bg = "none" },
  NavicSeparator = { bg = "none" },
}

M.changed_themes = {
  tokyonight = {
    base_16 = {
      base00 = "#1a1b26",
      base01 = "#16161e",
      base02 = "#2f3549",
      base03 = "#444b6a",
      base04 = "#787c99",
      base05 = "#a9b1d6",
      base06 = "#cbccd1",
      base07 = "#d5d6db",
      base08 = "#c0caf5",
      base09 = "#a9b1d6",
      base0A = "#0db9d7",
      base0B = "#9ece6a",
      base0C = "#b4f9f8",
      base0D = "#2ac3de",
      base0E = "#bb9af7",
      base0F = "#f7768e",
    },

    polish_hl = {
      treesitter = {
        -- override from nvchad/base46
        ["@method"] = { fg = "#7aa2f7" },
        ["@method.call"] = { fg = "#7aa2f7" },
        ["@function"] = { fg = "#7aa2f7" },
        ["@function.call"] = { fg = "#7aa2f7" },
        ["@function.method.call"] = { fg = "#7aa2f7" },
        ["@constant"] = { fg = "#ff9e64" },
        ["@comment"] = { fg = "#4caf50" },

        -- operators
        ["@operator"] = { fg = "#89ddff" }, -- For any operator: `+`, but also `->` and `*` in C.

        --- punctuation
        ["@punctuation.delimiter"] = { fg = "#89ddff" }, -- For delimiters ie: `.`
        ["@punctuation.bracket"] = { fg = "#a9b1d6" }, -- For brackets and parens.
        ["@punctuation.special"] = { fg = "#89ddff" }, -- For special punctutation that does not fall in the catagories before.
        ["@punctuation.special.markdown"] = { fg = "#ff9e64", bold = true },

        --- literals
        ["@string.documentation"] = { fg = "#4caf50" },
        ["@string.regex"] = { fg = "#b4f9f8" }, -- For regexes.
        ["@string.escape"] = { fg = "#bb9af7" }, -- For escape characters within a string.

        --- functions
        ["@constructor"] = { fg = "#7aa2f7" }, -- For constructor calls and definitions: `= { }` in Lua, and Java constructors.
        ["@parameter"] = { fg = "#e0af68" }, -- For parameters of a function.
        -- ["@parameter.builtin"] = {}, -- For builtin parameters of a function, e.g. "..." or Smali's p[1-99]

        --- keywords
        ["@keyword"] = { fg = "#9d7cd8", bold = true }, -- For keywords that don't fall in previous categories.
        -- ["@keyword.coroutine"] = { }, -- For keywords related to coroutines.
        ["@keyword.function"] = { fg = "#bb9af7" }, -- For keywords used to define a fuction.

        ["@label"] = { fg = "#7aa2f7" }, -- For labels: `label:` in C and `:label:` in Lua.

        --- identifiers
        ["@variable"] = { fg = "#9abdf5" }, -- Any variable name that does not have another highlight.
        ["@variable.builtin"] = { fg = "#f7768e" }, -- Variable names that are defined by the languages, like `this` or `self`.

        --- text
        -- ["@text.literal.markdown"] = { fg = c.blue },
        ["@text.literal.markdown_inline"] = {
          bg = "#414868",
          fg = "#7aa2f7",
        },
        ["@text.reference"] = { fg = "#1abc9c" },
        ["@text.todo.unchecked"] = { fg = "#7aa2f7" }, -- For brackets and parens.
        ["@text.todo.checked"] = { fg = "#73daca" }, -- For brackets and parens.
        ["@text.uri"] = { fg = "#2ac3de" }, -- For URIs.
        -- ["@text.warning"] = { fg = "#24283b", bg = c.warning },
        -- ["@text.danger"] = { fg = "#24283b", bg = c.error },

        ["@text.diff.add"] = { link = "DiffAdd" },
        ["@text.diff.delete"] = { link = "DiffDelete" },
      },
    },
  },
}

return M
