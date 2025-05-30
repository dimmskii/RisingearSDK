--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	ENT_BASE.initialize( self )
	self.toKill = {}
end

function ENT:onTriggered( source, caller )
	--ENT_BASE.trigger( self, source, caller) -- different method we use
	
	if SERVER then
		if self.targetTag == "" then -- NO TARGET ENT TAG; KILL THE TRIGGER EVENT SOURCE
			if source and source.valid then
				table.insert(self.toKill,source)
			end
		else
			for _,v in ipairs(self.targetEnts) do -- WE HAVE TARGET ENT TAG; KILL MATCHING ENTS
				if v and v.valid then
					table.insert(self.toKill,v)
				end
			end
		end
	end
end

function ENT:sv_think(delta)
	ENT_BASE.sv_think(self,delta)
	for _,v in ipairs(self.toKill) do
		local vec2vel = geom.vec2(v.velocity.x, -27.5)
		if ents.isClass(v,"phys_base",true) then
			local body = v:getBody()
			if body then body:setLinearVelocity(vec2vel) end
		else
			v:setVelocity(vec2vel)
		end
	end
	self.toKill = {}
end

if ( EDITOR ) then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end
