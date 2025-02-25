physragdoll = {}
physragdoll.create = function(skeleton, bMirrored, vecOldVelocity, optCharOwner)
  
  local bodies = {}
  bodies[1] = 0 -- Will be used to hold place
  
  --create ragdoll limb bodies
  local limbs = skeleton:getLimbs()
--  skeleton:setAnimationPlay(skeletal.AP_STOP)
--  for i=1,limbs.length,1 do
--    limbs[i].angle = 0
--  end
  local mat = materials.get("flesh")
  local ragdoll = {}
  for i=1,limbs.length,1 do
    local limb = limbs[i]
    if (limb.physicsDisabled == false) then
      local root = false
      if not limb:getParent() then
        root = true
      end
      ragdoll[limb] = {}
      ragdoll[limb].initialAngle = limb.angle
      --limb.angle = 0
      --limb:update(1)
      local body = phys.createBody(phys.BT_DYNAMIC)
      if optCharOwner then body:setUserData(optCharOwner) end
      local spr = limb:getSprite()
      local outlineShape = spr:getOutlineShape(false)
      if (bMirrored) then
        -- If the char is mirrored (therefore the skeleton is also), we flip the shape horizontally with a scale transform
        local hflip = geom.scaleTransform(-1,1)
        outlineShape:transform(hflip)
      end
      local fixtures = phys.addShapeFixtureToBody( body, mat, outlineShape )
      for k,v in pairs(fixtures) do
        if optCharOwner then
          v:setUserData(optCharOwner)
          optCharOwner:applyDefaultFixtureListener( v )
        end
      end
      --body:setTransform( geom.vec2(spr.position.x, spr.position.y), limb.angle )
      body:setTransform( limb:getTransformedOrigin():toVec2(), limb.angle ) -- TODO why the diff. Ghost in the machine regarding either ragdoll:clone() or limb:clone() ?!
      
      ragdoll[limb].body = body
      
      if root then
        bodies[1] = body
      else
        table.insert(bodies,body)
      end
      
      -- Apply old linear velocity to limb
      body:setLinearVelocity(vecOldVelocity)
      -- Apply old angular velocity to limb (test)
      body:setAngularVelocity(limb:getAngularVelocity())
    end
  end
  
  for i=1,limbs.length,1 do
    local limb = limbs[i]
    if (limb.physicsDisabled == false) then
      local parent = limb:getParent()
      local ragLimb = ragdoll[limb]
      if (parent and parent.physicsDisabled == false) then -- TODO: parent.physicsDisabled is not a 100% CATCH-ALL! The cause behind it all: physics cannot be left enabled for any descendant of a physics-disabled limb
        local jointDef = phys.newRevoluteJointDef()
        jointDef:initialize(ragLimb.body, ragdoll[parent].body, limb:getSprite().position)
        --jointDef.referenceAngle = -limb.angle
        ragLimb.joint = phys.getWorld():createJoint(jointDef)
        local initialAngle = ragdoll[limb].initialAngle
        if bMirrored then
          ragdoll[limb].joint:setLimits(limb.physicsMinAngle + initialAngle,limb.physicsMaxAngle + initialAngle)
        else
          ragdoll[limb].joint:setLimits(limb.physicsMinAngle + initialAngle,limb.physicsMaxAngle + initialAngle)
        end
        ragLimb.joint:enableLimit(true)
      end
    end
  end
  
  return bodies, ragdoll
end