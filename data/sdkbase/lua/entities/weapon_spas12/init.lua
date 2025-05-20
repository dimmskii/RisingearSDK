--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local def = props.addDefinition("SPAS-12", "weapons/shot_spas12.png", 0.85, 0.236, geom.polygon(geom.vec2(0,0),geom.vec2(0.85,0),geom.vec2(0.1,0.236)), "weapon", true) -- props.COLLISION_SPRITE too slow
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

-- Allow placement in editor
if EDITOR then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end

ENT.niceName =	"SPAS-12"
ENT.damage = 2 	--int
ENT.force = 8200	--float
ENT.bulletsPerShot = 10
ENT.holdType = weapons.HOLDTYPE_RIFLE
ENT.ammoType = "12gauge"
ENT.ammoClip = 8
ENT.soundFire = "weapons/shot_spas12_firec.wav"
ENT.soundDistantFire = "weapons/shot_spas12_fired.wav"
ENT.soundReloadClip = "weapons/shot_spas12_rel10.wav"
ENT.soundReloadCharge = "weapons/shot_spas12_rel20.wav"

function ENT:initialize()

	-- Weapon class property defs
	self.automatic = false
	self.fireDelay = 0.25 -- auto delay in seconds
	self.fireCone = 0.1 -- in radians
	self.recoil = 0.4 -- in radians
	self.muzzlePos = geom.vec2(0.82, -0.085)
	
	self.definitionIndex = def.index
	
	ENT_BASE.initialize( self )
	
end

function ENT:getLimbOriginVec()
	return geom.vec2(-0.020, 0.170)
end
