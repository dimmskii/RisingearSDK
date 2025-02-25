--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_RECT
ENT.editor_resizable = true

--local MSG_EDITOR_BACKGROUND_CLTEXTURE = net.registerMessage( "MSG_EDITOR_BACKGROUND_CLTEXTURE", function(sender, data)
--	if ( SERVER ) then
--		local ent = ents.findByID( data:readNext() )
--		ent:editor_applyTexture( data:readNext() )
--	end
--end )
function ENT:editor_applyTexture( texPath )
	self.texture = texPath
	if (self.sprite) then
		self.sprite:setTexture(texPath)
	end
--	if (CLIENT) then
--		local data = net.data()
--		data:writeInt( self.id )
--		data:writeString(texPath)
--		net.sendMessage( MSG_EDITOR_BACKGROUND_CLTEXTURE, data )
--	end
end

function ENT:editor_fitTexture()
	self.textureWidth = self.width
	self.textureHeight = self.height
end

function ENT:editor_getOutlineShape()
	return self.outlineShape
end

if (CLIENT) then
	-- Declare future functions to get settings from GUI
	local getColor = nil
	local getSize = nil
	local getTexSize = nil
	local getDistance = nil
	local getOffset = nil
	local getConveyor = nil
	local getSeparation = nil
	local isTileX = nil
	local isTileY = nil
	local isMirroredH = nil
	local isMirroredV = nil
	local getBlendMode = nil
	local getLightMode = nil
	local getStencilTag = nil
	local isLit = nil
	
	function ENT:editor_populatePropertiesGUI( container )
		ENT_BASE.editor_populatePropertiesGUI( self, container )
		
		local colorCont = fgui.createContainer(container)
		local colorLabel = fgui.createLabel(colorCont, "Color") -- TODO: Stringadactyl
		local colorField = fgui.createColorBox(colorCont)
		colorField:setColor(self.color)
		
		getColor = function()
			local col = colorField:getColor() or color.WHITE
			return col
		end
		
		local sizeCont = fgui.createContainer(container)
		local sizeXLabel = fgui.createLabel(sizeCont, "Width/Height") -- TODO: Stringadactyl
		local sizeXField = fgui.createTextField(sizeCont)
		sizeXField:setText(tostring(self.width))
		local sizeYField = fgui.createTextField(sizeCont)
		sizeYField:setText(tostring(self.height))
		
		getSize = function()
			local vec = geom.vec2(tonumber(sizeXField:getText()) or 0, tonumber(sizeYField:getText()) or 0)
			return vec
		end
		
		local texSizeCont = fgui.createContainer(container)
		local texSizeXLabel = fgui.createLabel(texSizeCont, "Texture w/h") -- TODO: Stringadactyl
		local texSizeXField = fgui.createTextField(texSizeCont)
		texSizeXField:setText(tostring(self.textureWidth))
		local texSizeYField = fgui.createTextField(texSizeCont)
		texSizeYField:setText(tostring(self.textureHeight))
		
		getTexSize = function()
			local vec = geom.vec2(tonumber(texSizeXField:getText()) or 0, tonumber(texSizeYField:getText()) or 0)
			return vec
		end
		
		local distanceCont = fgui.createContainer(container)
		local distanceXLabel = fgui.createLabel(distanceCont, "Parallax dx,dy") -- TODO: Stringadactyl
		local distanceXField = fgui.createTextField(distanceCont)
		distanceXField:setText(tostring(self.distance.x))
		local distanceYField = fgui.createTextField(distanceCont)
		distanceYField:setText(tostring(self.distance.y))
		
		getDistance = function()
			local vec = geom.vec2(tonumber(distanceXField:getText()) or 0, tonumber(distanceYField:getText()) or 0)
			return vec
		end
		
		local offsetCont = fgui.createContainer(container)
		local offsetXLabel = fgui.createLabel(offsetCont, "Offset x,y") -- TODO: Stringadactyl
		local offsetXField = fgui.createTextField(offsetCont)
		offsetXField:setText(tostring(self.offset.x))
		local offsetYField = fgui.createTextField(offsetCont)
		offsetYField:setText(tostring(self.offset.y))
		
		getOffset = function()
			local vec = geom.vec2(tonumber(offsetXField:getText()) or 0, tonumber(offsetYField:getText()) or 0)
			return vec
		end
		
		local conveyorCont = fgui.createContainer(container)
		local conveyorXLabel = fgui.createLabel(conveyorCont, "Conveyor xv,yv") -- TODO: Stringadactyl
		local conveyorXField = fgui.createTextField(conveyorCont)
		conveyorXField:setText(tostring(self.conveyor.x))
		local conveyorYField = fgui.createTextField(conveyorCont)
		conveyorYField:setText(tostring(self.conveyor.y))
		
		getConveyor = function()
			local vec = geom.vec2(tonumber(conveyorXField:getText()) or 0, tonumber(conveyorYField:getText()) or 0)
			return vec
		end
		
		local separationCont = fgui.createContainer(container)
		local separationXLabel = fgui.createLabel(separationCont, "Separation x,y") -- TODO: Stringadactyl
		local separationXField = fgui.createTextField(separationCont)
		separationXField:setText(tostring(self.separation.x))
		local separationYField = fgui.createTextField(separationCont)
		separationYField:setText(tostring(self.separation.y))
		
		getSeparation = function()
			local vec = geom.vec2(tonumber(separationXField:getText()) or 0, tonumber(separationYField:getText()) or 0)
			return vec
		end
		
		local tileCont = fgui.createContainer(container)
		local tileLabel = fgui.createLabel(tileCont, "Tiling") -- TODO: Stringadactyl
		local tileXField = fgui.createCheckBox(tileCont)
		tileXField:setText("X")
		tileXField:setSelected(self.tileX)
		local tileYField = fgui.createCheckBox(tileCont)
		tileYField:setText("Y")
		tileYField:setSelected(self.tileY)
		
		isTileX = function()
			return tileXField:isSelected()
		end
		isTileY = function()
			return tileYField:isSelected()
		end
		
		local mirroredCont = fgui.createContainer(container)
		local mirroredLabel = fgui.createLabel(mirroredCont, "Mirrored") -- TODO: Stringadactyl
		local mirroredHField = fgui.createCheckBox(mirroredCont)
		mirroredHField:setText("H")
		mirroredHField:setSelected(self.mirroredH)
		local mirroredVField = fgui.createCheckBox(mirroredCont)
		mirroredVField:setText("V")
		mirroredVField:setSelected(self.mirroredV)
		
		isMirroredH = function()
			return mirroredHField:isSelected()
		end
		isMirroredV = function()
			return mirroredVField:isSelected()
		end

		local blendModes = {[renderables.BLEND_NONE]="BLEND_NONE",[renderables.BLEND_NORMAL]="BLEND_NORMAL",[renderables.BLEND_ADD]="BLEND_ADD",[renderables.BLEND_MULTIPLY]="BLEND_MULTIPLY",[renderables.BLEND_INVERT]="BLEND_INVERT",[renderables.BLEND_MATTE]="BLEND_MATTE"}		
		local blendModeCont = fgui.createContainer(container)
		local blendModeLabel = fgui.createLabel(blendModeCont, "Blend Mode") -- TODO: Stringadactyl
		local blendModeField = fgui.createComboBox(blendModeCont)

		for k,v in pairs(blendModes) do
			blendModeField:addItem(v)
		end
		
		blendModeField:setSelected( blendModes[self.blendMode] )
		
		getBlendMode = function()
			local blend = renderables[blendModeField:getSelectedValue()]
			return blend
		end
		
		local lightModes = {[renderables.LIGHT_NONE]="LIGHT_NONE",[renderables.LIGHT_EMIT]="LIGHT_EMIT",[renderables.LIGHT_OCCLUDE]="LIGHT_OCCLUDE"}		
		local lightModeCont = fgui.createContainer(container)
		local lightModeLabel = fgui.createLabel(lightModeCont, "Light Mode"); -- TODO: Stringadactyl
		local lightModeField = fgui.createComboBox(lightModeCont)

		for k,v in pairs(lightModes) do
			lightModeField:addItem(v)
		end
		
		lightModeField:setSelected( lightModes[self.lightMode] )
		
		getLightMode = function()
			local lightMode = renderables[lightModeField:getSelectedValue()]
			return lightMode
		end
		
		
		local litCont = fgui.createContainer( container )
		local litLabel = fgui.createLabel(litCont, "Lit"); -- TODO: Stringadactyl
		local litField = fgui.createCheckBox(litCont)
		litField:setSelected(self.lit)
		
		isLit = function()
			return litField:isSelected()
		end
		
		local stencilTagCont = fgui.createContainer( container )
		local stencilTagLabel = fgui.createLabel(stencilTagCont, "Stencil Ents Tag"); -- TODO: Stringadactyl
		local stencilTagField = fgui.createTextField(stencilTagCont)
		stencilTagField:setText(tostring(self.stencilEntsTag))
		
		getStencilTag = function()
			return stencilTagField:getText() or ""
		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		data:writeColor(getColor())
		local size = getSize()
		data:writeFloat( size.x )
		data:writeFloat( size.y )
		local texSize = getTexSize()
		data:writeFloat( texSize.x )
		data:writeFloat( texSize.y )
		local dist = getDistance()
		data:writeFloat( dist.x )
		data:writeFloat( dist.y )
		--data:writeString( EDITOR.getSelectedTexturePath() ) -- texture
		local offset = getOffset()
		data:writeFloat( offset.x )
		data:writeFloat( offset.y )
		local conveyor = getConveyor()
		data:writeFloat( conveyor.x )
		data:writeFloat( conveyor.y )
		local separation = getSeparation()
		data:writeFloat( separation.x )
		data:writeFloat( separation.y )
		data:writeBool( isTileX() )
		data:writeBool( isTileY() )
		data:writeBool( isMirroredH() )
		data:writeBool( isMirroredV() )
		data:writeShort( getBlendMode() )
		data:writeShort( getLightMode() )
		data:writeBool( isLit() )
		data:writeString( getStencilTag() )
	end
	
elseif (SERVER) then

	function ENT:editor_onPlaced(vec1, vec2)
		local x = math.min(vec1.x,vec2.x)
		local y = math.min(vec1.y,vec2.y)
		self:setPosition(x,y)
		local w = math.max(vec1.x,vec2.x) - x
		local h = math.max(vec1.y,vec2.y) - y
		if (w > 0) then
			self.width = w
		end
		if (h > 0) then
			self.height = h
		end
	end
	
	function ENT:editor_applySizeRectangle(rect)
		self:setWidth(rect:getWidth())
		self:setHeight(rect:getHeight())
		self:setPosition(rect:getX(),rect:getY())
	end
	
	EDITOR.actionAddCallback(function()
		for k,v in pairs(ents.getAll("background")) do
			v:setStencilEntsTag(v.stencilEntsTag)  -- Workaround for not showing until apply pressed in editor, etc
		end
	end)
	
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	self:setColor(data:readNext())
	self:setWidth(data:readNext())
	self:setHeight(data:readNext())
	self:setTextureWidth(data:readNext())
	self:setTextureHeight(data:readNext())
	self:setDistance(geom.vec2( data:readNext(), data:readNext()) )
	--self:setTexture(data:readNext())
	self:setOffset(geom.vec2( data:readNext(), data:readNext()) )
	self:setConveyor(geom.vec2( data:readNext(), data:readNext()) )
	self:setSeparation(geom.vec2( data:readNext(), data:readNext()) )
	self:setTileX(data:readNext())
	self:setTileY(data:readNext())
	self:setMirroredH(data:readNext())
	self:setMirroredV(data:readNext())
	self:setBlendMode(data:readNext())
	self:setLightMode(data:readNext())
	self:setLit(data:readNext())
	self:setStencilEntsTag(data:readNext())
end