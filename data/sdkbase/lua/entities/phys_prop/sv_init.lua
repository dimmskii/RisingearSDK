--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

local SOUND_COOLDOWN = 0.2 -- In secs
local SOUND_MAX_COUNT = 2 -- Per cooldown

function ENT:sv_initialize()
	ENT_BASE.sv_initialize( self )
	self:createBody()
	
	local fixtures = phys.addShapeFixtureToBody(self:getBody(), self.material, self:getStaticOutlineShape(), self)
	for _,v in pairs(fixtures) do
		self:applyDefaultFixtureListener( v )
	end
	-- Sound stuff
	self.soundCount = 0 -- To keep track of how many sounds emitted
	
	self.soundCooldown = 0
end


local ENT_BASE_beginContact = ENT_BASE.beginContact
function ENT:beginContact(selfFixture, otherFixture, contact)
	ENT_BASE_beginContact(self, selfFixture, otherFixture, contact)

	if self.soundCount > SOUND_MAX_COUNT then return end
	
	if (contact:isEnabled()) then
--		if not (self.soundGroupDef) then return end
--		if not (self.soundGroupDef.doContactSound) then return end
		phys_sounds.doContactSound(selfFixture, otherFixture, contact)
		self.soundCount = self.soundCount+1
		self.soundCooldown = SOUND_COOLDOWN
	end
end

local ENT_BASE_sv_think = ENT_BASE.sv_think
function ENT:sv_think(delta)
	ENT_BASE_sv_think(self,delta)
	
	if self.soundCooldown <= 0 then
		self.soundCount = 0
	else
		self.soundCooldown = self.soundCooldown - delta
	end
end


function ENT:takeDamage( iDamage, entAttacker, entDamager )
	if self.soundCount > SOUND_MAX_COUNT then return end
  phys_sounds.doSound( self, phys_sounds.SND_IMPACT_HIGH, iDamage )
  self.soundCount=self.soundCount+1
  self.soundCooldown = SOUND_COOLDOWN
  
  if self.destructible then
  	self.health = self.health - iDamage
  	if self.health <= 0 then
  		self:quebrar()
  	end
  end
end

function ENT:quebrar() -- Because  break is a keyword in lua outside of comments
	-- Create client-side breaking effect ent
	local e = ents.create("cl_destroyed_prop", false)
	e.materialID = self.definition.material
	e.position = self.position
	e.angle = self.angle
	e.sprite = self.sprite:clone()
	e.depth = self.depth
	ents.initialize(e)
	
	-- Play break sound effect
	phys_sounds.doSound( self, phys_sounds.SND_BREAK, 2 )
	
	-- Destroy self
	timer.simple( 0.001, function() ents.remove(self) end)  -- TODO: put this in a _G.next_update() function we make
end
