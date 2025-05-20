--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

include("features.lua")
include("clothes.lua")

function ENT:initialize()
	ENT_BASE.initialize(self)
	self:initProperty("female", false)
	self:initHumanFeatures()	-- Initialize human feature system
	self:initHumanClothes()		-- Initialize human clothes system
end

function ENT:initSkeletal()
	if (self.female) then
		self.skeleton = skeleton_factory.create("female")
	else
		self.skeleton = skeleton_factory.create("male")
	end
	
	self.skeleton:setAnimation(skeleton_anims.get("biped_stand"))
end

local weaponLimb, point
function ENT:getMuzzlePos()
	if (self.weapon) then
		weaponLimb = self.skeleton:getLimb("weapon")
		if (weaponLimb) then
			point = weaponLimb:getTransformed(geom.point(self.weapon.muzzlePos.x,self.weapon.muzzlePos.y))
			return geom.vec2(point:getX(),point:getY())
		end
	end
	return geom.vec2(self.position.x, self.position.y)
end

function ENT:getEyePos()
	if ( self.skeleton ) then
		return self.skeleton:getLimb("head"):getPosition()
	end
	return self.position.clone()
end

local biped_crouch = skeleton_anims.get("biped_crouch")
local biped_run = skeleton_anims.get("biped_run")
local biped_walk = skeleton_anims.get("biped_walk")
local biped_stand = skeleton_anims.get("biped_stand")
local biped_reload = skeleton_anims.get("biped_reload")
local biped_climb = skeleton_anims.get("biped_climb")

function ENT:updateSkeletalAnim( delta )

	-- Movement animation code
	local absvel = math.abs(self.velocity.x - self.movement.platformVelocity.x)
	local head = self.skeleton:getLimb("head")
	local torso = self.skeleton:getLimb("torso")
	local legupperleft = self.skeleton:getLimb("legupperleft")
  local legupperright = self.skeleton:getLimb("legupperright")
	local eyePos = self:getEyePos()
	local aimTo = self:getAimVecWorld()
	local aimDif = geom.vec2(math.abs(aimTo.x - eyePos.x), aimTo.y  - eyePos.y)
	local theta = aimDif:getTheta()
	if self:isAlive() then
	  if self.movement.crouched then
      if self.skeleton:getAnimation() ~= biped_crouch then
        self:setAnimationPlay(skeletal.AP_PLAY)
        torso:setAnimationNoChildren(biped_crouch)
        torso:setAnimationFrameNoChildren(0)
        torso:setAnimationSpeedNoChildren(5)
        legupperleft:setAnimation(biped_crouch)
        legupperleft:setAnimationFrame(0)
        legupperleft:setAnimationSpeed(5)
        legupperright:setAnimation(biped_crouch)
        legupperright:setAnimationFrame(0)
        legupperright:setAnimationSpeed(5)
      end
		elseif self.movement.reloading then
			if self.skeleton:getAnimation() ~= biped_reload then
				self:setAnimationPlay(skeletal.AP_PLAY)
				self.skeleton:setAnimation(biped_reload)
				self.skeleton:setAnimationFrame(0)
				self.skeleton:setAnimationSpeed(4)
			end
		elseif self.movement.climbing then
		    self:setAnimationPlay(skeletal.AP_LOOP)
        self.skeleton:setAnimation(biped_climb)
        self.skeleton:setAnimationSpeed(1.5 * self:getVelocity():len2()/4)
		elseif self.movement.landed then
			if absvel > 4.5 then
				self:setAnimationPlay(skeletal.AP_LOOP)
				self.skeleton:setAnimation(biped_run)
				self.skeleton:setAnimationSpeed(math.min(absvel * 5.0, 25))
			elseif absvel > 0.15 then
				self:setAnimationPlay(skeletal.AP_LOOP)
				self.skeleton:setAnimation(biped_walk)
				self.skeleton:setAnimationSpeed(math.min(absvel * 5.0, 25))
			else
				self:setAnimationPlay(skeletal.AP_PLAY)
				self.skeleton:setAnimation(biped_stand)
				self.skeleton:setAnimationSpeed(0)
			end
		else
			self.skeleton:setAnimationSpeed(math.max(0,self.skeleton:getAnimationSpeed()-60*delta))
		end

		head.animationPlay = false
		head.angle = math.rad(aimDif:getTheta()) - torso.angle
		
		
		-- Force uncrouch legs and torso code
		if not self.movement.crouched and self.wasCrouching then
		  torso:setAnimationNoChildren(biped_stand)
		  legupperleft:setAnimation(biped_stand)
		  legupperright:setAnimation(biped_stand)
		end
		
		-- Set 'was' values for next frame
		self.wasCrouching = self.movement.crouched
	end
	
	
	--Weapon code
	local weapon = self.skeleton:getLimb("weapon")
	local weaponArm = self.skeleton:getLimb("armright")
	local weaponForearm = self.skeleton:getLimb("forearmright")
	local weaponHand = self.skeleton:getLimb("handright")
	if (weapon) then
		if not (self.weapon) then
			weaponArm.animationPlay = true
			weaponForearm.animationPlay = true
			weaponHand.animationPlay = true
			weapon:detatch()
		elseif ( self:isAlive() ) then
		
			if self.movement.reloading then
				weaponArm.angle = math.rad(-95)
				weaponForearm.angle = math.rad(-45)
			else
				-- Holdtype code
				if (self.weapon.holdType == weapons.HOLDTYPE_MELEE) then
							if (self.movement.attacking) then
							
								head.angle = 0 -- no head movement while swinging
							
								weaponArm.animationPlay = false
								weaponForearm.animationPlay = false
								weaponHand.animationPlay = false
								
								local armTo = math.rad(        (((aimDif:getTheta() - 90) % 360) + 360) % 360       )
								local armDiff = weaponArm.angle - armTo
								local step = 14 * delta
								if (math.abs(armDiff) < step or math.abs(armDiff) > math.pi/2) then
									weaponArm.angle = armTo
								else
									if (armDiff > 0) then
										weaponArm.angle = weaponArm.angle - step
									else
										weaponArm.angle = weaponArm.angle + step
									end
									weaponArm.angle = math.rad(    ((math.deg(weaponArm.angle) % 360) + 360) % 360     )
								end
								
								weaponForearm.angle = 0
								weaponHand.angle = weaponArm.angle + math.pi/2
							end
				elseif (self.weapon.holdType == weapons.HOLDTYPE_PISTOL or self.weapon.holdType == weapons.HOLDTYPE_RIFLE) then --TODO weapon holdType rifle
							weaponArm.animationPlay = false
							weaponForearm.animationPlay = false
							weaponHand.animationPlay = false
							
							local armTo = math.rad(        (((aimDif:getTheta() - 90) % 360) + 360) % 360       )
							local armDiff = weaponArm.angle - armTo
							local step = 3 * delta -- TODO: magic number. 3 is the very rad/sec aim speed. AKA WEAPON SKILL :D
							if (math.abs(armDiff) < step or math.abs(armDiff) > math.pi/2) then
								weaponArm.angle = armTo
							else
								if (armDiff > 0) then
									weaponArm.angle = weaponArm.angle - step
								else
									weaponArm.angle = weaponArm.angle + step
								end
								weaponArm.angle = math.rad(    ((math.deg(weaponArm.angle) % 360) + 360) % 360     )
							end
							
							weaponForearm.angle = 0
							weaponHand.angle = 0
				end
			end
			
			-- Update the weapon entity's angle for its own use
			self.weapon:setAngleVelocity(0)
			if (self.skeleton:isMirrored()) then
				self.weapon:setAngle(math.pi + weapon:getSprite().angle)
			else
				self.weapon:setAngle(weapon:getSprite().angle)
			end
		end
	else
		if ( self.weapon and self:isAlive() ) then
			local newWeapon = self.weapon:createLimb()
			weaponArm.animationPlay = false
			weaponForearm.animationPlay = false
			weaponHand.animationPlay = false
			weaponHand:addChild(newWeapon)
			newWeapon.angle = math.pi/2 -- Rotate 90 because arm, forearm, hand face down at ang=0
		end
	end
end

function ENT:onDropWeapon()
	if (self.skeleton) then
		local weaponLimb = self.skeleton:getLimb("weapon")
		if (weaponLimb) then
			weaponLimb:detatch()
		end
	end
end

function ENT:doWeaponRecoil( fRecoilRads )
	if (self.skeleton) then
		local weaponArm = self.skeleton:getLimb("armright")
		if (weaponArm) then
			weaponArm.angle = weaponArm.angle - fRecoilRads
		end
	end
end

if (SERVER) then
	include("sv_init.lua")
end

function ENT.persist( thisClass )
		
	ENT_BASE.persist( thisClass )
	
	ents.persist(thisClass, "female", {
			write=function(field, data, ent)
				data:writeBool(field)
			end,
			read=function(data, ent)
				return data:readNext()
			end,
			dirty=function(field, ent) return false end
		}, ents.SNAP_NET)
	
	ents.persist(thisClass, "skinColor", {
			write=function(field, data, ent)
				data:writeColor(field)
				ent.skinColorDirty=false
			end,
			read=function(data, ent)
				local col = data:readNext()
				ent:setSkinColor(col)
				return col
			end,
			dirty=function(field, ent) return ent.skinColorDirty end
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "hair", {
			write=function(field, data, ent)
				data:writeString(tostring(field))
				ent.hairDirty=false
			end,
			read=function(data, ent)
				local str = data:readNext()
				ent:setHair(str)
				return str
			end,
			dirty=function(field, ent) return ent.hairDirty end
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "hairColor", {
			write=function(field, data, ent)
				data:writeColor(field)
				ent.hairColorDirty=false
			end,
			read=function(data, ent)
				local col = data:readNext()
				ent:setHairColor(col)
				return col
			end,
			dirty=function(field, ent) return ent.hairColorDirty end
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "facialHair", {
			write=function(field, data, ent)
				data:writeString(tostring(field))
				ent.facialHairDirty=false
			end,
			read=function(data, ent)
				local str = data:readNext()
				ent:setFacialHair(str)
				return str
			end,
			dirty=function(field, ent) return ent.facialHairDirty end
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "facialHairColor", {
			write=function(field, data, ent)
				data:writeColor(field)
				ent.facialHairColorDirty=false
			end,
			read=function(data, ent)
				local col = data:readNext()
				ent:setFacialHairColor(col)
				return col
			end,
			dirty=function(field, ent) return ent.facialHairColorDirty end
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "eyebrows", {
			write=function(field, data, ent)
				data:writeString(tostring(field))
				ent.eyebrowsDirty=false
			end,
			read=function(data, ent)
				local str = data:readNext()
				ent:setEyebrows(str)
				return str
			end,
			dirty=function(field, ent) return ent.eyebrowsDirty end
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "eyebrowColor", {
			write=function(field, data, ent)
				data:writeColor(field)
				ent.eyebrowColorDirty=false
			end,
			read=function(data, ent)
				local col = data:readNext()
				ent:setEyebrowColor(col)
				return col
			end,
			dirty=function(field, ent) return ent.eyebrowColorDirty end
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "eyes", {
			write=function(field, data, ent)
				data:writeString(tostring(field))
				ent.eyesDirty=false
			end,
			read=function(data, ent)
				local str = data:readNext()
				ent:setEyes(str)
				return str
			end,
			dirty=function(field, ent) return ent.eyesDirty end
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "eyeColor", {
			write=function(field, data, ent)
				data:writeColor(field)
				ent.eyeColorDirty=false
			end,
			read=function(data, ent)
				local col = data:readNext()
				ent:setEyeColor(col)
				return col
			end,
			dirty=function(field, ent) return ent.eyeColorDirty end
		}, ents.SNAP_NET)
	
	ents.persist(thisClass, "top", {
			write=function(field, data, ent)
				data:writeString(tostring(field))
				ent.topDirty=false
			end,
			read=function(data, ent)
				local str = data:readNext()
				ent:setTop(str)
				return str
			end,
			dirty=function(field, ent) return ent.topDirty end
		}, ents.SNAP_NET)
	
	ents.persist(thisClass, "bottom", {
			write=function(field, data, ent)
				data:writeString(tostring(field))
				ent.bottomDirty=false
			end,
			read=function(data, ent)
				local str = data:readNext()
				ent:setBottom(str)
				return str
			end,
			dirty=function(field, ent) return ent.bottomDirty end
		}, ents.SNAP_NET)
	
	ents.persist(thisClass, "shoes", {
			write=function(field, data, ent)
				data:writeString(tostring(field))
				ent.shoesDirty=false
			end,
			read=function(data, ent)
				local str = data:readNext()
				ent:setShoes(str)
				return str
			end,
			dirty=function(field, ent) return ent.shoesDirty end
		}, ents.SNAP_NET)
	
	ents.persist(thisClass, "weapon", {
			write=function(field, data, ent)
				data:writeEntityID(field)
				ent.weaponDirty=false
			end,
			read=function(data, ent)
				if (ent.skeleton) then
					local weaponLimb = ent.skeleton:getLimb("weapon")
					if (weaponLimb) then weaponLimb:detatch() end -- TODO perhaps we should just have a method ENT:removeWeaponLimb() ?
				end
				return ents.findByID(data:readNext())
			end,
			dirty=function(field, ent) return ent.weaponDirty end
		}, ents.SNAP_NET)
end
