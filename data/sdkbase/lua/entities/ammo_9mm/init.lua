--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local def = props.addDefinition("", "items/ammo_9mm.png", 0.16, 0.10, props.COLLISION_BOX, "weapon")
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

-- Allow placement in editor
if (EDITOR) then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end

ENT.ammoType = "9mm"
ENT.quantity = 24

function ENT:initialize()
	self.definitionIndex = def.index
	ENT_BASE.initialize( self )
	
end
