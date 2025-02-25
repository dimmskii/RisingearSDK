--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:cl_initialize()
	ENT_BASE.cl_initialize( self )
end

function ENT:cl_onJoin( )
	ENT_BASE.cl_onJoin( self )
	self:updateSourceEnts()
	self:updateTargetEnts()
end

function ENT:cl_think(fDelta)
	ENT_BASE.cl_think( self, fDelta )
	
	if EDITOR then return true end
	
	if not self.targetEnts then return end
	
	for _,target in ipairs(self.targetEnts) do
		if target.renderable then
			target.renderable:setVisible(true)
		end
	end
	
	local clientEnt = localClient().ent
	if clientEnt and clientEnt.valid then
		local vecCenter = clientEnt:getOutlineShape():getCenter()
		for _,source in ipairs(self.sourceEnts) do
			if source:getOutlineShape():contains(clientEnt.position.x,clientEnt.position.y) then
				for _,target in ipairs(self.targetEnts) do
					if target.renderable then
						target.renderable:setVisible(false)
					end
				end
				break
			end
		end
	end
end

