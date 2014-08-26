
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

dofile("E:/ZhanHuang/quick-cocos2d-x/samples/file_oper/scripts/FileOper.lua")
