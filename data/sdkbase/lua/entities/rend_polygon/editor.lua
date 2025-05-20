
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_RECT
ENT.editor_polygonEditable = true

function ENT:editor_getOutlineShape()
	return self.outlineShape
end
function ENT:editor_getPolygon()
	return self.outlineShape
end

if CLIENT then
	local getOutlineColor = nil
	local getFillColor = nil
	local getOutlineWidth = nil
	local isAddedToRenderList = nil
	
	function ENT:editor_populatePropertiesGUI( cont )
		ENT_BASE.editor_populatePropertiesGUI( self, cont )
		
		local outlineColorCont = fgui.createContainer(cont)
		local outlineColorLabel = fgui.createLabel(outlineColorCont, "Outline Color"); -- TODO: Stringadactyl
		local outlineColorField = fgui.createColorBox(outlineColorCont)
		outlineColorField:setColor(self.outlineColor)
		
		getOutlineColor = function()
			return outlineColorField:getColor() or color.WHITE
		end
		
		local fillColorCont = fgui.createContainer(cont)
		local fillColorLabel = fgui.createLabel(fillColorCont, "Fill Color"); -- TODO: Stringadactyl
		local fillColorField = fgui.createColorBox(fillColorCont)
		fillColorField:setColor(self.fillColor)
		
		getFillColor = function()
			return fillColorField:getColor() or color.WHITE
		end
		
		local outlineWidthCont = fgui.createContainer( cont )
		local outlineWidthLabel = fgui.createLabel(outlineWidthCont, "Outline Width"); -- TODO: Stringadactyl
		local outlineWidthField = fgui.createTextField(outlineWidthCont)
		outlineWidthField:setText(tostring(self.outlineWidth))
		
		getOutlineWidth = function()
			return tonumber(outlineWidthField:getText()) or 1
		end
		
		local addedToRenderListCont = fgui.createContainer(cont)
		local addedToRenderListLabel = fgui.createLabel(addedToRenderListCont, "Add to render list"); -- TODO: Stringadactyl
		local addedToRenderListField = fgui.createCheckBox(addedToRenderListCont)
		addedToRenderListField:setSelected(self.addedToRenderList)
		
		isAddedToRenderList = function()
			return addedToRenderListField:isSelected()
		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		
		data:writeColor( getOutlineColor() )
		data:writeColor( getFillColor() )
		data:writeFloat( getOutlineWidth() )
		data:writeBool( isAddedToRenderList() )
	end
	
	function ENT:editor_updateRenderable( delta)
	 self.renderable:setShape(self:getOutlineShape())
	end

elseif SERVER then
	
	function ENT:editor_onPlaced(vec1, vec2)
		local x = math.min(vec1.x,vec2.x)
		local y = math.min(vec1.y,vec2.y)
		self:setPosition(x,y)
		local w = math.max(vec1.x,vec2.x) - x
		local h = math.max(vec1.y,vec2.y) - y
		if (w <= 0) then
			w = 1
		end
		if (h <= 0) then
			h = 1
		end
		self.polygon = geom.polygon(geom.vec2(0,0),geom.vec2(w,0),geom.vec2(w,h),geom.vec2(0,h))
	end
	function ENT:editor_applyPolygon( polygon )
		self.polygon = polygon:transform(geom.translateTransform(-self.position.x, -self.position.y):concatenate(geom.rotateTransform(-self.angle)))
		self.polygonDirty = true
		net.forceEntUpdate(self,ents.SNAP_NET,false)
		return
	end
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	
	self:setOutlineColor(data:readNext())
	self:setFillColor(data:readNext())
	self:setOutlineWidth(data:readNext())
	self:setAddedToRenderList(data:readNext())
end
