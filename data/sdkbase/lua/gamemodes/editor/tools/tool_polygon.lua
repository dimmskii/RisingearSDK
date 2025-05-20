--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- NETWORKING
local function processApplyMessage(sender, data)
	if (CLIENT) then return end -- Clients don't need to have this executed
	local id = data:readNext()
	local ent = ents.findByID(id)
	local undoData = {
   entID = id,
   entPolygon = ent:editor_getPolygon()
  }
	if (ent == nil) then return end
	local pol = data:readNext()
	ent:editor_applyPolygon( pol )
	
	EDITOR.addUndoEntry(function(self)
      local ent = ents.findByID( self.data.entID )
      ent:editor_applyPolygon( self.data.entPolygon )
    end, undoData)
end
local MSG_TOOL_POLYGON_APPLY = net.registerMessage("tool_polygon_apply", processApplyMessage)


-- CLIENT-SIDED TOOL CODE
if (CLIENT) then

	local tool = tools.register("tool_polygon", "Polygon Editor") -- TODO: stringadactyl
	
	local outlineColor = color.fromRGBAf(1,0,0,1)
	local fillColor = color.fromRGBAf(1,0,0,0.3)
	
	local polygon = nil
	local points = {}
	local ent = nil
	local renderable = nil
	local pointDragging = nil
	
	local function pointsFromPolygon()
		for i=0,polygon:getPointCount()-1 do
			local p = polygon:getPoint(i)
			table.insert(points,geom.vec2(p[1],p[2]))
		end
	end
	
	local function polygonFromPoints()
		polygon = geom.polygon(points)
	end
	
	local function getPointRadius()
		local cam = camera.getCurrent()
		if (cam == nil) then return 0.05 end
		return cam:getHeight() / 200
	end
	
	local function createOrUpdateRenderable()
		if (renderable == nil) then
			renderable = renderables.composite()
			renderable:setLayer(renderables.LAYER_POST_GAME)
			renderable:setDepth(EDITOR.REND_DEPTH_TOOL)
			renderables.add(renderable)
		end
		
		renderable:clearRenderables()
		
		local renderablePoly = renderables.fromShape(polygon)
		renderablePoly.outlineColor = outlineColor
		renderablePoly.fillColor = fillColor
		renderable:addRenderable(renderablePoly)
		
		local pRend = nil
		for k,v in pairs(points) do
			pRend = renderables.fromShape(geom.circle(v.x,v.y,getPointRadius()))
			pRend.outlineColor = outlineColor
			pRend.fillColor = outlineColor
			renderable:addRenderable(pRend)
		end
		
	end
	
	local function ensureRenderableRemoved()
		if (renderable) then
			renderables.remove(renderable)
		end
		renderable = nil
	end
	
	local function sendApplyMessage()
		if (SERVER) then return end -- Servers don't send polygon apply messages
		local data = net.data()
		if not ent then return end
		if not polygon then return end
		data:writeInt( ent.id )
		data:writeShape( polygon )
		net.sendMessage( MSG_TOOL_POLYGON_APPLY, data )
		EDITOR.actionEvent(actions.ENTMODIFY)
	end

	tool.onMousePressed = function(button, cursorPos, freePos)
		if (button ~= mouse.BUTTON_1 and button ~= mouse.BUTTON_2) then return end -- Check to make sure that it's LMB
		
		if (table.count(points) > 0) then
			local min = math.huge
			local minPointIndex
			for k,v in pairs(points) do
				local r = freePos:sub(v):length()
				if (r < min) then
					min = r
					minPointIndex = k
				end
			end
			if (min < getPointRadius()) then
				if (button == mouse.BUTTON_1) then
					pointDragging = minPointIndex
				elseif (button == mouse.BUTTON_2) then
					if (table.count(points) > 3) then
						table.remove(points,minPointIndex)
						polygonFromPoints()
					end
				end
				return
			end
		end
		
		-- See if we should add a point
		if (table.count(points) > 1 and button == mouse.BUTTON_1) then
			local p1 = nil
			local k2 = nil
			local p2 = nil
			for k,v in pairs(points) do
				p1 = v
				if (k >= table.getn(points)) then
					k2 = 1
				else
					k2 = k + 1
				end
				p2 = points[k2]
				local r = math.abs( (p2.y-p1.y)*freePos.x - (p2.x-p1.x)*freePos.y + p2.x*p1.y - p2.y*p1.x ) / p2:sub(p1):length()
				if (r < getPointRadius()) then
					local add = cursorPos:clone()
					if not (add:equals(p1) or add:equals(p2)) then
						table.insert(points,k2,add)
						polygonFromPoints()
					end
					return
				end
			end
		end
	end
	
	tool.onMouseReleased = function(button, cursorPos)
		if (pointDragging and button == mouse.BUTTON_1) then
			pointDragging = nil
		end
		sendApplyMessage()
	end
	
	tool.populatePropertiesPanel = function(panel)
	
		local parent = fgui.createContainer(panel)
		parent:setLayoutManager(fgui.newRowLayout(false))
		
	end
	
	local function selErr(str)
		local wMsg = fgui.createMessageWindow( str, "Error" ) -- TODO: Stringadactyl
		wMsg:centerOnScreen()
	end
	
	tool.onSelected = function()
		if (table.count(tools.selectedEnts) ~= 1) then
			selErr("Please make sure exactly 1 entity is selected!") -- TODO: Stringadactyl
			return false
		end
		ent = tools.selectedEnts[1]
		if not (ent.editor_polygonEditable) then
			selErr("Selected entity does not have editable polygon!") -- TODO: Stringadactyl
			return false
		end
		polygon = ent:editor_getPolygon()
		
		ensureRenderableRemoved()
		pointsFromPolygon()
		createOrUpdateRenderable()
		
		return true
	end
	
	tool.update = function(delta, cursorPos)
		if (pointDragging) then
			points[pointDragging] = cursorPos:clone()
			polygonFromPoints()
		end
		createOrUpdateRenderable()
	end
	
	tool.onDeselected = function()
		if (CLIENT) then
			sendApplyMessage()
		
			-- Nullify selection and remove polygon renderable
			ent = nil
			polygon = nil
			points = {}
			
			ensureRenderableRemoved()
		end
	end

end
