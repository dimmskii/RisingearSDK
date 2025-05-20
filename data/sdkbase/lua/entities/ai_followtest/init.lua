--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

if SERVER then
	function ENT:updateMovement( movement, character )
		if self.target then
			local vecDistance = character:getPosition():sub(self.target:getPosition())
			if (vecDistance:len() > 6) then
				movement.direction = 1
				movement.running = true
			else
				movement.direction = 0
				movement.running = false
			end
			
			character:aimAt(self.target.position.x, self.target.position.y)
		else
			movement.direction = 0
			movement.running = false
		end
		
	end
	function ENT:selectTarget( tblTargetsInView, entTarget )
		for _,v in ipairs(tblTargetsInView) do
			if ents.isClass(v,"player",true) then
				print("hello")
				return v
			end
		end
		return nil
	end

	function ENT:lostViewOfTarget( entTarget, character )
		if ents.isClass(entTarget,"player",true) then
			print("goodbye")
		end
	end
end
