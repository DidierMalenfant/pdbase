-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

import "CoreLibs/graphics"
import "CoreLibs/object"

dm = dm or {}
dm.debug = dm.debug or {}

local debug <const> = dm.debug
local Plupdate <const> = dm.Plupdate
local gfx <const> = playdate.graphics

class('DebugText', { }, debug).extends()

function debug.DebugText:init(text, x, y, duration)
    self.text = text
    self.x = x
    self.y = y
    self.duration = duration
end

local text_background_color = gfx.kColorWhite
local debug_texts = { }
local debug_text_was_init = false
local memoryInit = 0
local memoryUsed = 0

local function text_init()
    if debug_text_was_init == true then
        return
    end

    Plupdate.addPostCallback(function()
        local debug_texts_to_delete = { }

        for i, debug_text in ipairs(debug_texts) do
            -- Save current state.
            gfx.pushContext()

            gfx.setDrawOffset(0, 0)
            gfx.setColor(text_background_color)
            gfx.setImageDrawMode(gfx.kDrawModeCopy)

            -- Draw the text.
            local width, height = gfx.getTextSize(debug_text.text)
            gfx.fillRect(debug_text.x, debug_text.y, width, height)
            gfx.drawText(debug_text.text, debug_text.x, debug_text.y)

            -- Restore all the things we modified.
            gfx.popContext()

            debug_text.duration -= 1

            if debug_text.duration == 0 then
                table.insert(debug_texts_to_delete, i)
            end
        end

        for i, index_to_remove in ipairs(debug_texts_to_delete) do
            table.remove(debug_texts, index_to_remove - i + 1)
        end
    end)

    debug_text_was_init = true
end

function debug.drawText(text, x, y, duration)
    text_init()

    if duration == nil then
        duration = 1
    end

    table.insert(debug_texts, debug.DebugText(text, x, y, duration))
end

function debug.set_text_background_color(color)
    text_background_color = color
end

function debug.memoryCheck(prefix)
    if memoryInit == 0 then
        -- If this is the first time calling this, we just init the module.
        memoryInit = collectgarbage("count")*1024
        memoryUsed = memoryInit

        print(string.format("MemoryCheck: initial memory usage (%d bytes)", memoryInit))

        return
    end

    local new <const> = collectgarbage("count") * 1024
    local diff <const> = new - memoryUsed

    prefix = prefix or 'MemoryCheck'

    if diff > 0 then
        print(string.format("%s: memory alloc\t+%dKB total %dKB (%dKB since start)",
                            prefix, diff // 1024, new // 1024, (new - memoryInit) // 1024))
    elseif diff < 0 then
        print(string.format("%s: memory free\t%dKB total %dKB (%dKB since start)",
                            prefix, diff // 1024, new // 1024, (new - memoryInit) // 1024))
    end

    memoryUsed = new
end
