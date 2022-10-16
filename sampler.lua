-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

import "CoreLibs/graphics"
import "CoreLibs/object"

local gfx = playdate.graphics

pdbase = pdbase or {}

-- Graphs samples collected/frame against a specified sample duration
class('Sampler', { }, pdbase).extends()

function pdbase.Sampler.new(...)
    return pdbase.Sampler(...)
end

function pdbase.Sampler:init(sample_period, sampler_fn)
    pdbase.Sampler.super.init(self)

    self.sample_period = sample_period
    self.sampler_fn = sampler_fn
    self:reset()
end

function pdbase.Sampler:reset()
    self.last_sample_time = nil
    self.samples = {}
    self.current_sample = {}
    self.current_sample_time = 0
    self.high_watermark = 0
end

function pdbase.Sampler:print()
    print('')

    print('Sampler Info')
    print('=================')
    print('Now: '..self.samples[#self.samples])
    print('High Watermark: '..self.high_watermark)

    local current_sample_avg = 0
    for _, v in ipairs(self.samples) do
        current_sample_avg = current_sample_avg + v
    end
    current_sample_avg /= #self.samples
    print('Average: '..current_sample_avg)

    print('Log:')
    for _, v in ipairs(self.samples) do
        print('\t'..v)
    end

    print('')
end

function pdbase.Sampler:draw(x, y, width, height)
    local time_delta = 0
    local current_time <const> = playdate.getCurrentTimeMilliseconds()
    local graph_padding <const> = 1
    local draw_height <const> = height - (graph_padding * 2)
    local draw_width <const> = width - (graph_padding * 2)

    if self.last_sample_time then
        time_delta = (current_time - self.last_sample_time)
    end
    self.last_sample_time = current_time

    self.current_sample_time += time_delta
    if self.current_sample_time < self.sample_period then
        self.current_sample[#self.current_sample + 1] = self.sampler_fn()
    else
        self.current_sample_time = 0
        if #self.current_sample > 0 then
            local current_sample_avg = 0
            for _, v in ipairs(self.current_sample) do
                current_sample_avg = current_sample_avg + v
            end
            current_sample_avg /= #self.current_sample
            self.high_watermark = math.max(self.high_watermark, current_sample_avg)
            if #self.samples == draw_width then
                table.remove(self.samples, 1)
            end
            self.samples[#self.samples + 1] = current_sample_avg
        end
        self.current_sample = {}
    end

    -- Render graph
    gfx.setDrawOffset(0, 0)
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(x, y, width, height)
    gfx.setColor(gfx.kColorBlack)

    for i, v in ipairs(self.samples) do
        local sample_height <const> = math.max(0, draw_height * (v / self.high_watermark))
        gfx.drawLine(x + graph_padding + i - 1,
                     y + height - graph_padding,
                     x + i - 1 + graph_padding,
                     (y + height - graph_padding) - sample_height)
    end
end
