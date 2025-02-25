--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- NETWORKING
local function scaleVec(vec, rectOld, rectNew)
	local result = geom.vec2(
		(vec.x - rectOld:getX()) / rectOld:getWidth() * rectNew:getWidth() + rectNew:getX(),
		(vec.y - rectOld:getY()) / rectOld:getHeight() * rectNew:getHeight() + rectNew:getY()
	)
	return result
end

local function processApplyMessage(sender, data)
	if (CLIENT) then return end -- Clients don't need to have this executed
	local rectOld = data:readNext()
	local rectNew = data:readNext()
	local entities = {}
	while(data:hasNext()) do
		table.insert( entities, ents.findByID(data:readNext()) )
	end
	
	local undoDatas = {}
	for k,ent in pairs(entities) do
		if (ent and ent.valid) then
		  table.insert(undoDatas,1,ents.getEntityData(ent))
			if (ent.editor_resizable) then
				local rectSizeBox = ent:editor_getSizeRectangle()
				local xy = scaleVec(geom.vec2(rectSizeBox:getX(), rectSizeBox:getY()), rectOld, rectNew)
				local wh = scaleVec(geom.vec2(rectSizeBox:getX() + rectSizeBox:getWidth(), rectSizeBox:getY() + rectSizeBox:getHeight()), rectOld, rectNew):sub(xy)
				ent:editor_applySizeRectangle(geom.rectangle(xy.x,xy.y,wh.x,wh.y))
			elseif (ent.editor_polygonEditable) then
				local poly = ent:editor_getPolygon()
				if poly then
					local newPoints = {}
					for i=1,poly:getPointCount() do
						table.insert(newPoints, scaleVec(poly:getPointAsVec2(i-1), rectOld, rectNew))
					end
					ent:editor_applyPolygon(geom.polygon(table.unpack(newPoints)))
				else
					console.err("Polygon editable class '" .. ent.CLASSNAME .. "' does not implement editor_applyPolygon()")
				end
			else
				local vecPos = scaleVec(ent.position, rectOld, rectNew)
				ent:setPosition(vecPos.x,vecPos.y)
			end
		end
	end
	
	EDITOR.addUndoEntry(function(self)
      for _,undoData in ipairs(self.data) do
        ents.remove(undoData:getID())
        undoData:createEntity()
      end
    end, undoDatas)
end
local MSG_TOOL_RESIZE_APPLY = net.registerMessage("tool_resize_apply", processApplyMessage)


-- CLIENT-SIDED TOOL CODE
if (CLIENT) then

	local tool = tools.register("tool_resize", "Resize") -- TODO: stringadactyl
	
	local outlineColor = color.fromRGBAf(1,0,0,1)
	local fillColor = color.fromRGBAf(1,0,0,0.3)
	
	local selectionRectangleOld = nil
	local selectionRectangle = nil
	local points = {}
	local ent = nil
	local renderable = nil
	local pointDragging = nil
	
	local function pointsFromSelectionRect()
		points = {}
		table.insert(points,geom.vec2(selectionRectangle:getMinX(),selectionRectangle:getMinY()))
		table.insert(points,geom.vec2(selectionRectangle:getCenterX(),selectionRectangle:getMinY()))
		table.insert(points,geom.vec2(selectionRectangle:getMaxX(),selectionRectangle:getMinY()))
		table.insert(points,geom.vec2(selectionRectangle:getMaxX(),selectionRectangle:getCenterY()))
		table.insert(points,geom.vec2(selectionRectangle:getMaxX(),selectionRectangle:getMaxY()))
		table.insert(points,geom.vec2(selectionRectangle:getCenterX(),selectionRectangle:getMaxY()))
		table.insert(points,geom.vec2(selectionRectangle:getMinX(),selectionRectangle:getMaxY()))
		table.insert(points,geom.vec2(selectionRectangle:getMinX(),selectionRectangle:getCenterY()))
	end
	
	local function selectionRectFromPoints()
		local wh = points[5]:sub(points[1])
		selectionRectangle = geom.rectangle(points[1].x,points[1].y,wh.x,wh.y)
	end
	
	local function updateSelectionRect()
		if (table.count(tools.selectedEnts) == 1) then
			if (tools.selectedEnts[1].editor_resizable or tools.selectedEnts[1].editor_polygonEditable) then
				selectionRectangle = tools.selectedEnts[1]:editor_getSizeRectangle()
			else
				selectionRectangle = nil
			end
			return
		end
		local x1y1 = geom.vec2(math.huge, math.huge)
		local x2y2 = geom.vec2(-math.huge, -math.huge)
		for k,v in pairs(tools.selectedEnts) do
			local x1y1ent, x2y2ent = nil
			local entRect = v:editor_getSizeRectangle()
			if (entRect) then
				x1y1ent = geom.vec2(entRect:getMinX(), entRect:getMinY())
				x2y2ent = geom.vec2(entRect:getMaxX(), entRect:getMaxY())
			else
				x1y1ent = v:getPosition()
				x2y2ent = v:getPosition()
			end
			x1y1.x = math.min(x1y1.x,x1y1ent.x)
			x1y1.y = math.min(x1y1.y,x1y1ent.y)
			
			x2y2.x = math.max(x2y2.x,x2y2ent.x)
			x2y2.y = math.max(x2y2.y,x2y2ent.y)
		end
		local wh = x2y2:sub(x1y1)
		selectionRectangle = geom.rectangle(x1y1.x,x1y1.y, wh.x, wh.y)
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
		
		local renderablePoly = renderables.fromShape(selectionRectangle)
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
		if not (selectionRectangleOld and selectionRectangle) then return end
		local data = net.data()
		data:writeShape( selectionRectangleOld )
		data:writeShape( selectionRectangle )
		for k,v in pairs(tools.selectedEnts) do
			data:writeEntityID(v)
		end
		net.sendMessage( MSG_TOOL_RESIZE_APPLY, data )
	end

	tool.onMousePressed = function(button, cursorPos, freePos)
		if (button ~= mouse.BUTTON_1) then return end -- Check to make sure that it's LMB
		
		selectionRectangleOld = selectionRectangle
		
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
				pointDragging = minPointIndex
				return
			end
		end
		
		
--		-- See if we should add a point
--		if (table.count(points) > 1 and button == mouse.BUTTON_1) then
--			local p1 = nil
--			local k2 = nil
--			local p2 = nil
--			for k,v in pairs(points) do
--				p1 = v
--				if (k >= table.getn(points)) then
--					k2 = 1
--				else
--					k2 = k + 1
--				end
--				p2 = points[k2]
--				local r = math.abs( (p2.y-p1.y)*freePos.x - (p2.x-p1.x)*freePos.y + p2.x*p1.y - p2.y*p1.x ) / p2:sub(p1):length()
--				if (r < getPointRadius()) then
--					local add = cursorPos:clone()
--					if not (add:equals(p1) or add:equals(p2)) then
--						table.insert(points,k2,add)
--						polygonFromPoints()
--					end
--					return
--				end
--			end
--		end
	end
	
	tool.onMouseReleased = function(button, cursorPos)
		if (button ~= mouse.BUTTON_1) then return end -- Check to make sure that it's LMB
		
		if (pointDragging) then
			pointDragging = nil
		end
		
		sendApplyMessage()
	end
	
	tool.populatePropertiesPanel = function(panel)
	
		local parent = fgui.createContainer(panel)
		parent:setLayoutManager(fgui.newRowLayout(false))
		
	end
	
	tool.onSelected = function()
		updateSelectionRect()
		
		if (selectionRectangle) then
			ensureRenderableRemoved()
			pointsFromSelectionRect()
			createOrUpdateRenderable()
			return true
		end
		
		return false
	end
	
	tool.update = function(delta, cursorPos)
		if not pointDragging and selectionRectangle then
			return
		end
		
		if (pointDragging < 4) then -- top = true
			if (cursorPos.y < points[5].y) then -- overlap bottom check
				points[1].y = cursorPos.y
				points[2].y = cursorPos.y
				points[3].y = cursorPos.y
			end
		elseif (pointDragging > 4 and pointDragging < 8) then -- bottom = true
			if (cursorPos.y > points[1].y) then -- overlap top check
				points[5].y = cursorPos.y
				points[6].y = cursorPos.y
				points[7].y = cursorPos.y
			end
		end
		if (pointDragging == 1 or pointDragging > 6) then -- left = true
			if (cursorPos.x < points[3].x) then -- overlap right check
				points[1].x = cursorPos.x
				points[7].x = cursorPos.x
				points[8].x = cursorPos.x
			end
		elseif (pointDragging > 2 and pointDragging < 6) then -- right = true
			if (cursorPos.x > points[1].x) then -- overlap left check
				points[3].x = cursorPos.x
				points[4].x = cursorPos.x
				points[5].x = cursorPos.x
			end
		end
		
		
		selectionRectFromPoints()
		pointsFromSelectionRect() -- Vice-versa to fix the rest of the (center) points
		createOrUpdateRenderable()
	end
	
	tool.onDeselected = function()
		if (CLIENT) then
			-- Nullify selection and remove polygon renderable
			selectionRectangle = nil
			selectionRectangleOld = nil
			points = {}
			
			ensureRenderableRemoved()
		end
	end

end
