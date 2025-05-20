--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:cl_initialize()
	ENT_BASE.cl_initialize( self )
	self.canPlay = true
	self:cl_doSoundLogic()
end

function ENT:setPlaying( bPlaying )
	self.playing = bPlaying
	self:cl_doSoundLogic()
end

function ENT:cl_doSoundLogic()
	if (self.snd == nil) then self.snd = audio.sound(self.soundFile) end
	
	if (self.canPlay) then
		if (self.loop) then
			self.snd:loopAt(self.pitch,self.volume,self.position.x,self.position.y,0,self.distance)
		else
			self.canPlay = false
			timer.simple(self.snd:getLength(),function() self.canPlay = true end)
			self.snd:playAt(self.pitch,self.volume,self.position.x,self.position.y,0,self.distance)
		end
	end
end

function ENT:cl_think( delta )
	ENT_BASE.cl_think( self, delta )
	if self.snd == nil then return end
	if self.snd:isPlaying() then
		if not self.playing then
			self.snd:stop()
		end
	end
end

function ENT:onTriggered( source, caller )
	self:setPlaying( true )
	self:cl_doSoundLogic()
end
