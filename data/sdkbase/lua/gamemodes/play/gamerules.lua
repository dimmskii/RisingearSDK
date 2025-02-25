--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local GM_BASE = gamemode.getClass(GM.CLASSNAME_BASE)


function GM:postMapLoad()		-- Override function create pickup respawners
	GM_BASE.postMapLoad(self)
	
	for k,v in pairs(ents.getAll()) do
		if v.valid and ( ents.isClass(v,"pickup",true) or ents.isClass(v,"weapon_base",true) ) then
			if (v.equipped == nil) then
				local spawner = ents.create("dm_itemspawner", false)
				spawner.position = geom.vec2(v.position.x, v.position.y)
				spawner.angle = v.angle
				spawner.pickup = v
				spawner.pickupClass = v.CLASSNAME
				ents.initialize(spawner)
			end
		end
	end
	
end


local G_WEAPONSTAYTIME_MIN = 30
cvars.register("g_weaponstaytime","120",cvars.CA_ARCHIVED)

function GM:onWeaponPickUp( entWeapon, entCharacter )		-- Override function to despawn weapons
	GM_BASE.onWeaponPickUp(self)
	
	if entWeapon.despawnTimer then
		timer.stop(entWeapon.despawnTimer)
		timer.remove(entWeapon.despawnTimer)
	end
end

function GM:onWeaponDrop( entWeapon, entCharacter )		-- Override function to despawn weapons
	GM_BASE.onWeaponDrop(self)
	
	entWeapon.despawnTimer = timer.create( math.max(cvars.real("g_weaponstaytime"), G_WEAPONSTAYTIME_MIN) ,1,function() ents.remove(entWeapon) end,true,true) -- TODO: magic number 30 secs to despawn
end




cvars.register("g_gametype","coop",cvars.CA_ARCHIVED)

local gameType = cvars.string("g_gametype")
local fileName = "/gamemodes/play/gametypes/" .. file.getName(gameType .. ".lua") -- TODO: verify good enough : This is user input so at least wrap around file.getName to prevent traversal it

if file.exists("lua" .. fileName) then
	include(fileName)
else
	include "/gamemodes/play/gametypes/dm.lua" -- DM default
end
