-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

import "CoreLibs/graphics"
import "CoreLibs/frameTimer"

pdbase = pdbase or {}
pdbase.debug = pdbase.debug or {}

local gfx <const> = playdate.graphics

local textBackgroundColor = gfx.kColorWhite

local drawTextFunc = function(text, x, y)
    -- Save current state.
    local doff_x, doff_y = gfx.getDrawOffset()
    gfx.setDrawOffset(0, 0)
    
    local color = gfx.getColor()
    gfx.setColor(textBackgroundColor)
    
    local dmode = gfx.getImageDrawMode()    
    gfx.setImageDrawMode(gfx.kDrawModeCopy)    
    
    -- Draw the text.
    local width, height = gfx.getTextSize(text)
    gfx.fillRect(x, y, width, height)
    gfx.drawText(text, x, y)
    
    -- Restore all the things we modified.
    gfx.setDrawOffset(doff_x, doff_y)
    gfx.setColor(color)
    gfx.setImageDrawMode(dmode)        
end

function pdbase.debug.drawText(text, x, y, duration)
    if duration ~= nil then
        local timer = playdate.frameTimer.new(duration)
        timer.updateCallback = function(timer)
            drawTextFunc(text, x, y)
        end
    else
        drawTextFunc(text, x, y)
    end
end

function pdbase.debug.setTextBackgroundColor(color)
    textBackgroundColor = color
end
