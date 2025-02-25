--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT

function ENT:editor_createSprite()
	local spr = sprites.create()
	spr:addTexture("gui/editor/ent_glyphs/sound.png")
	spr.width = 0.25
	spr.height = 0.25
	spr:centerOrigin()
	return spr
end

if CLIENT then
	-- Declare future functions to get settings from GUI
	local getSoundFile = nil
	local isPlaying = nil
	local isLooping = nil
	local getDistance = nil
	local getVolume = nil
	local getPitch = nil
	
	function ENT:editor_populatePropertiesGUI( cont )
		ENT_BASE.editor_populatePropertiesGUI( self, cont )
		
		local soundFileCont = fgui.createContainer( cont )
		local soundFileLabel = fgui.createLabel(soundFileCont, "Sound File"); -- TODO: Stringadactyl
		local soundFileField = fgui.createTextField(soundFileCont)
		soundFileField:setText(self.soundFile)
		
		getSoundFile = function()
			return soundFileField:getText()
		end
		
		local playingCont = fgui.createContainer(cont)
		local playingLabel = fgui.createLabel(playingCont, "Playing"); -- TODO: Stringadactyl
		local playingField = fgui.createCheckBox(playingCont)
		playingField:setSelected(self.playing)
		
		isPlaying = function()
			return playingField:isSelected()
		end
		
		local loopingCont = fgui.createContainer(cont)
		local loopingLabel = fgui.createLabel(loopingCont, "Looping"); -- TODO: Stringadactyl
		local loopingField = fgui.createCheckBox(loopingCont)
		loopingField:setSelected(self.loop)
		
		isLooping = function()
			return loopingField:isSelected()
		end
		
		local distanceCont = fgui.createContainer( cont )
		local distanceLabel = fgui.createLabel(distanceCont, "Distance"); -- TODO: Stringadactyl
		local distanceField = fgui.createTextField(distanceCont)
		distanceField:setText(tostring(self.distance))
		
		getDistance = function()
			return tonumber(distanceField:getText()) or 10
		end
		
		local volumeCont = fgui.createContainer( cont )
		local volumeLabel = fgui.createLabel(volumeCont, "Volume"); -- TODO: Stringadactyl
		local volumeField = fgui.createTextField(volumeCont)
		volumeField:setText(tostring(self.volume))
		
		getVolume = function()
			return tonumber(volumeField:getText()) or 1
		end
		
		local pitchCont = fgui.createContainer( cont )
		local pitchLabel = fgui.createLabel(pitchCont, "Pitch"); -- TODO: Stringadactyl
		local pitchField = fgui.createTextField(pitchCont)
		pitchField:setText(tostring(self.pitch))
		
		getPitch = function()
			return tonumber(pitchField:getText()) or 1
		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		data:writeString( getSoundFile() )
		data:writeBool( isPlaying() )
		data:writeBool( isLooping() )
		data:writeFloat( getDistance() )
		data:writeFloat( getVolume() )
		data:writeFloat( getPitch() )
	end
	
	function ENT:editor_getOutlineShape()
		return self.outlineShape
	end
	
	
	function ENT:cl_doSoundLogic() -- Override to not play in editor
  end
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	self.soundFile = data:readNext()
	self:setPlaying(data:readNext())
	self:setLoop(data:readNext())
	self:setDistance(data:readNext())
	self:setVolume(data:readNext())
	self:setPitch(data:readNext())
end
