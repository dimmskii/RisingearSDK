--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	
	self:initProperty("running", false)
	self:initProperty("repeating", false)
	self:initProperty("time", 1)
	self:initProperty("timeRemaining", -1)
	self:initProperty("source", nil)
	self:initProperty("caller", nil)
	
	ENT_BASE.initialize( self )
end

function ENT:setRunning( bRunning )
	self.running = bRunning
	if (SERVER) then self.runningDirty = true end
end

function ENT:isRunning()
	return self.running
end

function ENT:setRepeating( bRepeating )
	self.repeating = bRepeating
	if (SERVER) then self.repeatingDirty = true end
end

function ENT:isRepeating()
	return self.repeating
end

function ENT:setTime( fSeconds )
	self.time = fSeconds
	if (SERVER) then self.timeDirty = true end
end

function ENT:getTime()
	return self.time
end

function ENT:setTimeRemaining( fSeconds )
	self.timeRemaining = fSeconds
	if (SERVER) then self.timeRemainingDirty = true end
end

function ENT:getTimeRemaining()
	return self.timeRemaining
end

function ENT:getSource()
	return self.source
end

function ENT:getCaller()
	return self.caller
end

function ENT:onTriggered( source, caller )
	--ENT_BASE.trigger( self, source, caller) -- different method we use
	
	self.source = source
	self.caller = caller
	if (SERVER) then
		self.sourceDirty = true
		self.callerDirty = true
		self:setRunning(true) -- TODO trigger modes: toggle, pause, etc
		self:initTimer()
	end
end

if ( SERVER ) then
	include("sv_init.lua") -- Time to include server-only lua
elseif ( CLIENT ) then
	--include("cl_init.lua") -- Time to include client-only lua
end

if ( EDITOR ) then
	include("editor.lua")
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )
	
--	ents.persist(thisClass, "runOnInit", {
--		write=function(field, data, ent)
--			data:writeBool(field)
--			ent.runOnInitDirty = false
--		end,
--		read=function(data) return data:readNext() end,
--		dirty=function(field, ent) return ent.runOnInitDirty end,
--	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "running", {
		write=function(field, data, ent)
			data:writeBool(field)
			ent.runningDirty = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return ent.runningDirty end,
	}, ents.SNAP_NET + ents.SNAP_SAV)
	
	ents.persist(thisClass, "repeating", {
		write=function(field, data, ent)
			data:writeBool(field)
			ent.repeatingDirty = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return ent.repeatingDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "time", {
		write=function(field, data, ent)
			data:writeFloat(field)
			ent.timeDirty = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return ent.timeDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "timeRemaining", {
		write=function(field, data, ent)
			data:writeFloat(field)
			ent.timeRemainingDirty = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return ent.timeRemainingDirty end,
	}, ents.SNAP_NET + ents.SNAP_SAV)
	
	ents.persist(thisClass, "source", {
			write=function(field, data, ent)
				data:writeEntityID(field)
				ent.sourceDirty = false
			end,
			read=function(data, ent)
				local id = data:readNext()
				local source = ents.findByID(id)
				return source
			end,
			dirty=function(field, ent) return ent.sourceDirty end,
		}, ents.SNAP_NET + ents.SNAP_SAV)
		
	ents.persist(thisClass, "caller", {
			write=function(field, data, ent)
				data:writeEntityID(field)
				ent.callerDirty = false
			end,
			read=function(data, ent)
				local id = data:readNext()
				local caller = ents.findByID(id)
				return caller
			end,
			dirty=function(field, ent) return ent.callerDirty end,
		}, ents.SNAP_NET + ents.SNAP_SAV)
end