--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local def = props.addDefinition("Glock 17", "weapons/pist_glock.png", 0.25, 0.25, props.COLLISION_SPRITE, "weapon")
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

-- Allow placement in editor
if EDITOR then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end

ENT.niceName = "Glock 17"
ENT.damage = 12 	--int
ENT.force = 15000	--float
ENT.holdType = weapons.HOLDTYPE_PISTOL
ENT.ammoType = "9mm"
ENT.ammoClip = 12
ENT.soundFire = "weapons/pist_glock_firec.wav"
ENT.soundDistantFire = "weapons/pist_glock_fired.wav"
ENT.soundReloadClip = "weapons/pist_glock_rel10.wav"
ENT.soundReloadCharge = ""

function ENT:initialize()

	-- Weapon class property defs
	self.automatic = false
	self.fireDelay = 0.05 -- auto delay in seconds
	self.fireCone = 0.023 -- in radians
	self.muzzlePos = geom.vec2(0.27, -0.075)
	self.recoil = 0.35 -- in radians

	self.definitionIndex = def.index
	
	ENT_BASE.initialize( self )
	
end

function ENT:getLimbOriginVec()
	return geom.vec2(0.-0.05, 0.145)
end
