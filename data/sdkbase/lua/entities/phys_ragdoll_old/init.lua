--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
  
  self.platformConscious = true -- Characters can jump from underneath unto the platforms above the heads theirs
  
  self:initProperty("entFrom", nil)
  
  self:initProperty("rootLimbName", nil)
  
  self:initProperty("skeleton", nil)
  
  self:initProperty("health", 100)
  
  self:initProperty("mirrored", false)
  
  self:initProperty("ragdollAngles",{})
  
  if SERVER then
    self.mirroredDirty=true
    self:initSkeletal()
  end
  
  ENT_BASE.initialize( self )
end


function ENT:think( delta )
  if self.skeleton then
    self:updateSkeletalAnim( delta )
    self:updateSkeleton( delta )
  end
  
  ENT_BASE.think( self, delta )
end

function ENT:initSkeletal()
end

function ENT:cloneEntSkeleton( skel )
  skel = skel:clone()
  if self.rootLimbName then
    local r = skel:getLimb(self.rootLimbName)
    if r then
      r:detatch()
      r.offset = geom.vec2()
      skel = skeletal.createSkeleton()
      skel:setRoot(r)
      skel:rebuildLimbTable()
    end
  end
  self.skeleton = skel
  
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
    
  ents.persist(thisClass, "characterFrom", {
      write=function(field, data, ent)
        data:writeEntityID(field, data)
        ent.skeletonDirty=false
      end,
      read=function(data, ent)
        local char = ents.findByID(data:readNext(data))
        ent:initSkeletal(char)
        
        return char
      end,
      dirty=function() return false end
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
