--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:sv_initialize()
	ENT_BASE.sv_initialize( self )
	self.asdf = nil
end

function ENT:postMapLoad()
	ENT_BASE.postMapLoad( self ) -- Make sure this happens above pairs(self.sourceEnts)
	
	local listener = {}
	listener.beginContact = function(entFixture, otherFixture, contact)
		self:triggerTargets( otherFixture.m_body:getUserData() )
	end
	
	for k,source in pairs(self.sourceEnts) do
		if ents.isClass(source,"phys_base", true) then
			source:subscribePhysListener(listener)
		end
	end
	
end
