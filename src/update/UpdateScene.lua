
--注意：要把此文件和文件夹移出src

require("config")
require("cocos.init")
require("framework.init")

local nowVersion = cc.UserDefault:getStringForKey("current-version")
local bigVersion = cc.UserDefault:getStringForKey("big-version")

local UpdateScene = class("UpdateScene",function()
    return display.newScene("UpdateScene")
end)

function UpdateScene:ctor()
    self._path = device.writablePath.."kdfs/"
    self:createDownPath(self._path)
    self:createDownPath(self._path.."res/")
    self:createDownPath(self._path.."scripts/")
    if string.len(nowVersion) == 0 then
        nowVersion = bigVersion..".0"
    end
    local list = string.split(nowVersion,".")
    self._nowId = tonumber(list[3])
    self._bigVersion = list[1].."."..list[2]
    --大版本变化
    if self._bigVersion ~= bigVersion then
        self:delAllFilesInDir(self._path)
    end
    
    self._updateProgress = display.newProgressTimer("bar.png",display.PROGRESS_TIMER_BAR)
    self._proLabel = display.newTTFLabel({text="更新",size=26,align=ui.TEXT_ALIGN_CENTER,
        color=display.COLOR_BLACK}):pos(display.cx,160):addTo(self)
    
end

function UpdateScene:onEnter()
    self:getNewestVersion()
end

function UpdateScene:onExit()

end

function UpdateScene:createDownPath(path)
    if not self:checkDirOK(path) then
        print("更新目录创建失败，直接开始游戏")
        self:onUpdateStart()
    else
        print("更新目录存在或创建成功")
    end
end

function UpdateScene:downIndexedVersion()
    if not self._nowDownIndex then self._nowDownIndex = 1 end
    local versionData = self._needDownVersions[self._nowDownIndex]
    local versionUrl = SERVER.."version/?fileVersion"..versionData.version
    local packageUrl = versionData.filrUrl
    
    local function onError(errorCode)
        if errorCode == cc.ASSETSMANAGER_NO_NEW_VERSION then
            self._proLabel:setString("no new version")
        elseif errorCode == cc.ASSETSMANAGER_NETWORK then
            self._proLabel:setString("network error")
        end
    end
    
    local function onProgress(percent)
        local str = string.format("更新已完成:%d/100",percent)
        self._proLabel:setString(str)
    end
    
    local function onSuccess()
        self._proLabel:setString("更新成功，进入游戏")
    end
    
    if self._nowDownIndex==1 then
        self._assetManager = cc.AssetsManager:create(packageUrl,versionUrl,self._path,onError,onProgress,onSuccess)
    else
        self._assetManager:setVersionFileUrl(versionUrl)
        self._assetManager:setPackageUrl(packageUrl)
    end
    
    if self._assetManager:checkUpdate() then
        self._assetManager:update()
    end
    
end

function UpdateScene:getNewestVersion()
    self._proLabel:setString("正在获取版本列表..")
    
    function onNetCallback(event)
        local ok = (event.name == "completed")
        local request = event.request
        local code = request:getResponseStatusCode()
        if not ok or code ~= 200 then
            self._proLabel:setString("网络错误:"..code)
            self:performWithDelay(function()
                self:noUpdateStart()
            end,2)
            return
        end
        
        local needDownVersion = json.decode(request:getResponseString())
        if needDownVersion then
            print(request:getResponseString())
            if needDownVersion.code == 200 then
                self._needDownVersions = needDownVersion.list
                for i,v in pairs(self._needDownVersions) do
                    if v.needRestart > 0 then
                        self._needRestart = true
                    end
                end
                if #self._needDownVersions > 0 then
                    self:downIndexedVersion()
                end
             else
                self._proLabel:setString("当前版本是最新版本")
                self:performWithDalay(function()
                    self:noUpdateStart()
                end,2)
             end
        end
    end
    
    local url = SERVER.."update/version.php?id="..self._nowId.."&bigVersion="..self._bigVersion
    local request = network.createHTTPRequest(onNetCallback,url,"GET")
    request:setTimeout(10)
    request:start()
end

function UpdateScene:afterUpdateStart()
    if self._needRestart then
       print("需重启")
       require("game")
       game.exit()
       return 
    end
    
    print("更新成功，启动游戏")
    package.loaded["config"] = nil
    cc.LuaLoadChunksFromZIP("game.zip")
    require("game")
    game.startup()
end

function UpdateScene:onUpdateStart()
    print("没有更新或者更新失败启动游戏")
    cc.LuaLoadChunksFromZIP("game.zip")
    require("game")
    game.startup()
end

function UpdateScene:chekDirOK(path)
    require "lfs"
    local oldPath = lfs.currentdir()
    if lfs.chdir(path) then
        lfs.chdir(oldPath)
        return true
    end
    if lfs.mkdir(path) then
        return true
    end
end

function UpdateScene:delAllFilesInDirector(path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path.."/"..file
            local attr = lfs.attributes(f)
            assert(type(attr)=="table")
            if attr.mode == "directory" then
                self:delAllFilesInDirector(f)
            else
                os.remove(f)
            end            
        end
    end
end

return UpdateScene