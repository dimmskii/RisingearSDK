--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)


function ENT:cl_initialize()
	ENT_BASE.cl_initialize( self )
	
	-- Phys
	self.bodyType = phys.BT_DYNAMIC
	self.material = materials.get("rope")
	self:createBody()
	
	-- Cosmetic
	self.renderable = renderables.fromShape(geom.line(self.position.x,self.position.y,self.endPosition.x,self.endPosition.y))
	self.renderable:setDepth(self.depth)
  self.renderable:setOutlineColor(self.color)
  self.renderable:setOutlineWidth(self.width)
  self.renderable:setOutlineWidthWorld(true)
	renderables.add(self.renderable)
	
end

function ENT:cl_think(delta)
  ENT_BASE.cl_think(self,delta)
  if not self.bodies then return end
  local body = self.bodies[1]
  if body then
    body:setTransform( self.position, body:getAngle() )
    body:setLinearVelocity(self.velocity)
  end
  
  body = self.bodies[table.getn(self.bodies)]
  if body and body ~= self.bodies[1] then
    body:setTransform( self.endPosition, body:getAngle() )
    body:setLinearVelocity(self.endVelocity)
  end
end

function ENT:cl_updateRenderable( delta )
  ENT_BASE.cl_updateRenderable(self,delta)
  self.renderable:setOutlineColor(self.color)
  
  local shape
  if self.bodies and table.getn(self.bodies) > 1 then
    shape = geom.path(self.position.x, self.position.y)
    local pos
    local n = table.getn(self.bodies)
    for i=2,n do
      if i==n then
        shape:lineTo(self.endPosition.x,self.endPosition.y)
      else
        pos = self.bodies[i]:getPosition()
        shape:lineTo(pos.x,pos.y)
      end
    end
  else
    shape = geom.line(self.position.x,self.position.y,self.endPosition.x,self.endPosition.y)
  end
  
  self.renderable:setShape(shape)
end

function ENT:setDepth( depth )
	self.depth = depth
	self.renderable:setDepth(self.depth)
end

function ENT:destroy()
	ENT_BASE.destroy(self)
	renderables.remove(self.renderable)
	
end

local listener = phys.createFixtureListener( {
	beginContact = function(_, selfFixture, otherFixture, contact)
	  contact:setEnabled(false)
	end
})

function ENT:createBody()
  local segNum = math.floor(self.length / self.segmentLength)
  local segLength = self.segmentLength + (self.length-segNum*self.segmentLength)/segNum
  local bod, jointDef
  
  local segVec = geom.vec2(0, segLength)
  segVec:setTheta(self.endPosition:sub(self.position):getTheta())
  local theta = segVec:getTheta()
  
  local w = self.width
  segNum = math.floor(segNum*0.8)
  for i=1,segNum do
    bod = phys.createBody(self.bodyType,self)
    local fix = phys.addBoxFixtureToBody(bod, self.material, -w/2, 0, w, segLength, self)
    fix:addListener( listener )
    bod:setTransform( self.position:add(segVec:mul((i-1))), math.rad(theta + 180) )
    bod:setGravityScale(0)
    
    self.bodies[i] = bod
    
    if i>1 then
      jointDef = phys.newRevoluteJointDef()
      jointDef:initialize(self.bodies[i-1], bod, self.position:add(segVec:mul((i-1))))
      jointDef.localAnchorA = geom.vec2(0,segLength)
      phys.getWorld():createJoint(jointDef)
    end
  end
end
-- TODO: set userdata to self on all these joints we've been making. Needs additional parameter in phys.new*JointDef() funcs

--function ENT:setOutlineColor( colOutline )
--	self.outlineColor = colOutline
--	self.renderable:setOutlineColor(colOutline)
--end
--
--function ENT:setOutlineWidth( fWidth )
--	self.outlineWidth = fWidth
--	self.renderable:setOutlineWidth(fWidth)
--end
