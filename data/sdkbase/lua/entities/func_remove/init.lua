--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	ENT_BASE.initialize( self )
end

function ENT:onTriggered( source, caller )
	--ENT_BASE.trigger( self, source, caller) -- different method we use
	
	if (SERVER) then
		if (self.targetTag == "") then -- NO TARGET ENT TAG; DELETE THE TRIGGER EVENT SOURCE
			if (source and source.valid) then
				ents.remove(source)
			end
		else
			for k,v in pairs(self.targetEnts) do -- WE HAVE TARGET ENT TAG; DELETE MATCHING ENTS
				if (v and v.valid) then
					ents.remove(v)
				end
			end
		end
	end
end

if ( EDITOR ) then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end
