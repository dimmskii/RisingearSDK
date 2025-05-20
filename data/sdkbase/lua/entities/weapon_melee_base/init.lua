--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local def = props.addDefinition("Hanzo Steel", "weapons/melee_hanzo.png", 0.32, 1.50, props.COLLISION_SPRITE, "blade")
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.niceName =	"Base Melee Weapon"
ENT.damage = 10 	--int
ENT.force = 10000	--float
ENT.holdType = weapons.HOLDTYPE_MELEE
ENT.ammoType = "none"

ENT.dismembers = false

ENT.soundFire = nil
ENT.soundDistantFire = nil

function ENT:initialize()
	-- Weapon class property defs
	self.automatic = true
	self.fireDelay = 0.4 -- auto delay in seconds
	self.recoil = 0.0 -- in radians
	
	-- weapon_base overrides
	self:initProperty("materialID", "blade")
	
	ENT_BASE.initialize( self )
	
end

function ENT:getLimbOriginVec()
	return geom.vec2(0, 1.30)
end

if SERVER then
	include("sv_init.lua")
end