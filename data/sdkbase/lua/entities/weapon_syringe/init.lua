--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local def = props.addDefinition("Syringe Gun", "weapons/syringe_gun.png", 0.3961, 0.2679, props.COLLISION_SPRITE, "weapon")
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

-- Allow placement in editor
--if EDITOR then
--	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
--end

ENT.niceName =	"Syringe Gun"
ENT.damage = 20 	--int
ENT.force = 42069	--float
ENT.holdType = weapons.HOLDTYPE_RIFLE
ENT.ammoType = "none"
ENT.ammoClip = -1
ENT.soundFire = "weapons/syringe_firec.wav"
ENT.soundDistantFire = ""

function ENT:initialize()

	-- Weapon class property defs
	self.automatic = true
	self.fireDelay = 0.18 -- auto delay in seconds
	self.fireCone = 0.01 -- in radians
	self.recoil = 0.2 -- in radians
	self.muzzlePos = geom.vec2(0.3961, -0.07)
	
	self.definitionIndex = def.index
	
	ENT_BASE.initialize( self )
	
end

function ENT:getLimbOriginVec()
	return geom.vec2(-0.075, 0.15)
end

if SERVER then
	function ENT:fire()
		if self.equipped and not self.equipped.reloading then
			local vecFrom = self.equipped:getMuzzlePos()	
			local entSyringe = ents.create("proj_syringe",false)
			local vecFrom = self.equipped:getMuzzlePos():clone() -- Get muzzle position
			entSyringe:setPosition(vecFrom.x,vecFrom.y)	-- Set position of projectile
			entSyringe.owner = self.equipped -- Set whoever equips this weapon as the projectile's owner
			ents.initialize(entSyringe)
			
			-- Apply velocity
			local vecSpeed = geom.vec2(20)
			vecSpeed:setTheta(math.deg(self.angle))
			entSyringe:setVelocity(vecSpeed.x + self.equipped.velocity.x,vecSpeed.y + self.equipped.velocity.y)
			
			-- Set angle on her
			entSyringe:setAngle(self.angle)
			
			-- Emit the gun fire sound
			self:emitFireSound( vecFrom )
			
			--Do the recoil
			self:doRecoil()
		end
	end
end
