require "lib.moonloader"
local inicfg = require 'inicfg'
local keys = require 'vkeys'
local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8
local imgui = require "imgui"

local tag = " Deed | {FFFFFF}Запущен."

function main()
   if not isSampLoaded() or not isSampfuncsLoaded() then return end
   while not isSampAvailable() do wait(100) end

   autoupdate("https://raw.githubusercontent.com/b0ga9/12313131/main/script_version.json", '['..string.upper(thisScript().name)..']: ', "")

   sampAddChatMessage(tag, -1)
   sampRegisterChatCommand("updat", cmd_updat)
   

   while true do 
      wait(0)
      --code
   end
end

--это в main(), после while not isSampAvailable() do wait(100) end
--autoupdate("http://qrlk.me/dev/moonloader/getgun/stats.php", '['..string.upper(thisScript().name)..']: ', "http://vk.com/qrlk.mods")

function autoupdate(json_url, prefix, url)
   local dlstatus = require('moonloader').download_status
   local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
   if doesFileExist(json) then os.remove(json) end
   downloadUrlToFile(json_url, json,
      function(id, status, p1, p2)
         if status == dlstatus.STATUSEX_ENDDOWNLOAD then
            if doesFileExist(json) then
               local f = io.open(json, 'r')
               if f then
                  local info = decodeJson(f:read('*a'))
                  updatelink = info.updateurl
                  updateversion = info.latest
                  f:close()
                  os.remove(json)
                  if updateversion ~= thisScript().version then
                     lua_thread.create(function(prefix)
                     local dlstatus = require('moonloader').download_status
                     local color = -1
                     sampAddChatMessage((prefix..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion), color)
                     wait(250)
                     downloadUrlToFile(updatelink, thisScript().path,
                        function(id3, status1, p13, p23)
                           if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                              print(string.format('Загружено %d из %d.', p13, p23))
                           elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                              print('Загрузка обновления завершена.')
                              sampAddChatMessage((prefix..'Обновление завершено!'), color)
                              goupdatestatus = true
                              lua_thread.create(function() wait(500) thisScript():reload() end)
                           end
                           if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                              if goupdatestatus == nil then
                                 sampAddChatMessage((prefix..'Обновление прошло неудачно. Запускаю устаревшую версию..'), color)
                                 update = false
                              end
                           end
                        end
                     )
                     end, prefix
                     )
                  else
                     update = false
                     print('v'..thisScript().version..': Обновление не требуется.')
                  end
               end
            else
               print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..url)
               sampAddChatMessage("Нема", -1)
               update = false
            end
         end
      end
   )
   while update ~= false do wait(100) end
end

function cmd_updat(arg)
   sampShowDialog(1000,'Автообновление','Текущая версия скрипта: '.. script_vers_text .. "\nNew Обновление",'Закрыть',"", 0)-- body
end
