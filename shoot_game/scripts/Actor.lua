 
local scheduler = require("framework.scheduler")

 local Actor = class("Actor",function(filename)
     return display.newSprite(filename)
 end)

function Actor:ctor(filename)
    
end

function Actor:setHp(nHp)
    assert(type(nHp) == "number", " error nHp - should be number type!")
    self.hp = nHp
    return self
end

local function newFrames(t)
    local frames = {}
    for i=1,#t do
        local frame = display.newSpriteFrame(t[i])
        frames[#frames + 1] = frame
    end
    return frames
end

function Actor:fire(layer,target)
    if self.hp <= 0 then return end
    
    local frames = newFrames{"HeroIdle.png","HeroFiring.png","HeroIdle.png"}
    local animation = display.newAnimation(frames, 0.5 / 2) -- 0.5 秒播放 2 桢
    self:playAnimationOnce(animation) -- 播放一次动画
    local posx,posy = self:getPosition()
    local px = posx + 2000
    local bullet = display.newSprite("#Bullet.png")
    bullet:addTo(layer)
    bullet:pos(posx+30,posy+15)
    if self:isFlipX() then
        bullet:pos(posx-30,posy+15)
        bullet:flipX(true)
        px = posx - 2000
    end
    bullet.enable = true
    bullet:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        math.newrandomseed()
        local rad = math.random(1,2)
        if target:boundingBox():containsPoint(cc.p(bullet:getPosition())) and target.hp > 0 and bullet.enable == true then
            bullet.enable = false
            if rad == 2 then  --miss
                printInfo("miss")
                target:miss()
            else
                target:hited()
                bullet:removeFromParentAndCleanup(true)
            end            
        end
    end)

    
    bullet:setVisible(false)
    scheduler.performWithDelayGlobal(function()
        bullet:setVisible(true)
        bullet:scheduleUpdate() 
        transition.moveTo(bullet,
                {x =px, y = self:getPositionY(), time = 2,
                onComplete = function()
                    bullet:removeFromParentAndCleanup(true)
                end})
    end, 0.25)
    self:jump()
end

function Actor:hited()  
    self.hp = self.hp - 10
    if self.hp <= 0 then
        self:dead()
        self.label:setString("Dead")
    else
        local frames = newFrames{"HeroIdle.png","HeroDead0001.png","HeroIdle.png"}
        local animation = display.newAnimation(frames, 0.5 / 2) -- 0.5 秒播放 8 桢
        self:playAnimationOnce(animation) -- 播放一次动画
        self.label:setString("Hp:" .. self.hp)
    end 
end

function Actor:miss()
    local sprite = display.newSprite("#Miss.png")
    :pos(self:getContentSize().width/2,self:getContentSize().height/2 + 10)
    :addTo(self)
    transition.fadeOut(sprite,
            {time = 0.5,delay = 0.5 ,
            onComplete = function()
                sprite:removeFromParentAndCleanup(true)
            end})
end

function Actor:dead()
    local frames = display.newFrames("HeroDead%04d.png", 1, 4)
    local animation = display.newAnimation(frames, 0.5 / 4) -- 0.5 秒播放 4 桢
    self:playAnimationOnce(animation) -- 播放一次动画
end

function Actor:jump()
    if self:getActionByTag(123) then
        return
    end
    local upAction = cc.MoveTo:create(0.5, cc.p(self:getPositionX(),self:getPositionY() + 200))
    local actionUp = transition.newEasing(upAction, "BACKIN")
    local downAction = cc.MoveTo:create(0.5, cc.p(self:getPositionX(),self:getPositionY()))
    local actionDown = transition.newEasing(downAction, "BACKIN")
    local sequence = transition.sequence({
        actionUp,
        actionDown,
    })
    sequence:setTag(123)
    self:runAction(sequence)
end

 return Actor