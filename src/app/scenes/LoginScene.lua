
local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

function LoginScene:ctor()     
    self._widget = cc.uiloader:load("Login.csb"):addTo(self)
end

function LoginScene:onEnter()
    local btnLogin = self._widget:getChildByName("btnLogin")
--    local btnLogin = cc.uiloader:seekNodeByNameFast(self, "btnLogin")  --bug
--    local btnLogin = cc.uiloader:seekNodeByTag(self, 13)
    
    self._edtName = cc.uiloader:seekNodeByTag(self, 14)
    self._edtPwd = cc.uiloader:seekNodeByTag(self, 15)
    
    btnLogin:addTouchEventListener(function(btn,type)
        if(type ~= 2) then return end
        local name = self._edtName:getString()
        local pwd = self._edtPwd:getString()
        if(name == "admin" and pwd=="admin") then
            app:enterScene("MainScene.lua")
        else
            print("login error")
        end
      end
    )
end

function LoginScene:onExit()
    self._edtName = nil
    self._edtPwd = nil
    self._widget = nil
end

function LoginScene:onLogin(type)
    if(type ~= 2) then return end
    print("login btn click")
end

return LoginScene
