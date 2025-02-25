--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --

local BULLET_DISTANCE = 500 -- 500m

local function processBulletMessage(sender, data)
  if CLIENT then
    local entAttacker = ents.findByID(data:readNext())
    local entWeapon = ents.findByID(data:readNext())
    local vecFrom = data:readNext()
    local vecTo = data:readNext()
    local entHit = ents.findByID(data:readNext())
    local bDrawDebug = data:readNext()
    
    -- DEBUG SHOT RAYCAST CODE
    if bDrawDebug then
      local rendComposite = renderables.composite()
      local rendLine = renderables.fromShape(geom.line(vecFrom.x,vecFrom.y,vecTo.x,vecTo.y))
      rendComposite:addRenderable(rendLine)
      rendLine = renderables.fromShape(geom.line(vecTo.x - 0.05,vecTo.y-0.05,vecTo.x+0.05,vecTo.y+0.05))
      rendLine.outlineColor = color.RED
      rendComposite:addRenderable(rendLine)
      rendLine = renderables.fromShape(geom.line(vecTo.x - 0.05,vecTo.y+0.05,vecTo.x+0.05,vecTo.y-0.05))
      rendLine.outlineColor = color.RED
      rendComposite:addRenderable(rendLine)
      renderables.add(rendComposite)-- Draw line sent to our clientside resulting from a server-sided jbox raycast -- needs cvar with cheat protection
      rendComposite:setLayer(renderables.LAYER_POST_GAME)
      timer.simple(1, function() renderables.remove(rendComposite) return end) -- remove old ones after a second or so -- needs cvar
    end
    
    --combat_effects.createBulletTracer(vecFrom,vecTo) -- To show tracer from real place (not alwayz muzzle due to walling prevention code)
    local vecTracer = vecFrom
    if entAttacker and entAttacker.valid then
    	local muzzlePos = entAttacker:getMuzzlePos()
    	if muzzlePos then vecTracer = muzzlePos end
    end
    combat_effects.createBulletTracer(vecTracer,vecTo)
  end
end

local MSG_BULLET = net.registerMessage("bullet", processBulletMessage)

if SERVER then
  local bDrawDebug = cvars.bool("sv_debug_bullet_traces")

  local function doServerBullet(entAttacker, entWeapon, vecFrom, vecTo, fAngle, vecNormal, fixtureHit, iDamage, fForce)
    local entHit = nil
    if fixtureHit then
      local bodyHit = fixtureHit:getBody()
      local vecForce = geom.vec2(fForce,0)
      vecForce:setTheta(math.deg(fAngle))
      bodyHit:applyForce(vecForce, vecTo)
      local entHit = bodyHit:getUserData() -- TODO: verify
      
      if entHit and entHit ~= entAttacker then
        if ents.isClass(entHit,"char_base",true) then
          local vecToNew = vecTo:clone()
          vecToNew:subLocal(vecFrom):mulLocal(2):addLocal(vecFrom)
          local scanLine = geom.line(vecFrom.x,vecFrom.y,vecToNew.x,vecToNew.y)
          if entHit.skeleton then
            local limbs = entHit.skeleton:getLimbs()
            local limb
            local shape
            for i=1,limbs.length,1 do
              limb = limbs[i]
              if not limb.physicsDisabled then  --TODO this line is a hack to make sure we're not hitting some face feature, hair, clothes item, accessory, etc
                shape = limb:getTransformed(limb:getSprite():getOutlineShape(false))
                if shape:intersects(scanLine) then
                  -- Broadcast blood out to clients
                  local linearVelocity = geom.vec2(16)
                  linearVelocity:setTheta(math.deg(fAngle))
                  if (entHit:isAlive()) then
                    combat_effects.sv_blood_bullet(limb:getSprite().position:clone(), linearVelocity, color.RED:darker(0.2), entHit)
                  else
                    combat_effects.sv_blood_bullet(vecTo, linearVelocity, color.RED:darker(0.2), entHit)
                  end
                  break
                end
              end
            end
          end
          entHit:takeDamage(iDamage, entAttacker, entWeapon)
        else
          entHit:takeDamage(iDamage, entAttacker, entWeapon)
        end
      end
    end
    
    -- Broadcast it out to clients
    local data = net.data()
    data:writeEntityID(entAttacker)
    data:writeEntityID(entWeapon)
    data:writeVec2(vecFrom)
    data:writeVec2(vecTo)
    data:writeEntityID(entHit)
    data:writeBool(bDrawDebug or false)
    net.sendMessage(MSG_BULLET, data)
  end
  
  local entAttacker_temp = nil
  local entWeapon_temp = nil
  local vecFrom_temp = geom.vec2()
  local fAngle_temp = 0
  local iDamage_temp = 0
  local fForce_temp = 0
  local traceResult = nil
  
  local function isShotThrough(fixtureHit, entAttacker)
    local bodyHit = fixtureHit:getBody()
    if (bodyHit) then
      local entHit = bodyHit:getUserData()
      if (entHit) then
        return entHit == entAttacker or entHit.platform
      end
    end
    return false
  end
  
  local funcBulletRayCastCallback = function(fixtureHit, vecPoint, vecNormal, fFraction)
    if (isShotThrough(fixtureHit, entAttacker_temp)) then
      --traceResult = nil
      return -1
    else
      traceResult = {}
      traceResult.fFraction = fFraction
      traceResult.fixtureHit = fixtureHit
      traceResult.vecPoint = vecPoint
      traceResult.vecNormal = vecNormal
      return fFraction
    end
  end
  
  function GM:fireBullet( entAttacker, entWeapon, vecFrom, fAngle, iDamage, fForce )
    entAttacker_temp = entAttacker
    entWeapon_temp = entWeapon
    vecFrom_temp = vecFrom
    fAngle_temp = fAngle
    iDamage_temp = iDamage or 0
    fForce_temp = fForce or 0
    
    local callback = phys.newRayCastCallback( funcBulletRayCastCallback )
    local vecTo = geom.vec2(BULLET_DISTANCE, 0)
    vecTo:setTheta(math.deg(fAngle))
    vecTo:addLocal(vecFrom)
    
    -- First check if the bullet is fired from within a hitable fixture. This is the first doServerBullet scenario
    local world = phys.getWorld()
    local fixtureInside = world:getFixtureAtPoint(vecFrom)
    if (fixtureInside and not isShotThrough(fixtureInside, entAttacker_temp)) then
      -- The starting point is inside fixture; fire server bullet from vecFrom to vecFrom, normal is 0,0
      doServerBullet( entAttacker_temp, entWeapon_temp, vecFrom_temp, vecFrom_temp, fAngle_temp, geom.vec2(), fixtureInside, iDamage_temp, fForce_temp )
      return
    end
    
    -- We got here if not fired from within a hitable fixture. This is the second doServerBullet scenario -- we do a trace
    traceResult = nil
    world:raycast(callback, vecFrom, vecTo:clone()) -- Fire the raycast; it will doServerBullet from within the callback
    if traceResult then
      doServerBullet( entAttacker_temp, entWeapon_temp, vecFrom_temp, traceResult.vecPoint:clone(), fAngle_temp, traceResult.vecNormal, traceResult.fixtureHit, iDamage_temp, fForce_temp )
      return
    end
    
    -- Trace did not hit anything; fire server bullet with length of BULLET_DISTANCE, normal is 0,0 and fixture hit is nil. This is the third doServerBullet scenario
    doServerBullet( entAttacker_temp, entWeapon_temp, vecFrom_temp, vecTo:clone(), fAngle_temp, geom.vec2(), nil, iDamage_temp, fForce_temp )
    
  end
  hook.ensureExists("fireBullet")

end
