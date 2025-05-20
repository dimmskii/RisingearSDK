--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	self:initProperty("lifeTime", 3) -- Rubble lifetime in seconds after which this entity will be removed
	self:initProperty("materialID", "wood")
	self:initProperty("material", materials.get(self.materialID))
	self:initProperty("sprite", nil)
	ENT_BASE.initialize(self)
end

if CLIENT then
	include "cl_init.lua"
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )
	
	ents.persist(thisClass, "materialID", {
		write=function(field, data) data:writeString(field) end,
		read=function(data) return data:readNext() end,
		dirty=function() return false end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "sprite", {
		write=function(field, data, ent) data:writeSprite(field) end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return false end,
	})
end
