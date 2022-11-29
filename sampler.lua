-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

import "CoreLibs/graphics"
import "CoreLibs/object"

dm = dm or {}

-- Graphs samples collected/frame against a specified sample duration
class('Sampler', { }, dm).extends()

local Sampler <const> = dm.Sampler
local gfx <const> = playdate.graphics

function Sampler.new(...)
    return Sampler(...)
end

function Sampler:init(sample_period, sampler_fn)
    Sampler.super.init(self)

    self.sample_period = sample_period
    self.sampler_fn = sampler_fn
    self.max_nb_of_samples = 30

    self:reset()
end

function Sampler:reset()
    self.last_sample_time = nil
    self.samples = {}
    self.current_sample = {}
    self.current_sample_time = 0
    self.high_watermark = 0
end

function Sampler:print(prefix, display_log)
    if display_log == nil then
        display_log = false
    end

    if prefix ~= nil then
        print(prefix)
    end

    print('Now: '..self.samples[#self.samples])
    print('High Watermark: '..self.high_watermark)
    print('Average: '..self:currentAverage())

    if display_log == true then
        print('Log:')
        for _, v in ipairs(self.samples) do
            print('\t'..v)
        end
    end
end

function Sampler:setMaxNbOfSamples(nb_of_samples)
    self.max_nb_of_samples = nb_of_samples
end

function Sampler:addValue(value)
    assert(self.sampler_fn == nil, 'Sample: Should not manually add values if a smapling function was provided.')

    self.high_watermark = math.max(self.high_watermark, value)
    self.samples[#self.samples + 1] = value

    self:pruneSamples()
end

function Sampler:pruneSamples(nb_of_samples)
    if nb_of_samples ~= nil then
        self.max_nb_of_samples = math.max(nb_of_samples, self.max_samples)
    end

    while #self.samples == self.max_nb_of_samples do
        table.remove(self.samples, 1)
    end
end

function Sampler:currentHighWatermark()
    return self.high_watermark
end

function Sampler:currentAverage()
    local current_sample_avg = 0

    for _, v in ipairs(self.samples) do
        current_sample_avg = current_sample_avg + v
    end

    current_sample_avg /= #self.samples

    return current_sample_avg
end

function Sampler:draw(x, y, width, height)
    local time_delta = 0
    local current_time <const> = playdate.getCurrentTimeMilliseconds()
    local graph_padding <const> = 1
    local draw_height <const> = height - (graph_padding * 2)
    local draw_width <const> = width - (graph_padding * 2)

    if self.sampler_fn ~= nil then
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
                local current_sample_avg = self.currentAverage()
                self.high_watermark = math.max(self.high_watermark, current_sample_avg)
                self.samples[#self.samples + 1] = current_sample_avg
            end

            self.current_sample = {}
        end

        self:pruneSamples(draw_width)
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
