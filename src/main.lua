
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")
end

cc.FileUtils:getInstance():addSearchPath("res/")

cc.LuaLoadChunksFromZIP("res/framework_precompiled.zip")
cc.LuaLoadChunksFromZIP("res/update.zip")

package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
--require("app.MyApp").new():run()
require("UpdateScene").new():run()
