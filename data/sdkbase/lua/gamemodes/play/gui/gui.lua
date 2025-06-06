--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local GM_BASE = gamemode.getClass(GM.CLASSNAME_BASE)

if (CLIENT) then
	
	-- Include CS
	include("cl_gui_scores.lua")
	
	function GM:fgui_initialize()
		GM_BASE.fgui_initialize( self )
		gui_scores.initialize()
	end
	

	function GM:fgui_destroy()
		GM_BASE.fgui_destroy( self )
		gui_scores.destroy()
	end
	

end

-- Shared include after
include("gui_window_appearance.lua")
