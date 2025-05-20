--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:sv_initialize()
	self.dropped = false
	ENT_BASE.sv_initialize(self)
end

function ENT:use( source )
	if source and ents.isClass(source,"char_base",true) then
		source:pickupWeapon(self)
	end
end

local fRecoilForceScale = 1
--local fBlah = 500

local function setWeaponSettingsFromCvars()
	fRecoilForceScale = cvars.real( "g_weaponrecoilscale", fRecoilForceScale )
	--fBlah = cvars.real( "g_blah", fBlah )
end
hook.add("onCvarChanged", "onCvarChanged_weaponSettings", function(strName, strOldValue, strNewValue)
	if strName=="g_weaponrecoilscale" then --or strName=="g_blah" or strName=="g_blah"  or strName=="g_blah" then
		setWeaponSettingsFromCvars()
	end

end)
setWeaponSettingsFromCvars()

local ENT_BASE_sv_think = ENT_BASE.sv_think
function ENT:sv_think( delta )
	ENT_BASE_sv_think(self, delta)
	if self.equipped and self.equipped.valid and self.equipped:isAlive() then
		if self.equipped.movement.attacking then
			if not self.cooldown then
				self:fire()
				
				if not self.automatic then
					self.equipped.movement.attacking = false
				end
				
				local delay = math.abs( self.fireDelay )
				
				if delay ~= 0 then
					self.cooldown = true
					timer.simple( delay, function() self.cooldown = false end )
				end
				
			end
		end
	end
end

function ENT:fire()
	if self.equipped and not self.equipped.movement.reloading then
		local vecFrom = self.equipped:getMuzzlePos()
		if not self.equipped:canSee(vecFrom) then vecFrom = self.equipped:getPosition() end -- This one line should fix shooting through walls
		if self.ammo > 0 or self.ammoType == "none" then
			for i=1, self.bulletsPerShot do
				local ang = self.angle + (math.random() * self.fireCone) - (self.fireCone / 2)
				hook.run("fireBullet", self.equipped, self, vecFrom, ang, self.damage, self.force)
				local bod = self.equipped:getBody()
				if bod then
					local fRecoilForce = self.force / 4 * fRecoilForceScale
					bod:applyForce( geom.vec2(math.cos(ang+math.pi)*fRecoilForce, math.sin(ang+math.pi)*fRecoilForce), vecFrom ) -- Recoil on body
				end
			end
			
			-- Take ammo
			self.ammo = self.ammo - 1
			
			-- Emit the gun fire sound
			self:emitFireSound( vecFrom )
			
			--Do the recoil
			self:doRecoil()
			
			-- Broadcast gun fire message to clients
			local data = net.data()
			data:writeInt( self.id )
			net.sendMessage( self.MSG_WEAPON_FIRED, data )
		else
			self:emitEmptySound( vecFrom ) -- Emit clip empty sound
			self.equipped.movement.attacking = false -- Automatic doesn't work when there's no bang
			self.equipped:reloadWeapon() -- Try reloading
		end
	end
end

function ENT:emitFireSound( vecFrom )
	if type(self.soundFire)=="string" and string.len(self.soundFire) > 0 then sndeffect.emit( self.soundFire, vecFrom.x, vecFrom.y, 20, 1.0 ) end -- Close sound
	if type(self.soundDistantFire)=="string" and string.len(self.soundDistantFire) > 0 then sndeffect.emit( self.soundDistantFire, vecFrom.x, vecFrom.y, 100, 0.8 ) end -- Distant sound
end

function ENT:emitEmptySound( vecFrom )
	if type(self.soundClipEmpty)=="string" and string.len(self.soundClipEmpty) > 0 then sndeffect.emit( self.soundClipEmpty, vecFrom.x, vecFrom.y, 10, 1.0 ) end
end

function ENT:emitReloadClipSound( vecFrom )
	if type(self.soundReloadClip)=="string" and string.len(self.soundReloadClip) > 0 then sndeffect.emit( self.soundReloadClip, vecFrom.x, vecFrom.y, 10, 1.0 ) end
end

function ENT:emitReloadChargeSound( vecFrom )
	if type(self.soundReloadCharge)=="string" and string.len(self.soundReloadCharge) > 0 then sndeffect.emit( self.soundReloadCharge, vecFrom.x, vecFrom.y, 10, 1.0 ) end
end

function ENT:onPickedUp( character )
	self.usable = false
	self:setEquipped( character )
	self:getBody():setActive(false)
	self.usable = false
end

function ENT:onDropped( character )
	self.usable = true
	self:setEquipped( nil )
	self:getBody():setActive(true)
	self.usable = true
	self.dropped = true
end
