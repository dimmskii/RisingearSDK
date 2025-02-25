--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local def = props.addDefinition("Hanzo Steel", "weapons/melee_hanzo.png", 0.32, 1.50, props.COLLISION_SPRITE, "blade")
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

-- Allow placement in editor
if EDITOR then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end

ENT.niceName =	"Hanzo Steel"
ENT.damage = 10 	--int
ENT.force = 10000	--float
ENT.holdType = weapons.HOLDTYPE_MELEE

ENT.dismembers = true

ENT.soundFire = "weapons/melee_hanzo_swing.wav"
ENT.soundDistantFire = nil

function ENT:initialize()
	self.muzzlePos = geom.vec2(0, -1.05) -- the tip
	self.definitionIndex = def.index	
	
	ENT_BASE.initialize( self )
end

function ENT:getLimbOriginVec()
	return geom.vec2(0, 1.30)
end
