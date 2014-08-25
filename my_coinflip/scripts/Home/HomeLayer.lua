
local FatButton = import("FatButton")
local SelectScene = require("SelectPass.SelectScene")
local HomeLayer = class("HomeLayer",function()
    return display.newLayer("HomeLayer")
end)

function HomeLayer:ctor()
    local bg = display.newSprite("#MenuSceneBg.png")
    :pos(display.cx,display.cy)
    :addTo(self) 

    self:init() 
end

function HomeLayer:init()
    self.startButton = FatButton.new({
        image = "#MenuSceneStartButton.png",
        x = display.cx ,
        y = display.cy - 100 ,
        sound = "sfx/TapButtonSound.mp3",
        tag = 1,
        listener = function(tag)
            display.replaceScene(SelectScene.new())
        end,
    })

    self.menu = ui.newMenu({self.startButton,})
    self:addChild(self.menu)
end

return HomeLayer