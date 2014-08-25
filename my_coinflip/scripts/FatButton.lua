
local FatButton = class("FatButton")
function FatButton.new(btnParams,labelParams)
    local Button = nil

    local listener = btnParams.listener
    btnParams.listener = function(tag)
        local scaleToBig = cc.ScaleTo:create(0.1, 1.1, 1.1)
        local scaleToNor = cc.ScaleTo:create(0.1, 1.0, 1.0)
        local onComplete = cc.CallFunc:create(function()
                listener(tag)
        end)
        local sequence = transition.sequence({
            scaleToBig,
            scaleToNor,
            onComplete,
        })
        Button:runAction(sequence)
    end
    Button = ui.newImageMenuItem(btnParams)
    if labelParams then
        local size = Button:getContentSize()
        local label = ui.newTTFLabel(labelParams)
        :pos(size.width/2,size.height/2)
        :addTo(Button)
    end
    return Button
end

return FatButton