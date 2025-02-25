--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.touchPickup = false

ENT.niceName = "Base Weapon" -- TODO stringadactyl
ENT.damage = 0					--int
ENT.force = 0					--float
ENT.bulletsPerShot = 1			-- number of bullets per shot
ENT.holdType = weapons.HOLDTYPE_NONE
ENT.ammoType = "none"
ENT.ammoClip = -1
ENT.soundFire = "weapons/rif_ak47_firec.wav"
ENT.soundDistantFire = "weapons/rif_ak47_fired.wav"
ENT.soundClipEmpty = "weapons/empty_clip.wav"
ENT.soundReloadClip = "weapons/shot_spas12_rel10.wav"
ENT.soundReloadCharge = "weapons/shot_spas12_rel20.wav"

function ENT:initialize()

	-- Weapon class property defs
	self:initProperty("equipped", nil)
	self:initProperty("automatic", false)
	self:initProperty("fireDelay", 0.2) -- auto delay in seconds
	self:initProperty("fireCone", 0.00) -- in radians
	self:initProperty("muzzlePos", geom.vec2(0,0))
	self:initProperty("recoil", 0.00) -- in radians (kick to arm)
	
	self:initProperty("ammo", self.ammoClip)

	self.usable = true
	
	-- phys_base overrides
	self:initProperty("materialID", "weapon")
	
	ENT_BASE.initialize( self )
	
end

function ENT:getUseText()
	return "Switch weapon for " .. self.niceName -- TODO stringadactyl
end

function ENT:setEquipped( character )
	if character and ents.isClass(character, "char_base", true) then
		self.equipped = character
	else
		self.equipped = nil
	end
	
	if SERVER then self.equippedDirty = true end
end

function ENT:isEquipped()
	return self.equipped
end

function ENT:createLimb()
	local spr = self.sprite:clone()
	local limb = skeletal.createLimb("weapon",spr)
	limb.offset.x = 0.0
	limb.offset.y = 0.0
	local vecOrigin = self:getLimbOriginVec()
	limb.origin.x = vecOrigin.x
	limb.origin.y = vecOrigin.y
	limb.behindParent = true
	limb.flipBehindParent = true
	limb.physicsDisabled = true
	return limb
end

function ENT:getLimbOriginVec()
	return geom.vec2()
end

ENT.MSG_WEAPON_FIRED = net.registerMessage( "weapon_fired", function(sender, data)
	local entWeapon = ents.findByID(data:readNext())
	entWeapon:onFired()
end )

function ENT:onFired()
	self:doRecoil()
	if CLIENT then
		self:doFiredEffects()
	end
end

function ENT:doRecoil()
	if self.equipped then
		self.equipped:doWeaponRecoil(self.recoil)
	end
end

if SERVER then
	include("sv_init.lua")
elseif CLIENT then
	include("cl_init.lua")
end

function ENT.persist( thisClass )
	
	ENT_BASE.persist( thisClass )
	
	ents.persist(thisClass, "ammo", {
			write=function(field, data, ent)
				data:writeShort(field)
			end,
			read=function(data, ent)
				return data:readNext()
			end
		}, ents.SNAP_SAV)
		
	ents.persist(thisClass, "equipped", {
			write=function(field, data, ent)
				data:writeEntityID(field)
				ent.equippedDirty=false
			end,
			read=function(data, ent)
				return ents.findByID(data:readNext())
			end,
			dirty=function(field, ent) return ent.equippedDirty end
		}, ents.SNAP_ALL)
end
