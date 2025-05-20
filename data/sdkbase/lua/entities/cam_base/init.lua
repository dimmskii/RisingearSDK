--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	ENT_BASE.initialize( self )
	self:initProperty("size", 15)
	self:initProperty("bSizeWidth", false)
end

function ENT:isSizeWidth()
	return self.bSizeWidth
end

function ENT:setSizeWidth( bSizeWidth )
	self.bSizeWidth = bSizeWidth
	if SERVER then self.bSizeWidthDirty = true end
end

function ENT:getSize()
	return self.size
end

function ENT:setSize( fSize )
	self.size = fSize
	if SERVER then self.sizeDirty = true end
end

if (CLIENT) then
	
	function ENT:cl_initialize()
		ENT_BASE.cl_initialize( self )

		self.camera = camera.create()
		self:cl_updateCamera()
	end
	
	function ENT:cl_think( delta )
		ENT_BASE.cl_think( self, delta )
		
		if (camera.getCurrent() == self.camera) then
			self:cl_updateCamera( self, delta )
		end
	end
	
	function ENT:cl_updateCamera( )
		if (self:isSizeWidth()) then
			self.camera:setWidth(self.size)
		else
			self.camera:setHeight(self.size)
		end
		self.camera:setX(self.position.x)
		self.camera:setY(self.position.y)
		self.camera:setAngle(self.angle)
		
		-- Audio position
		audio.setListenerPosition(self.camera:getX(),self.camera:getY(), self.camera:getHeight() / -2)
	end
	
	function ENT:onTriggered( source, caller )
		camera.use(self.camera)
	end
	
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )

	ents.persist(thisClass, "size", {
		write=function(field, data, ent)
			data:writeFloat(field)
		end,
		read=function(data)
			return data:readNext()
		end,
		dirty=function(field, ent) return ent.sizeDirty end,
	}, ents.SNAP_ALL)
	
	ents.persist(thisClass, "bSizeWidth", {
		write=function(field, data, ent)
			data:writeBool(field)
			ent.platformDirty = false
		end,
		read=function(data) return data:readNext() end,
		dirty=function(field, ent) return ent.bSizeWidthDirty end,
	}, ents.SNAP_ALL)
	
end

if EDITOR then include("editor.lua") end
