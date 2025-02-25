--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --

PRINT_AREA_CONSOLE = 1
PRINT_AREA_CHAT = 2

PRINT_AREA_ALL = PRINT_AREA_CONSOLE + PRINT_AREA_CHAT

local msgPrint = net.registerMessage("msg_print_message", function(sender, data)
  print_message(data:readNext(), data:readNext())
end)

print_message = function( strMessage, iPrintArea, client)
  strMessage = strMessage or ""
  iPrintArea = iPrintArea or PRINT_AREA_CONSOLE
  
  if SERVER then
    local data = net.data()
    data:writeString(strMessage)
    data:writeShort(iPrintArea)
    net.sendMessage(msgPrint,data,client)
  elseif CLIENT then
    console.log(strMessage,true)
  end
end
