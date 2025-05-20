--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local def = props.addDefinition("", "items/ammo_12gauge.png", 0.15, 0.12, props.COLLISION_BOX, "weapon", true)
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

-- Allow placement in editor
if (EDITOR) then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end

ENT.ammoType = "12gauge"
ENT.quantity = 12

function ENT:initialize()
	self.definitionIndex = def.index
	ENT_BASE.initialize( self )
end
