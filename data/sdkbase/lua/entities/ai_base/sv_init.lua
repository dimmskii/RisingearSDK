--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.viewRadius = 20

function ENT:sv_initialize()
	ENT_BASE.sv_initialize( self )
	
	self.rescanTimer = timer.create(0,1,function()
		if self.character then
			self:rescan(self.character)
		end
	end,false,false)
	self.updateMovementTimer = timer.create(0.1,-1,function()
		if self.character then
			self:updateMovement(self.character.movement, self.character)
		end
	end,false,false)
	self.targetsInView = {}
end

function ENT:updateMovement( movement, character )
end

function ENT:selectTarget( tblTargetsInView, entTarget )
	return nil
end

function ENT:lostViewOfTarget( entTarget, character )
end

function ENT:rescan( character )
	self.targetsInView = {} -- Clear targets in view

	local world = phys.getWorld()
	local steps = 40
	local vec, angleDiff
	if character.mirrored then
		vec = geom.vec2(-self.viewRadius,0)
		angleDiff = 180/steps
	else
		vec = geom.vec2(self.viewRadius,0)
		angleDiff = -180/steps
	end
	local targetsByKey = {}

	local charPos = character:getPosition()
	local fixtureResult, bodyResult, entResult, pointResult
	
	local callback = phys.newRayCastCallback( function(fixtureHit, vecPoint, vecNormal, fFraction)
		local ent = fixtureHit:getBody():getUserData()
		if ent ~= character and not ent.notarget then -- TODO: should notarget code really be here?
			entResult = ent
			pointResult = vecPoint
			return fFraction
		end
		return -1
		
	end)
	
	for i=0, steps do
		world:raycast( callback, charPos:clone(), charPos:add(vec) )
		
		if entResult then
			targetsByKey[entResult] = pointResult
		end
		
		vec:setTheta(vec:getTheta() + angleDiff)
	end
	
	for k,v in pairs(targetsByKey) do
		table.insert(self.targetsInView, k)
	end
	
	self:scheduleNextRescan(1)
end

function ENT:scheduleNextRescan(fSeconds)
	timer.adjust(self.rescanTimer,fSeconds,1)
	timer.start(self.rescanTimer)
end

function ENT:entInView( ent )
	for _,v in ipairs( self.targetsInView ) do
		if v == ent then return true end
	end
	return false
end

function ENT:think( delta )
	if self.target and self.target.valid then
		if not self:entInView( self.target ) then
			self:lostViewOfTarget( self.target, self.character )
			self.target = nil
		end
	else
		if type(self.targetsInView)=="table" and table.getn(self.targetsInView) > 0 then
			self.target = self:selectTarget( self.targetsInView, self.character )
		end
	end
end

function ENT:destroy()
	timer.remove(self.updateMovementTimer)
	timer.remove(self.rescanTimer)
end
