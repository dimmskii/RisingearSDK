--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local window_editing = nil

-- GRID
local function snapToGridChanged(ev) -- Called when user ticks/unticks Snap to grid check box
	editor_config.set("editor_grid_snap", ev:isSelected())
end

local function showGridChanged(ev) -- Called when user ticks/unticks Snap to grid check box
	editor_config.set("editor_grid_show", ev:isSelected())
end

local function sizeFieldChanged(ev) -- Called when user changes the grid size text
	editor_config.set("editor_grid_size", ev:getText())
end

local function sizeButtonPressed(less, sizeField) -- Called when user presses the + or - button for grid size
	local size = editor_config.get("editor_grid_size")
	if (less) then
		size = math.max( size / 2, grid.MIN_SIZE)
	else
		size = math.min( size * 2, grid.MAX_SIZE)
	end
	sizeField:setText(tostring(size))
end


-- VIEW
local function setShowLighting(bShow)
	if bShow then
		local entWorldSpawn = GAMEMODE:getWorldspawnEntity()
		if entWorldSpawn ~= nil then
			renderables.setAmbientLightColor(entWorldSpawn.ambientLightColor)
		end
	else
		renderables.setAmbientLightColor(color.WHITE)
	end
end
local function showLightingChanged(ev) -- Called when user changes toggles view lighting
	local bSelected = ev:isSelected()
	editor_config.set("editor_view_lighting", bSelected)
	setShowLighting(bSelected)
end

local function showOutlinesChanged(ev) -- Called when user changes toggles view outlines
	editor_config.set("editor_view_outlines", ev:isSelected())
end

function EDITOR.gui_showEditingWindow()
	if not ( gui_utils.widgetExists(window_editing) ) then
		window_editing = fgui.createWindow(true, false, false, false)
		window_editing:setTitle("Editing") -- TODO: stringadactyl
		local cont = window_editing:getContentContainer()
		
		-- Origin panel
		local cont_origin = fgui.createContainer(cont)
		cont_origin:getAppearance():add(fgui_decorators.createTitledBorder("Origin")) -- TODO Stringadactyl
		cont_origin:setLayoutManager(fgui.newGridLayout(3,3))
		cont_origin:setMaxSize(128,128)
		cont_origin:setExpandable(false)
		local originGroup = fgui.newToggableGroup()
		local originTL = fgui.createRadioButton(originGroup, cont_origin)
		originTL:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev) if(ev:isSelected()) then grid.setOrigin(1, 1) end end))
		local originTC = fgui.createRadioButton(originGroup, cont_origin)
		originTC:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev) if(ev:isSelected()) then grid.setOrigin(0, 1) end end))
		local originTR = fgui.createRadioButton(originGroup, cont_origin)
		originTR:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev) if(ev:isSelected()) then grid.setOrigin(-1, 1) end end))
		local originML = fgui.createRadioButton(originGroup, cont_origin)
		originML:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev) if(ev:isSelected()) then grid.setOrigin(1, 0) end end))
		local originMC = fgui.createRadioButton(originGroup, cont_origin)
		originMC:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev) if(ev:isSelected()) then grid.setOrigin(0, 0) end end))
		local originMR = fgui.createRadioButton(originGroup, cont_origin)
		originMR:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev) if(ev:isSelected()) then grid.setOrigin(-1, 0) end end))
		local originBL = fgui.createRadioButton(originGroup, cont_origin)
		originBL:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev) if(ev:isSelected()) then grid.setOrigin(1, -1) end end))
		local originBC = fgui.createRadioButton(originGroup, cont_origin)
		originBC:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev) if(ev:isSelected()) then grid.setOrigin(0, -1) end end))
		local originBR = fgui.createRadioButton(originGroup, cont_origin)
		originBR:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev) if(ev:isSelected()) then grid.setOrigin(-1, -1) end end))
	
		originMC:setSelected(true)
		
		-- Grid panel
		local cont_grid = fgui.createContainer(cont)
		cont_grid:getAppearance():add(fgui_decorators.createTitledBorder("Grid")) -- TODO Stringadactyl
		cont_grid:setLayoutManager(fgui.newRowLayout(true))
		local snap = fgui.createCheckBox(cont_grid)
		snap:setText("Snap to grid") -- TODO Stringadactyl
		snap:setSelected(editor_config.get("editor_grid_snap"))
		snap:addSelectionChangedListener(fgui_listeners.selectionChanged(snapToGridChanged))
		
		-- Size panel
		--local cont_size = fgui.createContainer(cont_grid)
		local sizeField = fgui.createTextField(cont_grid, editor_config.get("editor_grid_size"))
		sizeField:addTextChangedListener(fgui_listeners.textChanged(sizeFieldChanged))
		sizeField:setExpandable(false)
		sizeField:setShrinkable(false)
		sizeField:setMinWidth(64)
		sizeField:setWidth(64)
		local sizeMinus = fgui.createButton(cont_grid,"-")
		sizeMinus:setMinSize(22,33)
		sizeMinus:setMaxSize(22,33)
		sizeMinus:addButtonPressedListener(fgui_listeners.buttonPressed(function() sizeButtonPressed(true,sizeField) end))
		local sizePlus = fgui.createButton(cont_grid,"+")
		sizePlus:setMinSize(22,33)
		sizePlus:setMaxSize(22,33)
		sizePlus:addButtonPressedListener(fgui_listeners.buttonPressed(function() sizeButtonPressed(false,sizeField) end))
		
		local showGrid = fgui.createCheckBox(cont_grid)
		showGrid:setText("Show grid") -- TODO Stringadactyl
		showGrid:setSelected(editor_config.get("editor_grid_show"))
		showGrid:addSelectionChangedListener(fgui_listeners.selectionChanged(showGridChanged))
		
		
		-- View panel
		local cont_view = fgui.createContainer(cont)
		cont_view:getAppearance():add(fgui_decorators.createTitledBorder("View")) -- TODO Stringadactyl
		
		local showLighting = fgui.createCheckBox(cont_view)
		showLighting:setText("Lighting") -- TODO Stringadactyl
		showLighting:setSelected(editor_config.get("editor_view_lighting"))
		showLighting:addSelectionChangedListener(fgui_listeners.selectionChanged(showLightingChanged))
		setShowLighting(showLighting:isSelected())
		
		local showOutlines = fgui.createCheckBox(cont_view)
		showOutlines:setText("Outlines") -- TODO Stringadactyl
		showOutlines:setSelected(editor_config.get("editor_view_outlines"))
		showOutlines:addSelectionChangedListener(fgui_listeners.selectionChanged(showOutlinesChanged))

		window_editing:setResizable(true)
		
		window_editing:setX(fgui.getDisplay():getWidth()/2 - window_editing:getWidth()/2)
		window_editing:setY(0)
		
		window_editing:addWindowClosedListener(fgui_listeners.windowClosed(EDITOR.gui_hideEditingWindow))
	end
	
	window_editing:setVisible(true)
end

function EDITOR.gui_getEditingWindow()
	return window_editing
end

function EDITOR.gui_hideEditingWindow()
	EDITOR.gui_showEditingWindow()
	window_editing:setVisible(false)
end

function EDITOR.gui_toggleEditingWindow()
	if not ( gui_utils.widgetExists(window_editing) ) then
		EDITOR.gui_showEditingWindow()
		return
	end
	window_editing:setVisible(not window_editing:isVisible())
end