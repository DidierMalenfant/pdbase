-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

function enum( t )
    local result = {}

    for index, name in pairs(t) do
        result[name] = index
    end

    return result
end
