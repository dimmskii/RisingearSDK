--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


sndeffect = {}

local function processSoundEffectMessage(sender, data)
	if (SERVER) then return end
	
	local sound = audio.sound(data:readNext()) --local strFile = data:readNext()
	local x = data:readNext()
	local y = data:readNext()
	local distance = data:readNext()
	local volume = data:readNext()
	local pitch = data:readNext()
	
	sound:playAt(pitch,volume,x,y,0,distance)
end

local MSG_SOUND_EFFECT = net.registerMessage("sndeffect", processSoundEffectMessage)

local function sendSoundEffectMessage( strFile, x, y, fDistance, fVolume, fPitch )
	if (CLIENT) then return end
	
	local data = net.data()
	data:writeString(strFile)
	data:writeInt(x)
	data:writeInt(y)
	data:writeFloat(fDistance)
	data:writeFloat(fVolume)
	data:writeFloat(fPitch)
	
	net.sendMessage( MSG_SOUND_EFFECT, data )
end

if (SERVER) then
	sndeffect.emit = function( strFile, x, y, fDistance, fVolume, fPitch )
		fVolume = fVolume or 1
		fPitch = fPitch or 1
		sendSoundEffectMessage( strFile, x, y, fDistance, fVolume, fPitch )
	end
end
