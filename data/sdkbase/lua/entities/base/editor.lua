--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_NONE
ENT.editor_resizable = false
ENT.editor_polygonEditable = false

local _initProperty = ENT.initProperty

function ENT:initProperty( name, defaultValue ) -- TODO: What
	if EDITOR then
		if self.editor_properties == nil then
			self.editor_properties = {}	 -- TODO: Why
		end
		self.editor_properties[name] = defaultValue
	end
	_initProperty( self, name, defaultValue ) -- TODO: All for what...
end

function ENT:editor_createSprite()
end

function ENT:editor_setSprite( spr )
	self.editor_sprite = spr
end

function ENT:editor_getSprite()
	return self.editor_sprite
end

local function onEntityCreated( ent )
	local spr = ent:editor_createSprite()
	if spr then
		ent.editor_sprite = spr
		if CLIENT then
			local rend = ent:editor_createRenderable()
				if rend then
				rend:setLayer(renderables.LAYER_POST_GAME)
				ent.editor_renderable = rend
				renderables.add( rend )
			end
		end
	end
end
hook.add( "onEntityCreated", "editor_onEntityCreated", onEntityCreated )

local function onEntityDestroyed( ent )
	if CLIENT then
		local rend = ent.editor_renderable
		if rend then
			renderables.remove( rend )
		end
	end
end
hook.add( "onEntityDestroyed", "editor_onEntityDestroyed", onEntityDestroyed )

function ENT:editor_updateSprite( delta )
	local spr = self.editor_sprite
	if spr then
		spr.position.x = self.position.x
		spr.position.y = self.position.y
	end
end

hook.add( "doEntityThink", "editor_updateSprite", function( ent, delta ) ent:editor_updateSprite( delta ) end )

function ENT:editor_onMove(vecNewPos)
end

function ENT:editor_applyTexture(texPath)
end

function ENT:editor_fitTexture()
end

function ENT:editor_getTexture()
	if self.texture then
		return self.texture
	elseif self.renderable and self.renderable.sprite then
		return self.renderable.sprite:getTexture():getFileName()
	end
	return nil
end

function ENT:editor_getOutlineShape()
	return self.outlineShape
end

function ENT:editor_getSizeRectangle()
	local xy = geom.vec2(self.outlineShape:getMinX(), self.outlineShape:getMinY())
	local wh = geom.vec2(self.outlineShape:getMaxX(), self.outlineShape:getMaxY()):sub(xy)
	return geom.rectangle(xy.x,xy.y,wh.x,wh.y)
end

function ENT:editor_getPolygon()
	return nil
end

if CLIENT then
	-- Declare future functions to get settings from GUI
	local getTag = nil
	local getPosition = nil
	local getAngle = nil
	local getDepth = nil
	
	function ENT:editor_populatePropertiesGUI( container )
		local tagCont = fgui.createContainer( container )
		local tagLabel = fgui.createLabel(tagCont, "Tag"); -- TODO: Stringadactyl
		local tagField = fgui.createTextField(tagCont)
		tagField:setText(tostring(self.tag))
		
		getTag = function()
			return tagField:getText() or ""
		end
	
		local positionCont = fgui.createContainer( container )
		local positionLabel = fgui.createLabel(positionCont, "Position X,Y"); -- TODO: Stringadactyl
		local positionXField = fgui.createTextField(positionCont)
		positionXField:setText(tostring(self.position.x))
		local positionYField = fgui.createTextField(positionCont)
		positionYField:setText(tostring(self.position.y))
		
		getPosition = function()
			local pos = geom.vec2(tonumber(positionXField:getText()) or 0, tonumber(positionYField:getText()) or 0)
			return pos
		end
		
		local angleCont = fgui.createContainer( container )
		local angleLabel = fgui.createLabel(angleCont, "Angle"); -- TODO: Stringadactyl
		local angleField = fgui.createTextField(angleCont)
		angleField:setText(tostring(math.deg(self.angle)))
		
		getAngle = function()
			return math.rad(tonumber(angleField:getText()) or 0)
		end
		
		
		local depthCont = fgui.createContainer( container )
		local depthLabel = fgui.createLabel(depthCont, "Depth"); -- TODO: Stringadactyl
		local depthField = fgui.createTextField(depthCont)
		depthField:setText(tostring(self.depth))
		
		getDepth = function()
			return tonumber(depthField:getText()) or 0
		end
	end
	
	function ENT:editor_createRenderable()
		local spr = self:editor_getSprite()
		if spr then
			return renderables.fromSprite( spr )
		end
		return nil
	end
	
	function ENT:editor_updateRenderable( delta )
	end
	hook.add( "doEntityThink", "editor_updateRenderable", function( ent, delta ) ent:editor_updateRenderable( delta ) end )
	
	function ENT:editor_onClientJoin( )
	end
	local function onJoinGame(  )
		for k,v in pairs(ents.getAll()) do
			v:editor_onClientJoin()
		end
	end
	hook.add("onJoinGame", "editor_ent_onJoinGame", onJoinGame)
	
  function ENT:editor_hide()
   self._editor_hidden = true
   if (self.renderable) then
     self.renderable:setVisible(false)
   end
  end
  
  function ENT:editor_unhide()
   self._editor_hidden = false
   if (self.renderable) then
     self.renderable:setVisible(true)
   end
  end
  
  function ENT:editor_isHidden()
   return self._editor_hidden
  end
	
	function ENT:editor_sendProperties( data )
		data:writeString(getTag()) -- Tag
		data:writeVec2(getPosition()) -- Position
		data:writeFloat(getAngle()) -- Angle
		data:writeFloat(getDepth()) -- Depth
	end
	
elseif SERVER then

	function ENT:editor_onPlaced()
	end
	
	function ENT:editor_applySizeRectangle(rect)
	
	end
	
	function ENT:editor_applyPolygon(polygon)
	
	end
	
end

function ENT:editor_receiveProperties( data )
	self:setTag(data:readNext())
	local pos = data:readNext()
	self:setPosition(pos.x, pos.y)
	self:setAngle(data:readNext())
	self:setDepth(data:readNext())
end

