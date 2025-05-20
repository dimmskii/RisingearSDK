--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:sv_initialize()
	ENT_BASE.sv_initialize( self )
	self:initTimer()
end

function ENT:initTimer()
	local repititions = 1
	if (self:isRepeating()) then
		repititions = -1
	end
	
	if not (self.timer) then
		self.timerName = timer.create( self:getTime(), repititions, function() self:onTimer() end, false, false)
		timer.stop(self.timerName) -- TODO: WHY?! This is a bug. Should not need to do. Why do...
	end
	
	if (EDITOR) then return end
	
	if ( self:isRunning() ) then -- TODO make use of timeRemaining -- it's for saves and stuff
		timer.start(self.timerName)
	end
end

function ENT:onTimer()
	if (EDITOR) then return end
	
	self:triggerTargets(self:getSource())
	
end

function ENT:sv_think( delta ) -- TODO move this to network tick
	ENT_BASE.sv_think( self, delta )
	
	if ( self:isRunning() ) then
		self:setTimeRemaining( timer.timeleft(self.timerName) )
	end
end

function ENT:destroy()
	if (self.timer) then
		timer.removeTimer(self.timerName)
	end
end
