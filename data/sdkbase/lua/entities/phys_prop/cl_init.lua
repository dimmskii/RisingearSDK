--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:cl_initialize()
	ENT_BASE.cl_initialize( self )
	
	self:cl_createRenderable(self.sprite)
end

function ENT:cl_createRenderable( spr )
	if not spr then return end
	if self.renderable then renderables.remove(self.renderable) end
	
	self.renderable = renderables.fromSprite( spr )
	renderables.add(self.renderable)
	
	return self.renderable
end

function ENT:destroy()
	ENT_BASE.destroy(self)
	
	renderables.remove(self.renderable)
end