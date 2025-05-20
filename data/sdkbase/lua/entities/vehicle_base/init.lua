--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	
	self.platformConscious = true -- Physics props can fly up from underneath onto platforms
	
	self:initProperty("definitionIndex", 1)
	self.definition = props.getDefinitionByIndex(self.definitionIndex)
	self:initProperty("dimensions", geom.vec2(self.definition.width,self.definition.height))
	
	self.sprite = props.createSprite(self.definition)
	
	ENT_BASE.initialize( self )
	self.definition.onSpawn( self )
end

function ENT:getStaticOutlineShape()
	if (self.definition.collision == props.COLLISION_BOX) then
		return self.sprite:getOutlineShape(false)
	elseif (self.definition.collision == props.COLLISION_SPRITE) then
		return self.sprite:getOutlineShape(true)
	elseif (self.definition.collision == props.COLLISION_CIRCLE) then
		return geom.circle(self.sprite:getWidth()/2,self.sprite:getHeight()/2,math.max(self.sprite:getWidth()/2,self.sprite:getHeight()/2))
	end
	
	return self.sprite:getOutlineShape(false)
end

if ( SERVER ) then
	include("sv_init.lua")
elseif ( CLIENT ) then
	include("cl_init.lua")
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )
	
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
end