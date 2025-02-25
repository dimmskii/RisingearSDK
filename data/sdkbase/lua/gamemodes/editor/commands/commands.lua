--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local GM_BASE = gamemode.getClass(GM.CLASSNAME_BASE)

function GM:registerCommands()
	GM_BASE.registerCommands( self )
end