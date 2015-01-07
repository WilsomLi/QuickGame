
local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
--    cc.ui.UILabel.new({
--            UILabelType = 2, text = "Hello, World", size = 64})
--        :align(display.CENTER, display.cx, display.cy)
--        :addTo(self)
        
    cc.uiloader:load("MainScene.csb"):addTo(self)
end

function MainScene:onEnter()
    local hero = require("app.layers.SharkLayer").new()
--    hero:align(display.CENTER, display.cx, display.cy)
    hero:setPosition(cc.p(display.cx, display.cy * 0.5))
    hero:addTo(self)
    
    audio.playMusic(MUSIC.backgroundMusic,true)
end

function MainScene:onExit()
end

return MainScene
