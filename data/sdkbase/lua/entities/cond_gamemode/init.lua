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
	self:initProperty("gamemode", "")
	self.gamemodeDirty = false
	self.notEqDirty = false
	-- TODO: canBeSubclass?
end

function ENT:setGamemode(strGamemode)
	self.gamemode = strGamemode
	self.gamemodeDirty = true
end

function ENT:setNotEq(bNotEq)
	self.notEq = bNotEq
	self.notEqDirty = true
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
		}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "gamemode", {
			write=function(field, data, ent)
				data:writeString(field)
				ent.gamemodeDirty = false
			end,
			read=function(data, ent)
				return data:readNext()
			end,
			dirty=function(field, ent) return ent.gamemodeDirty end
		}, ents.SNAP_ALL)
end
