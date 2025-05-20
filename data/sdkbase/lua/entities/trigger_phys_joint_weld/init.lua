--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
  ENT_BASE.initialize(self)
  
  self:initProperty("frequencyHz", 0)
end

if ( SERVER ) then
	function ENT:createJoint(entTargetA, entPhysA, entTargetB, entPhysB)
    local bodyA = entPhysA:getBody()
    local bodyB = entPhysB:getBody()
    if bodyA==nil or bodyB==nil then return end
  
    local joint = ents.create("phys_joint", false)
    local def = phys.newWeldJointDef()
    def.bodyA = bodyA
    def.localAnchorA = entTargetB.position:sub(entTargetA.position)
    def.referenceAngle = entTargetB.angle - entTargetA.angle
    def.bodyB = bodyB
    if self.frequencyHz <= 0 then
      def.frequencyHz = 0
    else
      def.frequencyHz = self.frequencyHz
    end
    def.collideConnected = self.collide
    joint.jointDef = def
    ents.initialize(joint)
    
    self.bodyA = bodyA
    self.bodyB = bodyB
    
    return joint
  end
  
  function ENT:removeJoint()
    ents.remove(self.clEnt)
  end
  
end

if EDITOR then
	include("editor.lua")
end

function ENT.persist( thisClass )
  ENT_BASE.persist( thisClass )
    
  ents.persist(thisClass, "frequencyHz", {
    write=function(field, data) data:writeFloat(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return false end,
  }, ents.SNAP_ALL)
  
end
