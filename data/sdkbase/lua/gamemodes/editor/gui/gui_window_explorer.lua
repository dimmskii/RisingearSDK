--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


if (CLIENT) then
	
	local hidden16 = pixmap.fromTexture(textures.get("gui/hide.png"),0,0,16,16,16,16,16,16)
  local visible16 = pixmap.fromTexture(textures.get("gui/show.png"),0,0,16,16,16,16,16,16)
  
  local show32 = pixmap.fromTexture(textures.get("gui/show32.png"),0,0,24,24,24,24,24,24)
  local hide32 = pixmap.fromTexture(textures.get("gui/hide32.png"),0,0,24,24,24,24,24,24)
  local remove32 = pixmap.fromTexture(textures.get("gui/cross32.png"),0,0,24,24,24,24,24,24)
  local dots32 = pixmap.fromTexture(textures.get("gui/dots32.png"),0,0,24,24,24,24,24,24)
	
	local window_explorer = nil
	
	local explorer_list = nil
	
	local explorer_list_ents = {}
	
	local supressSelectionChangedEvent = false -- Used to avoid infinite call loop when we update the entity table widget from model
	
	local function actionCallback( action )
		EDITOR.gui_updateExplorerList( )
	end
	
	EDITOR.actionAddCallback(actionCallback)
	
	-- Global function to update the entity explorer
	function EDITOR.gui_updateExplorerList( )
		if not explorer_list then return end
		
		supressSelectionChangedEvent = true
		
		explorer_list_ents = {}
		
		local allEnts = ents.getAll()
		for k,v in pairs(allEnts) do
			if v.id == 0 then
				table.insert(explorer_list_ents,1,v)
			else
				table.insert(explorer_list_ents, v)
			end
		end
		
		explorer_list:updateFromModel()
		explorer_list:setNumberOfSelectableRows(table.count(explorer_list_ents))
		explorer_list:clearSelection()
		
		local model = explorer_list:getModel()
		local n = table.getn(explorer_list_ents)
		for i=0,n-1 do
			local ent = explorer_list_ents[i+1]
			if table.hasValue(tools.selectedEnts,ent) then
				explorer_list:setSelected(i, true)
			end
		end
		
		supressSelectionChangedEvent = false
	end
	
	-- Callback for when the apply button is pressed
	local function applyButton()
		if (SERVER) then return end -- Servers don't send prop spawn messages
	end
	
	function EDITOR.gui_showExplorerWindow()
		if not ( gui_utils.widgetExists(window_explorer) ) then
			window_explorer = fgui.createWindow(true, false, false, false)
			window_explorer:setTitle("Ent Explorer") -- TODO: stringadactyl
			
			local cont = window_explorer:getContentContainer()
			cont:setLayoutManager(fgui.newRowLayout())
			
--			local scroll = fgui.createScrollContainer(cont)
--			scroll:getAppearance():add(fgui_decorators.createTitledBorder("id - CLASSNAME - tag")) -- TODO Stringadactyl
			
--			explorer_list = fgui.createTable(scroll)
			local table_container = fgui.createTableContainer(cont)
			explorer_list = table_container:getTable()
			explorer_list:setModel(fgui.newTableModel({
				getColumnName = function(iCol)
					if iCol == 0 then
						return "ID" -- TODO Stringadactyl
					elseif iCol == 1 then
						return "Class Name" -- TODO Stringadactyl
					else
						return "Tag" -- TODO Stringadactyl
					end
				end,
				getColumnCount = function()
					return 3
				end,
				getRowCount = function()
					return table.count(explorer_list_ents)
				end,
				getItem = function(iCol, iRow, labelAppearance)
					local ent = explorer_list_ents[iRow+1]
					local item
					if iCol == 0 then
						item = fgui.newItem(labelAppearance, tostring(ent.id))
					elseif iCol == 1 then
						item = fgui.newItem(labelAppearance, tostring(ent.CLASSNAME))
					else
						item = fgui.newItem(labelAppearance, tostring(ent.tag))
					end
					item:setData(ent)
					return item
				end
			
			}))
			explorer_list:setColumnWidthPercent(0, 15)
			explorer_list:setColumnWidthPercent(1, 45)
			explorer_list:setColumnWidthPercent(2, 40)
			explorer_list:updateFromModel()
			
			explorer_list:addSelectionChangedListener(fgui_listeners.selectionChanged(function(selectionChangedEvent)
				if supressSelectionChangedEvent then return end
				local ent = selectionChangedEvent:getToggableWidget():getItem(0):getData()
				local tSelectedEnts = tools.selectedEnts
				if selectionChangedEvent:isSelected() then
					for k,v in pairs(tSelectedEnts) do
						if v==ent then
							return -- Already contains so return
						end
					end
					table.insert(tSelectedEnts, ent)
				else
					for k,v in pairs(tSelectedEnts) do
						if v==ent then
							table.remove(tSelectedEnts,k)
						end
					end
				end
				tools.setSelection(tSelectedEnts)
			end))
			
			window_explorer:addWindowClosedListener(fgui_listeners.windowClosed(EDITOR.gui_hideExplorerWindow))
			
			local contButtons = fgui.createContainer(cont)
			contButtons:setLayoutManager(fgui.newRowLayout(true))
			contButtons:setExpandable(false)
			
			local btnShow = fgui.createButton(contButtons)
      btnShow:setPixmap(show32)
      btnShow:setMinSize(32,32)
      btnShow:setSize(32,32)
      btnShow:setExpandable(false)
      fgui.setTooltip(btnShow, "Un-hide") -- TODO: Stringadactyl
      btnShow:addButtonPressedListener(fgui_listeners.buttonPressed( function()
        EDITOR.actionEvent(actions.UNHIDE)
      end ))
			
			local btnHide = fgui.createButton(contButtons)
      btnHide:setPixmap(hide32)
      btnHide:setMinSize(32,32)
      btnHide:setSize(32,32)
      btnHide:setExpandable(false)
      fgui.setTooltip(btnHide, "Hide") -- TODO: Stringadactyl
      btnHide:addButtonPressedListener(fgui_listeners.buttonPressed( function()
        EDITOR.actionEvent(actions.HIDE)
      end ))
			
			local btnRemove = fgui.createButton(contButtons)
      btnRemove:setPixmap(remove32)
      btnRemove:setMinSize(32,32)
      btnRemove:setSize(32,32)
      btnRemove:setExpandable(false)
      fgui.setTooltip(btnRemove, "Delete") -- TODO: Stringadactyl
      btnRemove:addButtonPressedListener(fgui_listeners.buttonPressed( function()
        EDITOR.actionEvent(actions.DELETE)
      end ))
      
      local btnProps = fgui.createButton(contButtons)
      btnProps:setPixmap(dots32)
      btnProps:setMinSize(32,32)
      btnProps:setSize(32,32)
      btnProps:setExpandable(false)
      fgui.setTooltip(btnProps, "Properties") -- TODO: Stringadactyl
      btnProps:addButtonPressedListener(fgui_listeners.buttonPressed( function()
        EDITOR.gui_showPropertiesWindow(tools.selectedEnts)
      end ))
      
      contButtons:layout()
			
			window_explorer:setWidth(200)
			window_explorer:setHeight(512)
			
			window_explorer:setX(fgui.getDisplay():getWidth() - window_explorer:getWidth())
			window_explorer:setY(0)

		end
		
		window_explorer:setVisible(true)
	end
	
	function EDITOR.gui_getExplorerWindow()
		return window_explorer
	end
	
	function EDITOR.gui_hideExplorerWindow()
		EDITOR.gui_showExplorerWindow()
		window_explorer:setVisible(false)
	end
	
	function EDITOR.gui_toggleExplorerWindow()
		if not ( gui_utils.widgetExists(window_explorer) ) then
			EDITOR.gui_showExplorerWindow()
			return
		end
		window_explorer:setVisible(not window_explorer:isVisible())
	end
	
	local function onJoinGame()
    EDITOR.gui_updateExplorerList( )
	end
	hook.add("onJoinGame", "gui_window_explorer_onJoinGame", onJoinGame)

end