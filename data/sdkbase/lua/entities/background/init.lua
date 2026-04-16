--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT_META.CLASSNAME_BASE = "base"

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()

	self:initProperty("texture", "")
	
	self:initProperty("color", color.WHITE)

	self:initProperty("distance", geom.vec2())
	
	self:initProperty("width", 1)
	self:initProperty("height", 1)
	
	self:initProperty("textureWidth", self.width)
	self:initProperty("textureHeight", self.height)
	
	self:initProperty("tileX", false)
	self:initProperty("tileY", false)
	
	self:initProperty("mirroredH", false)
	self:initProperty("mirroredV", false)
	
	self:initProperty("offset", geom.vec2())
	
	self:initProperty("conveyor", geom.vec2())
	
	self:initProperty("separation", geom.vec2())
	
	self:initProperty("blendMode", 0)
	
	self:initProperty("lightMode", 0)
	
	self:initProperty("lit", true)
	
	self:initProperty("stencilEntsTag", "")
	
	self.sprite = sprites.create()
	self.sprite.width = self.textureWidth
	self.sprite.height = self.textureHeight
	self.sprite:setPlaying(false)
	self.sprite:addTexture( self.texture )
	self.sprite.color = self.color
	
	ENT_BASE.initialize( self )
	
end

function ENT:setStencilEntsTag( strTag )
	self.stencilEntsTag = strTag
	if SERVER then self._dirty_stencilEntsTag = true end
	if CLIENT and self.initialized then self:updateStencilEnts() end
end

function ENT:getStaticOutlineShape()
	return geom.rectangle(0, 0, self.width, self.height)
end

function ENT:getTexture()
	return self.texture
end

function ENT:setTexture(texture)
	self.texture = texture
	self._dirty_texture = true
end

function ENT:getDistance()
	return self.distance
end
function ENT:setDistance(distance)
	self.distance = distance
	self._dirty_distance = true
end

function ENT:getWidth()
	return self.width
end
function ENT:setWidth(width)
	self.width = width
	self._dirty_width = true
end

function ENT:getHeight(height)
	return self.height
end
function ENT:setHeight(height)
	self.height = height
	self._dirty_height = true
end

function ENT:getTextureWidth()
	return self.textureWidth
end
function ENT:setTextureWidth(textureWidth)
	self.textureWidth = textureWidth
	self._dirty_textureWidth = true
end

function ENT:getTextureHeight()
	return self.textureHeight
end
function ENT:setTextureHeight(textureHeight)
	self.textureHeight = textureHeight
	self._dirty_textureHeight = true
end

function ENT:isTileX()
	return self.tileX
end
function ENT:setTileX(tileX)
	self.tileX = tileX
	self._dirty_tileX = true
end

function ENT:isTileY()
	return self.tileY
end
function ENT:setTileY(tileY)
	self.tileY = tileY
	self._dirty_tileY = true
end

function ENT:isMirroredH()
	return self.mirroredH
end
function ENT:setMirroredH(bMirroredH)
	self.mirroredH = bMirroredH
	self._dirty_mirroredH = true
end

function ENT:isMirroredV()
	return self.mirroredV
end
function ENT:setMirroredV(bMirroredV)
	self.mirroredV = bMirroredV
	self._dirty_mirroredV = true
end

function ENT:getOffset()
	return self.offset
end
function ENT:setOffset(offset)
	self.offset = offset
	self._dirty_offset = true
end

function ENT:getConveyor()
	return self.conveyor
end
function ENT:setConveyor(conveyor)
	self.conveyor = conveyor
	if SERVER then self._dirty_conveyor = true end
end

function ENT:getSeparation()
	return self.separation
end
function ENT:setSeparation(separation)
	self.separation = separation
	if SERVER then self._dirty_separation = true end
end

function ENT:getColor()
	return self.color
end
function ENT:setColor(color)
	self.color = color
	if SERVER then self._dirty_color = true end
end

function ENT:getBlendMode()
	return self.blendMode
end

function ENT:setBlendMode( blend )
	self.blendMode = blend
	if SERVER then
		self._dirty_blendMode = true
	elseif CLIENT and self.renderable then
		self.renderable:setBlendMode(blend)
	end
end

function ENT:getLightMode()
	return self.lightMode
end

function ENT:setLightMode( lightMode )
	self.lightMode = lightMode
	if SERVER then
		self._dirty_lightMode = true
	elseif CLIENT and self.renderable then
		self.renderable:setLightMode(lightMode)
	end
end

function ENT:isLit()
	return self.lit
end

function ENT:setLit( bLit )
	self.lit = bLit
	if SERVER then
		self._dirty_lit = true
	elseif CLIENT and self.renderable then
		self.renderable:setLit( bLit )
	end
end

function ENT:getTranslatedPos()
	local vecPos = self.position:clone()
	if CLIENT then
		local camera = camera.getCurrent()
		if camera ~= nil then
		     -- THis is the true code which allows writing depth as a positive distance in meters. We use a make-belief angle of 1/2 screen size = camz
		     -- But we'd also need to scale widths/heights re-writing this in its general transformation form.
--		  local p = (camera:getWidth() + camera:getHeight()) / 4 -- camz = 1/2avg(camw,camh)
--		  local z = self.distance.x
--		  vecPos.x = self.position.x + (camera:getX() - self.position.x) * (z/(p+z))
--		  vecPos.y = self.position.y + (camera:getY() - self.position.y) * (z/(p+z))
		  
		  self.distance.x = math.max(math.min(self.distance.x,1), 0) -- clamp x dist between 0,1
		  self.distance.y = math.max(math.min(self.distance.y,1), 0) -- clamp y dist between 0,1
			vecPos.x = self.position.x + (camera:getX() - self.position.x) * self.distance.x
			vecPos.y = self.position.y + (camera:getY() - self.position.y) * self.distance.y
		end
	end
	return vecPos
end

function ENT:updateOutlineShape()
	local drawPos = self:getTranslatedPos()
	local shape = self:getStaticOutlineShape()
	shape = shape:transform(geom.translateTransform(drawPos.x, drawPos.y):concatenate(geom.rotateTransform(self.angle)))
	self.outlineShape = shape
end

local function wrap(num,min,max) -- TODO: Test this. It was ported quickly from java code in math lib because let's face it: this isn't a 'real math function'
	local len
	
	if min > max then
		len = min
		min = max
		max = len
	end
	
	len = max - min
	
	if num - min >= len then
		num = ((num - min) % len) + min; 
	elseif num - min < 0 then
		num = len - ((-num - min) % len) + min
	end
	
	return num;
end

function ENT:updateSprite( delta )
	self.offset.x = wrap(self.offset.x + (self.conveyor.x * delta), 0, self.width)
	self.offset.y = wrap(self.offset.y + (self.conveyor.y * delta), 0, self.height)
	local drawPos = self:getTranslatedPos()
	
	if CLIENT then
		local camera = camera.getCurrent()
		if camera == nil then return end
		local noX = 0
		local noY = 0
		
		if self.tileX then
			noX = camera:getResultantWidth() / self.sprite:getWidth() + 3
			drawPos.x = drawPos.x + (self.sprite:getWidth() * (math.floor((camera:getTopLeft().x - drawPos.x) / self.sprite:getWidth()) - 1))
			self.sprite.repeatingH = true
		else
			noX = self.width / self.sprite:getWidth()
			self.sprite.repeatingH = false
		end

		if self.tileY then
			noY = math.floor(camera:getResultantHeight() / self.sprite:getHeight()) + 3
			drawPos.y = drawPos.y + (self.sprite:getHeight() * (math.floor((camera:getTopLeft().y - drawPos.y) / self.sprite:getHeight() ) - 1))
			self.sprite.repeatingV = true
		else
			noY = self.height / self.sprite:getHeight()
			self.sprite.repeatingV = false
		end

		self.sprite.tileNumX = noX
		self.sprite.tileNumY = noY
	end
	
	self.sprite.mirroredH = self.mirroredH
	self.sprite.mirroredV = self.mirroredV
	
	self.sprite.position.x = drawPos.x
	self.sprite.position.y = drawPos.y
	
	self.sprite.offset.x = self.offset.x
	self.sprite.offset.y = self.offset.y
	
	if self.textureWidth ~= self.width  then
		self.sprite.repeatingH = true
	end
	if self.textureHeight ~= self.height then
		self.sprite.repeatingV = true
	end
	
	self.sprite.color = self.color:clone()
end

if SERVER then
	include("sv_init.lua")
elseif CLIENT then
	include("cl_init.lua")
end

if EDITOR then
	include("editor.lua")
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )
	
	ents.persist(thisClass, "texture", {
			write=function(field, data, ent) data:writeString(field) ent._dirty_texture=false end,
			read=function(data) return data:readNext() end,
			dirty=ents.DIRTY_CHECK,
		})
	
	ents.persist(thisClass, "color", {
			write=function(field, data, ent) data:writeFloat(field:getRed()) data:writeFloat(field:getGreen()) data:writeFloat(field:getBlue()) data:writeFloat(field:getAlpha()) ent._dirty_color=false end,
			read=function(data) return color.fromRGBAf(data:readNext(),data:readNext(),data:readNext(),data:readNext()) end,
			dirty=ents.DIRTY_CHECK,
		})
	
	ents.persist(thisClass, "distance", {
			write=function(field, data, ent) data:writeFloat(field.x) data:writeFloat(field.y) ent._dirty_distance=false end,
			read=function(data) return geom.vec2(data:readNext(),data:readNext()) end,
			dirty=ents.DIRTY_CHECK,
		})
	
	ents.persist(thisClass, "width", {
			write=function(field, data, ent) data:writeFloat(field) ent._dirty_width=false end,
			read=function(data) return data:readNext() end,
			dirty=ents.DIRTY_CHECK,
		})
	ents.persist(thisClass, "height", {
			write=function(field, data, ent) data:writeFloat(field) ent._dirty_height=false end,
			read=function(data) return data:readNext() end,
			dirty=ents.DIRTY_CHECK,
		})
	
	ents.persist(thisClass, "textureWidth", {
			write=function(field, data, ent) data:writeFloat(field) ent._dirty_textureWidth=false end,
			read=function(data,ent)
				local texWidth = data:readNext()
				if (ent.sprite) then ent.sprite.width = texWidth end
				return texWidth
			end,
			dirty=ents.DIRTY_CHECK,
		})
	ents.persist(thisClass, "textureHeight", {
			write=function(field, data, ent) data:writeFloat(field) ent._dirty_textureHeight=false end,
			read=function(data,ent)
				local texHeight = data:readNext()
				if (ent.sprite) then ent.sprite.height = texHeight end
				return texHeight
			end,
			dirty=ents.DIRTY_CHECK,
		})
	
	ents.persist(thisClass, "tileX", {
			write=function(field, data, ent) data:writeBool(field) ent._dirty_tileX=false end,
			read=function(data) return data:readNext() end,
			dirty=ents.DIRTY_CHECK,
		})
	ents.persist(thisClass, "tileY", {
			write=function(field, data, ent) data:writeBool(field) ent._dirty_tileY=false end,
			read=function(data) return data:readNext() end,
			dirty=ents.DIRTY_CHECK,
		})
	
	ents.persist(thisClass, "mirroredH", {
			write=function(field, data, ent) data:writeBool(field) ent._dirty_mirroredH=false end,
			read=function(data) return data:readNext() end,
			dirty=ents.DIRTY_CHECK,
		})
	ents.persist(thisClass, "mirroredV", {
			write=function(field, data, ent) data:writeBool(field) ent._dirty_mirroredV=false end,
			read=function(data) return data:readNext() end,
			dirty=ents.DIRTY_CHECK,
		})
	
	ents.persist(thisClass, "offset", {
			write=function(field, data, ent) data:writeFloat(field.x) data:writeFloat(field.y) ent._dirty_offset=false end,
			read=function(data) return geom.vec2(data:readNext(),data:readNext()) end,
			dirty=ents.DIRTY_CHECK,
		})
	
	ents.persist(thisClass, "conveyor", {
			write=function(field, data, ent) data:writeFloat(field.x) data:writeFloat(field.y) ent._dirty_conveyor=false end,
			read=function(data) return geom.vec2(data:readNext(),data:readNext()) end,
			dirty=ents.DIRTY_CHECK,
		})
		
	ents.persist(thisClass, "separation", {
			write=function(field, data, ent) data:writeFloat(field.x) data:writeFloat(field.y) ent._dirty_separation=false end,
			read=function(data) return geom.vec2(data:readNext(),data:readNext()) end,
			dirty=ents.DIRTY_CHECK,
		})
		
	ents.persist(thisClass, "blendMode", {
			write=function(field, data, ent) data:writeInt(field) ent._dirty_blendMode=false end,
			read=function(data) return data:readNext() end,
			dirty=ents.DIRTY_CHECK,
		})
		
	ents.persist(thisClass, "lightMode", {
			write=function(field, data, ent) data:writeInt(field) ent._dirty_lightMode=false end,
			read=function(data) return data:readNext() end,
			dirty=ents.DIRTY_CHECK,
		})
			
	ents.persist(thisClass, "lit", {
			write=function(field, data, ent) data:writeBool(field) ent._dirty_lit=false end,
			read=function(data) return data:readNext() end,
			dirty=ents.DIRTY_CHECK,
		})
		
	ents.persist(thisClass, "stencilEntsTag", {
			write=function(field, data, ent)
				data:writeString(field)
				ent._dirty_stencilEntsTag = false
			end,
			read=function(data, ent)
				local tag = data:readNext()
				if (ent.initialized) then
					ent:updateStencilEnts(tag)
				end
				return tag
			end,
			dirty=ents.DIRTY_CHECK,
		})
end
