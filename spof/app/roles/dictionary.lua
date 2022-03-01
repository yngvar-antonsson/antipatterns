local utils = require('app.utils')

local function init(opts)
    if opts.is_master then
        local departments = box.schema.space.create('departments', {if_not_exists = true})

        -- задаем формат
        departments:format({
            {name = 'department_id', type = 'string'},
            {name = 'name', type = 'string'},
            {name = 'manager', type = 'string'},
            {name = 'employee_count', type = 'unsigned'},
        })

        -- Создаем первичный индекс
        departments:create_index('primary', {parts = {{field = 'department_id'}},
            if_not_exists = true })
    end

    return true
end

local function select(department_ids)
    return utils.yield_every(500, box.space.departments:pairs()):
        filter(function(x)
            return department_ids[x.department_id]
        end):reduce(function(acc, x)
            acc[x.department_id] = x
            return acc
        end, {})
end

local function insert(data)
    return box.space.departments:put(box.space.departments:frommap(data))
end

return {
    init = init,
    select = select,
    insert = insert,
}
