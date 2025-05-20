--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.useRange = 2.0 -- maximum distance character can trigger usable items in meters
ENT.jumpForce = 6

function ENT:sv_initialize()
  ENT_BASE.sv_initialize( self )
  self.bodyType = phys.BT_DYNAMIC
  self:createBody()
  self.fixtureTop = phys.addBoxFixtureToBody(self:getBody(), materials.get("flesh"), -0.3, -0.65, 0.6, 0.65, self)
  self:addAsListenerToFixture( self.fixtureTop )
  self.fixtureMid = phys.addBoxFixtureToBody(self:getBody(), materials.get("flesh"), -0.3, 0, 0.6, 1, self)
  self:addAsListenerToFixture( self.fixtureMid )
  self.fixtureFeet = phys.addBoxFixtureToBody(self:getBody(), materials.get("character_feet"), -0.25, 1.0, 0.5, 0.1, self)
  self:addAsListenerToFixture( self.fixtureFeet )
  
  self:updateFixtureList()
  
  self.headContacts = {}
  
  --self:setAnimation(ANIM_STANCE)
  
  self.useCooldown = 0
  
  self.direction = 1
  
  self.numFeetContacts = 0
  
  self.notLandedTimer = timer.create(0.17,1,function()
    self.movement.landed=false
    self.lastLandedNormal = nil
    self.lastLandedBody = nil
    self.movement.platformVelocity = geom.vec2()
  end,false,false)
  
  -- Initialize server-sided ammo inventory using globally registered ammo types in gamemode
  self.ammo = {}
  for k,v in pairs(ammo) do
    self.ammo[k] = 0
  end
  
  -- Initialize AI entity if necessary
  if not EDITOR and string.len(self.aiClass) > 0 then
    self.ai = ents.create(self.aiClass,true)
    self.ai.character = self
  end
end

local phys_util = include("/entities/phys_base/physutil.lua")

local ENT_BASE_beginContact = ENT_BASE.beginContact
local otherEnt, manifold
function ENT:beginContact(selfFixture, otherFixture, contact)
  if self.noclip then contact:setEnabled(false) end -- NOCLIP
  
  otherEnt = otherFixture:getUserData()
  if otherEnt and otherEnt.valid and ( ents.isClass(otherEnt, "char_base", true) or ents.isClass(otherEnt, "weapon_base", true) ) then
    contact:setEnabled(false) -- Characters walk through other characters and weapons
    -- TODO: we still hit weapons what.
  end

  if (selfFixture == self.fixtureTop) then
    self.headContacts[otherFixture] = contact
    if (self.movement.crouched) then
      contact:setEnabled(false)
    end
  end
  if (selfFixture == self.fixtureTop or selfFixture == self.fixtureMid) then
    if phys_util.fixtureIsPlatform(otherFixture) then contact:setEnabled(false) end
    return
  end
  
  ENT_BASE_beginContact(self, selfFixture, otherFixture, contact)
  
  if (otherEnt == self) then
    contact:setEnabled(false)
  end
  
  if (selfFixture == self.fixtureFeet) then
    self.numFeetContacts = self.numFeetContacts + 1 
    if (contact:isEnabled()) then
      self.movement.landed = true
      manifold = phys.newWorldManifold()
      contact:getWorldManifold(manifold)
      self.lastLandedNormal = manifold.normal
      self.lastLandedBody = otherFixture:getBody()
      self.movement.platformVelocity:set(self.lastLandedBody:getLinearVelocity())
      timer.stop(self.notLandedTimer)
    end
  end
end

local ENT_BASE_endContact = ENT_BASE.endContact
function ENT:endContact(selfFixture, otherFixture, contact)
  if (selfFixture == self.fixtureTop) then
    self.headContacts[otherFixture] = nil
    if (self.movement.crouched) then
      contact:setEnabled(true)
    end
  end
  if (selfFixture == self.fixtureTop or selfFixture == self.fixtureMid) then
    if phys_util.fixtureIsPlatform(otherFixture) then contact:setEnabled(true) end
    return
  end
  ENT_BASE_endContact(self, selfFixture, otherFixture, contact)
  
  if (selfFixture == self.fixtureFeet) then
    self.numFeetContacts = self.numFeetContacts - 1 
    if self.numFeetContacts == 0 then
      if (self.movement.landed) then
        -- Un-land code 2: feet contacts == 0 means we are no longer landeded
        --self.movement.landed = false
        timer.adjust(self.notLandedTimer,0.17,1)
        timer.start(self.notLandedTimer)
      end
    end
  end
end

function ENT:sv_think( delta )
  if (self.movement.using) then
    if (self.useTarget and self.useCooldown <= 0) then
      self.useTarget:use( self )
      self.useCooldown = 0.5
    end
  end
  if (self.useCooldown > 0) then
    self.useCooldown = self.useCooldown - delta
  end
  ENT_BASE.sv_think(self, delta)
end

function ENT:updateSprite( delta )
--  if (self.movement.landed) then
--    if not (self.movement.direction == 0) then
--      if (self.movement.running) then
--        self:setAnimation(ANIM_RUN)
--      else
--        self:setAnimation(ANIM_WALK)
--      end
--    else
--      self:setAnimation(ANIM_STANCE)
--    end
--  end
  
  if (self.direction > 0) then
    self.skeleton:setMirrored(false)
  else
    self.skeleton:setMirrored(true)
  end
  
  --ENT_BASE.updateSprite( self, delta )
  
  self.skeleton:update( delta )
  
  
  --self.sprFrame = self.sprite:getCurrentFrame()
end

local ladders = {}

function ENT:isTouchingLadder()
  ladders = ents.getAll("func_ladder")
  local pos = self:getPosition()
  for k,v in pairs(ladders) do
    if v.valid and v:getOutlineShape():contains(pos.x, pos.y) then
      return true
    end
  end
  
  return false
end

local limbs, limb, ragLimb, joint
function ENT:updateSkeleton( delta )
  self.skeleton:setPosition(self.position.x,self.position.y)
  
  if (self:isAlive()) then
    if (self.direction > 0) then
      self.skeleton:setMirrored(false)
    else
      self.skeleton:setMirrored(true)
    end
    self.skeleton:update(delta)
    self.mirrored = self.skeleton:isMirrored()
  elseif (self.ragdoll) then -- Update skeleton angles to match ragdoll physics bodies
    limbs = self.skeleton:getLimbs()
    self.ragdollAngles = {}
    for i=1,limbs.length,1 do
      limb = limbs[i]
      limb:resetFrameOrigin()
      limb:resetFrameOffset()
      if (limb.physicsDisabled == false) then
        ragLimb = self.ragdoll[limb]
        joint = ragLimb.joint
        if (joint) then
          if self.mirrored then
            limb.angle = joint:getJointAngle() + self.ragdoll[limb].initialAngle
          else
            limb.angle = -joint:getJointAngle() + self.ragdoll[limb].initialAngle
          end
        else
          if self.mirrored then
            limb.angle = -ragLimb.body:getAngle()
          else
            limb.angle = ragLimb.body:getAngle()
          end
        end
        self.ragdollAngles[limb:getName()] = limb.angle
      end
    end
  end
end

local fAccelerate = 5000
local fAirAccelerate = 800
local fRunSpeed = 7
local fMaxSpeed = 8
local fNoclipAccel = 100
local fNoclipMaxSpeed = 15
local fNoclipDampen = 4
local fClimbSpeed = 3.5

local function setPlMoveSettingsFromCvars()
  fAccelerate = cvars.real( "g_accelerate", fAccelerate )
  fAirAccelerate = cvars.real( "g_airaccelerate", fAirAccelerate )
  fRunSpeed = cvars.real( "g_runspeed", fRunSpeed )
  fMaxSpeed = cvars.real( "g_maxspeed", fMaxSpeed )
  
  fNoclipAccel = cvars.real( "g_accelerate_noclip", fNoclipAccel )
  fNoclipMaxSpeed = cvars.real( "g_maxspeed_noclip", fNoclipMaxSpeed )
  fNoclipDampen = cvars.real( "g_dampen_noclip", fNoclipDampen )
end
hook.add("onCvarChanged", "onCvarChanged_plmoveSettings", function(strName, strOldValue, strNewValue)
  if strName=="g_accelerate" or strName=="g_airaccelerate" or strName=="g_runspeed"  or strName=="g_maxspeed" or strName=="g_accelerate_noclip"  or strName=="g_maxspeed_noclip"  or strName=="g_dampen_noclip" then
    setPlMoveSettingsFromCvars()
  end

end)
setPlMoveSettingsFromCvars()

local body, resultantMoveDirection, vecVelResult, currentVelocityX, currentVelocityY, tang, weaponBodyPos, weaponLimb
function ENT:updateMotion( delta )
  body = self:getBody()
  if body == nil then return end
  
  self:setAngleVelocity(0)
  
  ENT_BASE.updateMotion( self, delta )
  
  resultantMoveDirection = math.signum(self.direction) * math.signum(self.movement.direction) -- This is needed for noclip and regular move code
  -- TODO static shared 'movetype functions' or 'tables with cmove function'. Each char has one of those movetypes set as property. This method should call its respective movetype's cmove(delta, body, resultantDirection, entCharThis)
  -- The movetype will deal with all walking/flying(todo)/noclipping code individually to avoid huge chained if-statement mess. The 'motion updating' to be done here for base chars is pretty much only the above -- fix body rotation. Or anything else that applies to its movement as generally a physics object
  
  if self.noclip then
   body:setGravityScale(0)
   body:setLinearDamping(fNoclipDampen)
   self.movement.landed = true
   if self.movement.down and not self.movement.up then
     self.movement.crouched = false
     body:setLinearVelocity(body:getLinearVelocity():add(geom.vec2(0,fNoclipAccel * delta)))
   elseif self.movement.up and not self.movement.down then
     self.movement.crouched = false
     body:setLinearVelocity(body:getLinearVelocity():add(geom.vec2(0,-fNoclipAccel * delta)))
   end
   body:setLinearVelocity(body:getLinearVelocity():add(geom.vec2(fNoclipAccel * resultantMoveDirection * delta,0)))
   vecVelResult = body:getLinearVelocity()
   if math.abs(vecVelResult.x) > fNoclipMaxSpeed then --TODO Shoddy axial checks resulting in no dir change when max speed hit. And directly modifying jbox linear vel vector of body -- is that even kosher? 
    vecVelResult.x = vecVelResult.x / math.abs(vecVelResult.x) * fNoclipMaxSpeed
   end
   if math.abs(vecVelResult.y) > fNoclipMaxSpeed then
    vecVelResult.y = vecVelResult.y / math.abs(vecVelResult.y) * fNoclipMaxSpeed
   end
   return -- NOCLIP EXITS METHOD HERE
  else
   body:setGravityScale(1)
   body:setLinearDamping(0)
  end
  
  if self:isAlive() then
    
    currentVelocityX = self:getVelocity().x
    currentVelocityY = self:getVelocity().y
    
    if self:isTouchingLadder() and not self.movement.landed then
      self.movement.climbing = true
      self.movement.crouched = false
      body:setGravityScale(0)
      body:setLinearVelocity(geom.vec2(fClimbSpeed * resultantMoveDirection,0))
      if self.movement.down and not self.movement.up then
       body:setLinearVelocity(geom.vec2(fClimbSpeed * resultantMoveDirection,fClimbSpeed))
      elseif self.movement.up and not self.movement.down then
       body:setLinearVelocity(geom.vec2(fClimbSpeed * resultantMoveDirection,-fClimbSpeed))
      end
      return
    else
      self.movement.climbing = false
      body:setGravityScale(1)
    end
    
    if self.movement.landed then
      
      -- Un-land code: uses vertical velocity to prevent "late/double" jumps
      if math.abs(self:getVelocity().y) > 5 then
        self.movement.landed = false
        return
      end
    
      -- Ground movement code
      local maxVelocityX = fRunSpeed / 2
      if self.movement.direction == 0 then
        maxVelocityX = 0
      elseif self.movement.running and not self.movement.crouched then
        maxVelocityX = fRunSpeed
      end
      
      -- Un-bounce code
      if currentVelocityY < 0 then self:setVelocity(currentVelocityX, 0) end
      
      if math.abs(currentVelocityX) < maxVelocityX then
      	-- We make applyLinearImpulse and applyForce do 50-50 the amount of work
        body:applyForce(geom.vec2(fAccelerate * body:getMass() / 2 * resultantMoveDirection * delta), body:getPosition())
        body:applyLinearImpulse(geom.vec2(fAccelerate * 200 * resultantMoveDirection * delta), body:getPosition(), true)
        -- Slope code
        if self.lastLandedNormal then
          tang = self.lastLandedNormal:clone()
          if resultantMoveDirection < 0 then
            tang:addAngleLocal(-90)
          elseif resultantMoveDirection > 0 then
            tang:addAngleLocal(90)
          end
          -- Un-bounce code when running
          if math.abs(tang.y) > 0.05 and math.abs(tang.y) < 0.5 then
            --self:setPosition(self.position.x, self.position.y+(maxVelocityX*tang.y*delta))
            self:setVelocity(currentVelocityX, maxVelocityX*tang.y)
          else
            self:setVelocity(currentVelocityX, 0)
          end
          
          -- Update last landed platformVelocity
          self.movement.platformVelocity:set(self.lastLandedBody:getLinearVelocity())
        end
      end
    else
      -- Air movement
      if (resultantMoveDirection > 0 and currentVelocityX < fMaxSpeed ) or (resultantMoveDirection < 0 and currentVelocityX > -fMaxSpeed) then
        body:applyForce(geom.vec2(fAirAccelerate * body:getMass() * resultantMoveDirection * delta), body:getPosition())
      end
    end
    
    -- Crouching code
    if (self.movement.down) then
      if not (self.movement.crouched) then
        self.movement.crouched = true
        for k,v in pairs(self.headContacts) do
          v:setEnabled(false)
        end
        self.headContacts = {}
      end
    else
    	--Uncrouching code
    	if (self.movement.crouched) then
	    	-- Query world to see if the position above head is free
				local world = phys.getWorld()
				local foundFixture = nil
				world:queryAABB(phys.newQueryCallback(function(fixture)
						local userData = fixture:getUserData() or fixture:getBody():getUserData()
						if not phys_util.fixtureIsPlatform(fixture) and not (userData and userData == self) then -- if obstacle is not platform and doesnt have user data EQUAL TO SELF (hitscaning ourselves)
							foundFixture = fixture
							return false -- stop query
						end
						return true -- continuie query
				end), phys.newAABB(  self.position:addXY(-0.4,-0.7),  self.position:addXY(0.4,0) ))
				if not foundFixture then self.movement.crouched = false end
			end
    end
    
    
    -- Weapon phys movement code
    if (self.weapon) then
      weaponBodyPos = self:getPosition()
      if (self.skeleton) then
        
        weaponLimb = self.skeleton:getLimb("weapon")
        if (weaponLimb) then
          weaponBodyPos = weaponLimb:getTransformedOrigin():toVec2() -- subtract it back
        else
          weaponBodyPos = self.skeleton:getPosition()
        end
        self.weapon:setPosition(weaponBodyPos.x,weaponBodyPos.y)
      end
    end
    
    -- Keep upright
    self:setAngle(0)
    
  end
  
end

function ENT:takeDamage( iDamage, entAttacker, entDamager )
  if not self:isAlive() or self.god then return end -- The dead don't take damage; also god mode
  
  self:setHealth( self.health - iDamage )
  if (self.health <= 0) then
    self:kill( entAttacker, entDamager )
  end
end

function ENT:heal( iHealth ) --, entAttacker, entDamager )
  if not self:isAlive() or self.god then return end -- The dead don't take hp
  
  self:setHealth( math.min(self.health + iHealth, self.maxHealth) )
end

local vec2Aim, vecUseTarg, useTargets, useTargetsSorted, useTarget
function ENT:aimAt( x, y )
  vec2Aim = geom.vec2( x, y )
  if not vec2Aim:equals(self:getAimVecWorld()) then
    self.aimVec = vec2Aim:sub(self.position)
    self.aimVecDirty = true
    
    
    vecUseTarg = vec2Aim:clone()
    vecUseTarg:subLocal(self:getEyePos())
    if vecUseTarg:len() > self.useRange then
    	vecUseTarg:normalize()
    	vecUseTarg:mulLocal(self.useRange)
    	
    	--reflect if were mirrored
    	if self.direction <= 0 then
    		vecUseTarg.x = vecUseTarg.x * -1
    	end
    end
    vecUseTarg:addLocal(self:getEyePos())
    useTargets = ent_utils.getEntsInRadius(vecUseTarg, 2, function(ent) return ent.usable and self:canUse(ent) end ) 
    useTargetsSorted = {} -- create empty table for sorted potential use targets
    for k,v in pairs(useTargets) do
    	table.insert(useTargetsSorted, {
    		dist=v:getOutlineShape():getCenter():sub(vecUseTarg):len(), -- the distance to USE vector (not character position)
    		ent=v -- store the corresponding ent
    	})
    end
    table.sort(useTargetsSorted, function(a,b) return a.dist < b.dist end) -- sort potential use targets by distance
    if (table.count(useTargetsSorted) < 1) then
    	useTarget = nil
    else
	    useTarget = useTargetsSorted[1].ent -- Select the one with least distance
    end
    if (self.useTarget ~= useTarget) then
      self.useTarget = useTarget
			self.useTargetDirty = true
	  end
  end
end

local xdiff
function ENT:canUse( entUsable ) -- keyword usable
  if not self:isAlive() then return false end -- The dead don't usable
  if not entUsable.valid then return false end
  if not self:canSee( entUsable.position ) then return false end -- This one line should prevent using through walls
  xdiff = entUsable.position.x - self.position.x
  if not ( (xdiff <= 0 and self.direction <= 0) or (xdiff >= 0 and self.direction >= 0) ) then return end -- Char is not facing same direction as use target
  return self.position:sub(entUsable:getOutlineShape():getCenter()):len() <= self.useRange -- Return 
end

function ENT:pickupWeapon( entWeapon )
  if not self:isAlive() then return end -- The dead don't shoot

  -- Drop old weapon if applicable
  if self.weapon then
    self:dropWeapon()
  end
  
  -- Fire the hook
  hook.run("onWeaponPickUp",entWeapon,self)
  
  -- Pick up new weapon
  entWeapon:onPickedUp( self )
  self.weapon = entWeapon
  self.weaponDirty = true
  
end

-- TODO: this may be better to use in some fitting hook like player join game?
timer.create(1,-1,function()
  
  for k,v in pairs(ents.getAll()) do
    if v.valid and ents.isClass(v,"char_base",true) then
      v.weaponDirty = true
    end
  end
end, true, false)

function ENT:canPickUp( entPickup )
  return false
   -- To avoid having all characters (possibly NPCs, etc) eating pickups along the way, char_base returns false here
   -- For players' canPickUp logic, see /entities/player/sv_init.lua
end

function ENT:reloadWeapon()
  if self.weapon and self.weapon.valid then
    if not self.movement.reloading then
      if self.weapon.ammoClip > 0 and self.weapon.ammo < self.weapon.ammoClip then
        self.movement.reloading = true
        local strType = self.weapon.ammoType
        if self.ammo[strType] > 0 then
          self.weapon:emitReloadClipSound(self.position:clone()) -- Emit clip reload sound
          -- Time the reload finish
          timer.simple( 0.9348, function() -- TODO not magic number 0.9348. weapons should have different reload times
            if self.weapon and self.weapon.valid then
              local iAmount = math.min(self.ammo[strType], self.weapon.ammoClip - self.weapon.ammo)
              self.weapon.ammo = self.weapon.ammo + iAmount
              self.ammo[strType] = self.ammo[strType] - iAmount
              self.weapon:emitReloadChargeSound(self.position:clone()) -- Emit charge sound
              self.movement.reloading = false
            end
          end )
        else
          self.movement.reloading = false
        end
      end
    end
  end
end

function ENT:dropWeapon()
  if not self.weapon then return end
  
  -- Fire the hook
  hook.run("onWeaponDrop",self.weapon,self)
  
  -- Fire own and weapon's event methods
  self:onDropWeapon()
  self.weapon:onDropped( self )
  
  -- Prevent certain problems:
  self.movement.reloading = false
  self.movement.attacking = false
  
  local vecThrowVel = self:getAimVecWorld()
  vecThrowVel:subLocal(self.position):normalize()
  vecThrowVel:mulLocal(3):addLocal(self:getVelocity())
  self.weapon:setVelocity(vecThrowVel.x,vecThrowVel.y)
  
  self.weapon = nil
  self.weaponDirty = true
  
  local data = net.data()
  data:writeInt( self.id )
  net.sendMessage( self.MSG_CHAR_DROP_WEAPON, data )
end

function ENT:addAmmo( strType, iAmmo )
  if self.ammo[strType] then
    self.ammo[strType] = math.min(self.ammo[strType] + iAmmo, ammo[strType].capacity)
  else
    console.err("Attempt to add non-existing ammo type '" .. strType .. "' to a char_human!")
  end
end

function ENT:getAmmo( strType )
  if self.ammo[strType] then
    return self.ammo[strType]
  end
  
  return -1
end

function ENT:kill( entAttacker, entDamager )
  if not self:isAlive() then return end -- The dead don't die
  --GAMEMODE:onCharacterKilled( self, entAttacker, entDamager )
  hook.run( "onCharacterKilled", self, entAttacker, entDamager )
  if self.ai then
    ents.remove(self.ai)                  -- Delete AI entity
  end
  self:dropWeapon()                     -- Drop weapon
  timer.simple(0.01,function()
   self:ragdollize()
  end)      -- Make self into ragdoll on a timer (just in case phys world is locked)
  self:setHealth(0)                     -- Ensure Health is 0
  if self.ai and self.ai.valid then ents.remove(self.ai) self.ai = nil end  -- Delete AI if needed
  self:setAlive(false)                    -- Lastly, set alive bool to false
end

function ENT:dismember( body )
  if self.alive or not self.ragdoll then return end
  
  
  local limb = nil
  for k,v in pairs(self.ragdoll) do
    if body == v.body then
      if table.hasValue(self.ragdollDismem, k:getName()) then
        return
      end
      if k:isRoot() then return end -- Can't dismember the root limb
      limb = k
    end
  end
  
  if not limb then return end
  
  -- Insert dismembered limb into server-side table
  local t = limb:getSelfAndAllChildren()
  -- go through all of that
  local l
  for i=1,t.length,1 do
    l = t[i]
    table.insert(self.ragdollDismem, l:getName()) -- add to dismem persist table
  end
  
  self.ragdollDismemDirty = true
  
  local ragent = ents.create("phys_ragdoll",false)
  ragent.position = limb:getTransformedOrigin():toVec2()
  ragent.rootLimbName = limb:getName()
  local rootLimb = self.skeleton:clone():getLimb(limb:getName())
  rootLimb.offset = geom.vec2()
  rootLimb:detatch()
  ragent.skeleton = skeletal.createSkeleton( )
  ragent.skeleton.position:set(ragent.position)
  ragent.skeleton:setRoot(rootLimb)
  ragent.skeleton:rebuildLimbTable()
  ragent.angle = limb:getAbsoluteAngle()
  ragent.mirrored = self.mirrored
  ents.initialize(ragent)
end

function ENT:ragdollize()
  self:setAnimationPlay( skeletal.AP_STOP )
  if (self.skeleton == nil) then self:destroy() return end
  
  --store velocity of original body
  local vecOldVelocity = self.bodies[1]:getLinearVelocity()
  phys.getWorld():destroyBody(self.bodies[1])
  
  self.bodies, self.ragdoll = physragdoll.create(self.skeleton, self.mirrored, vecOldVelocity, self)
  
  -- Create table that keeps track of which of its own skeleton's limbs were dismembered so client can hide them later
  self.ragdollDismem = {}
end

function ENT:destroy()
  ENT_BASE.destroy( self )
  if self.weapon and self.weapon.valid then
    ents.remove(self.weapon)
  end
end

function ENT:jump()
  if (self:isAlive() and self.movement.landed and not self.movement.crouched) then
    --self:setAnimation(ANIM_JUMP)
    self:setPosition(self.position.x, self.position.y-0.05) -- Sometimes the "unbounce" code in self:updateMotion() doesn't let us off the ground
    self:setVelocity(self.velocity.x,self.velocity.y-self.jumpForce)
    self.movement.landed = false
  end
end
