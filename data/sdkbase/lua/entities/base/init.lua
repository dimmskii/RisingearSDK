--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT.LAZY_UPDATE_DISTANCE = -1

function ENT:initialize()
	-- ----------------------------
	-- Shared base entity fields --
	-- ----------------------------
	
	-- Initialize shared properties
	self:initProperty("position", geom.vec2())
	self:initProperty("velocity", geom.vec2())
	self:initProperty("angle", 0)
	self:initProperty("angleVelocity", 0)
	self:initProperty("depth", 0)
	self:initProperty("tag", "")
	self:initProperty("usable", false)
	self:initProperty("radius", 1)

	self.outlineShape = self:getStaticOutlineShape()
	self:updateOutlineShape()
	
	if CLIENT then
		self:cl_initialize()
	else
		self:sv_initialize()
	end
end

function ENT:isInitialized()
	return self.initialized
end

function ENT:precacheGraphics ()
  
end

function ENT:precacheSound()

end

function ENT:getID()
	return self.id
end

function ENT:setTag(str)
	self.tag = tostring(str)
	self.tagDirty = true
end

function ENT:getTag()
	return self.tag
end

function ENT:isUsable()
	return self.usable
end

function ENT:onUse( entUser )
end

function ENT:setPosition( arg1, arg2 )
  if type(arg1) == "userdata" then
    self.position = arg1:clone()
  else
  	self.position.x = arg1
  	self.position.y = arg2
  end
	self.positionDirty = true
end

function ENT:getPosition( )
	return self.position:clone()
end

function ENT:setVelocity( arg1, arg2 )
	if type(arg1) == "userdata" then
    self.velocity = arg1:clone()
  else
    self.velocity.x = arg1
    self.velocity.y = arg2
  end
  self.velocityDirty = true
end

function ENT:getVelocity( )
	return self.velocity:clone()
end

function ENT:setAngle( a)
	self.angle = a
	self.angleDirty = true
end

function ENT:getAngle()
	return self.angle
end

function ENT:setAngleVelocity( av )
	self.angleVelocity = av
	self.angleVelocityDirty = true
end

function ENT:getAngleVelocity()
	return self.angleVelocity
end

function ENT:setDepth( depth )
	self.depth = depth
	self.depthDirty = true
end

function ENT:getDepth()
	return self.depth
end

function ENT:initProperty( name, defaultValue )
	if self[name] == nil then
		self[name] = defaultValue
	end
end

local MSG_ENT_TRIGGERED = net.registerMessage( "ent_triggered", function(sender, data)
	if CLIENT then
		local ent = ents.findByID( data:readNext() )
		local source = ents.findByID( data:readNext() )
		local caller = ents.findByID( data:readNext() )
		if ent then
			ent:onTriggered( source, caller )
		end
	end
end )
function ENT:trigger( source, caller )
	if SERVER then
		local data = net.data()
		data:writeInt( self.id )
		if source then
			data:writeInt( source.id )
		else
			data:writeInt( -1 )
		end
		if caller then
			data:writeInt( caller.id )
		else
			data:writeInt( -1 )
		end
		net.sendMessage( MSG_ENT_TRIGGERED, data )
	end
	
	self:onTriggered( source, caller )
end

function ENT:onTriggered( source, caller )

end

function ENT:use( source )
	self:trigger( source )
end

function ENT:getUseText()
	return "Use " .. self.CLASSNAME -- TODO stringadactyl
end

function ENT:think( delta )
	self:updateMotion( delta )
	if self.sprite then
		self:updateSprite( delta )
	end
	self:updateOutlineShape()
	if CLIENT then
		self:cl_think( delta )
	elseif SERVER then
		self:sv_think( delta )
	end
end

function ENT:updateSprite( delta )
	self.sprite.position.x = self.position.x
	self.sprite.position.y = self.position.y
	self.sprite.angle = self.angle
	self.sprite:update( delta )
end

function ENT:updateMotion( delta )
	self.position = self.position:add( self.velocity:mul(delta) )
	self.angle = self.angle + self.angleVelocity * delta
end

function ENT:destroy()

end

function ENT:getStaticOutlineShape()
	if self.sprite then
		return self.sprite:getOutlineShape(true)
	elseif EDITOR then
		local spr = self:editor_getSprite()
		if spr then
			return spr:getOutlineShape(false)
		end
	end
	return geom.circle(0,0,self.radius)
end

function ENT:updateOutlineShape()
	local shape = self:getStaticOutlineShape()
	shape = shape:transform(geom.translateTransform(self.position.x, self.position.y):concatenate(geom.rotateTransform(self.angle)))
	self.outlineShape = shape
end

function ENT:getOutlineShape()
	self:updateOutlineShape()
	return self.outlineShape
end

function ENT.persist( thisClass )
	ents.persist(thisClass, "position", {
			write=function(field, data, ent) data:writeFloat(field.x) data:writeFloat(field.y) ent.positionDirty=false end,
			read=function(data) return geom.vec2(data:readNext(),data:readNext()) end,
			dirty=function(field, ent) return ent.positionDirty end,
		}, ents.SNAP_ALL)
		
	ents.persist(thisClass, "velocity", {
			write=function(field, data, ent) data:writeFloat(field.x) data:writeFloat(field.y) ent.velocityDirty=false end,
			read=function(data) return geom.vec2(data:readNext(),data:readNext()) end,
			dirty=function(field, ent) return ent.velocityDirty end,
		}, ents.SNAP_NET + ents.SNAP_SAV)
		
	ents.persist(thisClass, "angle", {
			write=function(field, data, ent) data:writeFloat(field) ent.angleDirty=false end,
			read=function(data) return data:readNext() end,
			dirty=function(field, ent) return ent.angleDirty end,
		}, ents.SNAP_ALL)
		
	ents.persist(thisClass, "angleVelocity", {
			write=function(field, data, ent) data:writeFloat(field) ent.angleVelocityDirty=false end,
			read=function(data) return data:readNext() end,
			dirty=function(field, ent) return ent.angleVelocityDirty end,
		}, ents.SNAP_NET + ents.SNAP_SAV)
		
	ents.persist(thisClass, "depth", {
			write=function(field, data, ent) data:writeFloat(field) ent.depthDirty=false end,
			read=function(data) return data:readNext() end,
			dirty=function(field, ent) return ent.depthDirty end,
		}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "tag", {
			write=function(field, data, ent) data:writeString(field) ent.tagDirty=false end,
			read=function(data) return data:readNext() end,
			dirty=function(field, ent) return ent.tagDirty end,
		}, ents.SNAP_ALL)
	ents.persist(thisClass, "usable", {
			write=function(field, data, ent) data:writeBool(field) end,
			read=function(data) return data:readNext() end,
			dirty=function(field, ent) return false end,
		}, ents.SNAP_NET)
end

--------------
-- INCLUDES --
--------------

if SERVER then
	include("sv_init.lua") -- Time to include server-only lua
elseif CLIENT then
	include("cl_init.lua") -- Time to include client-only lua
end

if EDITOR then
	include("editor.lua")
end
