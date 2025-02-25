--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.pickupSound = nil

local tRenderables = {}

function ENT:cl_createRenderable( spr )
	local rend = ENT_BASE.cl_createRenderable(self,spr)
	tRenderables[self.id] = rend --ID key hack so we know which renderable to remove later. ID for entities is guaranteed to be unique across client and server range; renderalbes have a 1-1 relationship with this entity
end

local ENT_BASE_cl_think = ENT_BASE.cl_think
function ENT:cl_think( delta )
	ENT_BASE_cl_think(self, delta)
end


function ENT:destroy()
	ENT_BASE.destroy(self)
	
	if self.pickupSound then
		self.pickupSound:playAt(1,1,self.position.x,self.position.y,0,15)
	end
	
	tRenderables[self.id] = nil
end

local trueFalse = false
timer.create(0.2,-1,function()
	
	for k,v in pairs(tRenderables) do
		if trueFalse then
			v:setLightMode(renderables.LIGHT_EMIT)
		else
			v:setLightMode(renderables.LIGHT_NONE)
		end
	end
	trueFalse = not trueFalse
end,true,false)