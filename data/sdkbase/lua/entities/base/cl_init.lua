--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


function ENT:cl_initialize()
	
end

function ENT:cl_think( delta )
	self:cl_updateRenderable( delta )
end

function ENT:setDepth( depth )
	self.depth = depth
	if (self.renderable) then
		self.renderable:setDepth(self.depth)
	end
end

function ENT:getDepth()
	return self.depth
end

function ENT:cl_updateRenderable( delta )
	if (self.renderable) then
		self.renderable:setDepth(self.depth)
	end
end

function ENT:cl_onJoin( )
end
local function onJoinGame(  )
	for k,v in pairs(ents.getAll()) do
		v:cl_onJoin()
	end
end
hook.add("onJoinGame", "ent_cl_onJoin", onJoinGame)
