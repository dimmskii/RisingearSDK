--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local def = props.addDefinition("UMP9", "weapons/smg_ump9.png", 0.680, 0.3264, geom.polygon(geom.vec2(0,0), geom.vec2(0.680,0), geom.vec2(0.480,0.3264)), "weapon", true) -- props.COLLISION_SPRITE too slow
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

-- Allow placement in editor
if EDITOR then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end

ENT.niceName =	"UMP9"
ENT.damage = 15 	--int
ENT.force = 21034	--float
ENT.holdType = weapons.HOLDTYPE_RIFLE
ENT.ammoType = "9mm"
ENT.ammoClip = 30
ENT.soundFire = "weapons/smg_ump9_firec.wav"
ENT.soundDistantFire = "weapons/smg_ump9_fired.wav"

function ENT:initialize()

	-- Weapon class property defs
	self.automatic = true
	self.fireDelay = 0.1 -- auto delay in seconds
	self.fireCone = 0.05 -- in radians
	self.recoil = 0.2 -- in radians
	self.muzzlePos = geom.vec2(0.44, -0.11)
	
	self.definitionIndex = def.index
	
	ENT_BASE.initialize( self )
	
end

function ENT:getLimbOriginVec()
	return geom.vec2(0.200, 0.125)
end
