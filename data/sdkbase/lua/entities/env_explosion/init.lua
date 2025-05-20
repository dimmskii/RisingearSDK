--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

local texExplod = textures.get("sfx/explod01.png")

function ENT:initialize()
  self:initProperty("effectRadius", 2.5)
  
  self:initProperty("force", 2250)
  self:initProperty("damage", 100)

  ENT_BASE.initialize( self )
  
  self.sprite = sprites.create()
  self.sprite.width = self.effectRadius * 2
  self.sprite.height = self.effectRadius * 2
  self.sprite:centerOrigin()
  self.sprite:addTexture(texExplod)
  self.sprite.cellNumX = 8
  self.sprite.cellNumY = 6
  self.sprite.frameNum = 48
  self.sprite.cellWidth = 256
  self.sprite.cellHeight = 256
  self.sprite.position = self.position:clone()
  self.sprite:setPlaying(true)
  self.sprite:setAnimationToFullLength()
  self.sprite:setAnimType(sprites.ANIM_STOP_ON_LAST)
  self.sprite:setFrameDelay(10)
  
  if CLIENT then
    self.renderable = renderables.fromSprite(self.sprite)
    self.renderable:setLightMode(renderables.LIGHT_EMIT)
    renderables.add(self.renderable)

		-- Create dynamic light client ent
		local dlight = ents.create("cl_dlight",false)
		dlight.color = color.fromRGBAf(1,0.9,0.5,0.7)
		dlight.position = self.position:clone()
		dlight.radius = 18
		dlight.lifeTime = 0.3
		ents.initialize(dlight)
  end
end

function ENT:getStaticOutlineShape()
	return geom.circle(0,0,self.radius)
end

if SERVER then
	
	function ENT:sv_initialize()
		ENT_BASE.sv_initialize( self )
		
		-- Emit sounds
		sndeffect.emit( "env/explod01c.wav", self.position.x, self.position.y, 20, 1.0 ) -- Close sound
    sndeffect.emit( "env/explod01d.wav", self.position.x, self.position.y, 100, 0.8 ) -- Distant sound
    
    self:scanAndDamageTargets()
    
    -- Do physics
--    local bod = phys.getWorld():getBodyList()
--    local vecDist, fDist, fMul, vecForce, vecWorldCenter, userData
--    while bod ~= nil do
--      userData = bod:getUserData()
--      if userData ~= self and bod:getType() == phys.BT_DYNAMIC then
--        vecWorldCenter = bod:getWorldCenter()
--        vecDist = vecWorldCenter:sub(self:getPosition())
--        fDist = vecDist:len()
--        if fDist < self.forceRadius then
--          -- Calculate falloff
--          fMul = (self.forceRadius-fDist) / self.forceRadius
--          
--          if type(userData)=="table" and type(userData.bodies)=="table" then fMul = fMul/table.getn(userData.bodies) end -- This line of code spreads out the force if an ent has multiple bodies TODO: is this appropriate?
--          
--          -- Calculate the resulting vec force
--          vecForce = vecDist:clone()
--          vecForce:normalize()
--          vecForce:mulLocal(self.force * fMul)
--          if userData == self.owner then vecForce:mulLocal(4) end -- Self rocket jump amplifier code
--          bod:applyLinearImpulse(vecForce, vecWorldCenter, true)
--        end
--      end
--      bod = bod:getNext()
--    end
    
    -- Time self-removal
    timer.simple(1,function()
      ents.remove(self)
    end)
	end
	
	function ENT:scanAndDamageTargets()
		
		
		local bodiesHit = {}
		local entitiesHit = {}
		
			-- Query world
		local world = phys.getWorld()
		world:queryAABB(phys.newQueryCallback(function(fixture)
			if fixture then
				local bodyHit = fixture:getBody()
				local entityHit = bodyHit:getUserData()
				if not entityHit or not entityHit.valid then entityHit = nil end
				if not table.hasValue(bodiesHit,bodyHit) and not (entityHit and table.hasValue(entitiesHit,entityHit)) then
					local v1,v2
					v1 = self.position:clone()
					v2 = bodyHit:getWorldCenter()
					local vecForce = v2:sub(v1)
					local d = math.min(vecForce:len(), self.radius)
					vecForce:normalize()
					vecForce:mulLocal(self.force * math.min( (self.radius-d)/self.radius , 1))
					if bodyHit:getUserData() == self.owner then vecForce:mulLocal(11) end -- Self rocket jump amplifier code
					bodyHit:applyLinearImpulse(vecForce, v2, true)
					table.insert(bodiesHit,bodyHit)
					table.insert(entitiesHit, entityHit)
				end
			end
			return true -- continue query
		end), phys.newAABB(  geom.vec2(self.outlineShape:getMinX(),self.outlineShape:getMinY()),  geom.vec2(self.outlineShape:getMaxX(),self.outlineShape:getMaxY()) ))
		
		local entitiesHit = {}
		
		-- Go through list 
		for k,bodyHit in pairs(bodiesHit) do
			local entHit = bodyHit:getUserData() -- TODO: verify
			if entHit and entHit.valid and entHit ~= self.owner then
				if not table.hasValue(entitiesHit,entHit) then
					table.insert(entitiesHit,entHit)
				end
			end
--			
--			vecForce:normalize()
--			vecForce:mulLocal(self.force)
--			bodyHit:applyForceToCenter(vecForce)
--			entHit:takeDamage(self.damage, self.equipped, self)
--			if ents.isClass(entHit,"char_base",true) then
--				combat_effects.sv_blood_bullet(self.position, geom.vec2(), color.RED:darker(0.2), entHit)
--				entHit:dismember( bodyHit )
--			end
		end
		
		for k,entHit in pairs(entitiesHit) do
			entHit:takeDamage(self.damage, self.equipped, self)
			if ents.isClass(entHit,"char_base",true) then
				combat_effects.sv_blood_bullet(self.position, geom.vec2(), color.RED:darker(0.2), entHit)
			end
		end
		
	end
  
elseif CLIENT then

  function ENT:destroy()
    ENT_BASE.destroy(self)
    renderables.remove(self.renderable)
  end

end

function ENT.persist( thisClass )
  ENT_BASE.persist( thisClass )
    
  ents.persist(thisClass, "effectRadius", {
    write=function(field, data) data:writeFloat(field) end,
    read=function(data) return data:readNext() end,
    dirty=function() return false end,
  }, ents.SNAP_NET)
  
end