--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)


function ENT:cl_initialize()
	ENT_BASE.cl_initialize( self )
	
	self.renderable = renderables.fromShape(self:getOutlineShape())
	
	self.renderable:setDepth(self.depth)
	self.renderable:setOutlineColor(self.outlineColor)
	self.renderable:setFillColor(self.fillColor)
	self.renderable:setOutlineWidth(self.outlineWidth)
	
	if self.addedToRendererList then
		renderables.add(self.renderable)
	end
	
end

function ENT:cl_updateRenderable( delta )
  ENT_BASE.cl_updateRenderable(self,delta)
	self.renderable:setOutlineColor(self.outlineColor)
	self.renderable:setFillColor(self.fillColor)
end

function ENT:setDepth( depth )
	self.depth = depth
	self.renderable:setDepth(self.depth)
end

function ENT:destroy()
	ENT_BASE.destroy(self)
	renderables.remove(self.renderable)
	
end


function ENT:setOutlineColor( colOutline )
	self.outlineColor = colOutline
	self.renderable:setOutlineColor(colOutline)
end

function ENT:setFillColor( colFill )
	self.fillColor = colFill
	self.renderable:setFillColor(colFill)
end

function ENT:setOutlineWidth( fWidth )
	self.outlineWidth = fWidth
	self.renderable:setOutlineWidth(fWidth)
end

function ENT:setAddedToRenderList( bAdded )
	self.addedToRenderList = bAdded
	if (bAdded) then
		renderables.add(self.renderable)
	else
		renderables.remove(self.renderable)
	end
end