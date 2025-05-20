--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	
	self.platformConscious = true -- Physics props can fly up from underneath onto platforms
	
	self:initProperty("sprite", nil)
	self:initProperty("definitionIndex", 1)
	self.definition = props.getDefinitionByIndex(self.definitionIndex)
	self:initProperty("dimensions", geom.vec2(self.definition.width,self.definition.height))
	self:initProperty("destructible", false)
	self:initProperty("health", 80)
	
	-- phys_base overrides
  self:initProperty("materialID", self.definition.material)
	
	if self.sprite == nil then -- Important check to keep for sub-classes like phys_prop_custom which serialize/network the entire sprite.
		self.sprite = self:createSprite()
	end
	
	ENT_BASE.initialize( self )
	self.definition.onSpawn( self )
end

function ENT:createSprite()
	return props.createSprite(self.definition)
end

function ENT:setSprite( spr )
	self.sprite = spr
end

function ENT:setCollision( iCollision ) -- Shouldn't be used. Call works better in subclass phys_prop_custom
	self.definition.collision  = iCollision
end

function ENT:getCollision()
	if self.definition == nil then return props.COLLISION_SPRITE end
	return self.definition.collision
end

function ENT:setBodyType( bodyType )
	self.bodyType = bodyType
	if SERVER then self.bodyTypeDirty = true end
end

function ENT:getBodyType( )
	return self.bodyType
end

function ENT:setDestructible( bDestructible )
	self.destructible  = bDestructible
end

function ENT:isDestructible()
	return self.destructible
end

function ENT:setHealth( iHealth )
	self.health  = iHealth
end

function ENT:getHealth()
	return self.health
end

function ENT:getStaticOutlineShape()
  if type(self.definition.collision) == "userdata" then return self.definition.collision end -- In case the collision is a com.risingear.engine.geom.Shape (hopefully)
  
	if self:getCollision() == props.COLLISION_BOX then
		return self.sprite:getOutlineShape(false)
	elseif self:getCollision() == props.COLLISION_SPRITE then
		return self.sprite:getOutlineShape(true)
	elseif self:getCollision() == props.COLLISION_CIRCLE then
		return geom.circle(self.sprite:getWidth()/2,self.sprite:getHeight()/2,math.max(self.sprite:getWidth()/2,self.sprite:getHeight()/2)) -- TODO what
	elseif self:getCollision() == props.COLLISION_ELLIPSE then
		return geom.ellipse(self.sprite:getWidth()/2,self.sprite:getHeight()/2,self.sprite:getWidth()/2,self.sprite:getHeight()/2) -- TODO what optimize
	elseif self:getCollision() == props.COLLISION_ROUNDED_RECTANGLE then
		return geom.roundedRectangle(-self.sprite.origin.x,-self.sprite.origin.y,self.sprite:getWidth(),self.sprite:getHeight(),0.1) -- TODO what mayjeeck number
	end
	
	return self.sprite:getOutlineShape(false)
end

if SERVER then
	include "sv_init.lua"
elseif CLIENT then
	include "cl_init.lua"
end

if EDITOR then
	include "editor.lua"
end

local bodyTypes = { ["STATIC"] = phys.BT_STATIC, ["KINEMATIC"] = phys.BT_KINEMATIC, ["DYNAMIC"] = phys.BT_DYNAMIC }

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )
	
	ents.persist(thisClass, "bodyType", {
		write=function(field, data, ent)
			data:writeString(field)
			ent.bodyTypeDirty = false
		end,
		read=function(data)
			return bodyTypes [data:readNext()]
		end,
		dirty=function(field, ent) return ent.bodyTypeDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "dimensions", {
		write=function(field, data, ent) data:writeFloat(field.x) data:writeFloat(field.y) end,
		read=function(data) return geom.vec2(data:readNext(),data:readNext()) end,
		dirty=function(field, ent) return false end,
	})
	
	ents.persist(thisClass, "definitionIndex", {
		write=function(field, data, ent) data:writeInt(field) end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return false end,
	})
	
	ents.persist(thisClass, "destructible", {
		write=function(field, data, ent) data:writeBool(field) end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return false end,
	})
	
	ents.persist(thisClass, "health", {
		write=function(field, data, ent) data:writeInt(field) end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return false end,
	}, ents.SNAP_ALL)
end