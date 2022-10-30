-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

dm = dm or {}
dm.table = dm.table or {}

local table <const> = dm.table

function table.count(t)
    local count = 0

    for _ in pairs(t) do
        count += 1
    end

    return count
end

function table.random(t)
    if type(t) ~= 'table' then
        return nil
    end

    return t[math.ceil(math.random(#t))]
end

function table.each(t, funct)
    if type(funct)~='function' then
        return
    end

    for _, e in pairs(t) do
        funct(e)
    end
end

function table.newAutotable(dim)
    local MT = {};
    for i=1, dim do
        MT[i] = {__index = function(t, k)
            if i < dim then
                t[k] = setmetatable({}, MT[i+1])
                return t[k];
            end
        end}
    end

    return setmetatable({}, MT[1]);
end

function table.filter(t, filterFunction)
    local out = {}

    for _, value in pairs(t) do
        if (filterFunction(value)) then
            table.insert(out,value)
        end
    end

    return out
end
