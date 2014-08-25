
local SelectLayer = require("SelectPass.SelectLayer")

local SelectScene = class("SelectScene",function()
    return display.newScene("SelectScene")
end)

function SelectScene:ctor()
    self:init()
end

function SelectScene:init()
    self:addChild(SelectLayer.new())
end

return SelectScene