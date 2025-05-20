-- This file deals with printing cvar change to chat box if cvar has notify attrib flag set

-- Gamemode authors can avoid resorting to modifying tabNotifyCvars by setting cvar notify attribute i.e. cvars.register("sv_mybool",myDefaultBooleanVal,cvars.CA_NOTIFY)
-- cvars.register("sv_Test","dree",cvars.CA_PROTECTED + cvars.CA_NOTIFY) -- Should notify as protected

local tabNotifyCvars = {
  "sv_cheats",
}

function GM:isNotifyCvar(strCvar)
	if table.hasValue(tabNotifyCvars, strCvar) then return true end -- contained in tabNotifyCvars
  if strCvar:find("g_", 1, true) == 1 then return true end -- g_* cvars
 	return cvars.isAttrib(strCvar, cvars.CA_NOTIFY) -- Lastly default to return true when cvar has CA_NOTIFY attrib set
end

local function processCvarNotifyMessage(sender, data)
  if SERVER then
    console.log(data:readNext() .. " changed to " .. data:readNext())
  else
    gui_chat.serverMessage(data:readNext() .. " changed to " .. data:readNext()) -- TODO: stringadactyl
  end
end
local MSG_CVAR_NOTIFY = net.registerMessage("cvar_notify", processCvarNotifyMessage)
local function sendCvarNotifyMessage(strCvar, strNewVal)
  local data = net.data()
  data:writeString(strCvar)
  if cvars.isAttrib(strCvar,cvars.CA_PROTECTED) then strNewVal = "***PROTECTED***" end -- TODO: stringadactyl
  data:writeString(strNewVal)
  net.sendMessage(MSG_CVAR_NOTIFY, data)
end

hook.add("onCvarChanged", "onCvarChanged_notify", function(strName, strOldValue, strNewValue)
  if GAMEMODE:isNotifyCvar(strName) then
    sendCvarNotifyMessage(strName, strNewValue)
  end

end)
