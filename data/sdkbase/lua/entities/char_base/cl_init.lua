--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:cl_initialize()
	ENT_BASE.cl_initialize( self )
	
	self.renderable = renderables.fromSkeleton(self.skeleton)
	renderables.add(self.renderable)
	
end

function ENT:updateSprite( delta )
	self.skeleton:setMirrored(self.mirrored)
end

local color_transparent = color.fromRGBAf(0,0,0,0)

local limb
function ENT:updateSkeleton( delta )
	self.skeleton:setPosition(self.position.x ,self.position.y)
	self.skeleton:setMirrored(self.mirrored)
	
	 -- Update the limb angles as per server-sided physics ragdoll if we are dead
	if not self:isAlive() then
		self.skeleton:setAnimationPlay(skeletal.AP_STOP)
		limb = nil
		for k,v in pairs(self.ragdollAngles) do
		  limb = self.skeleton:getLimb(k)
		  if not table.hasValue(self.ragdollDismem, k) then
  			if limb then		-- TODO: Some limbs don't exist like weapon
  				limb.angle = v
  				limb:resetFrameOffset()
  				limb:resetFrameOrigin()
  			end
			end
		end
	end
	
	-- Invoke skeleton's internal updating stuff
	self.skeleton:update(delta)
end

local t, limb, l
function ENT:cl_updateDismemberment( tRagdollDismem )
	tRagdollDismem = tRagdollDismem or self.ragdollDismem
  if not self.skeleton or not tRagdollDismem then return end
  
  self.skeleton:rebuildLimbTable()
  t = nil
  limb = nil
  for k,v in pairs(tRagdollDismem) do
    limb = self.skeleton:getLimb( v )
    if limb then
      t = limb:getSelfAndAllChildren()
      -- go through all of that
      for i=1,t.length,1 do
         l = t[i]
          l:getSprite():setColor(color_transparent)
      end
    end
  end
end

function ENT:destroy()
	ENT_BASE.destroy(self)
	
	renderables.remove(self.renderable)
	
end