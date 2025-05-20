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
	
	local function actionCallback( action )
		EDITOR.gui_updateExplorerList( )
	end
	
	EDITOR.actionAddCallback(actionCallback)
	
	-- Global function to update the entity explorer
	function EDITOR.gui_updateExplorerList( )
		if not explorer_list then return end
		explorer_list:clear()
		-- Update
		 local allEnts = ents.getAll()
		 local allEntsSorted = {}
		 for k,v in pairs(allEnts) do
		  table.insert(allEntsSorted,v)
		 end
		 table.sort(allEntsSorted,function(ent1,ent2)
		  return ent1.id < ent2.id
		 end)
		 for _,ent in ipairs(allEntsSorted) do
		  local tag = ent:getTag() or ""
		  local item = explorer_list:addItem(string.format("%5d | %s | %s", ent.id, ent.CLASSNAME, tag))
		  item:setData(ent)
		  if ent:editor_isHidden() then
        item:setPixmap(hidden16,explorer_list:getAppearance())
      else
        item:setPixmap(visible16,explorer_list:getAppearance())
      end
		  if table.hasValue(tools.selectedEnts,ent) then
		    item:setSelected(true)
		  end
		 end
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
			
			local scroll = fgui.createScrollContainer(cont)
			scroll:getAppearance():add(fgui_decorators.createTitledBorder("id - CLASSNAME - tag")) -- TODO Stringadactyl
			explorer_list = fgui.createList(scroll, fgui.SELECTION_MULTIPLE)
			
			explorer_list:getToggableWidgetGroup():addSelectionChangedListener(fgui_listeners.selectionChanged(function(selectionChangedEvent)
			   local ent = selectionChangedEvent:getToggableWidget():getData()
			   local tSelectedEnts = tools.selectedEnts
			   if (selectionChangedEvent:isSelected()) then
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