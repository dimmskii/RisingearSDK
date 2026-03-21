--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

EDITOR.REND_DEPTH_GRID = 0
EDITOR.REND_DEPTH_ENTSHAPE = -100
EDITOR.REND_DEPTH_SELECTION = -200
EDITOR.REND_DEPTH_TOOL = -300

editor_config.register("editor_view_lighting", true, editor_config.TYPE_BOOL)
editor_config.register("editor_view_outlines", true, editor_config.TYPE_BOOL)

local GM_BASE = gamemode.getClass(GM.CLASSNAME_BASE)

function GM:cl_initialize()
	GM_BASE.cl_initialize( self )
end

function GM:cl_update( delta )
	GM_BASE.cl_update( self, delta )
	
	-- Update tools
	tools.update( delta )
end

	
	editor_cam.initialize()	-- TODO: LUAJC PROBLEM? 		-- TODO: LUAJC PROBLEM? Moved before cl_init.lua and its init func controller listeners only work when added outside of cl_init.lua GM:Initialize()
	editor_keys.initialize()	-- TODO: LUAJC PROBLEM? 		-- TODO: LUAJC PROBLEM? Moved before cl_init.lua and its init func controller listeners only work when added outside of cl_init.lua GM:Initialize()