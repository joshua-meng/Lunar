local table_ext = require('table_ext')

local pattern_class_begin = [[([%w_%.]+)%s*=%s*([%w_%.]+)%.extend%s*%(]]
local pattern_method = [[([%w_]+)%s*:%s*function%s*%((.*)%)]]
local pattern_arrow_method = [[([%w_]+)%s*:%s*%((.*)%)%s*=>]]

function parseFile(filename, classes)
    local f = io.open(filename, "r")
    if f then
        local line = f:read('*line')
        local current_class = nil
        local line_number = 1
        while line do
            repeat
                local trim_line = util.strTrim(line)
                --comments
                if string.len(trim_line) == 0 or util.strStartWith(trim_line, '/') or util.strStartWith(trim_line, '*') then
                    break
                end
                
                --match class start
                local class, super = string.match(trim_line, pattern_class_begin)
                if class and super then
                    current_class = { name = class, extends = {}, methods = {}, fields = {}, file = filename, line_number = line_number, line = line }
                    table.insert(current_class.extends, super)
                    break
                end
                
                if current_class then
                    local method, params = string.match(trim_line, pattern_method)
                    if method and params then
                        table.insert(current_class.methods, { name = method, args = params, file = filename, line_number = line_number, line = line })
                        if method == 'ctor' then
                            table.insert(current_class.methods, { name = 'create', args = params, file = filename, line_number = line_number, line = line })
                        end
                        break
                    end
                    
                    method, params = string.match(trim_line, pattern_arrow_method)
                    if method and params then
                        table.insert(current_class.methods, { name = method, args = params, file = filename, line_number = line_number, line = line })
                        if method == 'ctor' then
                            table.insert(current_class.methods, { name = 'create', args = params, file = filename, line_number = line_number, line = line })
                        end
                        break
                    end
                end
                
                --match class end
                if util.strStartWith(line, '});') then
                    if current_class then
                        classes[current_class.name] = current_class
                        current_class = nil
                    end
                    break
                end
            until true
            line = f:read("*line")
            line_number = line_number + 1
        end
        io.close(f)
    end
end

function processExtends(class, extends, classes, apis)
    for _, e in ipairs(extends) do
        local extend_class = classes[e]
        if extend_class then
                for _, v in ipairs(extend_class.methods) do
                    apis[string.format('%s.%s(%s)', class.name, v.name, v.args)] = true
                end
            processExtends(class, extend_class.extends, classes, apis)
        end
    end
end

function inClassRange(filename, current_line_number)
    local f = io.open(filename, "r")
    local return_class = nil
    local out_of_range = false
    if f then
        local line = f:read('*line')
        local current_class = nil
        local line_number = 1
        while line do
            repeat
                if current_class and line_number == current_line_number then
                    return_class = current_class
                    break
                end
                
                local trim_line = util.strTrim(line)
                --comments
                if string.len(trim_line) == 0 or util.strStartWith(trim_line, '/') or util.strStartWith(trim_line, '*') then
                    break
                end

                --match class start
                local class, super = string.match(trim_line, pattern_class_begin)
                if class and super then
                    current_class = class
                    if line_number > current_line_number then
                        out_of_range = true
                    end
                    break
                end
                
                --match class end
                if util.strStartWith(line, '});') then
                    if current_class then
                        current_class = nil
                    end
                    break
                end
            until true
            line = f:read("*line")
            line_number = line_number + 1
            
            if return_class or out_of_range then
                break
            end
        end
        io.close(f)
    end
    
    return return_class
end

function parseSupplementApi(filename, cursor_line, project_src_dir)
    local apis = {}
    
    local classes = table_ext.load('cocos_api_tb')
    local js_files = util.findFilesInDirRecursively(project_src_dir, 'js')
    for _, v in ipairs(js_files) do
        parseFile(v, classes)
    end
    
    -- process this in range
    local range_class_name = inClassRange(filename, cursor_line)
    if range_class_name then
        local range_class = classes[range_class_name]
        if range_class then
            local this_tb = table_ext.shallowCopy(range_class)
            this_tb.name = 'this'
            classes['this'] = this_tb
        end
    end

    --process extends
    local apis = {}
    for _, c in pairs(classes) do
        for _, v in ipairs(c.methods) do
            apis[string.format('%s.%s(%s)', c.name, v.name, v.args)] = true
        end
        processExtends(c, c.extends, classes, apis)
    end

    local array = {}
    for k, _ in pairs(apis) do
        table.insert(array, k)
    end

    table.sort(array)

    return array
end
