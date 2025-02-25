--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local def = props.addDefinition("", "items/item_health_m_01.png", 0.35, 0.35, props.COLLISION_BOX, "weapon")
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

if CLIENT then
	ENT.pickupSound = audio.sound("pickups/item_health_m.wav")
end

-- Allow placement in editor
if EDITOR then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end

ENT.amountArmor = 0
ENT.amountHealth = 25

ENT.flashTexture = "items/item_health_m_02.png"

function ENT:initialize()
	self.definitionIndex = def.index
	ENT_BASE.initialize( self )
	
end
