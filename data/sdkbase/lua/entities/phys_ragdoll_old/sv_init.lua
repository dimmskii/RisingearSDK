--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
  ENT_BASE.initialize(self)
  
  self:initSkeletal( self.characterFrom )
end

function ENT:initSkeletal( ent )
  if ent and ent.skeleton then
    self:cloneEntSkeleton(ent.skeleton)
    self.mirrored = ent.mirrored
    self.mirroredDirty = ent
    self.position = ent:getPosition()
    self.positionDirty = true
    --store velocity of original body
    self.velocity = ent.bodies[1]:getLinearVelocity()
  end
  
  if self.skeleton then
    self:createPhysSkeleton( ent )
  end
end

function ENT:createPhysSkeleton( char )
  if not char.skeleton then return end
  
  self.bodies, self.ragdoll = physragdoll.create(self.skeleton, self.mirrored, self.velocity, char)
end

function ENT:beginContact(selfFixture, otherFixture, contact)
  if selfFixture:getUserData() == otherFixture:getUserData() then contact:setEnabled(false) end
end

function ENT:updateSprite( delta )
  if (self.direction > 0) then
    self.skeleton:setMirrored(false)
  else
    self.skeleton:setMirrored(true)
  end
  
  self.skeleton:update( delta )
end

function ENT:updateSkeleton( delta )
  self.skeleton:setPosition(self.position.x,self.position.y)
  
  local limbs = self.skeleton:getLimbs()
  self.ragdollAngles = {}
  for i=1,limbs.length,1 do
    local limb = limbs[i]
    limb:resetFrameOffset()
    limb:resetFrameOrigin()
    if (limb.physicsDisabled == false) then
      local ragLimb = self.ragdoll[limb]
      local joint = ragLimb.joint
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
end