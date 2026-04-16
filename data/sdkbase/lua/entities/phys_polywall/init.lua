--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT_META.CLASSNAME_BASE = "phys_base"

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	
	self:initProperty("polygon", geom.polygon(geom.vec2(0,0),geom.vec2(1,0),geom.vec2(1,1),geom.vec2(0,1)))
	
	ENT_BASE.initialize( self )
	
	self.bodyType = phys.BT_STATIC
	self:createBody()
	local fixtures = phys.addShapeFixtureToBody(self:getBody(), self.material, self.polygon, self)
	for _,v in pairs(fixtures) do
		self:addAsListenerToFixture( v )
	end
	
	self:updateFixtureList()
end

function ENT:getStaticOutlineShape()
	return self.polygon
end

function ENT:setPlatform(bPlatform)
	self.platform = bPlatform
	
	if (SERVER) then
		self._dirty_platform = true
	end
end

function ENT:isPlatform()
	return self.platform
end

if CLIENT then
	include("cl_init.lua")
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
		dirty=false,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "platform", {
		write=function(field, data, ent)
			data:writeBool(field)
			ent._dirty_platform = false
		end,
		read=function(data) return data:readNext() end,
		dirty=ents.DIRTY_CHECK,
	}, ents.SNAP_ALL)
	
end

if ( EDITOR ) then
	include("editor.lua")
end
