-- Globals provided by pdbase.
stds.github_didiermalenfant_pdbase = {
    globals = {
        enum = {},
        filepath = {
            fields = {
                filename = {},
                extension = {},
                directory = {},
                basename = {},
                join = {},
            }
        },
        math = {
            -- This will be overidden for the math.lua file but here we don't want
            -- to make the entire 'math' global read-write in other pdbase files.
            read_only = true,
            fields = {
                clamp = {},
                ring = {},
                ring_int = {},
                approach = {},
                infinite_approach = {},
                round = {},
                sign = {},
            }
        },
        table = {
            -- This will be overidden for the table.lua file but here we don't want
            -- to make the entire 'table' global read-write in other pdbase files.
            read_only = true,
            fields = {
                random = {},
                each = {},
                newAutotable = {},
            }
        }
    }
}

-- This is only used for the math.lua file
stds.github_didiermalenfant_pdbase_math = {
    globals = {
        math = {
            fields = {
                clamp = {},
                ring = {},
                ring_int = {},
                approach = {},
                infinite_approach = {},
                round = {},
                sign = {},
            }
        },
    }
}

-- This is only used for the table.lua file
stds.github_didiermalenfant_pdbase_table = {
    globals = {
        table = {
            fields = {
                random = {},
                each = {},
                newAutotable = {},
            }
        },
    }
}

std = "lua54+playdate+github_didiermalenfant_pdbase"
files["math.lua"].std = "+github_didiermalenfant_pdbase_math"
files["table.lua"].std = "+github_didiermalenfant_pdbase_table"

operators = {"+=", "-=", "*=", "/="}
