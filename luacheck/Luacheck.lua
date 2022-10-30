-- Globals provided by pdbase.
--
-- This file can be used by toyboypy (https://toyboxpy.io) to import into a project's luacheck config.
--
-- Just add this to your project's .luacheckrc:
--    require "toyboxes/luacheck" (stds, files)
--
-- and then add 'toyboxes' to your std:
--    std = "lua54+playdate+toyboxes"

return {
    globals = {
        dm = {
            fields = {
                enum = {},
                debug = {
                    fields = {
                        DebugText = {
                            fields = {
                                super = {
                                    fields = {
                                        className = {},
                                        init = {}
                                    }
                                },
                                className = {},
                                init = {}
                            }
                        },
                        drawText = {},
                        set_text_background_color = {},
                        memoryCheck = {}
                    }
                },
                filepath = {
                    fields = {
                        filename = {},
                        extension = {},
                        directory = {},
                        basename = {},
                        join = {}
                    }
                },
                Sampler = {
                    fields = {
                        super = {
                            fields = {
                                className = {},
                                init = {}
                            }
                        },
                        className = {},
                        new = {},
                        init = {},
                        reset = {},
                        print = {},
                        draw = {}
                    }
                },
                math = {
                    fields = {
                        clamp = {},
                        ring = {},
                        ring_int = {},
                        approach = {},
                        infinite_approach = {},
                        round = {},
                        sign = {}
                    }
                },
                table = {
                    fields = {
                        count = {},
                        random = {},
                        each = {},
                        newAutotable = {},
                        filter = {}
                    }
                }
            }
        }
    }
}
