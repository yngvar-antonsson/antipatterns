local fiber = require('fiber')

local utils = {}

function utils.yield_every(batch_size, iter)
    local i = 0
    return iter:map(function(...)
        i = i + 1
        if i % batch_size == 0 then
            fiber.yield()
        end
        return ...
    end)
end

return utils
