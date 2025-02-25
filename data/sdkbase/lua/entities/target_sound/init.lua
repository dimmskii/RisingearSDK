--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


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
	self.playingDirty = true
end

function ENT:isPlaying()
	return self.playing
end

function ENT:setLoop( bLooping )
	self.loop = bLooping
	if (SERVER) then self.loopDirty = true end
end

function ENT:isLoop()
	return self.loop
end

function ENT:setDistance( fDist )
	self.distance = fDist
	if (SERVER) then self.distanceDirty = true end
end

function ENT:getDistance()
	return self.distance
end

function ENT:setVolume( fVol )
	self.volume = fVol
	if (SERVER) then self.volumeDirty = true end
end

function ENT:getVolume()
	return self.volume
end

function ENT:setPitch( fPitch )
	self.pitch = fPitch
	if (SERVER) then self.pitchDirty = true end
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
			ent.playingDirty = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return ent.playingDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "loop", {
		write=function(field, data, ent)
			data:writeBool(field)
			ent.loopDirty = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return ent.loopDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "distance", {
		write=function(field, data, ent)
			data:writeFloat(field)
			ent.distanceDirty = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return ent.distanceDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "pitch", {
		write=function(field, data, ent)
			data:writeFloat(field)
			ent.pitchDirty = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return ent.pitchDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "volume", {
		write=function(field, data, ent)
			data:writeFloat(field)
			ent.volumeDirty = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return ent.volumeDirty end,
	}, ents.SNAP_ALL)
end