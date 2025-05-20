--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local entWorldspawn = nil

function GM:sv_initialize()

end

function GM:sv_update( delta )
	
end

function GM:postMapLoad()
	local tableEnts = ents.getAll()
	console.log( "Map loaded with " .. table.count(tableEnts) .. " entities!" )
	for k,v in pairs(tableEnts) do
		v:postMapLoad()
	end
	
	local entWorldspawn = self:getWorldspawnEntity()
	if not entWorldspawn:isInitialized() then
		console.err("Worldspawn entity not initialized; initializing now!")
		ents.initialize(entWorldspawn)
	end
	
end

function GM:getWorldspawnEntity()
	if entWorldspawn == nil then
		local tEnts = ents.getAll()
		for k,v in pairs(tEnts) do
			if v.CLASSNAME == "worldspawn" then
				entWorldspawn = v
				return entWorldspawn
			end
		end
		console.err("Map does not have a worldspawn entity; one will be created!")
		entWorldspawn = ents.create("worldspawn")
		return entWorldspawn
	end
	return entWorldspawn
end

function GM:onWeaponPickUp( entWeapon, entCharacter )
	
end
hook.ensureExists("onWeaponPickUp")

function GM:onWeaponDrop( entWeapon, entCharacter )
	
end
hook.ensureExists("onWeaponDrop")

function GM:networkTick()
	-- Call entities' network tick methods
	for k, v in pairs(ents.getAll()) do
		if v:isInitialized() and v.networked then
			v:networkTick()
		end
	end
	
end

function GM:setClientEntity( client, ent )
	client.ent = ent
end

function GM:getClientEntity( client )
	return client.ent
end

function GM:onCharacterKilled( entCharacter, entAttacker, entDamager )
end
hook.ensureExists("onCharacterKilled")

-------------------------------------------------------------------------------
-- Returns whether or not a character should take damage from attacker/damager
-- @function [parent=#Gamemode] characterAcceptDamage
-- @return #boolean bAcceptDmg
function GM:characterAcceptDamage( entChar, entAttacker, entDamager )
	return true
end
