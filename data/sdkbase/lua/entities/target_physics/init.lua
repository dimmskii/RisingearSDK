--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
  ENT_BASE.initialize( self )
  
  self:initProperty("physEntTag", "")
end

function ENT:setPhysEntTag(strTag)
  self.physEntTag = strTag
  self:updatePhysEnt()
  if SERVER then self.physEntTagDirty = true end
end

function ENT:getPhysEntTag1()
  return self.physEntTag
end

function ENT:updatePhysEnt()
  
  self.physEnt = nil
  if self.physEntTag and self.physEntTag ~= "" then
    local entsByTag = ents.findByTag(self.physEntTag)
    for k,v in pairs(entsByTag) do
      if ents.isClass(v,"phys_base",true) then
        self.physEnt = v
        break -- TODO check if multiple phys ents matching tag and do something about it
      end
    end
  else
    local fix = phys.getWorld():getFixtureAtPoint(self.position)
    if fix and fix.m_userData and fix.m_userData.valid and ents.isClass(fix.m_userData,"phys_base",true) then
        self.physEnt = fix.m_userData
     end
  end
end

if SERVER then
function ENT:postMapLoad()
    ENT_BASE.postMapLoad( self )
    self:updatePhysEnt()
  end
end

if EDITOR then
  include("editor.lua")
end

function ENT.persist( thisClass )
  ENT_BASE.persist( thisClass )
  
  ents.persist(thisClass, "physEntTag", {
      write=function(field, data, ent)
        data:writeString(field)
        ent.physEntTagDirty = false
      end,
      read=function(data, ent)
        return data:readNext()
      end,
      dirty=function(field, ent) return ent.physEntTagDirty end,
    }, ents.SNAP_ALL)
end