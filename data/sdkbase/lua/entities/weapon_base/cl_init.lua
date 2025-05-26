--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:cl_think( delta )
	if self:isEquipped() then
		self.renderable:setVisible(false)
	else
		self.renderable:setVisible(true)
	end
	ENT_BASE.cl_think( self, delta )
end

function ENT:use( source )
	
end


local muzzleFlashCol = color.fromRGBAf(1,0.9,0.6,0.145)
function ENT:doFiredEffects()

		-- Create dynamic light client ent for muzzleflash
		local dlight = ents.create("cl_dlight",false)
		dlight.color = muzzleFlashCol
		if self.equipped then
			dlight.position = self.equipped:getMuzzlePos():clone()
		else
			dlight.position = self.position:clone()
		end
		dlight.radius = 25
		dlight.lifeTime = 0.12
		ents.initialize(dlight)


--	local vecMuzzlePos = self.equipped:getMuzzlePos()
--	local vecVelocity = self.equipped:getAimVecWorld:sub(vecMuzzlePos)
--	vecVelocity:normalize()
--	vecVelocity:mulLocal(20)
--	vecVelocity:addLocal(self.equipped:getVelocity())
--	local pg = phys.createParticleGroup( geom.circle(vecMuzzlePos.x,vecMuzzlePos.y,0.1), phys.PT_POWDER, 0, 1, true, 0, vecVelocity )
--	local rend = renderables.fromParticleGroup(pg)
--	renderables.add(rend)
--	
--	timer.simple(3,function()
--		phys.getWorld():destroyParticlesInGroup(pg)
--		renderables.remove(rend)
--	end)
end


