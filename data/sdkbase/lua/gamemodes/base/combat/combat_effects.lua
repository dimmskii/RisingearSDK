--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local t = {}

local function processBloodMessage(sender, data)
  if CLIENT then
    local vecPos = data:readNext()
    local linearVelocity = data:readNext()
    local color = data:readNext()
    local entCharacter = ents.findByID(data:readNext())
    combat_effects.createBloodSpatter(vecPos, linearVelocity, color, entCharacter)
  end
end

t.MSG_BLOOD = net.registerMessage("blood", processBloodMessage)

if CLIENT then

  -- TRACERS
  
  local TRACER_SPEED = 400 -- m/s
  local TRACER_LENGTH = 12 -- m
  local TRACER_WIDTH = 2.5
  local TRACER_COLOR = color.fromRGBAf(1,0.85,0.6,0.2)
  
  local tracerList = {} -- The list of existing client-sided tracers
  
  local vecToNew = geom.vec2() -- Allocate vector once
  t.createBulletTracer = function(vecFrom, vecTo)
  	local tracer = {}
  	tracer.vecFrom = vecFrom
  	tracer.vecTo = vecTo
  	tracer.distance = vecTo:sub(vecFrom):length()
  	tracer.distTravelled = 0
  	vecToNew:set(tracer.vecTo):subLocal(tracer.vecFrom):normalize()
  	vecToNew:mulLocal(math.min(tracer.distTravelled + TRACER_LENGTH,tracer.distance)):addLocal(vecFrom)
  	tracer.lineShape = geom.line(vecFrom.x,vecFrom.y,vecToNew.x,vecToNew.y)
  	tracer.renderable = renderables.fromShape(tracer.lineShape)
  	tracer.renderable.outlineColor = TRACER_COLOR
  	tracer.renderable.outlineWidth = TRACER_WIDTH
  	tracer.renderable:setBlendMode(renderables.BLEND_ADD)
  	tracer.renderable:setLightMode(renderables.LIGHT_EMIT)
  	renderables.add(tracer.renderable)
  	table.insert(tracerList,tracer)
  end
  
  local vec1 = geom.vec2() -- Allocate vector once
  local vec2 = geom.vec2() -- Allocate vector once
  local function updateTracers(delta)
  	local newTracerList = {} -- The swap tracer list: upon updating tracers, only surviving ones for next update will be added here; ones not added will be discardeda
  	for _,tracer in ipairs(tracerList) do
  		tracer.distTravelled = tracer.distTravelled + TRACER_SPEED * delta
  		if tracer.distTravelled >= tracer.distance + TRACER_LENGTH then -- Bullet reached its ultimate destination
  			renderables.remove(tracer.renderable) -- Remove the tracer's renderable ; do not add it to swap list
  		else
  			table.insert(newTracerList,tracer) -- Don't remove renderable ; add it to swap list so it may live until next update
  		end
  		vec1:set(tracer.vecTo):subLocal(tracer.vecFrom):normalize()
  		vec1:mulLocal(math.max( math.min(tracer.distTravelled - TRACER_LENGTH,tracer.distance), 0 )):addLocal(tracer.vecFrom)
  		vec2:set(tracer.vecTo):subLocal(tracer.vecFrom):normalize()
  		vec2:mulLocal(math.min(tracer.distTravelled,tracer.distance)):addLocal(tracer.vecFrom)
  		tracer.lineShape:set(vec1,vec2)
  	end
  	tracerList = newTracerList -- Swap out the old list for new one containing only the tracers that are still alive
  	
  end
  hook.add("update", "cl__eff_update_tracers", updateTracers)
  
  
  
  
  -- BLOOD SPLATTERS
  
  local BLOOD_PARTICLE_FLAGS = phys.PT_WATER
  local BLOOD_PARTICLE_GROUP_FLAGS = 1
  local BLOOD_PARTICLE_STRENGTH = 1
  local BLOOD_PARTICLE_APPARENT_RADIUS = 0.04
  local BLOOD_LIFETIMESECS = 1.5
  local BLOOD_ALPHA = 1
  local BLOOD_SPATTER_LENGTH_MIN = 0.2
  local BLOOD_SPATTER_LENGTH_MAX = 0.8
  
  local spatterList = {} -- The list of existing client-sided spatters
  
  t.createBloodSpatter = function(vecPos, linearVelocity, col, entCharacter)
    local spatter = {}
     
    local shape = geom.polygon(geom.vec2(0,0),geom.vec2(math.random() * (BLOOD_SPATTER_LENGTH_MAX - BLOOD_SPATTER_LENGTH_MIN) + BLOOD_SPATTER_LENGTH_MIN,-0.08),geom.vec2(0.5,0.08))
    shape = shape:transform(geom.rotateTransform(math.rad(linearVelocity:getTheta()),0,0)):transform(geom.translateTransform(vecPos.x,vecPos.y))
    
    spatter.particleGroup = phys.createParticleGroup(shape, BLOOD_PARTICLE_FLAGS, BLOOD_PARTICLE_GROUP_FLAGS, BLOOD_PARTICLE_STRENGTH, true, 0, linearVelocity, col, entCharacter)
    
    spatter.renderable = renderables.fromParticleGroup(spatter.particleGroup)
    spatter.renderable.color = color.fromRGBAf(col:getRed(),col:getGreen(),col:getBlue(),BLOOD_ALPHA)
    spatter.renderable.radius = BLOOD_PARTICLE_APPARENT_RADIUS
    spatter.time = 0
    renderables.add(spatter.renderable)
    table.insert(spatterList,spatter)
  end
  
  local oldCol -- Once
  local function updateSpatters(delta)
    local newSpatterList = {} -- The swap spatter list: upon updating spatters, only surviving ones for next update will be added here; ones not added will be discarded
    for _,spatter in ipairs(spatterList) do
      spatter.time = spatter.time + delta
      if spatter.time >= BLOOD_LIFETIMESECS then -- Bullet reached its ultimate destination
        renderables.remove(spatter.renderable) -- Remove the spatters's renderable ; do not add it to swap list
        phys.getWorld():destroyParticlesInGroup(spatter.particleGroup)
      else
        table.insert(newSpatterList,spatter) -- Don't remove renderable ; add it to swap list so it may live until next update
        oldCol = spatter.renderable.color
        spatter.renderable.color = color.fromRGBAf(oldCol:getRed(),oldCol:getGreen(),oldCol:getBlue(),BLOOD_ALPHA * (1 - spatter.time / BLOOD_LIFETIMESECS))
      end
    end
    spatterList = newSpatterList -- Swap out the old list for new one containing only the spatters that are still alive
    
  end
  hook.add("update", "cl__eff_update_spatters", updateSpatters)
  
  
else --SERVER


  --- Broadcast blood effect which weapon bullet hits call
  t.sv_blood_bullet = function(vecPos, vecVel, color, entHit)
    local bloodData = net.data()
    bloodData:writeVec2(vecPos)
    bloodData:writeVec2(vecVel)
    bloodData:writeColor(color)
    bloodData:writeEntityID(entHit)
    net.sendMessage(combat_effects.MSG_BLOOD, bloodData)
  end

end

combat_effects = t
