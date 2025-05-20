--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


tools = {}

tools.list = {}

tools.listByAdded = {}

tools.current = nil

local toolCount = 0

tools.register = function(toolName, friendlyName)
	toolCount = toolCount + 1
	local tool = {}
	tool.number = toolCount
	tool.name = toolName
	tool.friendlyName = friendlyName
	tool.update = function(delta, pos, freePos) return end
	tool.onSelected = function() return true end
	tool.onDeselected = function() return end
	if (CLIENT) then
		tool.populatePropertiesPanel = function(panel) end
		tool.onMousePressed = function(button, pos, freePos) end
		tool.onMouseReleased = function(button, pos, freePos) end
	end
	
	tools.list[toolName] = tool
	tools.listByAdded[toolCount] = tool
	
	if (tools.current == nil) then
		tools.current = tool
	end
	
	return tool
end

tools.setCurrent = function( tool, bKeepToolPanel )
	-- TODO bKeepToolPanel is a hacky approach used by things like tool_hand during space press and release. This prevents resetting the panel after hold space for pan
	-- Ideally, every tool should have a referenced GUI panel of its own and show/hide or insert/remove from window.
	if (tool.onSelected() == false) then
		return
	end
	
	if (tools.current ~= nil) then
		tools.current.onDeselected()
	end

	if type(tool)=='string' then
		tools.current = tools.list[tool]
	else
		tools.current = tool -- TODO: Check if this is actually a tool table
	end
	
	if (CLIENT and not bKeepToolPanel) then
		local panel = EDITOR.gui_getToolSettingsPanel()
		if (panel) then
			panel:removeAllWidgets()
			tool.populatePropertiesPanel(panel)
		end
	end
end

tools.getSelected = function() return tools.current end

-- =INPUT= --

-- Deals with getting the cursor position, determined by the grid, snap setting, etc.
local function getCursorPos(snap)
	if (snap) then
		return grid.snapCoord(geom.vec2(display.getMouseXViewport(), display.getMouseYViewport()))
	else
		return geom.vec2(display.getMouseXViewport(), display.getMouseYViewport())
	end
end

local mouseListener = {
	buttonPressed = function(button) -- We don't take the x, y that follow in the event, since we find the world coords instead
		if (tools.current == nil) then return end
		if not (controller.isMouseButton(button)) then return end
		tools.current.onMousePressed(button, getCursorPos(editor_config.get("editor_grid_snap")), getCursorPos(false) )
	end
	,
	buttonReleased = function(button) -- We don't take the x, y that follow in the event, since we find the world coords instead
		if (tools.current == nil) then return end
		if not (controller.isMouseButton(button)) then return end
		tools.current.onMouseReleased(button, getCursorPos(editor_config.get("editor_grid_snap")), getCursorPos(false) )
	end
}
controller.addListener(mouseListener,false)


-- =SELECTION= --

local selectionColorOutline = color.WHITE
local selectionWidthOutline = 3.0
local selectionColorFill = color.fromRGBAf(0.1,1,0.1,0.15)

local selectionRenderable = nil
local selectionRenderableShapes = {}

tools.updateSelectionRenderable = function()
	if (selectionRenderable) then
		renderables.remove( selectionRenderable )
		selectionRenderable = nil
	end
	
	if ( tools.isSelectionEmpty() ) then return end
	
	selectionRenderable = renderables.composite()
	
	for k,v in pairs( tools.selectedEnts ) do
		local shapeRenderable = renderables.fromShape(v.outlineShape)
		shapeRenderable.outlineWidth = selectionWidthOutline
		shapeRenderable.outlineColor = selectionColorOutline
		shapeRenderable.fillColor = selectionColorFill
		selectionRenderable:addRenderable( shapeRenderable )
		selectionRenderableShapes[v] = shapeRenderable
	end
	
	selectionRenderable:setLayer(renderables.LAYER_POST_GAME)
	selectionRenderable:setDepth(EDITOR.REND_DEPTH_SELECTION)
	
	renderables.add( selectionRenderable )
end

local function updateSelectionRenderableShapes()
	for k,v in pairs(selectionRenderableShapes) do
		v.shape = k.outlineShape
	end
end

tools.selectedEnts = {}

local selectionCycle = {}
local selectionCycleIndex = 1

local function selectionCycleMatches( tableNewCycle )
	if ( table.getn( tableNewCycle ) == table.getn( selectionCycle ) ) then
		for k,v in pairs(tableNewCycle) do
			if not (v == selectionCycle[k]) then
				return false
			end
		end
		return true
	end
	return false
end

tools.doSelection = function( cornerVec1, cornerVec2 )
	
	if ( cornerVec2==nil or (cornerVec1.x == cornerVec2.x and cornerVec1.y == cornerVec2.y) ) then
		local pos = cornerVec1:clone()
		local tableNewCycle = {} -- Create a temporary point selection cycle for to check against the old one later
		for k, v in pairs(ents.getAll()) do
			if ( v.outlineShape and v.outlineShape:contains(pos.x,pos.y) ) then
				if not table.hasValue(tableNewCycle, v) then
					table.insert(tableNewCycle, v)
				end
			end
		end
		
		-- Sort temp point selection cycle by depth
		table.sort(tableNewCycle,function(ent1,ent2)
		  if (ent1.depth == ent2.depth) then return ent1.id > ent2.id end -- Greater id goes first because it typically appears on top
		  if (ent1.depth < ent2.depth) then return true end
		  return false
		end)
		
		if ( selectionCycleMatches(tableNewCycle) ) then
			selectionCycleIndex = selectionCycleIndex + 1
			if (selectionCycleIndex > table.getn(selectionCycle)) then
				selectionCycleIndex = 1
			end
		else
			selectionCycle = tableNewCycle
			selectionCycleIndex = 1
		end
		local entToSelect = selectionCycle[selectionCycleIndex]
		if not table.hasValue(tools.selectedEnts,entToSelect) then
		  table.insert(tools.selectedEnts, entToSelect)
		end
		
		tools.updateSelectionRenderable()
		EDITOR.actionEvent(actions.SELECT)
		return
	end
	
	-- clear selection cycle first, since we are selecting an area
	selectionCycle = {}
	
	local from = geom.vec2( math.min(cornerVec1.x,cornerVec2.x), math.min(cornerVec1.y,cornerVec2.y) )
	local to = geom.vec2( math.max(cornerVec1.x,cornerVec2.x), math.max(cornerVec1.y,cornerVec2.y) )
	local dim = to:sub(from)
	local rect = geom.rectangle( from.x, from.y, dim.x, dim.y )	
	for k, v in pairs(ents.getAll()) do
		if ( v.outlineShape and (rect:contains(v.outlineShape) or v.outlineShape:contains(rect) or rect:intersects(v.outlineShape)) ) then
			if not table.hasValue(tools.selectedEnts, v) then table.insert(tools.selectedEnts, v) end
		end
	end
	tools.updateSelectionRenderable()
	EDITOR.actionEvent(actions.SELECT)
	return
end

tools.selectAll = function()
	for k, v in pairs(ents.getAll()) do
		if not table.hasValue(tools.selectedEnts, v) then table.insert(tools.selectedEnts, v) end
	end
	tools.updateSelectionRenderable()
	EDITOR.actionEvent(actions.SELECT)
end

tools.isSelectionEmpty = function()
	return table.isEmpty( tools.selectedEnts )
end

tools.clearSelection = function()
	-- Clear current selection
	tools.selectedEnts = {}
	tools.updateSelectionRenderable()
	EDITOR.actionEvent(actions.DESELECT)
end

tools.setSelection = function(tableEnts)
	-- Set current selection
	tools.selectedEnts = tableEnts
	tools.updateSelectionRenderable()
	EDITOR.actionEvent(actions.SELECT)
end

-- =UPDATE= --
tools.update = function( delta )
	-- Run update code for current tool if applicable
	if (tools.current ~= nil) then
		tools.current.update( delta, getCursorPos(editor_config.get("editor_grid_snap")), getCursorPos(false) )
	end
	
	-- Update the current selected ent outline shapes (they get replaced upon transformation)
	if not tools.isSelectionEmpty() then
		updateSelectionRenderableShapes()
	end
end

local function onEntDestroyed( ent )
	for k,v in pairs(tools.selectedEnts) do
		if (v.id == ent.id) then
			table.remove(tools.selectedEnts,k)
			tools.updateSelectionRenderable()
		end
	end
end
hook.add("onEntityDestroyed", "editor_tools_onEntityDestroyed", onEntDestroyed)
