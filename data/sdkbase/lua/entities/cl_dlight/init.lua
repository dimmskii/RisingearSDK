--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	self:initProperty("lifeTime", -1) -- Lifetime in seconds after which this entity will be removed (-1 is default and means keep forever)
	self:initProperty("color", color.WHITE) -- Color
	ENT_BASE.initialize(self)
end

function ENT:getStaticOutlineShape()
	return geom.circle(0,0,self.radius)
end

if CLIENT then
	include "cl_init.lua"
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )
	
	ents.persist(thisClass, "lifeTime", {
		write=function(field, data) data:Real(field) end,
		read=function(data) return data:readNext() end,
		dirty=function() return false end,
	}, ents.SNAP_NET)
	
	ents.persist(thisClass, "radius", {
		write=function(field, data, ent) data:writeReal(field) end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return false end,
	}, ents.SNAP_NET)
	
	ents.persist(thisClass, "color", {
		write=function(field, data, ent) data:writeColor(field) end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return false end,
	}, ents.SNAP_NET)
end