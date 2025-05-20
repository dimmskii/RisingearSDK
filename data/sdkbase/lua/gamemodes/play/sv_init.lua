--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local GM_BASE = gamemode.getClass(GM.CLASSNAME_BASE)

function GM:sv_initialize()
	GM_BASE.sv_initialize( self )
end

local GM_BASE_sv_update = GM_BASE.sv_update
function GM:sv_update( delta )
	GM_BASE_sv_update( self, delta )
end

function GM:onClientConnect( client )
	GM_BASE.onClientConnect( self, client )
	
	--self:spawnPlayer( client ) -- Spawn right away mod. Disabled due to appearance menu on connect for now...
end

function GM:onClientDisconnect( client )
	GM_BASE.onClientDisconnect( self, client )
	
	if (client.ent) then
		ents.remove(client.ent)
	end
end

function GM:pickSpawnPoint( ply )
	local spawners = {}
	for k,v in pairs(ents.getAll()) do
		if v.valid and ents.isClass(v,"info_player_start") then
			table.insert(spawners,v)
		end
	end
	if (table.isEmpty(spawners)) then
		console.err("Map has no valid player spawners. Players will spawn at coordinate (0,0)!")
		return geom.vec2()
	end
	return spawners[math.random(table.getn(spawners))]:getPosition():clone()
end

local playerAppearances = {}

function GM:setPlayerAppearance( client, appearance )
	playerAppearances[client] = appearance
end

function GM:spawnPlayer( client )
	local appearance = playerAppearances[client]
	local ent = ents.create("player", false)
	if appearance then
		ent.female = appearance.female
		ents.initialize(ent)
		
		ent:setHair( appearance.hair )
		ent:setFacialHair( appearance.facialHair )
		ent:setEyebrows( appearance.eyebrows )
		ent:setEyes( appearance.eyes )
		
		ent:setSkinColor( appearance.skinColor )
		ent:setHairColor( appearance.hairColor )
		ent:setFacialHairColor( appearance.facialHairColor )
		ent:setEyebrowColor( appearance.eyebrowColor )
		ent:setEyeColor( appearance.eyeColor )
		
		ent:setTop( appearance.top )
		ent:setBottom( appearance.bottom )
		ent:setShoes( appearance.shoes )
	else
		ents.initialize(ent)
	end
	
	self:setClientEntity( client, ent )
	
	local vecSpawnPoint = self:pickSpawnPoint( ent )
	ent:setPosition(vecSpawnPoint.x,vecSpawnPoint.y)
	
	self:playerLoadout( ent )
	
	self:sendPlyEntMessage( ent, client )
	client.alive = true
	
	-- Emit spawn sound effect
	sndeffect.emit( "telespawn.wav", vecSpawnPoint.x, vecSpawnPoint.y, 10, 1, 1 )
end

function GM:playerLoadout( entPlayer )
	-- Give glock
	local entWeapon = ents.create("weapon_glock17", false)
	entWeapon:setPosition( entPlayer.position.x, entPlayer.position.y )
	ents.initialize( entWeapon )
	entWeapon:use( entPlayer )
	
	-- Give ammo
	entPlayer.ammo["9mm"] = 36
	entPlayer.ammo["12gauge"] = 18
	entPlayer.ammo["762sov"] = 30
	entPlayer.ammo["rockets"] = 15
end

function GM:onCharacterKilled( entCharacter, entAttacker, entDamager )
	for k,client in pairs(net.getClients()) do
		if(client.ent == entCharacter) then
			client.alive = false
			timer.simple( 6, function()
				ents.remove( entCharacter )
				self:spawnPlayer( client )
			end )
		end
	end
end

