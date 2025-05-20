--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

-- Just like a phys_prop but it saves the sprite and adds editor customization in properties at the expense of network and disk space
-- This is a workaround for having to make prop definitions ala the super class: phys_prop

function ENT:initialize()
	self.initProperty(self,"collision", props.COLLISION_SPRITE)
	ENT_BASE.initialize( self ) -- Make sure phys_prop initialize gets called last ; it fires create prop event at the end
end

function ENT:setSprite( spr )
	self.sprite = spr
	if SERVER then self.spriteDirty = true end
end

function ENT:setCollision( iCollision )
	self.collision  = iCollision
	if SERVER then self.collisionDirty = true end
end

function ENT:getCollision( )
	return self.collision
end

--if ( SERVER ) then
--	include("sv_init.lua")
--elseif ( CLIENT ) then
--	include("cl_init.lua")
--end

if (EDITOR) then
	include( "editor.lua" )
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )
	
	ents.persist(thisClass, "sprite", {
		write=function(field, data, ent)
			data:writeSprite(field)
			ent.spriteDirty=false
		end,
		read=function(data, ent)
			local spr = data:readNext()
			if CLIENT then
				ent:cl_createRenderable( spr )
			end
			return spr
		end,
		dirty=function(field, ent) return ent.spriteDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "collision", {
		write=function(field, data, ent)
			data:writeInt(field)
			ent.collisionDirty=false
		end,
		read=function(data, ent)
			return data:readNext()
		end,
		dirty=function(field, ent) return ent.collisionDirty end,
	}, ents.SNAP_ALL)
end