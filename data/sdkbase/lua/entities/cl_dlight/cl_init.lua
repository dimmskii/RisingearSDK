--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:cl_initialize()
	ENT_BASE.cl_initialize( self )
	
	self.sprite = sprites.create()
	self.sprite:addTexture("common/grad_alpha_radial.png")
	self.sprite:setPlaying(false)
	self:cl_updateLightSprite()
	
	self.renderable = renderables.fromSprite( self.sprite )
	self.renderable:setBlendMode(renderables.BLEND_NONE)
	self.renderable:setLightMode(renderables.LIGHT_EMIT)
	renderables.add(self.renderable)
	
	if self.lifeTime >= 0 then
		self.timer = timer.create(self.lifeTime,1,function() ents.remove(self) end,true,true)
	end
	
	self.radius_initial = self.radius
end

function ENT:cl_updateLightSprite()
	self.sprite.width = self.radius/2
	self.sprite.height = self.radius/2
	self.sprite:centerOrigin()
	self.sprite.position:set(self.position)
	self.sprite.color = self.color
end

local ENT_BASE_cl_think = ENT_BASE.cl_think
function ENT:cl_think(delta)
	ENT_BASE_cl_think(self,delta)
	
	if not self.timer then return end
	--self.radius = (self.radius_initial + self.radius_initial * math.sqrt(timer.timeleft(self.timer) / self.lifeTime)) / 2
	local x = (self.lifeTime - timer.timeleft(self.timer)) / self.lifeTime
	self.radius = (1-math.abs(x-0.25)) * self.radius_initial
	self:cl_updateLightSprite()
end

function ENT:destroy()
	ENT_BASE.destroy(self)
	if not self.renderable then return end -- TODO add this line in many more renderable using entities
	renderables.remove(self.renderable)
end