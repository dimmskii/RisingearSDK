--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT_META.CLASSNAME_BASE = "base"

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	ENT_BASE.initialize( self )
	
	self:initProperty("soundFile","env/wind_strong.wav")
	self:initProperty("playing",false)
	self:initProperty("loop",false)
	self:initProperty("distance",10)
	self:initProperty("pitch",1)
	self:initProperty("volume",0.75)
end

function ENT:setPlaying( bPlaying )
	self.playing = bPlaying
	self._dirty_playing = true
end

function ENT:isPlaying()
	return self.playing
end

function ENT:setLoop( bLooping )
	self.loop = bLooping
	if (SERVER) then self._dirty_loop = true end
end

function ENT:isLoop()
	return self.loop
end

function ENT:setDistance( fDist )
	self.distance = fDist
	if (SERVER) then self._dirty_distance = true end
end

function ENT:getDistance()
	return self.distance
end

function ENT:setVolume( fVol )
	self.volume = fVol
	if (SERVER) then self._dirty_volume = true end
end

function ENT:getVolume()
	return self.volume
end

function ENT:setPitch( fPitch )
	self.pitch = fPitch
	if (SERVER) then self._dirty_pitch = true end
end

function ENT:getPitch()
	return self.pitch
end

if ( SERVER ) then
	--include("sv_init.lua") -- Time to include server-only lua
elseif ( CLIENT ) then
	include("cl_init.lua") -- Time to include client-only lua
end

if ( EDITOR ) then
	include("editor.lua")
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )
	
	ents.persist(thisClass, "soundFile", {
		write=function(field, data) data:writeString(field) end,
		read=function(data) return data:readNext() end,
		dirty=function() return false end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "playing", {
		write=function(field, data, ent)
			data:writeBool(field)
			ent._dirty_playing = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(ent) return ent._dirty_playing end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "loop", {
		write=function(field, data, ent)
			data:writeBool(field)
			ent._dirty_loop = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(ent) return ent._dirty_loop end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "distance", {
		write=function(field, data, ent)
			data:writeFloat(field)
			ent._dirty_distance = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(ent) return ent._dirty_distance end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "pitch", {
		write=function(field, data, ent)
			data:writeFloat(field)
			ent._dirty_pitch = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(ent) return ent._dirty_pitch end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "volume", {
		write=function(field, data, ent)
			data:writeFloat(field)
			ent._dirty_volume = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(ent) return ent._dirty_volume end,
	}, ents.SNAP_ALL)
end