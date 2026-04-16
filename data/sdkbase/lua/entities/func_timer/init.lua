--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT_META.CLASSNAME_BASE = "trigger_base"

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
	if (SERVER) then self._dirty_running = true end
end

function ENT:isRunning()
	return self.running
end

function ENT:setRepeating( bRepeating )
	self.repeating = bRepeating
	if (SERVER) then self._dirty_repeating = true end
end

function ENT:isRepeating()
	return self.repeating
end

function ENT:setTime( fSeconds )
	self.time = fSeconds
	if (SERVER) then self._dirty_time = true end
end

function ENT:getTime()
	return self.time
end

function ENT:setTimeRemaining( fSeconds )
	self.timeRemaining = fSeconds
	if (SERVER) then self._dirty_timeRemaining = true end
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
		self._dirty_source = true
		self._dirty_caller = true
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
--			ent._dirty_runOnInit = false
--		end,
--		read=function(data) return data:readNext() end,
--		dirty=function(ent) return ent._dirty_runOnInit end,
--	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "running", {
		write=function(field, data, ent)
			data:writeBool(field)
			ent._dirty_running = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(ent) return ent._dirty_running end,
	}, ents.SNAP_NET + ents.SNAP_SAV)
	
	ents.persist(thisClass, "repeating", {
		write=function(field, data, ent)
			data:writeBool(field)
			ent._dirty_repeating = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(ent) return ent._dirty_repeating end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "time", {
		write=function(field, data, ent)
			data:writeFloat(field)
			ent._dirty_time = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(ent) return ent._dirty_time end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "timeRemaining", {
		write=function(field, data, ent)
			data:writeFloat(field)
			ent._dirty_timeRemaining = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(ent) return ent._dirty_timeRemaining end,
	}, ents.SNAP_NET + ents.SNAP_SAV)
	
	ents.persist(thisClass, "source", {
			write=function(field, data, ent)
				data:writeEntityID(field)
				ent._dirty_source = false
			end,
			read=function(data, ent)
				local id = data:readNext()
				local source = ents.findByID(id)
				return source
			end,
			dirty=function(ent) return ent._dirty_source end,
		}, ents.SNAP_NET + ents.SNAP_SAV)
		
	ents.persist(thisClass, "caller", {
			write=function(field, data, ent)
				data:writeEntityID(field)
				ent._dirty_caller = false
			end,
			read=function(data, ent)
				local id = data:readNext()
				local caller = ents.findByID(id)
				return caller
			end,
			dirty=function(ent) return ent._dirty_caller end,
		}, ents.SNAP_NET + ents.SNAP_SAV)
end