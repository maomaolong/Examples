
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

local GRAVITY = -200
local COIN_MASS       = 100
local COIN_RADIUS     = 46
local COIN_FRICTION   = 0.8
local COIN_ELASTICITY = 0.8
local WALL_THICKNESS  = 64
local WALL_FRICTION   = 1.0
local WALL_ELASTICITY = 0.5

function MainScene:ctor()
    self.layer = display.newLayer():addTo(self)

    -- create physics world
    self.world = CCPhysicsWorld:create(0, GRAVITY)
    -- add world to scene
    self:addChild(self.world)

    self:init()
end

function MainScene:init()
    self:initWall()
end

function MainScene:initWall()
    local leftWall = display.newSprite("#Wall.png"):addTo(self)
    local size = leftWall:getContentSize()
    --leftWall:pos(size.width/2,display.cy)
    leftWall:setScaleY(display.height/size.height)
    local leftWallBody = self.world:createBoxBody(0, WALL_THICKNESS, display.height)
    leftWallBody:setFriction(WALL_FRICTION)
    leftWallBody:setElasticity(WALL_ELASTICITY)
    leftWallBody:bind(leftWall)
    leftWallBody:setPosition(size.width/2,display.cy)

    local rightWall = display.newSprite("#Wall.png"):addTo(self)
    --rightWall:pos(display.width-size.width/2 , display.cy)
    rightWall:setScaleY(display.height/size.height)
    local rightWallBody = self.world:createBoxBody(0, WALL_THICKNESS, display.height)
    rightWallBody:setFriction(WALL_FRICTION)
    rightWallBody:setElasticity(WALL_ELASTICITY)
    rightWallBody:bind(rightWall)
    rightWallBody:setPosition(display.width-size.width/2 , display.cy)

    local bottomWall = display.newSprite("#Wall.png"):addTo(self)
    --bottomWall:pos(display.cx , size.height/2)
    bottomWall:setScaleX(display.width/size.width - 2)
    local bottomWallBody = self.world:createBoxBody(0, display.width, WALL_THICKNESS)
    bottomWallBody:setFriction(WALL_FRICTION)
    bottomWallBody:setElasticity(WALL_ELASTICITY)
    bottomWallBody:bind(bottomWall)
    bottomWallBody:setPosition(display.cx , size.height/2)
end

function MainScene:createCoin(x,y)
    local ball = display.newSprite("#Coin.png"):addTo(self.layer)
    local coinBody = self.world:createCircleBody(COIN_MASS, COIN_RADIUS)
    coinBody:setFriction(COIN_FRICTION)
    coinBody:setElasticity(COIN_ELASTICITY)
    -- binding sprite to body
    coinBody:bind(ball)
    -- set body position
    coinBody:setPosition(x, y)
end

function MainScene:onEnter()

    self.layer:setTouchEnabled(true)
    -- make world running
    self.world:start()
    self.layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
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

        if event.name == "began" then
            -- 在单点触摸模式下：在触摸事件开始时，必须返回 true
            -- 返回 true 表示响应本次触摸事件，并且接收后续状态更新
            self:createCoin(event.x,event.y)
            return true
        end
    end)
end


return MainScene
