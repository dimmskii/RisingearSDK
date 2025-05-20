--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:cl_initialize()
  ENT_BASE.cl_initialize( self )
  
end

function ENT:initSkeletal( skel )
		if not skel then return end
		
		if self.renderable then renderables.remove(self.renderable) end
		
		self.renderable = renderables.fromSkeleton(skel)
		renderables.add(self.renderable)

end

function ENT:updateSkeleton( delta )
  if not self.skeleton then return end
  self.skeleton:setPosition(self.position.x ,self.position.y)
  self.skeleton:setMirrored(self.mirrored)
  
   -- Update the limb angles as per server-sided physics ragdoll if we are dead
  self.skeleton:setAnimationPlay(skeletal.AP_STOP)
  local limb = nil
  for k,v in pairs(self.ragdollAngles) do
    limb = self.skeleton:getLimb(k)
    if limb then    -- TODO: Some limbs don't exist like weapon
      limb.angle = v
      limb:resetFrameOffset()
      limb:resetFrameOrigin()
    end
  end
  
  -- Invoke skeleton's internal updating stuff
  self.skeleton:update(delta)
end