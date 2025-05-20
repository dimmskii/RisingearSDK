--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


if ( SERVER ) then
	include("sv_init.lua")
end

if ( EDITOR ) then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end
