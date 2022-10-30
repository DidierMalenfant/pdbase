-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

dm = dm or {}

function dm.enum(t)
    local result = {}

    for index, name in pairs(t) do
        result[name] = index
    end

    return result
end
