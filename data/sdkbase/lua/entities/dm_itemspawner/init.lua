--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

if (SERVER) then
	
	function ENT:sv_initialize()
		ENT_BASE.sv_initialize( self )
		self:initProperty("respawnDelay", 30)
	end
	
	function ENT:pickupRemoved()
		self.pickup = nil
		timer.simple(self.respawnDelay,function()
			local ent = ents.create(self.pickupClass, false)
			ent.position = self.position:clone()
			ent.angle = self.angle
			ents.initialize(ent)
			self.pickup = ent
			sndeffect.emit( "pickups/pspawn_generic.wav", self.position.x, self.position.y, 15, 0.8, 1 )
		end)
	end
	
	local function entDestroyed( ent )
		for k,v in pairs(ents.getAll("dm_itemspawner")) do
			if ent == v.pickup then
				v:pickupRemoved()
			end
		end
	end
	hook.add("onEntityDestroyed", "dm_itemSpawnEntDestroy", entDestroyed)
	
	local function weaponPickedUp( entWeapon, entCharacter )
		if (entWeapon.dropped) then return end
		for k,v in pairs(ents.getAll("dm_itemspawner")) do
			if entWeapon == v.pickup then
				v:pickupRemoved()
			end
		end
	end
	hook.add("onWeaponPickUp", "dm_itemSpawnWeaponPickedUp", weaponPickedUp)
	
end
