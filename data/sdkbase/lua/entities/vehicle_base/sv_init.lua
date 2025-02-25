--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:sv_initialize()
	ENT_BASE.sv_initialize( self )
	self:createBody()
	local fixtures = phys.addShapeFixtureToBody(self:getBody(), self.material, self:getStaticOutlineShape())
	for _,v in ipairs(fixtures) do
		self:applyDefaultFixtureListener( v )
		v:setUserData( self )
	end
end

function ENT:beginContact(selfFixture, otherFixture, contact)
	ENT_BASE.beginContact(self, selfFixture, otherFixture, contact)
	if (contact:isEnabled()) then
--		if not (self.soundGroupDef) then return end
--		if not (self.soundGroupDef.doContactSound) then return end
		phys_sounds.doContactSound(selfFixture, otherFixture, contact)
	end
end
