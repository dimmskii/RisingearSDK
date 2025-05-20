--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
  ENT_BASE.initialize( self )
  
  -- Define pre-init
  self:initProperty("width", 0.1) -- Also cosmetic
  self:initProperty("length", 8)
  self:initProperty("segmentLength", 0.2)
  
  -- Cosmetic
  self:initProperty("color", color.fromRGBf(0.8,0.8,0.05))
  
  -- Networked
  self:initProperty("endPosition", geom.vec2())
  self:initProperty("endVelocity", geom.vec2())
end

if ( CLIENT ) then
  include("cl_init.lua")
end

function ENT.persist( thisClass )
  ENT_BASE.persist( thisClass )
  ents.persist(thisClass, "color", {
    write=function(field, data) data:writeColor(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return false end,
  }, ents.SNAP_NET)
  
  ents.persist(thisClass, "width", {
    write=function(field, data) data:writeFloat(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return false end,
  }, ents.SNAP_NET)
  
  ents.persist(thisClass, "length", {
    write=function(field, data) data:writeFloat(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return false end,
  }, ents.SNAP_NET)
  
  ents.persist(thisClass, "segmentLength", {
    write=function(field, data) data:writeFloat(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return false end,
  }, ents.SNAP_NET)
  
  ents.persist(thisClass, "color", {
    write=function(field, data) data:writeColor(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return false end,
  }, ents.SNAP_NET)
    
    
  ents.persist(thisClass, "endPosition", {
    write=function(field, data) data:writeVec2(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return true end,
  }, ents.SNAP_NET)
      
  ents.persist(thisClass, "endVelocity", {
    write=function(field, data) data:writeVec2(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return true end,
  }, ents.SNAP_NET)
  
end