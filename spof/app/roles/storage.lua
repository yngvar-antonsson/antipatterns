local function init(opts)
    if opts.is_master then
        local employee = box.schema.space.create('employee', {if_not_exists = true})

        employee:format({
            {name = 'bucket_id', type = 'unsigned'},
            {name = 'employee_id', type = 'string', comment = 'ID сотрудника'},
            {name = 'name', type = 'string', comment = 'ФИО сотрудника'},
            {name = 'department', type = 'string', comment = 'Отдел'},
            {name = 'position', type = 'string', comment = 'Должность'},
            {name = 'salary', type = 'unsigned', comment = 'Зарплата'}
        })

        employee:create_index('primary', {parts = {{field = 'employee_id'}},
            if_not_exists = true })

        employee:create_index('bucket_id', {parts = {{field = 'bucket_id'}},
            unique = false,
            if_not_exists = true })
    end

    return true
end

return {
    init = init,
    dependencies = {'cartridge.roles.crud-storage'},
}
