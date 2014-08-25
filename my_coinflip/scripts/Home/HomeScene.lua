
local HomeLayer = require("Home.HomeLayer")

local HomeScene = class("HomeScene",function()
    return display.newScene("HomeScene")
end)

function HomeScene:ctor()
    self:addChild(HomeLayer.new())
end
return HomeScene