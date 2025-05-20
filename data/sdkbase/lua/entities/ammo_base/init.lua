--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

--local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.ammoType = "base"
ENT.quantity = 10

if (CLIENT) then
	ENT.pickupSound = audio.sound("pickups/pickup_ammo.wav")
end

--function ENT:initialize()
--	ENT_BASE.initialize( self )
--end

if (SERVER) then
	include("sv_init.lua")
end