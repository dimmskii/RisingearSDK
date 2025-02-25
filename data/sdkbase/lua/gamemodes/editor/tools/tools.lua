--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


if (CLIENT) then
	include("cl_tools.lua")
end

-- Include our shared tool files. They should register themselves.
-- These files are shared only because they might define their own network messages.
-- Everything else is client-sided anyways.
include("tool_select.lua")
include("tool_hand.lua")
include("tool_resize.lua")
include("tool_move.lua")
include("tool_polygon.lua")
include("tool_entity.lua")
include("tool_physprop.lua")

