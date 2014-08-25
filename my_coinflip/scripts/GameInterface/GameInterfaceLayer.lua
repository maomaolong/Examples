
local FatButton = require("FatButton")
local PassConfig = require("GameInterface.PassConfig")

local GameInterfaceLayer = class("GameInterfaceLayer",function()
    return display.newLayer("GameInterfaceLayer")
end)

function GameInterfaceLayer:ctor(params)
    printInfo("params.tag = %d",params.tag)
    self:init(params)
end

function GameInterfaceLayer:init(params)
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
            display.replaceScene(require("SelectPass.SelectScene").new())
        end,
    })

    self.menu1 = ui.newMenu({self.backButton,})
    self:addChild(self.menu1)

    self:initCoin(params)
end

function GameInterfaceLayer:initCoin(params)
    local config = PassConfig[params.tag]
    local row = #config
    local col = #config[1]
    local offset = 0
    local sprite = display.newSprite("#Coin0001.png")
    local size = sprite:getContentSize()
    local width = math.floor(size.width)
    local height = math.floor(size.height)
    local startX = display.cx - ((col*width + (col -1)*10)/2 - width/2)
    local startY = display.cy + ((row*height + (row -1)*10)/2 - height/2)
    local coins = {}
    for r=1,row do
        coins[r] = {}
        for c=1,col do
            local x = startX + (c-1)*(offset + width) 
            local y = startY - (r - 1)*(offset + height) 
            if config[r][c] == 1 then 
                coins[r][c] = display.newSprite("#Coin0001.png"):pos(x,y):addTo(self)
            else
                coins[r][c] = display.newSprite("#Coin0008.png"):pos(x,y):addTo(self)
            end
            coins[r][c].data = {value = config[r][c],row = r, col = c}
            coins[r][c]:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE) -- 单点触摸
            coins[r][c]:setTouchEnabled(true)
            coins[r][c]:setTouchSwallowEnabled(true)
            -- 添加触摸事件处理函数
            coins[r][c]:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                -- event.phase 的值是：
                -- cc.NODE_TOUCH_TARGETING_PHASE

                -- event.mode 的值是下列之一：
                -- cc.TOUCH_MODE_ONE_BY_ONE 单点触摸
                -- cc.TOUCH_MODE_ALL_AT_ONCE 多点触摸

                -- event.name 的值是下列之一：
                -- began 触摸开始
                -- moved 触摸点移动
                -- ended 触摸结束
                -- cancelled 触摸被取消

                -- 如果是单点触摸：
                -- event.x, event.y 是触摸点位置
                -- event.prevX, event.prevY 是触摸点之前的位置

                -- 如果是多点触摸：
                -- event.points 包含了所有触摸点的信息
                -- event.points = {point, point, ...}
                -- 每一个触摸点的值包含：
                -- point.x, point.y 触摸点的当前位置
                -- point.prevX, point.prevY 触摸点之前的位置
                -- point.id 触摸点 id，用于确定触摸点的变化
                local WIN = false
                local function judgeWin()
                    local isWin = true
                    for r=1,row do
                        for c=1,col do
                            if coins[r][c].data.value == 0 then
                                isWin = false
                            end
                        end
                    end
                    if isWin == true and WIN == false then
                        WIN = true
                        printInfo("恭喜你，胜利啦！")
                    end
                end
                local function flip(r,c)
                    if (r >= 1 and r <= row) and (c >= 1 and c <= col) then  
                        local frames
                        if coins[r][c].data.value == 1 then 
                            frames = display.newFrames("Coin%04d.png", 1, 8)
                            coins[r][c].data.value = 0
                        else
                            frames = display.newFrames("Coin%04d.png", 1, 8,true)
                            coins[r][c].data.value = 1
                        end
                        local animation = display.newAnimation(frames, 0.5 / 8) -- 0.5 秒播放 8 桢
                        local action = transition.sequence({
                            cc.Animate:create(animation),
                            cc.CallFunc:create(judgeWin),
                        })
                        coins[r][c]:runAction(action)
                        --coins[r][c]:playAnimationOnce(animation) -- 播放一次动画
                    end
                end

                if event.name == "began" then
                    -- 在单点触摸模式下：在触摸事件开始时，必须返回 true
                    -- 返回 true 表示响应本次触摸事件，并且接收后续状态更新
                    flip(r+1,c)
                    flip(r-1,c)
                    flip(r,c+1)
                    flip(r,c-1)
                    return true
                end
            end)
        end
    end

end

return GameInterfaceLayer