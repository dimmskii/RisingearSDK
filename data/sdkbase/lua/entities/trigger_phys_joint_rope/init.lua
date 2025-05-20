--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
  ENT_BASE.initialize(self)
  
  self:initProperty("maxLength", -1)
  self:initProperty("width", 0.1)
  self:initProperty("segmentLength", 0.2)
  self:initProperty("color", color.fromRGBf(0.8,0.8,0.05))
end

if ( SERVER ) then
	function ENT:createJoint(entTargetA, entPhysA, entTargetB, entPhysB)
    local bodyA = entPhysA:getBody()
    local bodyB = entPhysB:getBody()
    if bodyA==nil or bodyB==nil then return end
  
    local joint = ents.create("phys_joint", false)
    local def = phys.newRopeJointDef()
    def.bodyA = bodyA
    def.localAnchorA = entTargetA.position:sub(bodyA:getPosition())
    def.bodyB = bodyB
    def.localAnchorB = entTargetB.position:sub(bodyB:getPosition())
    def.collideConnected = self.collide
    if self.maxLength < 0 then
      def.maxLength = entTargetB:getPosition():sub(entTargetA:getPosition()):len()
    else
      def.maxLength = self.maxLength
    end
    joint.jointDef = def
    ents.initialize(joint)
    
    -- Create helper client physics ent (chain of revolute joints for lag-less realism)
    local clEnt = ents.create("cl_physrope",false)
    clEnt.length = def.maxLength
    clEnt.width = self.width
    clEnt.segmentLength = self.segmentLength
    clEnt.color = self.color
    self.clEnt = clEnt
    ents.initialize(clEnt)
    
    self.bodyA = bodyA
    self.bodyB = bodyB
    
    return joint
  end
  
  function ENT:removeJoint()
    ENT_BASE.removeJoint(self)
    ents.remove(self.clEnt)
  end
  
  function ENT:sv_think(delta)
    ENT_BASE.sv_think(self, delta)
    
    if self.jointEnt and self.jointEnt.valid then
      local joint = self.jointEnt:getJoint()
      if not joint then return end
      local vecStart = geom.vec2()
      joint:getAnchorA(vecStart)
      local vecEnd = geom.vec2()
      joint:getAnchorB(vecEnd)
      self.clEnt:setPosition(vecStart)
      self.clEnt:setVelocity(self.bodyA:getLinearVelocity())
      self.clEnt.endPosition = vecEnd
      self.clEnt.endVelocity = self.bodyB:getLinearVelocity()
    end
  end
end

if EDITOR then
	include("editor.lua")
end

function ENT.persist( thisClass )
  ENT_BASE.persist( thisClass )
    
  ents.persist(thisClass, "maxLength", {
    write=function(field, data) data:writeFloat(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return false end,
  }, ents.SNAP_ALL)
  
  ents.persist(thisClass, "width", {
    write=function(field, data) data:writeFloat(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return false end,
  }, ents.SNAP_ALL)
  
  ents.persist(thisClass, "segmentLength", {
    write=function(field, data) data:writeFloat(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return false end,
  }, ents.SNAP_ALL)
  
  ents.persist(thisClass, "color", {
    write=function(field, data) data:writeColor(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return false end,
  }, ents.SNAP_ALL)
end
