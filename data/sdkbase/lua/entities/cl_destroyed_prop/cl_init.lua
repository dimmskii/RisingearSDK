--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:cl_initialize()
	ENT_BASE.cl_initialize(self)
	
	self.material = materials.get(self.materialID)
	
	self.shapes = {}
	self.bodies = {}
	self.renderables = {}
	self.sprites = {}
	self.shapeRenderables = {}
	self.timeLeft = self.lifeTime
	
	self:create()
end

function ENT:create()
	if not self.sprite or not self.material then return end
	
	local polygon = self.sprite:getOutlineShape():getPointsAsPolygon():subdivide()
	
	local decomp = polygon:getDecomposition()
	for i=1,decomp.length,1 do
		-- Create the shapes, sprites and theyre renderables
		self.shapes[i] = decomp[i]
		local sprite = self.sprite:clone()
		self.sprites[i] = sprite
		local renderable = renderables.fromSprite(self.sprites[i])
		local shapeRenderable = renderables.fromShape(self.shapes[i])
		shapeRenderable.fillColor = color.WHITE
		shapeRenderable.outlineColor = color.fromRGBAf(0,0,0,0)
		renderable:setStencil(shapeRenderable)
		renderables.add(renderable)
		self.shapeRenderables[i] = shapeRenderable
		self.renderables[i] = renderable
		
		-- Create the physics body
		local body = phys.createBody(phys.BT_DYNAMIC)
		body:setUserData(self)
		local fixtures = phys.addShapeFixtureToBody( body, self.material, decomp[i] )
		for k,v in pairs(fixtures) do
			v:setUserData(self)
		end
		body:setTransform(self.position, self.angle)
		--body:applyForce(geom.vec2(-100+math.random()*200, -100+math.random()*200), polygon:getCenter())
		body:setLinearVelocity(geom.vec2(-10+math.random()*20, -10+math.random()*20))
		self.bodies[i] = body
		
	end
end

local ENT_BASE_cl_think = ENT_BASE.cl_think
local rend
local spr
function ENT:cl_think(delta)
	
	for i=1,table.getn(self.shapes),1 do
		local shape = self.shapes[i]
		local pos = self.bodies[i]:getPosition()
			-- Move sprite
			spr = self.sprites[i]
			spr.position:set(pos)
			spr.angle = self.bodies[i]:getAngle()
			spr.color = color.fromRGBAf(spr.color:getRed(),spr.color:getGreen(),spr.color:getBlue(), self.timeLeft / self.lifeTime)
			
			-- Transform the stencil shape
			local t = geom.rotateTransform(self.bodies[i]:getAngle(),pos.x,pos.y):concatenate( geom.translateTransform(pos.x,pos.y) )
			shape = shape:transform(t)
		
		rend = self.shapeRenderables[i]
		rend.shape = shape
	end
	
	self.timeLeft = self.timeLeft - delta
	if self.timeLeft <=0 then
		ents.remove(self)
	end
	
	ENT_BASE_cl_think(self, delta)
end

function ENT:destroy()
	-- Destroy bodies
	for _,v in pairs(self.bodies) do
		phys.destroyBody(v)
	end
	for _,v in pairs(self.renderables) do
		renderables.remove(v)
	end
	ENT_BASE.destroy(self)
end
