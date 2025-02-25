--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT.lifeTime = 4			-- life time in seconds
ENT.directHitDamage	= 6	-- HP to take away from characters directly hit

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()

	self.sprite = sprites.create()
	self.sprite.width = 0.25
	self.sprite.height = 0.06
	self.sprite:centerOrigin()
	self.sprite:setPlaying(false)
	self.sprite:addTexture("weapons/projectiles/syringe.png")
	
	timer.simple( self.lifeTime, function() ents.remove(self) end )
	
	ENT_BASE.initialize( self )
	
	self.platformConscious = true
end

if SERVER then
	local phys_util = include("/entities/phys_base/physutil.lua")
	function ENT:sv_initialize()
		ENT_BASE.sv_initialize( self )
		self.armed = true -- Whether or not this thing gives out damage. Armed gets set to false on first collision
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
       bod:setBullet(true)
     end
  end
	
	function ENT:beginContact(selfFixture, otherFixture, contact)
		if phys_util.fixtureIsPlatform(otherFixture) then
			contact:setEnabled(false)
			return
		end
		local entHit = otherFixture:getBody():getUserData()
		if (entHit and entHit.valid) then
			if ents.isClass(entHit,"char_base",true) then
				if (self.armed and entHit ~= self.owner and GAMEMODE:characterAcceptDamage(entHit,self.owner,self)) then -- entRecipient, entAttacker, entDamager
					entHit:takeDamage(self.directHitDamage,self.owner,self) -- iDmg, entAttacker, entDamager
					ents.remove(self)
				else
					contact:setEnabled(false)
					return
				end
			else
        self.armed = false
			end
		end
	end
elseif CLIENT then
	function ENT:cl_initialize()
		ENT_BASE.cl_initialize( self )
		
		self.renderable = renderables.fromSprite(self.sprite)
		
		renderables.add(self.renderable)
	end
	
	function ENT:destroy()
		ENT_BASE.destroy(self)
		
		renderables.remove(self.renderable)
	end
end

function ENT:getStaticOutlineShape()
	return self.sprite:getOutlineShape(false)
end
