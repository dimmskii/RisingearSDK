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
	
	if (SERVER) then
		if (self.targetTag == "") then -- NO TARGET ENT TAG; KILL THE TRIGGER EVENT SOURCE
			if (source and source.valid and ents.isClass(source,"char_base",true)) then
				if (source:isAlive()) then
					table.insert(self.toKill,source)
				end
			end
		else
			for k,v in pairs(self.targetEnts) do -- WE HAVE TARGET ENT TAG; KILL MATCHING ENTS
				if (v and v.valid and ents.isClass(v,"char_base",true)) then
					if (v:isAlive()) then
						table.insert(self.toKill,v)
					end
				end
			end
		end
	end
end

function ENT:sv_think(delta)
	ENT_BASE.sv_think(self,delta)
	for k,v in pairs(self.toKill) do
		v:kill(self,self)
	end
	self.toKill = {}
end

if ( EDITOR ) then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end
