
require("config")
require("cocos.init")
require("framework.init")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:preLoadMusic()
    
    self:enterScene("LoginScene.lua")
--    self:enterScene("MainScene.lua")
end

function MyApp:preLoadMusic()
    for k, v in pairs(MUSIC) do
        audio.preloadMusic(v)
    end    
end

return MyApp
