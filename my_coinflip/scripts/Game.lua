
require("config")
require("framework.init")
require("framework.shortcodes")
require("framework.cc.init")

local HomeScene = require("Home.HomeScene")

local Game = class("Game")

function Game:ctor()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)
    self:enterMainScene()

    audio.preloadSound("BackButtonSound.mp3")
    audio.preloadSound("ConFlipSound.mp3")
    audio.preloadSound("LevelWinSound.mp3")
    audio.preloadSound("TapButtonSound.mp3")
end

function Game:enterMainScene()
    display.replaceScene(HomeScene.new())
end

return Game