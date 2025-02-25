--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
ENT.editor_resizable = true

function ENT:editor_createSprite()
	return self.sprite
end

function ENT:editor_applyTexture( texPath )
	self.texture = texPath
	if (self.sprite) then
		self.sprite:setTexture(texPath)
		if SERVER then
			self.spriteDirty=true
			net.forceEntUpdate(self,ents.SNAP_NET,false)
		end
	end
end

if CLIENT then
	local getCollision = nil
	
	local collisionConvert= {}
	collisionConvert[0] = "COLLISION_BOX"
	collisionConvert[1] = "COLLISION_CIRCLE"
	collisionConvert[2] = "COLLISION_SPRITE"
	collisionConvert[3] = "COLLISION_ELLIPSE"
	collisionConvert[4] = "COLLISION_ROUNDED_RECTANGLE"
	
	function ENT:editor_populatePropertiesGUI( cont )
		ENT_BASE.editor_populatePropertiesGUI( self, cont )
		
		local collisionCont = fgui.createContainer(cont)
		local collisionLabel = fgui.createLabel(collisionCont, "Collision"); -- TODO: Stringadactyl
		local collisionField = fgui.createComboBox(collisionCont)
		for _,v in pairs(collisionConvert) do
			collisionField:addItem(v)
		end
		collisionField:setSelected(collisionConvert[self.collision])
		
		getCollision = function()
			return props[collisionField:getSelectedValue()]
		end
		
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		
		data:writeInt( getCollision() )
	end
	
	function ENT:editor_getOutlineShape()
		return self.outlineShape
	end
	
elseif SERVER then
	function ENT:editor_applySizeRectangle(rect)
		self.sprite:setWidth(rect:getWidth())
		self.sprite:setHeight(rect:getHeight())
		self:setPosition(rect:getX() + self.sprite.origin.x, rect:getY() + self.sprite.origin.y)
		--self.sprite.position = geom.vec2(rect:getX(),rect:getY())
		self:setSprite(self.sprite)
		self.spriteDirty=true
		net.forceEntUpdate(self,ents.SNAP_NET,false)
	end
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	
	self:setCollision(data:readNext())
end


