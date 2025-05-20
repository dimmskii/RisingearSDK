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
	spr:addTexture("gui/editor/ent_glyphs/clock.png")
	spr.width = 0.25
	spr.height = 0.25
	spr:centerOrigin()
	return spr
end

if (CLIENT) then

	local isRepeating = nil
	local getTime = nil
	--local getTimeRemaining = nil
	
	function ENT:editor_populatePropertiesGUI( cont )
		ENT_BASE.editor_populatePropertiesGUI( self, cont )
		
		local repeatingCont = fgui.createContainer(cont)
		local repeatingLabel = fgui.createLabel(repeatingCont, "Repeating"); -- TODO: Stringadactyl
		local repeatingField = fgui.createCheckBox(repeatingCont)
		repeatingField:setSelected(self.repeating)
		
		isRepeating = function()
			return repeatingField:isSelected()
		end
		
		local timeCont = fgui.createContainer( cont )
		local timeLabel = fgui.createLabel(timeCont, "Time (sec)"); -- TODO: Stringadactyl
		local timeField = fgui.createTextField(timeCont)
		timeField:setText(tostring(self.time))
		
		getTime = function()
			return tonumber(timeField:getText()) or 1
		end
		
--		local timeRemainingCont = fgui.createContainer( cont )
--		local timeRemainingLabel = fgui.createLabel(timeRemainingCont, "Remaining (sec)"); -- TODO: Stringadactyl
--		local timeRemainingField = fgui.createTextField(timeRemainingCont)
--		timeRemainingField:setText(tostring(self.timeRemaining))
--		
--		getTimeRemaining = function()
--			return tonumber(timeRemainingField:getText()) or 1
--		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		
		data:writeBool( isRepeating() )
		data:writeFloat( getTime() )
		--data:writeFloat( getTimeRemaining() )
	end
	
	function ENT:editor_getOutlineShape()
		return self.outlineShape
	end
	
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	
	self:setRepeating(data:readNext())
	self:setTime(data:readNext())
	--self:setTimeRemaining(data:readNext())
end
