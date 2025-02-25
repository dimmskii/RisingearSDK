--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

include("sound.lua")
if ( SERVER ) then
	include("sv_init.lua")
elseif ( CLIENT ) then
	include("cl_init.lua")
end

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	self:initProperty("materialID", "wood")
	self:initProperty("material", materials.get(self.materialID))
	self:initProperty("bodyType", phys.BT_DYNAMIC)
	
	self.bodies = {}
	self.joints = {}
	self.world = {}
	self.fixtures = {}
	
	ENT_BASE.initialize( self )
end

local _temp_vec2
function ENT:setPosition( arg1, arg2 )
  if type(arg1) == "userdata" then
    _temp_vec2 = arg1:clone()
  else
    _temp_vec2 = geom.vec2(arg1,arg2)
  end
  
	if self:getBody() then
		self:getBody():setTransform(_temp_vec2, self:getBody():getAngle())
	end
	self.position = _temp_vec2
	_temp_vec2 = nil
	if SERVER then self.positionDirty = true end
end

function ENT:setVelocity( arg1, arg2 )
  if type(arg1) == "userdata" then
    _temp_vec2 = arg1:clone()
  else
    _temp_vec2 = geom.vec2(arg1,arg2)
  end
  
	if self:getBody() then
		self:getBody():setLinearVelocity(_temp_vec2)
	end
	self.velocity = _temp_vec2
	_temp_vec2 = nil
	if SERVER then self.velocityDirty = true end
end

function ENT:setAngle( a )
	if self:getBody() then
		self:getBody():setTransform(self:getBody():getPosition(), a)
	end
	self.angle = a
	if SERVER then self.angleDirty = true end
end

function ENT:setAngleVelocity( av )
	if self:getBody() then
		self:getBody():setAngularVelocity(av)
	end
	self.angleVel = av
	if SERVER then self.angleVelocityDirty = true end
end

function ENT:getBody()
	if self.bodies == nil then return nil end
	return self.bodies[1]
end

function ENT:getJoint()
  if self.joints == nil then return nil end
  return self.joints[1]
end

function ENT:createBody()
	self.bodies[1] = phys.createBody(self.bodyType)
	self.bodies[1]:setUserData(self)
	self:setPosition(self.position.x, self.position.y)
	self:setAngle(self.angle)
end

function ENT:destroy()
	-- Destroy joints
	for _,v in pairs(self.joints) do
		phys.destroyJoint(v)
	end
	
	-- Destroy bodies
	for _,v in pairs(self.bodies) do
		
		phys.destroyBody(v)
	end
end

function ENT:clearPhysListeners()
	self.physListeners = {}
end

function ENT:setMaterialID(strMaterialID)
	local material = materials.get(self.materialID)
	if material then
		self.materialID = strMaterialID
		self.material = material
	end
	--if SERVER then self.materialIDDirty = true end
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )
		
	ents.persist(thisClass, "materialID", {
		write=function(field, data) data:writeString(field) end,
		read=function(data) return data:readNext() end,
		dirty=function() return false end,
	}, ents.SNAP_ALL)
	
end

if ( EDITOR ) then
	include("editor.lua")
end