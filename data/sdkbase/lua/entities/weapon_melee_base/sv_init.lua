--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

local MELEE_GAP_SECS = 0.11
local MELEE_GAP_DIST = 0.4
local SOUND_COOLDOWN = 0.25
local DMG_MULT = 250000


function ENT:sv_initialize()
  ENT_BASE.sv_initialize(self)
  self.atkAccum = 0
  self.soundCooldown = 0
  
  self.entitiesHit = {} -- Entities hit clears once per update
end

function ENT:sv_think(delta)
  ENT_BASE.sv_think(self,delta)
  
  self.entitiesHit = {} -- clear the entities hit list since last update
  
  self.soundCooldown = math.max(self.soundCooldown - delta, 0)
  
  if not self.equipped then return end
  
  self.atkAccum = self.atkAccum + delta
  
  if self.equipped.movement.attacking == false then
    self.atkAccum = 0
    self.atkVec = nil
    self.atkVecHilt = nil
  else
    -- TODO optimize this trash
    if self.atkVec == nil then
      self.atkVec = self.equipped:getMuzzlePos():sub(self.equipped:getPosition())
      self.atkVecHilt = self.equipped.skeleton:getLimb("weapon"):getTransformedOrigin():toVec2():sub(self.equipped:getPosition())
    else
      local dist = self.equipped:getMuzzlePos():sub(self.equipped:getPosition()):sub(self.atkVec)
      if dist:len2() > MELEE_GAP_DIST then
        local weaponLimb = self.equipped.skeleton:getLimb("weapon")
        weaponLimb:getTransformed(weaponLimb:getSprite():getOutlineShape())
        self:melee( dist:mul(delta),  geom.polygon( self.atkVecHilt:add(self.equipped:getPosition()), self.atkVec:add(self.equipped:getPosition()), self.equipped:getMuzzlePos(), self.equipped.skeleton:getLimb("weapon"):getTransformedOrigin():toVec2() )  )
        --self:melee(  geom.polygon( self.atkVec:add(self.equipped:getPosition()), self.equipped:getMuzzlePos(), self.atkVec:add(self.equipped:getPosition()), self.equipped:getMuzzlePos() )  )
        self.atkVec = self.equipped:getMuzzlePos():sub(self.equipped:getPosition())
        self.atkVecHilt = self.equipped.skeleton:getLimb("weapon"):getTransformedOrigin():toVec2():sub(self.equipped:getPosition())
      end
    end
    if self.atkAccum >= MELEE_GAP_SECS then
      self.atkVec = self.equipped:getMuzzlePos():sub(self.equipped:getPosition())
      self.atkVecHilt = self.equipped.skeleton:getLimb("weapon"):getTransformedOrigin():toVec2():sub(self.equipped:getPosition())
      self.atkAccum = 0
    end
  end
end

---
-- @function [parent=TODO] melee
-- @param geom#Vec2 vecAttack
-- @param geom#Hull shapeHull
function ENT:melee( vecAttack, shapeHull )
  -- Emit sound
  if self.soundCooldown <= 0 then
    self:emitFireSound( shapeHull:getCenter() )
    self.soundCooldown = SOUND_COOLDOWN
  end
  
	-- Query world and do the mayjeeck
	local world = phys.getWorld()
	world:queryAABB(phys.newQueryCallback(function(fixture)

			if fixture then
				local bodyHit = fixture:getBody()
				local entHit = bodyHit:getUserData() -- TODO: verify
				if entHit and entHit.valid and entHit ~= self.equipped then
					if not table.hasValue(self.entitiesHit,entHit) then
						table.insert(self.entitiesHit,entHit)
						local vecForce = vecAttack:clone()
						vecForce:normalize()
						vecForce:mulLocal(self.force)
						bodyHit:applyForceToCenter(vecForce)
						entHit:takeDamage(self.damage, self.equipped, self)
						if ents.isClass(entHit,"char_base",true) then
							combat_effects.sv_blood_bullet(shapeHull:getCenter(), vecAttack, color.RED:darker(0.2), entHit)
							if self.dismembers then entHit:dismember( bodyHit ) end
						end
					end
				end
			end
			return true -- continue query

	end), phys.newAABB(  geom.vec2(shapeHull:getMinX(),shapeHull:getMinY()),  geom.vec2(shapeHull:getMaxX(),shapeHull:getMaxY()) ))
  
  
  
--  local ent = ents.create("rend_polygon",false)
--  ent.polygon = shapeHull
--  ents.initialize(ent)
end

function ENT:fire()
end

function ENT:emitFireSound( vecFrom )
	if type(self.soundFire)=="string" and string.len(self.soundFire) > 0 then sndeffect.emit( self.soundFire, vecFrom.x, vecFrom.y, 15, 1.0 ) end -- Close sound
end