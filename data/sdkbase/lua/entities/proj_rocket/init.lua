--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT.lifeTime = 20			-- life time in seconds
ENT.directHitDamage	= 80	-- HP to take away from characters directly hit

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()

	self.sprite = sprites.create()
	self.sprite.width = 0.3
	self.sprite.height = 0.15
	self.sprite:centerOrigin()
	self.sprite:setPlaying(false)
	self.sprite:addTexture("weapons/projectiles/rocket.png")
	
	timer.simple( self.lifeTime, function() ents.remove(self) end )
	
	ENT_BASE.initialize( self )
	
	self.platformConscious = true
end

if SERVER then
	local phys_util = include("/entities/phys_base/physutil.lua")
	function ENT:sv_initialize()
		ENT_BASE.sv_initialize( self )
		self.material = materials.get("metal")
		self:createBody()
		local fixtures = phys.addShapeFixtureToBody(self:getBody(), self.material, self:getStaticOutlineShape())
		for _,v in pairs(fixtures) do
			self:applyDefaultFixtureListener( v )
		end
	end
	
	function ENT:createBody()
	   ENT_BASE.createBody( self )
	   
	   local bod = self:getBody()
	   if bod then
	     bod:setGravityScale(0)
	     bod:setBullet(true)
	   end
	end
	
	function ENT:beginContact(selfFixture, otherFixture, contact)
      ENT_BASE.beginContact(self,selfFixture,otherFixture,contact)
      
      local entHit = otherFixture:getBody():getUserData()
      local charDirectDmg
      if (entHit and entHit.valid) then
        if ents.isClass(entHit,"char_base",true) then
          if not (entHit ~= self.owner and GAMEMODE:characterAcceptDamage(entHit,self.owner,self)) then -- entRecipient, entAttacker, entDamager
            contact:setEnabled(false)
            return
          else
            charDirectDmg = entHit
          end
        end
      end
      
      if contact:isEnabled() then
        if charDirectDmg then
          charDirectDmg:takeDamage(self.directHitDamage,self.owner,self) -- iDmg, entAttacker, entDamager
        end
      
        ents.remove(self)
        
        local ent = ents.create("env_explosion",false)
        ent:setPosition(self.position:clone())
        ent.owner = self.owner
        ent.radius=4.5
				ent.effectRadius = 2.5
				ent.force = 1650
				ent.damage = 60
        ents.initialize(ent)
      end
	end
	
  function ENT:sv_think( delta )
     ENT_BASE.sv_think( self, delta )
     
     self:setAngle(math.rad(self.velocity:getTheta()))
  end
	
elseif CLIENT then
	function ENT:cl_initialize()
		ENT_BASE.cl_initialize( self )
		
		self.glowSpr = sprites.create()
    self.glowSpr.width = 2
    self.glowSpr.height = 1.5
    self.glowSpr:setPlaying(false)
    self.glowSpr:addTexture("common/grad_alpha_radial.png")
    self.glowSpr:centerOrigin()
    self.glowSpr:setColor(color.fromRGBAf(1,0.75,0.6,0.5))
		
		local glowRend = renderables.fromSprite(self.glowSpr)
		local rocketRend = renderables.fromSprite(self.sprite)
		
		self.renderable = renderables.composite(glowRend, rocketRend)
		self.renderable:setDepth(self.depth)
		--self.renderable:setBlendMode(renderables.BLEND_NONE)
		self.renderable:setLightMode(renderables.LIGHT_EMIT)
		renderables.add(self.renderable)
		
		-- Init fly sound
		self.soundFly = audio.sound("weapons/projectiles/rocket_fly.wav")
		self.soundFly:loopAt(1,1,self.position.x, self.position.y, 0, 8)
	end
	
	function ENT:cl_think( delta )
  	 ENT_BASE.cl_think( self, delta )
  	 if self.glowSpr then
  	   self.glowSpr.position = self.position:clone()
  	   self.glowSpr.angle = math.rad(self.velocity:getTheta())
  	 end
  	 
  	 -- Update fly sound
  	 if self.soundFly then
  	   self.soundFly:setLocation(self.position.x, self.position.y, 0)
  	 end
	end
	
	function ENT:destroy()
		ENT_BASE.destroy(self)
		
		renderables.remove(self.renderable)
		
		-- Stop fly sound
		self.soundFly:stop()
	end
end

function ENT:getStaticOutlineShape()
	return self.sprite:getOutlineShape(false)
end
