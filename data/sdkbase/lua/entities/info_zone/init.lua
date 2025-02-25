--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	
	self:initProperty("polygon", geom.polygon(geom.vec2(0,0),geom.vec2(1,0),geom.vec2(1,1),geom.vec2(0,1)))
	
	ENT_BASE.initialize( self )
end

function ENT:getStaticOutlineShape()
	return self.polygon
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )

	ents.persist(thisClass, "polygon", {
		write=function(field, data, ent)
			data:writeShape(field)
		end,
		read=function(data)
			return data:readNext()
		end,
		dirty=function() return false end,
	}, ents.SNAP_ALL)
	
end

if ( EDITOR ) then
	include("editor.lua")
end
