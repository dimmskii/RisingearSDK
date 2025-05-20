--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()

	self:initProperty("polygon", geom.polygon(geom.vec2(0,0),geom.vec2(1,0),geom.vec2(1,1),geom.vec2(0,1)))
	self:initProperty("outlineColor", color.WHITE)
	self:initProperty("fillColor", color.fromRGBAf(1,1,1,0))
	self:initProperty("outlineWidth", 3)
	self:initProperty("addedToRendererList", true)

	
	ENT_BASE.initialize( self )
	
end

function ENT:getOutlineColor()
	return self.outlineColor
end

function ENT:setOutlineColor( colOutline )
	self.outlineColor = colOutline
	if SERVER then
		self.outlineColorDirty = true
	end
end

function ENT:getFillColor()
	return self.fillColor
end

function ENT:setFillColor( colFill )
	self.fillColor = colFill
	if SERVER then
		self.fillColorDirty = true
	end
end

function ENT:getOutlineWidth()
	return self.outlineWidth
end

function ENT:setOutlineWidth( fWidth )
	self.outlineWidth = fWidth
	if SERVER then
		self.outlineWidthDirty = true
	end
end

function ENT:getStaticOutlineShape()
	return self.polygon
end

function ENT:isAddedToRenderList()
	return self.addedToRenderList
end

function ENT:setAddedToRenderList( bAdded )
	self.addedToRenderList = bAdded
	if SERVER then
		self.addedToRenderListDirty = true
	end
end

if (CLIENT) then
	include("cl_init.lua")
end

if (EDITOR) then
	include("editor.lua")
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
		dirty=function(ent) return ent.polygonDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "outlineColor", {
		write=function(field, data, ent)
			data:writeColor(field)
		end,
		read=function(data)
			return data:readNext()
		end,
		dirty=function(ent) return ent.outlineColorDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "fillColor", {
		write=function(field, data, ent)
			data:writeColor(field)
		end,
		read=function(data)
			return data:readNext()
		end,
		dirty=function(ent) return ent.fillColorDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "outlineWidth", {
		write=function(field, data, ent)
			data:writeInt(field)
		end,
		read=function(data)
			return data:readNext()
		end,
		dirty=function(ent) return ent.outlineWidthDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "addedToRenderList", {
		write=function(field, data, ent)
			data:writeBool(field)
		end,
		read=function(data)
			return data:readNext()
		end,
		dirty=function(ent) return ent.addedToRenderListDirty end,
	}, ents.SNAP_ALL)
	
end