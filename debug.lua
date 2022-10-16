-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

import "CoreLibs/graphics"
import "CoreLibs/object"

pdbase = pdbase or {}
pdbase.debug = pdbase.debug or {}

local gfx <const> = playdate.graphics

class('DebugText', { }, pdbase.debug).extends()

function pdbase.debug.DebugText:init(text, x, y, duration)
    self.text = text
    self.x = x
    self.y = y
    self.duration = duration
end

local text_background_color = gfx.kColorWhite
local debug_texts = { }
local debug_text_was_init = false

function pdbase.debug.init()
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

function pdbase.debug.drawText(text, x, y, duration)
    pdbase.debug.init()

    if duration == nil then
        duration = 1
    end

    table.insert(debug_texts, pdbase.debug.DebugText(text, x, y, duration))
end

function pdbase.debug.set_text_background_color(color)
    text_background_color = color
end
