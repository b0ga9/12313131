require "lib.moonloader"
local dlstatus = require("moonloader").download_status
local inicfg = require 'inicfg'
local keys = require 'vkeys'
local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8
local imgui = require "imgui"

update_state = false

local script_vers = 1
local script_vers_text="1.00"

local update_url = "https://raw.githubusercontent.com/b0ga9/scripts/master/update.ini"
local update_path = getWorkingDirectory() .. "/update.ini"

local script_url = "" -- cc���� 
local script_path = thisScript().path

local tag = " Deed | {FFFFFF}�������."

function main()
   if not isSampLoaded() or not isSampfuncsLoaded() then return end
   while not isSampAvailable() do wait(100) end

   sampAddChatMessage(tag, -1)
   sampRegisterChatCommand("updat", cmd_updat)
   
   downloadUrlToFile(update_url, update_path, function(id, status)
      if status == dlstatus.STATUS_ENDDOWNLOADDATA then
         updateIni = inicfg.load(nil, update_path)
         if tonumber(updateIni.info.vers) > script_vers then
            sampAddChatMessage("���� ����������!" .. updateIni.info.vers_text, -1)
            update_state = true
         end
         --os.remove(update_path)
      end
   end)

   while true do 
      wait(0)
      if update_state then
         downloadUrlToFile(update_url, update_path, function(id, status)
            if status == dlstatus.STATUS_ENDDOWNLOADDATA then
               sampAddChatMessage("������ ������� ��������", -1)
               thisScript():reload()
            end
         end)
         break
      end--code
   end
end

function cmd_updat(arg)
   sampShowDialog(1000,'��������������','������� ������ �������: '.. script_vers_text .. "\nNew ����������",'�������',"", 0)-- body
end