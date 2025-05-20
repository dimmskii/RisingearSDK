--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
  
  self.platformConscious = true -- Characters can jump from underneath unto the platforms above the heads theirs
  
  self:initProperty("skeleton", nil)
  
  self:initProperty("health", 100)
  
  self:initProperty("mirrored", false)
  
  self:initProperty("ragdollAngles",{})
  
  ENT_BASE.initialize( self )
end


local ENT_BASE_think = ENT_BASE.think
function ENT:think( delta )
	self:updateSkeleton( delta )
	ENT_BASE_think( self, delta )
end

function ENT:initSkeletal()
end

function ENT:updateSkeleton( delta )
  
end

function ENT:updateSkeletalAnim( delta )
  
end

if CLIENT then
  include("cl_init.lua")
elseif (SERVER) then
  include("sv_init.lua")
end

function ENT.persist( thisClass )
    
  ENT_BASE.persist( thisClass )
  
  ents.persist(thisClass, "skeleton", {
      write=function(field, data, ent)
        data:writeSkeleton(field, data)
        ent.skeletonDirty=false
      end,
      read=function(data, ent)
        local skel = data:readNext(data)
        ent:initSkeletal( skel )
        
        return skel
      end,
      dirty=function(field, ent) return ent.skeletonDirty end
    }, ents.SNAP_NET)
    
    ents.persist(thisClass, "rootLimbName", {
      write=function(field, data, ent) data:writeString(field) end,
      read=function(data) return data:readNext() end,
      dirty=function(field, ent) return ent.rootLimbNameDirty end
    }, ents.SNAP_NET)
    
  ents.persist(thisClass, "mirrored", {
      write=function(field, data, ent) data:writeBool(field) end,
      read=function(data) return data:readNext() end,
    }, ents.SNAP_NET)
  
  ents.persist(thisClass, "ragdollAngles", {
      write=function(field, data, ent)
        if field == nil then field = {} end -- TODO tf?
        for k,v in pairs(field) do
          data:writeString(k)
          data:writeFloat(v)
        end
      end,
      read=function(data, ent)
        local angs = {}
        while (data:hasNext()) do
          angs[data:readNext()] = data:readNext()
        end
        return angs
      end,
    }, ents.SNAP_NET)
    
end
