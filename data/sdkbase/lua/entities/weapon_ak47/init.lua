--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local def = props.addDefinition("AK-47", "weapons/rif_ak.png", 0.889, 0.278, geom.polygon(geom.vec2(0,0), geom.vec2(0.889,0.05), geom.vec2(0.15,0.200)), "weapon") -- props.COLLISION_SPRITE too slow
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

-- Allow placement in editor
if EDITOR then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end

ENT.niceName =	"AK-47"
ENT.damage = 20 	--int
ENT.force = 42069	--float
ENT.holdType = weapons.HOLDTYPE_RIFLE
ENT.ammoType = "762sov"
ENT.ammoClip = 30
ENT.soundFire = "weapons/rif_ak47_firec.wav"
ENT.soundDistantFire = "weapons/rif_ak47_fired.wav"

function ENT:initialize()

	-- Weapon class property defs
	self.automatic = true
	self.fireDelay = 0.1 -- auto delay in seconds
	self.fireCone = 0.01 -- in radians
	self.recoil = 0.2 -- in radians
	self.muzzlePos = geom.vec2(0.74, -0.06)
	
	self.definitionIndex = def.index
	
	ENT_BASE.initialize( self )
	
end

function ENT:getLimbOriginVec()
	return geom.vec2(0.150, 0.125)
end
