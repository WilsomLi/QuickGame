local SharkLayer = class("SharkLayer",function()
    return display.newLayer("SharkLayer")
end)

SharkLayer.motions = {
    ["attack"] = {0,30},
    ["die"] = {31,67},
    ["skill"] = {68,151}
}

function SharkLayer:ctor()
    local node = cc.uiloader:load("generalshark.csb"):addTo(self)
    self._action = cc.CSLoader:createTimeline("generalshark.csb")
    node:runAction(self._action)
    node:setScale(0.5)
    
    self:playMotions("skill")
    
    local function onNodeEvent(event)
        if "enter" == event then
            self:onEnter()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function SharkLayer:playMotions(motionName)
    self._motion = motionName
    local motion = self.motions[motionName]
    if(type(motion) ~= "table") then return end
    local startFrame  = motion[1]
    local endFrame = motion[2]
    self._action:gotoFrameAndPlay(startFrame, endFrame, startFrame, true)
end

function SharkLayer:onEnter()
    print("shark enter")
    
    local function onTouchesEnded(touches, event)
        if self._motion == "skill" then
            self:playMotions("die")
        elseif self._motion == "attack" then
            self:playMotions("skill")
        else
            self:playMotions("attack")
        end
    end
    
    local listener = cc.EventListenerTouchAllAtOnce:create()    
    listener:registerScriptHandler(onTouchesEnded,cc.Handler.EVENT_TOUCHES_ENDED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function SharkLayer:onExit()
    print("shark exit")
end

return SharkLayer