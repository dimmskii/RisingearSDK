--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:sv_initialize()
	ENT_BASE.sv_initialize( self )
	self:createJoint()
end

function ENT:createJoint()
  if self.jointDef then
    self.joints[1] = phys.getWorld():createJoint(self.jointDef)
  end
end

function ENT:getJoint()
  return self.joints[1]
end
