--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

if (CLIENT) then
	
	function ENT:initialize()
		ENT_BASE.initialize( self )
		
		self.dreet = 0
	end
	
	function ENT:think( delta )
		ENT_BASE.think( self, delta )
    
	  self.dreet = self.dreet + delta * math.random()*16
    self.camera:setZoom(math.sin(self.dreet) * 0.25 + 1)
    self.camera:setAngle(math.sin(self.dreet)/337)
	end
	
	function ENT:zoomIn( delta )
	 -- You can't control rave
	end
	
	function ENT:zoomOut( delta )
  	-- You can't control rave
	end
	
end