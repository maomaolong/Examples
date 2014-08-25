
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    -- create Finite State Machine
    self.fsm_ = {}
    cc.GameObject.extend(self.fsm_)
        :addComponent("components.behavior.StateMachine")
        :exportMethods()

    self.fsm_:setupState({
        events = {
            {name = "start", from = "none",   to = "ready" },
            {name = "apportion", from = "ready",   to = "run" },
            {name = "timeout",  from = "run",  to = "ready"},
            {name = "wait", from = "run",  to = "block" },
            {name = "occur", from = "block",  to = "ready" },
        },

        callbacks = {
            onstart       = function(event) self:log("[FSM] START") end,
            onapportion  = function(event) self:log("[FSM] APPORTION", true) end,
            ontimeout = function(event) self:log("[FSM] TIMEOUT", true) end,
            onwait  = function(event) self:log("[FSM] WAIT",  true) end,
            onoccur = function(event) self:log("[FSM] OCCUR", true) end,
            onchangestate = function(event) self:log("[FSM] CHANGED STATE: " .. event.from .. " to " .. event.to) end,
        },
    })

    self.stateLable = ui.newTTFLabel({
        text = "none",
        size = 32,
        align = ui.TEXT_ALIGN_CENTER,
        color = display.COLOR_WHITE,
        x = display.cx,
        y = display.top - 120,
    }):addTo(self)

    self.pendingLabel_ = ui.newTTFLabel({
        text = "",
        size = 32,
        align = ui.TEXT_ALIGN_CENTER,
        color = display.COLOR_WHITE,
        x = display.cx,
        y = display.top - 200,
    }):addTo(self)

    -- preload texture
    self.stateImage_ = display.newSprite("#run.png")
        :pos(display.cx, display.top - 50)
        :scale(1.5)
        :addTo(self)

    cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonSize(140, 80)
        :setButtonLabel(cc.ui.UILabel.new({text = "apportion"}))
        :onButtonPressed(function(event)
            event.target:setScale(1.1)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function()
            if self.fsm_:isState("ready") then
                self.fsm_:doEvent("apportion")
            else
                printInfo("nonsupport")
            end
        end)
        :pos(display.cx - 240, display.bottom + 100)
        :addTo(self)


    cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonSize(140, 80)
        :setButtonLabel(cc.ui.UILabel.new({text = "timeout"}))
        :onButtonPressed(function(event)
            event.target:setScale(1.1)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function()
            if self.fsm_:isState("run") then
                self.fsm_:doEvent("timeout")
            else
                printInfo("nonsupport")
            end
        end)
        :pos(display.cx -100 , display.bottom + 100)
        :addTo(self)

    cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonSize(140, 80)
        :setButtonLabel(cc.ui.UILabel.new({text = "wait"}))
        :onButtonPressed(function(event)
            event.target:setScale(1.1)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function()
            if self.fsm_:isState("run") then
                self.fsm_:doEvent("wait")
            else
                printInfo("nonsupport")
            end
        end)
        :pos(display.cx + 100, display.bottom + 100)
        :addTo(self)

    cc.ui.UIPushButton.new("Button01.png", {scale9 = true})
        :setButtonSize(140, 80)
        :setButtonLabel(cc.ui.UILabel.new({text = "occur"}))
        :onButtonPressed(function(event)
            event.target:setScale(1.1)
        end)
        :onButtonRelease(function(event)
            event.target:setScale(1.0)
        end)
        :onButtonClicked(function()
            if self.fsm_:isState("block") then
                self.fsm_:doEvent("occur")
            else
                printInfo("nonsupport")
            end
        end)
        :pos(display.cx + 240, display.bottom + 100)
        :addTo(self)

    -- debug
    self.logCount_ = 0
end

function MainScene:pending(event, n)
    local msg = event.to .. " in ..." .. n
    self:log("[FSM] PENDING STATE: " .. msg)
    self.pendingLabel_:setString(msg)
end

function MainScene:log(msg, separate)
    if separate then self.logCount_ = self.logCount_ + 1 end
    if separate then print("") end
    printf("%d: %s", self.logCount_, msg)

    local state = self.fsm_:getState()
    if state == "run" then
        self.stateImage_:setDisplayFrame(display.newSpriteFrame("run.png"))
        self.stateLable:setString("run")
    elseif state == "block" then
        self.stateImage_:setDisplayFrame(display.newSpriteFrame("block.png"))
        self.stateLable:setString("block")
    elseif state == "ready" then
        self.stateImage_:setDisplayFrame(display.newSpriteFrame("ready.png"))
        self.stateLable:setString("ready")
    end

    -- self.clearButton_:setEnabled(self.fsm_:canDoEvent("clear"))
    -- self.calmButton_:setEnabled(self.fsm_:canDoEvent("calm"))
    -- self.warnButton_:setEnabled(self.fsm_:canDoEvent("warn"))
    -- self.panicButton_:setEnabled(self.fsm_:canDoEvent("panic"))
end

function MainScene:onEnter()
    self.fsm_:doEvent("start")
end

return MainScene
