
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

local writablePath = cc.FileUtils:getInstance():getWritablePath()
 
cc.FileUtils:getInstance():addSearchPath("res/")
cc.FileUtils:getInstance():addSearchPath(writablePath)
--cc.FileUtils:getInstance():addSearchPath(writablePath.."quickgame/scripts/")


--cc.LuaLoadChunksFromZIP("framework_precomplied.zip")
--cc.LuaLoadChunksFromZIP("res/update.zip")

package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
--require("app.MyApp").new():run()

--热更新
require("update.UpdateScene").new()
