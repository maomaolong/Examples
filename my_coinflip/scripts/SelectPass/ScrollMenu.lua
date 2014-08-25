
local PassMenuConfig = require("SelectPass.PassMenuConfig")
local FatButton = require("FatButton")
local GameInterfaceScene = require("GameInterface.GameInterfaceScene")

local ScrollMenu = class("ScrollMenu",function()
    return cc.Node:create()
end)

local offset = 0

function ScrollMenu:ctor()
    self:init()
end

function ScrollMenu:init()
    local page = #PassMenuConfig
    local sprite = display.newSprite("#UnlockedLevelIcon.png")
    local size = sprite:getContentSize()
    local width = math.floor(size.width)
    local height = math.floor(size.height)
    local menus = {}
    local function onMenuClick(tag)
        if self.enable == true then
            display.replaceScene(GameInterfaceScene.new({tag = tag}))
        end
    end

    for p=1,page do
        local row = #PassMenuConfig[p]
        for r=1,row do
            local col = #PassMenuConfig[p][r]
            for c=1,col do
                local startX = display.cx - ((col*width + (col -1)*10)/2 - width/2)
                local startY = display.cy + ((row*height + (row -1)*10)/2 - height/2)
                menus[#menus+1] = FatButton.new(
                {
                    image = "#UnlockedLevelIcon.png",
                    x = startX + (c-1)*(offset + width) + (p-1)*display.width,
                    y = startY - (r - 1)*(offset + height) ,
                    sound = "sfx/BackButtonSound.mp3",
                    tag = PassMenuConfig[p][r][c],
                    listener = onMenuClick
                },
                {
                    text = PassMenuConfig[p][r][c],
                    font = "Marker Felt",
                    size = 50,
                    align = ui.TEXT_ALIGN_CENTER ,-- 文字内部居中对齐
                    color = ccc3(0, 0, 0), -- 使用纯黑色
                }
                )
     
            end
        end
    end

    
    self.menu = ui.newMenu(menus)
    self:addChild(self.menu)
end

return ScrollMenu