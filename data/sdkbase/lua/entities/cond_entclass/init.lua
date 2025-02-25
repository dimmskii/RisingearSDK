--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	ENT_BASE.initialize( self )
	self:initProperty("notEq", false)
	self:initProperty("sourceClass", "base")
	self:initProperty("allowSubclass", true)
	self.sourceClassDirty = false
	self.notEqDirty = false
	self.allowSubclassDirty = false
end

function ENT:setGamemode(strGamemode)
	self.sourceClass = strGamemode
	self.sourceClassDirty = true
end

function ENT:setNotEq(bNotEq)
	self.notEq = bNotEq
	self.notEqDirty = true
end

function ENT:setAllowSubclass(bAllowSubclass)
	self.allowSubclass = bAllowSubclass
	self.allowSubclassDirty = true
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
				ent.notEqDirty = false
			end,
			read=function(data, ent)
				return data:readNext()
			end,
			dirty=function(field, ent) return ent.notEqDirty end
		}, ents.SNAP_MAP + ents.SNAP_NET)
	
	ents.persist(thisClass, "sourceClass", {
			write=function(field, data, ent)
				data:writeString(field)
				ent.sourceClassDirty = false
			end,
			read=function(data, ent)
				return data:readNext()
			end,
			dirty=function(field, ent) return ent.sourceClassDirty end
		}, ents.SNAP_MAP + ents.SNAP_NET)
		
	ents.persist(thisClass, "allowSubclass", {
			write=function(field, data, ent)
				data:writeBool(field)
				ent.allowSubclassDirty = false
			end,
			read=function(data, ent)
				return data:readNext()
			end,
			dirty=function(field, ent) return ent.allowSubclassDirty end
		}, ents.SNAP_MAP + ents.SNAP_NET)
	
end
