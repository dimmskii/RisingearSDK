--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
  ENT_BASE.initialize(self)
  
  if self.skeleton then
  	self:initSkeletal(self.skeleton)
  end
end

function ENT:initSkeletal( skel )
  if skel then
    self:createPhysSkeleton( skel )
  end
end

function ENT:createPhysSkeleton( skel )
  self.bodies, self.ragdoll = physragdoll.create(skel, self.mirrored, self.velocity, self)
end

function ENT:beginContact(selfFixture, otherFixture, contact)
--  if selfFixture:getUserData() == otherFixture:getUserData() then contact:setEnabled(false) end
  if otherFixture:getBody():getType() == phys.BT_DYNAMIC then contact:setEnabled(false) end -- Disable for all dynamic
end

local limbs, limb, ragLimb, joint
function ENT:updateSkeleton( delta )
  self.skeleton:setPosition(self.position.x,self.position.y)
  
  limbs = self.skeleton:getLimbs()
  self.ragdollAngles = {}
  for i=1,limbs.length,1 do
    limb = limbs[i]
    limb:resetFrameOffset()
    limb:resetFrameOrigin()
    if (limb.physicsDisabled == false) then
      ragLimb = self.ragdoll[limb]
      joint = ragLimb.joint
      if (joint) then
        if self.mirrored then
          limb.angle = joint:getJointAngle() + self.ragdoll[limb].initialAngle
        else
          limb.angle = -joint:getJointAngle() + self.ragdoll[limb].initialAngle
        end
      else
        if self.mirrored then
          limb.angle = -ragLimb.body:getAngle()
        else
          limb.angle = ragLimb.body:getAngle()
        end
      end
      self.ragdollAngles[limb:getName()] = limb.angle
    end
  end
  
  self.skeleton:update( delta )
end