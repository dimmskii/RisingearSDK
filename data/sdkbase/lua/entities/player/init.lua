--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT.LAZY_UPDATE_DISTANCE = -1 -- Disable culling on player because meh

if SERVER then
	function ENT:canPickUp( entPickup ) -- Override of char_base ENT:canPickUp to allow players picking up ammo, health, etc.
		if not self.alive then return false end -- We don't pick up if we're dead
		if entPickup == nil or not entPickup.valid then return false end -- We don't pickup nils and invalids
		if ents.isClass( entPickup, "ammo_base", true ) then -- CASE 1: is an ammo pickup
			return self.ammo[entPickup.ammoType] < ammo[entPickup.ammoType].capacity
		elseif ents.isClass( entPickup, "item_healtharmor", true ) then -- CASE 2: is an healtharmor
			return self.health < self.maxHealth
		end
		return false
	end
end