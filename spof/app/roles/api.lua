local cartridge = require('cartridge')
local rpc = require('cartridge.rpc')
local crud = require('crud')
local log = require('log')
local fun = require('fun')

local function get_employees_by_salary(request)
    local salary = tonumber(request:query_param('salary') or 0)

    local employees, err = crud.select('employee', {{'>=', 'salary', salary}})

    if err ~= nil then
        log.error(err)
        return { status = 500 }
    end

    employees = crud.unflatten_rows(employees.rows, employees.metadata)
    local department_ids = fun.iter(employees):reduce(function(acc, x)
        acc[x.department] = true
        return acc
    end, {})

    local connection = assert(rpc.get_connection('app.roles.dictionary'))
    local deps_data = connection:call('select', department_ids)

    employees = fun.iter(employees):map(function(x)
        return {
            employee_id = x.employee_id,
            name = x.name,
            department = deps_data[x.department],
            position = x.position,
            salary = x.salary,
        }
    end):totable()
    return request:render({json = employees})
end

local function post_employee(request)
    local employee = request:json()

    local _, err = crud.insert_object('employee', employee)

    if err ~= nil then
        log.error(err)
        return {status = 500}
    end
    return {status = 200}
end

local function post_department(request)
    local employee = request:json()

    local _, err = crud.insert_object('employee', employee)

    if err ~= nil then
        log.error(err)
        return {status = 500}
    end
    return {status = 200}
end

local function init()
    local httpd = assert(cartridge.service_get('httpd'), "Failed to get httpd service")

    httpd:route({method = 'GET', path = '/employees'}, get_employees_by_salary)
    httpd:route({method = 'POST', path = '/employee'}, post_employee)

    return true
end

return {
    init = init,
    dependencies = {'cartridge.roles.crud-router'},
}
