--table辅助函数
--[[
This function returns a deep copy of a given table.
The function below also copies the metatable to the
new table if there is one, so the behaviour of the 
copied table is the same as the original. But the 2 
tables share the same metatable, you can avoid this 
by changing this 'getmetatable(object)' to 
'_copy( getmetatable(object) )'.
]]

function th_table_dup(ori_tab)
    if (type(ori_tab) ~= "table") then
        return nil;
    end
    local new_tab = {};
    for i,v in pairs(ori_tab) do
        local vtyp = type(v);
        if (vtyp == "table") then
            new_tab[i] = th_table_dup(v);
        elseif (vtyp == "thread") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        elseif (vtyp == "userdata") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        else
            new_tab[i] = v;
        end
    end
    return new_tab;
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end  -- if
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end  -- for
        return setmetatable(new_table, getmetatable(object))
    end  -- function _copy
    return _copy(object)
end  -- function deepcopy

function printTab(tab,tabName,offset)
    local name = tabName
    if name == nil then name = "" end
    if offset == nil then 
        print("{------------start " ..name.. "-------------") 
    end
    local off = offset
    if off == nil then off = 4 end
    local str = string.rep(" ", off)
    for i,v in pairs(tab) do
        if type(v) == "table" then
            print(str .. i,"{")
            printTab(v,nil,off+4)
            print(str .. "}")
        else
            if type(v) == "boolean" then
                if v == true then 
                    v = "true"
                else
                    v = "false"
                end
            end
            print(str .. i .. "==" .. v)
        end
    end
    if offset == nil then  
        print("}-------------end " ..name.. "--------------") 
    end
end