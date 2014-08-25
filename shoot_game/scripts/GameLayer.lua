
local Actor = require("Actor")

local GameLayer = class("GameLayer",function()
    return display.newColorLayer(ccc4(255,255,255,255))
end)

function GameLayer:ctor()
    self._heroData = {
                x = display.cx - 300,
                y = display.cy ,
                flipX = false,
                Hp = 100,
            }
    self._enemyData = {
                x = display.cx + 300,
                y = display.cy ,
                flipX = true,
                Hp = 100,
            }
    self:init()
end

function GameLayer:init()
    self.hero = Actor.new("#HeroIdle.png")
    :flipX(self._heroData.flipX)
    :pos(self._heroData.x,self._heroData.y)
    :setHp(self._heroData.Hp)
    :addTo(self)

    self.enemy = Actor.new("#HeroIdle.png")
    :flipX(self._enemyData.flipX)
    :pos(self._enemyData.x,self._enemyData.y)
    :setHp(self._enemyData.Hp)
    :addTo(self)

    self.hero.label = ui.newTTFLabel({
        text = "Hp:" .. self.hero.hp,
        font = "Arial",
        size = 20,
        color = ccc3(255, 0, 0), -- 使用纯红色
        align = ui.TEXT_ALIGN_CENTER,
        valign = ui.TEXT_VALIGN_TOP,
        dimensions = CCSize(400, 200)
    }):pos(self._heroData.x,self._heroData.y+25):addTo(self)

    self.enemy.label = ui.newTTFLabel({
        text = "Hp:" .. self.enemy.hp,
        font = "Arial",
        size = 20,
        color = ccc3(255, 0, 0), -- 使用纯红色
        align = ui.TEXT_ALIGN_CENTER,
        valign = ui.TEXT_VALIGN_TOP,
        dimensions = CCSize(400, 200)
    }):pos(self._enemyData.x,self._enemyData.y+25):addTo(self)

    self.hero.btn = cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonSize(140, 80)
        :setButtonLabel(cc.ui.UILabel.new({text = "fire"}))
        :onButtonPressed(function(event)
            event.target:setScale(1.1)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function()
            self.hero:fire(self,self.enemy)
        end)
        :pos(display.cx - 240, display.bottom + 100)
        :addTo(self)

    self.enemy.btn = cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonSize(140, 80)
        :setButtonLabel(cc.ui.UILabel.new({text = "fire"}))
        :onButtonPressed(function(event)
            event.target:setScale(1.1)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function()
            self.enemy:fire(self,self.hero)
        end)
        :pos(display.cx + 240, display.bottom + 100)
        :addTo(self)
end

return GameLayer