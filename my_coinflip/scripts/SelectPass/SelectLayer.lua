
local FatButton = require("FatButton")
local ScrollMenu = require("SelectPass.ScrollMenu")
local PassMenuConfig = require("SelectPass.PassMenuConfig")
local SelectLayer = class("SelectLayer",function()
    return display.newLayer("SelectLayer")
end)

function SelectLayer:ctor()
    
    self:init()
end

function SelectLayer:init()
    local bg = display.newSprite("#OtherSceneBg.png")
    :pos(display.cx,display.cy)
    :addTo(self) 

    self.backButton = FatButton.new({
        image = "#BackButtonSelected.png",
        x = display.right -100 ,
        y = display.bottom + 100 ,
        sound = "sfx/BackButtonSound.mp3",
        tag = 100,
        listener = function(tag)
            display.replaceScene(require("Home.HomeScene").new())
        end,
    })

    self.menu1 = ui.newMenu({self.backButton,})
    self:addChild(self.menu1)
    local scrollMenu = ScrollMenu.new()
    self:addChild(scrollMenu)
    local PX,PY = scrollMenu:getPosition()

    local touchLayer = display.newLayer()
    self:addChild(touchLayer,100)
    touchLayer:setTouchEnabled(true)
    touchLayer:setTouchSwallowEnabled(false)

    local beganX = 0
    local beganY = 0
    local touchAble = true
    touchLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        if event.name ~= "moved" then
            --print(event.name)
        end
        if event.name == "began" then
            --print("点击开始", event.x, event.y, event.prevX, event.prevY)
            if touchAble == false then return end
            beganX = event.x 
            beganY = event.y 
            PX = scrollMenu:getPositionX()
            scrollMenu.enable = true
            return true
        elseif event.name == "ended" then
            --print("完成点击:", event.x, event.y)
            if event.x-beganX > 100 then
                PX = PX + display.width
                if PX > 0 then 
                    PX = 0
                end
            end
            if event.x-beganX < -100 then
                PX = PX - display.width
                if PX < -(#PassMenuConfig-1)*display.width then
                    PX = -(#PassMenuConfig-1)*display.width 
                end
            end
            touchAble = false
            transition.moveTo(scrollMenu, {x = PX,y = PY,time = 0.5,
                easing = "backout",
                onComplete = function()
                    touchAble = true
                    scrollMenu:setPosition(cc.p(PX,PY))
                end
                })
        elseif event.name == "moved" then
            --print("移动偏移量: ", event.x-event.prevX, event.y-event.prevY)
            if math.abs(event.x-beganX) > 20 or math.abs(event.y-beganY) > 20 then
                scrollMenu.enable = false
                scrollMenu:setPosition(cc.p(PX + event.x-beganX,PY))
            end
            
        elseif event.name == "cancelled" then
            --print("点击取消")
        end
    end)
end

return SelectLayer