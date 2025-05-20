--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


if EDITOR then
  ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
  function ENT:editor_createSprite()
    local spr = sprites.create()
    spr:addTexture("gui/editor/ent_glyphs/clock.png")
    spr.width = 0.25
    spr.height = 0.25
    spr:centerOrigin()
    return spr
  end
end

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

local ENT_BASE_initialize = ENT_BASE.initialize
function ENT:initialize()
  if CLIENT then console.log("Ent class test_d:initialize running") end
  
  self:initProperty("skeleton", nil)
	ENT_BASE_initialize( self )
	
end

local followDist = 1 -- How far to stop at in meters
local velocityCoefficient -- a in v=a*(d(target)-followDist)/s

local ENT_BASE_think = ENT_BASE.think
function ENT:think(delta)
  ENT_BASE_think( self , delta )
  local chase
  for k,v in pairs(ents.getAll("player")) do
    if v:isAlive() then
      chase = v
    end
  end
  
  if chase==nil then return end
  
  local vec = chase.position:sub(self.position)
  
  -- Limit the vel to 4
  if (vec:len() > 4) then
	  vec:normalize()
	  vec:mulLocal(4)
  end
  
  -- Set the vel
  self:setVelocity(vec)
  
  -- UPDATE SKEL
  if self.skeleton then
    self.skeleton.position:set(self.position)
    self.skeleton:update(delta)
  end
  
end

function ENT:setSkeleton( skel )
  self.skeleton = skel
  if SERVER then self.skeletonDirty = true end
end

if CLIENT then include("cl_init.lua") end

function ENT.persist( thisClass )
  ENT_BASE.persist( thisClass )
  
  ents.persist(thisClass, "skeleton", {
      write=function(field, data, ent)
        data:writeSkeleton(field)
        ent.skeletonDirty = false
      end,
      read=function(data, ent)
        local skel = data:readNext()
        ent:cl_createRenderable(skel)
        return skel
      end,
      dirty=function(field, ent) return ent.skeletonDirty end,
    }, ents.SNAP_ALL)
end