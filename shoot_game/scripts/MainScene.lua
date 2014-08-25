
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local MainScene = class("MainScene",function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    
end

function MainScene:run()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)
    self:addChild(require("GameLayer"):new())
    display.replaceScene(self)
end
return MainScene
