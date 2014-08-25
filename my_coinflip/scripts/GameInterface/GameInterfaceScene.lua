
local GameInterfaceLayer = require("GameInterface.GameInterfaceLayer")

local GameInterfaceScene = class("GameInterfaceScene",function()
    return display.newScene("GameInterfaceScene")
end)

function GameInterfaceScene:ctor(params)
    GameInterfaceLayer.new(params):addTo(self)
end

return GameInterfaceScene