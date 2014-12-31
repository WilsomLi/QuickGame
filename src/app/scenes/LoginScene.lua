
local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

function LoginScene:ctor()     
    self._widget = cc.uiloader:load("Login.csb"):addTo(self)
    print("loginScene ctor")
end

function LoginScene:onEnter()
    print("enter login")
--    local btnLogin = self._widget:getChildByName("btnLogin")
    local btnLogin = cc.uiloader:seekNodeByTag(self, 13)
    --    local btnLogin = cc.uiloader:seekNodeByNameFast(self, "btnLogin")  
    
--    addTouchEventListener
    btnLogin:addTouchEventListener(function(event)
        print("btn click")
    end)
end

function LoginScene:onExit()
    print("exit login")
end

function LoginScene:onLoginonLogin()
    print("login btn click")
end

return LoginScene
