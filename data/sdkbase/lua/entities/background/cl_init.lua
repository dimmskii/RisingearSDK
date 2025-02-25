--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:cl_initialize()
	ENT_BASE.cl_initialize( self )
	
	self.renderable = renderables.fromSprite(self.sprite)
	self.stencilRenderable = renderables.composite()
	
	self.renderable:setDepth(self.depth)
	self.renderable:setBlendMode(self.blendMode)
	self.renderable:setLightMode(self.lightMode)
	self.renderable:setLit(self.lit)
	
	renderables.add(self.renderable)
	
	self:updateStencilEnts(self.stencilEntsTag)
	
end

function ENT:updateStencilEnts(stencilEntsTag)
	self.stencilEntsTag = stencilEntsTag or self.stencilEntsTag
	if (self.stencilEntsTag == nil or self.stencilEntsTag == "") then
		self:updateStencilRenderable()
		return
	end
	self.stencilEnts = ents.findByTag(self.stencilEntsTag)
	self:updateStencilRenderable()
end

local function onJoinGame()
	for k,v in pairs(ents.getAll("background")) do
		v:updateStencilEnts()
	end
end

hook.add("onJoinGame", "backgrounds_onJoinGame", onJoinGame)

function ENT:updateStencilRenderable()
	self.stencilEnts = self.stencilEnts or {}
	if (self.stencilEntsTag == nil or self.stencilEntsTag == "") then
		self.renderable:removeStencil()
		return
	end
	self.stencilRenderable:clearRenderables()
	for k,v in pairs(self.stencilEnts) do
		if (v.renderable) then
			self.stencilRenderable:addRenderable(v.renderable)
		elseif (v.outlineShape) then
			local shapeRend = renderables.fromShape(v.outlineShape)
			shapeRend.fillColor = color.WHITE
			shapeRend.outlineColor = color.TRANSPARENT
			self.stencilRenderable:addRenderable(shapeRend)
		end
	end
	self.renderable:setStencil(self.stencilRenderable)
end

function ENT:destroy()
	ENT_BASE.destroy(self)
	renderables.remove(self.renderable)
	
end