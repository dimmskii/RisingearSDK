--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local asd = "asd"

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

local ENT_BASE_initialize = ENT_BASE.initialize
function ENT:initialize()
  if CLIENT then console.log("Ent class test_c:initialize running") end
  ENT_BASE_initialize( self )
  
end