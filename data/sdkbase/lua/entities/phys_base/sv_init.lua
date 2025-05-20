--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:sv_initialize()
	ENT_BASE.sv_initialize(self)
	
	self:initProperty("platform", false)
	self:initProperty("platformConscious", false)
	
	self.fixtureListener = phys.createFixtureListener(self)
end

local body, physPos, physVel, physAngle, physAngleVel -- to save some timespace
function ENT:updateMotion( delta ) -- Override on server only to poll from Box2D. Client-side moves pos/ang according to received velocity data.
  body = self:getBody()
	if body == nil then return end
	if not body:isActive() then return end
	
	physPos = body:getPosition()
	if not physPos:equals(self.position) then
		self.positionDirty = true
		self.position = physPos:clone()
	end
	
	physVel = body:getLinearVelocity()
	if not physVel:equals(self.velocity) then
		self.velocityDirty = true
		self.velocity = physVel:clone()
	end
	
	physAngle = body:getAngle()
	if physAngle ~= self.angle then
		self.angleDirty = true
		self.angle = physAngle
	end
	
	physAngleVel = body:getAngularVelocity()
	if physAngleVel ~= self.angleVelocity then
		self.angleVelocityDirty = true
		self.angleVelocity = physAngleVel
	end
end

function ENT:subscribePhysListener(table)
	self.fixtureListener:subscribeOther( phys.createFixtureListener(table) )
end

function ENT:addAsListenerToFixture( fixture )
	fixture:addListener(self.fixtureListener)
end

local phys_util = include("physutil.lua")


local platformBody, selfBody, numPoints, worldManifold, normalAngle, pointVelPlatform, pointVelOther, relativeVel, relativePoint, platformFaceY
function ENT:beginContact(selfFixture, otherFixture, contact)
	if not self.platformConscious then return end
	if not phys_util.fixtureIsPlatform(otherFixture) then return end
	
	platformBody = otherFixture:getBody()
	selfBody = self:getBody()

	numPoints = contact:getManifold().pointCount
	worldManifold = phys.newWorldManifold()
	contact:getWorldManifold(worldManifold)
	normalAngle = worldManifold.normal:getTheta()
	
	-- First of all, disable contact and return if the normal angle is not within upward facing right angle V
	-- I did something like this with Box2D in Elemental Fury (Slayrtech Engine) once. Remove this freshly added code if falling thru platforms gets too bad
	if normalAngle < 225 or normalAngle > 315 then
		contact:setEnabled(false)
		return
	end
	
	-- check if contact points are moving into platform
	for i=0,numPoints-1 do
		pointVelPlatform = platformBody:getLinearVelocityFromWorldPoint( worldManifold:getPoint(i) )
		pointVelOther = selfBody:getLinearVelocityFromWorldPoint( worldManifold:getPoint(i) )
		relativeVel = platformBody:getLocalVector( pointVelOther:sub(pointVelPlatform) )
		
		if relativeVel.y > 1  then -- if moving down faster than 1 m/s, handle as before
			return -- point is moving into platform, leave contact solid and exit
		elseif relativeVel.y > -1 then -- if moving slower than 1 m/s
			-- borderline case, moving only slightly out of platform
			relativePoint = platformBody:getLocalPoint( worldManifold:getPoint(i) )
			platformFaceY = 0.5 -- front of platform, from fixture definition :(
			if relativePoint.y < platformFaceY + 0.05 then
				return -- contact point is less than 5cm inside front face of platfrom
			end
		else
			-- moving up faster than 1 m/s
		end
	end
	
	contact:setEnabled(false)
end

function ENT:endContact(selfFixture, otherFixture, contact)
	if not self.platformConscious then return end
	if not phys_util.fixtureIsPlatform(otherFixture) then return end
	contact:setEnabled(true)
end
