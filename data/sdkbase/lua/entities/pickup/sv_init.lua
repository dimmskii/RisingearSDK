--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:sv_initialize()
	ENT_BASE.sv_initialize( self )
end

function ENT:beginContact(selfFixture, otherFixture, contact)
	
	local otherEnt = otherFixture.m_body:getUserData()
	if otherEnt and otherEnt.valid and ents.isClass( otherEnt, "char_base", true ) then
		if otherEnt:canPickUp( self ) then
			self:onPickedUp( otherEnt )
			ents.remove( self )
		else
			contact:setEnabled(false) -- Characters walk through  
		end
	end
	
	ENT_BASE.beginContact(self, selfFixture, otherFixture, contact)
end

function ENT:onPickedUp( character )
	-- Override me
end
