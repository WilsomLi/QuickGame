
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
    
    btnLogin:addTouchEventListener(function(sender,eventType)
        if(eventType ~= TOUCH_EVENT_ENDED) then return end
        local name = self._edtName:getString()
        local pwd = self._edtPwd:getString()
--        if(name == "admin" and pwd=="admin") then
--            app:enterScene("MainScene.lua")
--        else
--            print("login error")
--        end
        self:onLogin(name,pwd)
      end
    )
end

function LoginScene:onExit()
    self._edtName = nil
    self._edtPwd = nil
    self._widget = nil
end

function LoginScene:onLogin(username,pwd)
    if(device.platform ~= "windows" and not network.isInternetConnectionAvailable()) then
        print("网络不可用")
        return
    end

    local function onRequeseFinished(event)
    	local ok = (event.name == "completed")
    	local request = event.request
    	if not ok then
    	   print("not ok",request:getErrorCode(),request:getErrorMessage())
    	   return
    	end
    	local code = request:getResponseStatusCode()
    	if code ~= 200 then
    	   print("code:"..code)
    	   return
    	end
    	local response = request:getResponseString()
    	print(response)
    	if(response == "login success") then
            app:enterScene("MainScene.lua")
    	end
    end
    
    local url = "http://gameinstall.sinaapp.com/testlogin.php"
    local request = network.createHTTPRequest(onRequeseFinished,url,"POST")
    request:addPOSTValue("name",username)
    request:addPOSTValue("pwd",pwd)
    request:start()
end

return LoginScene
