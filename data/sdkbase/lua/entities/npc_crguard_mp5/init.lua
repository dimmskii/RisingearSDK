--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT.def_health = 45

ENT.def_female = false
ENT.def_aiClass = "ai_enemy"
ENT.def_weaponClass = "weapon_ump9"

ENT.def_skinColor = color.fromRGBi(143,205,41)
ENT.def_hair = ""
ENT.def_hairColor = color.BLACK
ENT.def_facialHair = ""
ENT.def_facialHairColor = color.BLACK
ENT.def_eyes = "virgil"
ENT.def_eyeColor = color.GREEN
ENT.def_eyebrows = "virgil"
ENT.def_eyebrowColor = color.BLACK

ENT.def_top = "unifrmblk_cr"
ENT.def_bottom = "trkblack"
ENT.def_shoes = "dresblk"

-- Allow placement in editor
if (EDITOR) then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end


