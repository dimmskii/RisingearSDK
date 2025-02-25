--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

local CHASE_FACTOR = 4.5 -- Velocity coefficient a in v=a*d(toTarget)/second
local ZOOM_SPEED = 0.05

if (CLIENT) then
	
	function ENT:initialize()
		ENT_BASE.initialize( self )
	end
	
	function ENT:think( delta )
		ENT_BASE.think( self, delta )
		
		if (self.target == nil or self.target.valid == false or self.target.initialized == false ) then return end
		
		local vec = self.target.position:sub(self.position)
		self:setVelocity(vec:mulLocal(CHASE_FACTOR))
		
	end
	
	function ENT:zoomIn( delta )
		local zs = self.zoomSpeed * delta
		self.camera:setZoom(self.camera:getZoom() + zs)
	end
	
	function ENT:zoomOut( delta )
		local zs = self.zoomSpeed * delta
		self.camera:setZoom(self.camera:getZoom() - zs)
	end
	
end