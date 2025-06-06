--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local function processMovePressMessage(sender, data)
	if not sender.ent then return end
	if not sender.ent.valid then return end
	
	local dir = data:readNext()
	if (dir == 0) then
	  sender.ent.movement.up = true
		sender.ent:jump()
	elseif (dir == 1) then
		sender.ent.movement.down = true
	elseif (dir == 2) then
		sender.ent.movement.direction = -1 * math.signum(sender.ent.direction)
	else
		sender.ent.movement.direction = 1 * math.signum(sender.ent.direction)
	end
end
local MSG_MOVEPRESS = net.registerMessage("clmove", processMovePressMessage)
local function sendMovePressMessage(direction)
	local data = net.data()
	data:writeByte(direction)
	net.sendMessage(MSG_MOVEPRESS, data)
end



local function processMoveReleaseMessage(sender, data)
	if not sender.ent then return end
	if not sender.ent.valid then return end

	local dir = data:readNext()
	if (dir == 0) then
		sender.ent.movement.up = false
	elseif (dir == 1) then
	 sender.ent.movement.down = false
	elseif (dir > 1) then
		sender.ent.movement.direction = 0
	end
end
local MSG_MOVERELEASE = net.registerMessage("clstop", processMoveReleaseMessage)
local function sendMoveReleaseMessage(direction)
	local data = net.data()
	data:writeByte(direction)
	net.sendMessage(MSG_MOVERELEASE, data)
end




local function processRunMessage(sender, data)
	if not sender.ent then return end
	if not sender.ent.valid then return end

	sender.ent.movement.running = data:readNext()
end
local MSG_RUN = net.registerMessage("clrun", processRunMessage)
local function sendRunMessage(bool)
	local data = net.data()
	data:writeBool(bool)
	net.sendMessage(MSG_RUN, data)
end

local function processAttackMessage(sender, data)
	if not sender.ent then return end
	if not sender.ent.valid then return end
	
	sender.ent.movement.attacking = data:readNext()
end
local MSG_ATTACK = net.registerMessage("clattack", processAttackMessage)
local function sendAttackMessage(bool)
	local data = net.data()
	data:writeBool(bool)
	net.sendMessage(MSG_ATTACK, data)
end

local function processUseMessage(sender, data)
	if not sender.ent then return end
	if not sender.ent.valid then return end

	sender.ent.movement.using = data:readNext()
end
local MSG_USE = net.registerMessage("cluse", processUseMessage)
local function sendUseMessage(bool)
	local data = net.data()
	data:writeBool(bool)
	net.sendMessage(MSG_USE, data)
end



local function processKillMessage(sender, data)
	if not sender.ent then return end
	if not sender.ent.valid then return end

	sender.ent:kill()
end
local MSG_KILL = net.registerMessage("clkill", processKillMessage)
local function sendKillMessage()
	net.sendMessage(MSG_KILL, net.data())
end



local function processReloadMessage(sender, data)
	if not sender.ent then return end
	if not sender.ent.valid then return end
	if not ents.isClass(sender.ent,"char_base",true) then return end

	sender.ent:reloadWeapon()
end
local MSG_RELOAD = net.registerMessage("clreload", processReloadMessage)
local function sendReloadMessage()
	net.sendMessage(MSG_RELOAD, net.data())
end



local function processDropWeaponMessage(sender, data)
	if not sender.ent then return end
	if not sender.ent.valid then return end
	if not ents.isClass(sender.ent,"char_base",true) then return end

	sender.ent:dropWeapon()
end
local MSG_DROP_WEAPON = net.registerMessage("cldropwep", processDropWeaponMessage)
local function sendDropWeaponMessage()
	net.sendMessage(MSG_DROP_WEAPON, net.data())
end



-- CHEATS
local CHT_GOD = 0
local CHT_NOCLIP = 1
local CHT_NOTARGET = 2

local function processCheatMessage(sender, data)
  if not GAMEMODE:isCheatsEnabled() then
    print_message("Cheats are not enabled on this server", PRINT_AREA_CONSOLE, sender)
    return
  end
  if not sender.ent then return end
  if not sender.ent.valid then return end

  local iCheat = data:readNext()
  if iCheat==CHT_GOD then
    if sender.ent.god then
     sender.ent.god = false
     print_message("godmode OFF", PRINT_AREA_CONSOLE, sender)
   else
     sender.ent.god = true
     print_message("godmode ON", PRINT_AREA_CONSOLE, sender)
   end
  elseif iCheat==CHT_NOCLIP then
    if sender.ent.noclip then
     sender.ent.noclip = false
     print_message("noclip OFF", PRINT_AREA_CONSOLE, sender)
   else
     sender.ent.noclip = true
     print_message("noclip ON", PRINT_AREA_CONSOLE, sender)
   end
  elseif iCheat==CHT_NOTARGET then
    if sender.ent.notarget then
     sender.ent.notarget = false
     print_message("notarget OFF", PRINT_AREA_CONSOLE, sender)
   else
     sender.ent.notarget = true
     print_message("notarget ON", PRINT_AREA_CONSOLE, sender)
   end
  end
end
local MSG_CHEAT = net.registerMessage("cheat", processCheatMessage)
local function sendCheatMessage(iCheat)
  local data = net.data()
  data:writeShort(iCheat)
  net.sendMessage(MSG_CHEAT, data)
end


local function processCheatGiveMessage(sender, data)
  if not GAMEMODE:isCheatsEnabled() then
    print_message("Cheats are not enabled on this server", PRINT_AREA_CONSOLE, sender)
    return
  end
  if not sender.ent then return end
  if not sender.ent.valid then return end
  
  local strClassName = tostring(data:readNext())
  
  local tListWeaponClasses = ents.getClasses("weapon_base")
  local tListPickupClasses = ents.getClasses("pickup")
  
  if (strClassName == "all") then
  	local spawned = {}
  	for _,v in ipairs(tListPickupClasses) do
  		local entPickup = ents.create(v.CLASSNAME,false)
    	entPickup:setPosition(sender.ent:getPosition())
    	ents.initialize(entPickup)
    	table.insert(spawned,entPickup)
    	timer.simple(0.01,function()
    		for _,v in ipairs(spawned) do
    			v:onPickedUp(sender.ent)
    			ents.remove(v)
    		end
    	end)
  	end
  	return
  end
  local tClass = ents.getClass(strClassName)
  if tClass == nil then
    print_message("Cannot give item - invalid class name or class does not exist", PRINT_AREA_CONSOLE, sender)
    return
  end
  
  
  if table.hasValue(tListWeaponClasses,tClass) then
    local entWeapon = ents.create(strClassName,false)
    --entWeapon:setPosition(sender.ent:getPosition())
    ents.initialize(entWeapon)
    sender.ent:dropWeapon()
    sender.ent:pickupWeapon(entWeapon)
    return
  elseif table.hasValue(tListPickupClasses,tClass) then
    local entPickup = ents.create(strClassName,false)
    entPickup:setPosition(sender.ent:getPosition())
    ents.initialize(entPickup)
    return
  end
  print_message("Cannot give item - not a pickup or weapon class", PRINT_AREA_CONSOLE, sender)
end
local MSG_CHEAT_GIVE = net.registerMessage("cheat_give", processCheatGiveMessage)
local function sendCheatGiveMessage(args)
  if args then
    local strClassName = args[1]
    if type(strClassName) == "string" then
      local data = net.data()
      data:writeString(strClassName)
      net.sendMessage(MSG_CHEAT_GIVE, data)
    end
  end
end


function GM:registerCommands()
	if (CLIENT) then
		
		cmds.register("+moveup", function() sendMovePressMessage(0) end)
		cmds.register("-moveup", function() sendMoveReleaseMessage(0) end)
		cmds.register("+movedown", function() sendMovePressMessage(1) end)
		cmds.register("-movedown", function() sendMoveReleaseMessage(1) end)
		
		local bMoveLeft = false
		local bMoveRight = false
		cmds.register("+moveleft", function()
			bMoveLeft = true
			sendMovePressMessage(2)
		end)
		cmds.register("-moveleft", function()
			bMoveLeft = false
			sendMoveReleaseMessage(2)
			if bMoveRight then
				sendMovePressMessage(3)
			end
		end)
		cmds.register("+moveright", function()
			bMoveRight = true
			sendMovePressMessage(3)
		end)
		cmds.register("-moveright", function()
			bMoveRight = false
			sendMoveReleaseMessage(3)
			if bMoveLeft then
				sendMovePressMessage(2)
			end
		end)
		
		cmds.register("+lookup", function() self.bLookUp = true end)
		cmds.register("-lookup", function() self.bLookUp = false end)
		cmds.register("+lookdown", function() self.bLookDown = true end)
		cmds.register("-lookdown", function() self.bLookDown = false end)
		cmds.register("+lookleft", function() self.bLookLeft = true end)
		cmds.register("-lookleft", function() self.bLookLeft = false end)
		cmds.register("+lookright", function() self.bLookRight = true end)
		cmds.register("-lookright", function() self.bLookRight = false end)
		
		cmds.register("+use", function() sendUseMessage(true) end)
		cmds.register("-use", function() sendUseMessage(false) end)
		cmds.register("+run", function() sendRunMessage(true) end)
		cmds.register("-run", function() sendRunMessage(false) end)
		cmds.register("kill", function() sendKillMessage() end)
		cmds.register("+attack", function() sendAttackMessage(true) end)
		cmds.register("-attack", function() sendAttackMessage(false) end)
		cmds.register("reload", function() sendReloadMessage() end)
		cmds.register("dropweapon", function() sendDropWeaponMessage() end)
		
		--CHEATS
		cmds.register("god", function() sendCheatMessage(CHT_GOD) end)
    cmds.register("noclip", function() sendCheatMessage(CHT_NOCLIP) end)
    cmds.register("notarget", function() sendCheatMessage(CHT_NOTARGET) end)
    cmds.register("give", function(args) sendCheatGiveMessage(args) end)
    
    -- CL GUI
    cmds.register("appearancemenu", function() GAMEMODE:gui_showAppearanceWindow() end)
    cmds.register("+showscores", function() gui_scores.show() end)	-- TODO: Maybe consider either consolidating everything to random global tables like gui_scores or call to extensible gamemode class function like above "appearancemenu"? **** or get off the pot.
    cmds.register("-showscores", function() gui_scores.hide() end)	-- TODO: Maybe consider either consolidating everything to random global tables like gui_scores or call to extensible gamemode class function like above "appearancemenu"? **** or get off the pot.
	end
end
