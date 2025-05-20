--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local GM_BASE = gamemode.getClass(GM.CLASSNAME_BASE)

function GM:sv_initialize()
	GM_BASE.sv_initialize( self )
end

function GM:sv_update( delta )
	GM_BASE.sv_update( self, delta )
end

function GM:physicsUpdate( delta )
	-- phys.step( delta ) -- We don't phys to Editholm
end

function GM:onClientConnect( client )
	GM_BASE.onClientConnect( self, client )
end

function GM:onClientDisconnect( client )
	GM_BASE.onClientDisconnect( self, client )
end
