-- SPDX-FileCopyrightText: 2022-present pdbase contributors
--
-- SPDX-License-Identifier: MIT

dm = dm or {}
dm.filepath = dm.filepath or {}

local filepath <const> = dm.filepath

function filepath.filename(path)
    local path_length = #path

    for i = path_length, 1, -1 do
        if string.sub(path, i, i) == '/' then
            if i == path_length then
                return nil
            end

            return string.sub(path, i + 1, path_length)
        end
    end

    return path
end

function filepath.extension(path)
    local path_length = #path

    for i = path_length, 1, -1 do
        local char = string.sub(path, i, i)
        if char == '/' then
            return nil
        end

        if string.sub(path, i, i) == '.' then
            if i == path_length then
                return nil
            end

            return string.sub(path, i + 1, path_length)
        end
    end

    return nil
end

function filepath.directory(path)
    local path_length = #path

    for i = path_length, 1, -1 do
        if string.sub(path, i, i) == '/' then
            return string.sub(path, 1, i - 1)
        end
    end

    return nil
end

function filepath.basename(path)
    local filename = filepath.filename(path)
    if filename ~= nil then
        local filename_length = #path

        for i = filename_length, 1, -1 do
            if string.sub(path, i, i) == '.' then
                return string.sub(path, 1, i - 1)
            end
        end
    end

    return filename
end

function filepath.join(path1, path2)
    return path1 .. '/' .. path2
end
