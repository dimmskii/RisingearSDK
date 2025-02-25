--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local GM_BASE = gamemode.getClass(GM.CLASSNAME_BASE)

function GM:initialize()
	GM_BASE.initialize( self )
end

-- Shared includes
include( "commands/commands.lua" )
include( "hud.lua" )
include( "networking.lua" )
include( "gui/gui.lua" )

if ( SERVER ) then -- Time to include server-only lua
	include( "sv_init.lua" )
elseif ( CLIENT ) then -- Time to include client-only lua
	include( "cl_init.lua" )
end

-- Shared post includes
include( "gamerules.lua" )
