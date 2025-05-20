--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- Include before
include("cl_gui_utils.lua")

-- FGUI stuff
function GM:fgui_initialize()
	gui_chat.initialize()
end

function GM:fgui_destroy()
	gui_chat.destroy()
end

-- Include after
include("cl_gui_chat.lua")
include("cl_gui_filedialog.lua")
