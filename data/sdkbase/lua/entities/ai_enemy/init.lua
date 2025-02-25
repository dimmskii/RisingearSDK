--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

if SERVER then

	local BORING_ZONE_COOLDOWN = 1 -- Seconds
	local BORING_ZONE_RADIUS = 2 -- Meters

	local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

	ENT.viewRadius = 30
	
	function ENT:sv_initialize()
		self.targetLastPosition = nil
		
		ENT_BASE.sv_initialize(self)
		
		self.boringZoneCooldown = BORING_ZONE_COOLDOWN
	end
	
	-- Checks if we are in the same vicinity for too long and responds various maneuvers attempts like jumping, etc
	function ENT:doBoringZoneLogic(movement, character )
		self.boringZoneVec = self.boringZoneVec or character.position:clone()
		if self.boringZoneVec:sub(character.position):len() > BORING_ZONE_RADIUS then
			self.boringZoneCooldown = BORING_ZONE_COOLDOWN -- Restart timer
			self.boringZoneVec = character.position:clone()
			--movement.direction = 0
			return
		end
		
		if self.boringZoneCooldown <= 0 then
			character:jump()
			--movement.direction = movement.direction * -1
			self.boringZoneCooldown = BORING_ZONE_COOLDOWN -- Restart timer
		end
	end
	
	local ENT_BASE_sv_update = ENT_BASE.sv_update
	function ENT:sv_update( delta )
		self.boringZoneCooldown = self.boringZoneCooldown - delta
		ENT_BASE_sv_update(self,delta)
	end
	
	function ENT:updateMovement( movement, character )
		
		-- Reset movement
		--movement.direction = 0
		movement.running = false
		
		if self.target and self.target.valid then
		--CAN SEE ITS TARGET CODE
			self.targetLastPosition = self.target.position:clone()
			-- Check if target is dead first and foremost
			if not self.target:isAlive() then
				self.target = nil
				self.targetLastPosition = nil -- Here it seems to be the analog of 'discovering' that its target is dead
				return
			end
		
			character:aimAt(self.targetLastPosition.x, self.targetLastPosition.y)
			
			local vecDistance = character:getPosition():sub(self.targetLastPosition)
			
			-- At greater than 6m distance, set running to target
			if vecDistance:len() > 6 then
				movement.direction = 1
				movement.running = true
			end
			
			-- At less than 7m distance, shooting code
			if vecDistance:len() < 7 then
				if character.weapon then
					if character.weapon.ammoType == "none" or character.weapon.ammoClip > 0 then
						movement.attacking = true
					else
						movement.attacking = false
						character:reloadWeapon()
					end
				end
			end
			
			self:doBoringZoneLogic(movement, character)
			
			-- If player is elevated 1m higher, jump if we are within 9m x-wise
			if vecDistance.x < 9 and vecDistance.y > 1 then
				character:jump()
			end
		elseif self.targetLastPosition then
		--CAN'T SEE ITS TARGET CODE
			character:aimAt(self.targetLastPosition.x, self.targetLastPosition.y)
			if movement.direction == 0 then movement.direction = 1 end
			
			character:aimAt(self.targetLastPosition.x, self.targetLastPosition.y)
			self:doBoringZoneLogic(movement, character)
			movement.running = false -- Walk calmly to the destination
			movement.attacking = false
		else
		--ROAM CODE
			movement.running = 0
			movement.direction = 0
			movement.attacking = false
		end
		
	end
	function ENT:selectTarget( tblTargetsInView, entTarget )
		for _,v in ipairs(tblTargetsInView) do
			if v and v.valid and ents.isClass(v,"player",true) then -- Only select players
				return v
			end
		end
		return nil
	end

	function ENT:lostViewOfTarget( entTarget, character )
		self.targetLastPosition = entTarget.position:clone()
		character:jump() -- Just for fun
	end
end
