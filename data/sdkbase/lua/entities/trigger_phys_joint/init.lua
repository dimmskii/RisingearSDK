--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
  ENT_BASE.initialize(self)
  
  self:initProperty("collide", false)
end

if ( SERVER ) then
	include("sv_init.lua")
end

if ( EDITOR ) then
	include("editor.lua")
end

function ENT.persist( thisClass )
    
  ENT_BASE.persist( thisClass )
    
  ents.persist(thisClass, "collide", {
      write=function(field, data, ent)
        data:writeBool(field)
      end,
      read=function(data, ent)
        return data:readNext()
      end,
      dirty=function(field, ent) return false end
    }, ents.SNAP_ALL)
  
end