--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT

if CLIENT then
	-- Declare future functions to get settings from GUI
	local getSize = nil
	local isSizeWidth = nil
	
	function ENT:editor_populatePropertiesGUI( container )
		ENT_BASE.editor_populatePropertiesGUI( self, container )
		
		local sizeCont = fgui.createContainer(container)
		local sizeLabel = fgui.createLabel(sizeCont, "Size"); -- TODO: Stringadactyl
		local sizeField = fgui.createTextField(sizeCont)
		sizeField:setText( tostring(self.size) )
		
		getSize = function()
			return tonumber(sizeField:getText())
		end
		
		
		--TODO make field below radio button just to make it clearer
		local sizeWidthCont = fgui.createContainer(container)
		local sizeWidthLabel = fgui.createLabel(sizeWidthCont, "Size"); -- TODO: Stringadactyl
		local sizeWidthGroup = fgui.newToggableGroup()
		local sizeWidthFieldW = fgui.createRadioButton(sizeWidthGroup,sizeWidthCont,"is width") -- TODO: Stringadactyl
		local sizeWidthFieldH = fgui.createRadioButton(sizeWidthGroup,sizeWidthCont,"is height") -- TODO: Stringadactyl
		
		if (self.bSizeWidth) then
			sizeWidthFieldW:setSelected( true )
		else
			sizeWidthFieldH:setSelected( true )
		end
		
		isSizeWidth = function()
			return sizeWidthGroup:isSelected(sizeWidthFieldW)
		end
		
--		function ENT:editor_applySizeRectangle(rect)
--			if self.isSizeWidth then
--				self.width = rect:getWidth()
--			else
--				self.height = rect:getHeight()
--			end
--			
--			self:setPosition(rect:getX(),rect:getY())
--		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		data:writeString( getSize() )
		data:writeBool( isSizeWidth() )
	end
	
	function ENT:editor_getOutlineShape()
		return self.outlineShape
	end
	
	function ENT:editor_getPolygon()
		return self.outlineShape
	end
	
end

function ENT:editor_createSprite()
	local spr = sprites.create()
	spr:addTexture("gui/editor/ent_glyphs/camera.png")
	spr.width = 0.5
	spr.height = 0.5
	spr:centerOrigin()
	return spr
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	self:setSize(data:readNext())
	self:setSizeWidth(data:readNext())
end
