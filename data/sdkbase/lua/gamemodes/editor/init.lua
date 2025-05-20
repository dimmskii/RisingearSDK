--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

-- Set the EDITOR global to true. This is mainly used by entities of all kinds to check if their editor.lua should be included.
EDITOR = {}

-- Placement type globals for our entities to use
EDITOR.PLACEMENT_TYPE_NONE = 0
EDITOR.PLACEMENT_TYPE_POINT = 1
EDITOR.PLACEMENT_TYPE_RECT = 2

local GM_BASE = gamemode.getClass(GM.CLASSNAME_BASE)

function GM:initialize()
	GM_BASE.initialize( self )
end

function GM:doEntityThink( ent, delta )
	ent:think( 0 ) -- We think with zero delta time in Editor. This way, we still update some things in a motionless state.
end

-- Shared includes first
include( "commands/commands.lua" )
include( "config/config.lua" )
include( "fileops.lua" )
include( "networking.lua" )
include( "actions.lua" )

if ( SERVER ) then -- Time to include server-only lua
	include( "sv_init.lua" )
elseif ( CLIENT ) then -- Time to include client-only lua
	include( "cl_init.lua" )
	include( "cl_editor_keys.lua" )
	include( "cl_editor_cam.lua" )
	include( "cl_grid.lua" )
	include( "cl_ent_draw.lua" )
end

-- Shared includes after
include( "selection.lua" )
include( "texture.lua" )
include( "tools/tools.lua" )
include( "gui/gui.lua" )
