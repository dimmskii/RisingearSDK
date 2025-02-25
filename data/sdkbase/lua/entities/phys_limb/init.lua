--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	ENT_BASE.initialize( self )
end


if ( SERVER ) then
	include("sv_init.lua")
elseif ( CLIENT ) then
	include("cl_init.lua")
end

function ENT.persist( thisClass )
	
	ENT_BASE.persist( thisClass )
	
end
