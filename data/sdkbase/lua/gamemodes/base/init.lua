--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


include("skeleton_factory/skeleton_factory.lua")

function GM:initialize()
	if SERVER then
		self:sv_initialize()
	elseif CLIENT then
		self:cl_initialize()
	end
	
	self:registerCommands()
end

function GM:registerCommands()
	
end

local allEntities = {}
function GM:update( delta )
	-- Branch off into client and server update funcs
	if SERVER then
		self:sv_update( delta )
	elseif CLIENT then
		self:cl_update( delta )
	end
	
	-- Update all ents
	allEntities = ents.getAll()
	for _,ent in pairs(allEntities) do
		if ent:isInitialized() then
			hook.run( "doEntityThink", ent, delta )
		end
	end
end

function GM:doEntityThink( ent, delta )
	ent:think( delta )
end
hook.ensureExists("doEntityThink")

function GM:destroy()
end

function GM:onSayMessage(clientInfo, mode, message)
end

function GM:onClientConnect( client )
end

function GM:onClientDisconnect( client )
end

function GM:onClientNameChanged( client, oldName, newName )
end

function GM:onCvarChanged(strName, strNewValue, strOldValue)
end

function GM:onEntityCreated( ent )
end

function GM:onEntityDestroyed( ent )
end

local function setGravityFromCvar()
	phys.getWorld():setGravity(geom.vec2(0,cvars.real( "g_gravity", 1 ) * 9.8))
end

function GM:physicsInit( world, particleSystem )
		setGravityFromCvar()

		-- Default materials in all mods/gamemodes
		materials.create("flesh", 1400, 0.9, 0.5)
		materials.create("character_feet", 1400, 0.9, 0.0)
		materials.create("ice", 920, 0.1, 0.1)
		materials.create("water", 997, 0.006, 0.1)
		materials.create("metal", 7870, 0.9, 0.1, "metal")
		materials.create("metal_hollow", 790, 0.9, 0.1, "metal_hollow")
		materials.create("blade", 7870, 0.9, 0.1, "blade")
		materials.create("weapon", 7870, 0.9, 0.1, "weapon")
		materials.create("cement", 1510, 0.93, 0.1)
		materials.create("earth", 1520, 0.9, 0.1)
		materials.create("wood", 700, 0.9, 0.1, "wood")
		materials.create("sand", 1600, 0.9, 0.1)
		materials.create("snow", 400, 0.81, 0.1)
		materials.create("rock", 2000, 0.9, 0.1)
		materials.create("massless", 0, 0.0, 0.0)
		materials.create("rope", 0.1, 0.8, 0.0) -- Used by cl_physrope; Insanely low mass because we need it for not bugging out as hard
		materials.create("rubber", 1400, 0.92, 0.75, "rubber_big")
		materials.create("rubber_tyre", 1400, 0.92, 0.75, "rubber_big")
		materials.create("bouncy_ball", 624, 0.85, 0.85, "bouncy_ball")
end

hook.add("onCvarChanged", "onCvarChanged_gravity", function(strName, strOldValue, strNewValue)
	if strName=="g_gravity" then
		setGravityFromCvar()
	end

end)

function GM:physicsUpdate( delta )
	phys.step( delta )
end

include "cvars.lua"
include "ent_utils.lua"
include "print_message.lua"
include "commands/commands.lua"
include "sound/sndeffect.lua"
include "phys/materials.lua"
include "phys/ragdoll.lua"
include "props/props.lua"
include "combat/combat_effects.lua"
include "combat/ammo.lua"
include "combat/bullet.lua"
include "combat/weapons.lua"

if SERVER then -- Time to include server-only lua
	include "sv_init.lua"
  include "sv_cheats.lua"
elseif CLIENT then -- Time to include client-only lua
	include "cl_init.lua"
	include "gui/cl_gui.lua"
end