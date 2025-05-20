--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	ENT_BASE.initialize( self )
	
	self:initProperty("targetTag", "")
	self:initProperty("sourceTag", "")
end

function ENT:setTargetTag(strTag)
	self.targetTag = strTag
	self:updateTargetEnts()
	if SERVER then self.targetTagDirty = true end
end

function ENT:getTargetTag()
	return self.targetTag
end

function ENT:setSourceTag(strTag)
	self.sourceTag = strTag
	self:updateSourceEnts()
	if SERVER then self.sourceTagDirty = true end
end

function ENT:getSourceTag()
	return self.sourceTag
end

function ENT:updateTargetEnts()
	self.targetEnts = ents.findByTag(self.targetTag)
end

function ENT:updateSourceEnts()
	self.sourceEnts = ents.findByTag(self.sourceTag)
end

if SERVER then
	include("sv_init.lua") -- Time to include server-only lua
--elseif ( CLIENT ) then
--	include("cl_init.lua") -- Time to include client-only lua
end

if EDITOR then
	include("editor.lua")
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )
	
	ents.persist(thisClass, "targetTag", {
			write=function(field, data, ent)
				data:writeString(field)
				ent.targetTagDirty = false
			end,
			read=function(data, ent)
				local tag = data:readNext()
				return tag
			end,
			dirty=function(field, ent) return ent.targetTagDirty end,
		}, ents.SNAP_ALL)
		
	ents.persist(thisClass, "sourceTag", {
			write=function(field, data, ent)
				data:writeString(field)
				ent.sourceTagDirty = false
			end,
			read=function(data, ent)
				local tag = data:readNext()
				return tag
			end,
			dirty=function(field, ent) return ent.sourceTagDirty end,
		}, ents.SNAP_ALL)
end