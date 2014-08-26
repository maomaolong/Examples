

function readFileAll(fileName)
    local file = assert(io.open (fileName,"r"))
    local str = file:read("*a")
    file:close()
    return str
end
--print(readFileAll("res/readFile.txt"))

function readFileLine(fileName)
    local file = assert(io.open(fileName,"r"))
    -- local i = 1
    -- while i < math.huge do
    --     local str = file:read("*l")
    --     if str == nil then
    --         break
    --     end
    --     print (str)
    -- end
    repeat 
        local str = file:read("*l")
        if str then
            print(str)
        end
    until str == nil
    file:close()
end
--readFileLine("res/readFile.txt")

function readFileNum(fileName)
    local file = assert(io.open(fileName,"r"))
    repeat 
        local num = file:read("*n")
        if num then
            print(num)
        end
    until num == nil
    file:close()  
end
--readFileNum("res/numberFile.txt")


function writeToFile(fileName)
    local file = assert(io.open(fileName,"w"))
    local str = readFileAll("E:/ZhanHuang/quick-cocos2d-x/samples/file_oper/res/readFile.txt")
    file:write(str)
    file:close()
    print("wirte to file" .. fileName .. "success!")
end
--writeToFile("res/writeFile.txt")


--[[--

用指定字符或字符串分割输入字符串，返回包含分割结果的数组

~~~ lua

local input = "Hello,World"
local res = string.split(input, ",")
-- res = {"Hello", "World"}

local input = "Hello-+-World-+-Quick"
local res = string.split(input, "-+-")
-- res = {"Hello", "World", "Quick"}

~~~

@param string input 输入字符串
@param string delimiter 分割标记字符或字符串

@return array 包含分割结果的数组

]]
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end
function writeConfigToFile(ConfigFile)
    local file = assert(io.open(ConfigFile,"w"))
    
    -- local tab = string.split(ConfigFile, "/")
    -- local fileName = tab[#tab]

    local pos = 1
    repeat 
        local st,en = string.find(ConfigFile,'%/',pos)
        if st ~= nil then
            pos = st + 1
        end
    until st == nil
    local fileName = string.sub(ConfigFile,pos)

    local _,endPos = string.find(fileName,'%.')
    local objName = string.sub(fileName,1,endPos-1)
    local str = string.format("local %s = {}\n",objName)
    for i=1,10 do
        str = str .. string.format("%s[%d] = %d\n",objName,i,i)
    end
    str = str .. string.format("return %s",objName)
    file:write(str)
    file:close()
end
writeConfigToFile("res/Config.lua")
