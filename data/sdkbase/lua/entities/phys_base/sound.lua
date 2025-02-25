--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


phys_sounds = {}

local PITCH_VARIATION = 1/4
local SUBDIRECTORY = "physics/"

local SND_IMPACT_LOW = 0
phys_sounds.SND_IMPACT_LOW = SND_IMPACT_LOW
local SND_IMPACT_MED = 1
phys_sounds.SND_IMPACT_MED = SND_IMPACT_MED
local SND_IMPACT_HIGH = 2
phys_sounds.SND_IMPACT_HIGH = SND_IMPACT_HIGH
local SND_BREAK = 3
phys_sounds.SND_BREAK = SND_BREAK
--local GRP_FRICTION = 4
--phys_sounds

local PHYS_SOUND_DIST = 15

local function getSound(strGroup, iType)
	if (iType == SND_IMPACT_LOW) then
		return audio.sound(SUBDIRECTORY .. strGroup .. "/impactl.wav")
	elseif (iType == SND_IMPACT_MED) then
		return audio.sound(SUBDIRECTORY .. strGroup .. "/impactm.wav")
	elseif (iType == SND_IMPACT_HIGH) then
		return audio.sound(SUBDIRECTORY .. strGroup .. "/impacth.wav")
	elseif (iType == SND_BREAK) then
		return audio.sound(SUBDIRECTORY .. strGroup .. "/break.wav")
--	elseif (iType == FRICTION) then
--		return audio.sound(SUBDIRECTORY .. strGroup .. "/friction.wav")
	end
end

local function processPhysicsSoundMessage(sender, data)
	if (SERVER) then return end
	
	local ent = ents.findByID(data:readNext())
	if not ent then return end
	
	local x = data:readNext()
	local y = data:readNext()
	local sound = getSound(data:readNext(), data:readNext())
	local volume = data:readNext()
	local pitch = data:readNext()
	local distance = data:readNext()
	
	sound:playAt(pitch,volume,x,y,0,distance)
end

local MSG_PHYS_SOUND = net.registerMessage("phys_sound", processPhysicsSoundMessage)

local function sendPhyicsSoundMessage( ent, x, y, group, type, volume, pitch, distance )
	if (CLIENT) then return end
	local data = net.data()
	data:writeEntityID(ent)
	data:writeInt(x)
	data:writeInt(y)
	data:writeString(group)
	data:writeShort(type)
	data:writeFloat(volume)
	data:writeFloat(pitch)
	data:writeFloat(distance)
	net.sendMessage( MSG_PHYS_SOUND, data )
end

if (SERVER) then
	-- Generate the server-sided function for contacts
	phys_sounds.doContactSound = function( self, other, contact )
		local ent = self:getBody():getUserData()
		local pos = self:getBody():getPosition()
		local vel = self:getBody():getLinearVelocity():add(other:getBody():getLinearVelocity()):length()
		local volume = vel / 6
		local pitch = 1.0 + ((math.random()-0.5)*PITCH_VARIATION) -- self:getBody():getMass() / self:getBody():getMass() -- 1.0 + ((math.random()-0.5) / 6.0)
		if (vel < 1.5) then return end
		vel = vel - 1.5
		local snd = SND_IMPACT_LOW
		if (vel > 4) then snd = SND_IMPACT_MED vel = vel - 4 end
		if (vel > 8) then snd = SND_IMPACT_HIGH vel = vel - 8 end
		local group = ent.material.soundGroup
		sendPhyicsSoundMessage( ent, pos.x, pos.y, group, snd, volume, pitch, PHYS_SOUND_DIST )
	end
	
	phys_sounds.doSound = function( physEnt, snd, volume, pitch )
	  volume = volume or 1
	  pitch = 1.0 + ((math.random()-0.5)*PITCH_VARIATION)
	  local pos = physEnt:getPosition()
    local group = physEnt.material.soundGroup
    sendPhyicsSoundMessage( physEnt, pos.x, pos.y, group, snd, volume, pitch, PHYS_SOUND_DIST )
  end
end
