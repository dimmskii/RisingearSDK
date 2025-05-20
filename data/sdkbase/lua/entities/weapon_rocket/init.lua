--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local def = props.addDefinition("Rocket Launcher", "weapons/rocket_launcher.png", 0.9, 0.239, geom.rectangle(0,0,0.9,0.239), "weapon") -- props.COLLISION_SPRITE too slow
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

-- Allow placement in editor
if EDITOR then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end

ENT.niceName =	"Rocket Launcher"
ENT.holdType = weapons.HOLDTYPE_RIFLE
ENT.ammoType = "rockets"
ENT.ammoClip = 0
ENT.soundFire = "weapons/rocket_firec.wav"
ENT.soundDistantFire = ""

function ENT:initialize()

	-- Weapon class property defs
	self.automatic = false
	self.fireDelay = 0.5 -- auto delay in seconds
	self.fireCone = 0.00 -- in radians
	self.recoil = 0.2 -- in radians
	self.muzzlePos = geom.vec2(0.7, -0.07)
	
	self.definitionIndex = def.index
	
	ENT_BASE.initialize( self )
	
end

function ENT:getLimbOriginVec()
	return geom.vec2(-0.075, 0.15)
end

if SERVER then
	function ENT:fire()
		if self.equipped and not self.equipped.reloading then
			local ammo = self.equipped.ammo[self.ammoType]
			local vecFrom = self.equipped:getMuzzlePos()	
			if ammo > 0 or self.ammoType == "none" then
  			local entRocket = ents.create("proj_rocket",false)
  			local vecFrom = self.equipped:getMuzzlePos():clone() -- Get muzzle position
  			if not self.equipped:canSee(vecFrom) then vecFrom = self.equipped:getPosition() end -- This one line should fix shooting through walls
  			entRocket:setPosition(vecFrom.x,vecFrom.y)	-- Set position of projectile
  			entRocket.owner = self.equipped -- Set whoever equips this weapon as the projectile's owner
  			ents.initialize(entRocket)
  			
  			-- Apply velocity
  			local vecSpeed = geom.vec2(24)
  			vecSpeed:setTheta(math.deg(self.angle))
  			--entRocket:setVelocity(vecSpeed.x + self.equipped.velocity.x,vecSpeed.y + self.equipped.velocity.y)
  			entRocket:setVelocity(vecSpeed.x, vecSpeed.y)
  			
  			-- Set angle on her
  			entRocket:setAngle(self.angle)
  			
  			-- Take ammo
        self.equipped.ammo[self.ammoType] = ammo - 1
  			
  			-- Emit the gun fire sound
  			self:emitFireSound( vecFrom )
  			
  			--Do the recoil
  			self:doRecoil()
  		else
        self:emitEmptySound( vecFrom ) -- Emit clip empty sound
        self.equipped.movement.attacking = false -- Automatic doesn't work when there's no bang
        self.equipped:reloadWeapon() -- Try reloading
			end
		end
	end
end
