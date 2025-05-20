--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.editor_polygonEditable = true

function ENT:editor_createSprite()
	local spr = sprites.create()
	spr:addTexture("gui/editor/ent_glyphs/world.png")
	spr.width = 0.25
	spr.height = 0.25
	spr:centerOrigin()
	return spr
end

if CLIENT then
	-- Declare future functions to get settings from GUI
	local getAmbientLightColor = nil
	local getMusic = nil
	local getMusicStart = nil
	local getMusicLoop = nil
	
	function ENT:editor_populatePropertiesGUI( container )
		ENT_BASE.editor_populatePropertiesGUI( self, container )
		
		local colorCont = fgui.createContainer(container)
		local colorLabel = fgui.createLabel(colorCont, "Ambient Light"); -- TODO: Stringadactyl
		local colorField = fgui.createColorBox(colorCont)
		colorField:setColor(self.ambientLightColor)
		
		getAmbientLightColor = function()
			local col = colorField:getColor() or color.WHITE
			return col
		end
		
		local musicCont = fgui.createContainer(container)
		local musicLabel = fgui.createLabel(musicCont, "Music"); -- TODO: Stringadactyl
		local musicField = fgui.createComboBox(musicCont)
		local musicNames = file.list("music", true, false, true, file.SORT_METHOD_PATH)
		musicField:addItem("")
		for _,v in ipairs(musicNames) do
			musicField:addItem(v:getPath():getRelativeTo(file.path("music")):getFileName())
		end
		
		musicField:setSelected( self.music )
		
		getMusic = function()
			return musicField:getSelectedValue()
		end
		
		local musicStartCont = fgui.createContainer(container)
		local musicStartLabel = fgui.createLabel(musicStartCont, "Music Start"); -- TODO: Stringadactyl
		local musicStartField = fgui.createCheckBox(musicStartCont)
		musicStartField:setSelected( self.musicStart )
		
		getMusicStart = function()
			return musicStartField:isSelected()
		end
		
		local musicLoopCont = fgui.createContainer(container)
		local musicLoopLabel = fgui.createLabel(musicLoopCont, "Music Loops"); -- TODO: Stringadactyl
		local musicLoopField = fgui.createCheckBox(musicLoopCont)
		musicLoopField:setSelected( self.musicLoop )
		
		getMusicLoop = function()
			return musicLoopField:isSelected()
		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		self.ambientLightColor = getAmbientLightColor()
		data:writeColor( self.ambientLightColor )
		self.music = getMusic()
		data:writeString( self.music )
		self.musicStart = getMusicStart()
		data:writeBool( self.musicStart )
		self.musicLoop = getMusicLoop
		data:writeBool( self.musicLoop )
	end
	
elseif SERVER then
	function ENT:editor_applyPolygon( polygon )
		return --avoid getting moved on resize hack
	end
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	self:setAmbientLightColor(data:readNext())
	self.music = data:readNext()
	self.musicStart = data:readNext()
	self.musicLoop = data:readNext()
end
