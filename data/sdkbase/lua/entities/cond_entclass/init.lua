--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT_META.CLASSNAME_BASE = "trigger_base"

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	ENT_BASE.initialize( self )
	self:initProperty("notEq", false)
	self:initProperty("sourceClass", "base")
	self:initProperty("allowSubclass", true)
	self._dirty_sourceClass = false
	self._dirty_notEq = false
	self._dirty_allowSubclass = false
end

function ENT:setGamemode(strGamemode)
	self.sourceClass = strGamemode
	self._dirty_sourceClass = true
end

function ENT:setNotEq(bNotEq)
	self.notEq = bNotEq
	self._dirty_notEq = true
end

function ENT:setAllowSubclass(bAllowSubclass)
	self.allowSubclass = bAllowSubclass
	self._dirty_allowSubclass = true
end

if ( SERVER ) then
	include("sv_init.lua")
end

if ( EDITOR ) then
	include("editor.lua")
end

function ENT.persist( thisClass )
		
	ENT_BASE.persist( thisClass )
	
	ents.persist(thisClass, "notEq", {
			write=function(field, data, ent)
				data:writeBool(field)
				ent._dirty_notEq = false
			end,
			read=function(data, ent)
				return data:readNext()
			end,
			dirty=function(ent) return ent._dirty_notEq end
		}, ents.SNAP_MAP + ents.SNAP_NET)
	
	ents.persist(thisClass, "sourceClass", {
			write=function(field, data, ent)
				data:writeString(field)
				ent._dirty_sourceClass = false
			end,
			read=function(data, ent)
				return data:readNext()
			end,
			dirty=function(ent) return ent._dirty_sourceClass end
		}, ents.SNAP_MAP + ents.SNAP_NET)
		
	ents.persist(thisClass, "allowSubclass", {
			write=function(field, data, ent)
				data:writeBool(field)
				ent._dirty_allowSubclass = false
			end,
			read=function(data, ent)
				return data:readNext()
			end,
			dirty=function(ent) return ent._dirty_allowSubclass end
		}, ents.SNAP_MAP + ents.SNAP_NET)
	
end
