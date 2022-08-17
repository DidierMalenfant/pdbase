-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

table = table or {}

function table.random(t)
    if type(t) ~= 'table' then return nil end

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
