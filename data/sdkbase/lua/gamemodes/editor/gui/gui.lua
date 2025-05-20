--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local GM_BASE = gamemode.getClass(GM.CLASSNAME_BASE)

if (CLIENT) then

	local window_tools = nil
	
	local window_tool_settings = nil
	local tool_settings_panel = nil
	
	local menu_bar = nil
	
	local display = fgui.getDisplay()
	
	function GM:fgui_initialize()
		--GM_BASE.fgui_initialize( self )
		EDITOR.gui_createMenuBar()
		EDITOR.gui_showEditingWindow()
		EDITOR.gui_showToolsWindow()
		EDITOR.gui_showToolSettingsWindow()
		EDITOR.gui_showTexturesWindow()
		EDITOR.gui_showExplorerWindow()
	end
	
	function EDITOR.gui_showToolsWindow()
		if not ( gui_utils.widgetExists(window_tools) ) then
			window_tools = fgui.createWindow(true, false, false, false)
			window_tools:setTitle("Tools") -- TODO: stringadactyl
			local cont = window_tools:getContentContainer()
			
			-- Set up the grid layout
			cont:setLayoutManager(fgui.newGridLayout(math.max(math.ceil(table.count(tools.list) / 2), 2),2))
			
			-- Add the tool buttons
			for k, v in pairs(tools.listByAdded) do
				local button = fgui.createButton(cont)
				local tex = textures.get("gui/editor/" .. v.name .. ".png")
				local pix = pixmap.fromTexture(tex,0,0,24,24,24,24,24,24)
				button:setPixmap(pix)
				button:setMinSize(32,32)
				button:setSize(32,32)
				fgui.setTooltip(button, v.friendlyName)
				
				button:addButtonPressedListener(fgui_listeners.buttonPressed( function() tools.setCurrent(v) end ))
				v.wButton = button
				
				window_tools:addWindowClosedListener(fgui_listeners.windowClosed(EDITOR.gui_hideToolsWindow))
			end
			
			cont:updateMinSizeAndLayout()
			window_tools:setResizable(false)
			window_tools:setX(0)
			window_tools:setY(fgui.getDisplay():getHeight()/2 - window_tools:getHeight()/2)
		end
		
		window_tools:setVisible(true)
	end
	
	function EDITOR.gui_getToolWindow()
		return window_tools
	end
	
	function EDITOR.gui_hideToolsWindow()
		EDITOR.gui_showToolsWindow()
		window_tools:setVisible(false)
	end
	
	function EDITOR.gui_toggleToolsWindow()
		if not ( gui_utils.widgetExists(window_tools) ) then
			EDITOR.gui_showToolsWindow()
			return
		end
		window_tools:setVisible(not window_tools:isVisible())
	end
	
	function EDITOR.gui_showToolSettingsWindow()
		if not ( gui_utils.widgetExists(window_tool_settings) ) then
			window_tool_settings = fgui.createWindow(true, false, false, false)
			window_tool_settings:setTitle("Tool Settings") -- TODO: stringadactyl
			tool_settings_panel = window_tool_settings:getContentContainer()
			window_tool_settings:setWidth(200)
			window_tool_settings:setHeight(280)
			
			
			window_tool_settings:setResizable(true)
			
			window_tool_settings:setX(fgui.getDisplay():getWidth() - window_tool_settings:getWidth())
			window_tool_settings:setY(fgui.getDisplay():getHeight() - window_tool_settings:getHeight() - menu_bar:getHeight())
			
			window_tool_settings:addWindowClosedListener(fgui_listeners.windowClosed(EDITOR.gui_hideToolSettingsWindow))
		end
		
		window_tool_settings:setVisible(true)
	end
	
	function EDITOR.gui_getToolSettingsWindow()
		return window_tool_settings
	end
	
	function EDITOR.gui_getToolSettingsPanel()
		return tool_settings_panel
	end
	
	function EDITOR.gui_hideToolSettingsWindow()
		EDITOR.gui_showToolSettingsWindow()
		window_tool_settings:setVisible(false)
	end
	
	function EDITOR.gui_toggleToolSettingsWindow()
		if not ( gui_utils.widgetExists(window_tool_settings) ) then
			EDITOR.gui_showToolSettingsWindow()
			return
		end
		window_tool_settings:setVisible(not window_tool_settings:isVisible())
	end
	
	
	function EDITOR.gui_createMenuBar()
		if not ( gui_utils.widgetExists(menu_bar) ) then
			menu_bar = fgui.createMenuBar()
			
			local menu_file = fgui.createMenu(menu_bar, "File") -- TODO Stringadactyl
			local menu_file_item_new = fgui.createMenuItem(menu_file, "New") -- TODO Stringadactyl
			menu_file_item_new:addMenuItemPressedListener(fgui_listeners.menuItemPressed( function() EDITOR.new() end ))
			local menu_file_item_open = fgui.createMenuItem(menu_file, "Open (CTRL+O)") -- TODO Stringadactyl
			menu_file_item_open:addMenuItemPressedListener(fgui_listeners.menuItemPressed( function() EDITOR.open() end ))
			local menu_file_item_save = fgui.createMenuItem(menu_file, "Save (CTRL+S)") -- TODO Stringadactyl
			menu_file_item_save:addMenuItemPressedListener(fgui_listeners.menuItemPressed( function() EDITOR.save() end ))
			local menu_file_item_save_as = fgui.createMenuItem(menu_file, "Save As... (CTRL+SHIFT+S)") -- TODO Stringadactyl
			menu_file_item_save_as:addMenuItemPressedListener(fgui_listeners.menuItemPressed( function() EDITOR.saveAs() end ))
			
			local menu_file_item_save_as = fgui.createMenuItem(menu_file, "Quit Editor") -- TODO Stringadactyl
			menu_file_item_save_as:addMenuItemPressedListener(fgui_listeners.menuItemPressed( function() net.disconnect() end ))
			
			local menu_edit = fgui.createMenu(menu_bar, "Edit") -- TODO Stringadactyl
			local menu_edit_undo = fgui.createMenuItem(menu_edit, "Undo (CTRL+Z)") -- TODO Stringadactyl
      menu_edit_undo:addMenuItemPressedListener(fgui_listeners.menuItemPressed( function() EDITOR.actionEvent(actions.UNDO) end ))
			local menu_edit_copy = fgui.createMenuItem(menu_edit, "Copy (CTRL+C)") -- TODO Stringadactyl
			menu_edit_copy:addMenuItemPressedListener(fgui_listeners.menuItemPressed( function() EDITOR.actionEvent(actions.COPY) end ))
			local menu_edit_paste = fgui.createMenuItem(menu_edit, "Paste (CTRL+V)") -- TODO Stringadactyl
			menu_edit_paste:addMenuItemPressedListener(fgui_listeners.menuItemPressed( function() EDITOR.actionEvent(actions.PASTE) end ))
			local menu_edit_delete = fgui.createMenuItem(menu_edit, "Delete (DELETE)") -- TODO Stringadactyl
			menu_edit_delete:addMenuItemPressedListener(fgui_listeners.menuItemPressed( function() EDITOR.actionEvent(actions.DELETE) end ))
			local menu_edit_selectall = fgui.createMenuItem(menu_edit, "Select All (CTRL+A)") -- TODO Stringadactyl
			menu_edit_selectall:addMenuItemPressedListener(fgui_listeners.menuItemPressed( function() tools.selectAll() end ))
			local menu_edit_properties = fgui.createMenuItem(menu_edit, "Properties (ALT+ENTER)") -- TODO Stringadactyl
			menu_edit_properties:addMenuItemPressedListener(fgui_listeners.menuItemPressed( function() EDITOR.gui_showPropertiesWindow(tools.selectedEnts) end ))
			
			local menu_window = fgui.createMenu(menu_bar, "Window") -- TODO Stringadactyl
			local menu_window_tools = fgui.createMenuItem(menu_window, "Tools") -- TODO Stringadactyl
			menu_window_tools:addMenuItemPressedListener(fgui_listeners.menuItemPressed( EDITOR.gui_toggleToolsWindow ))
			local menu_window_tool_settings = fgui.createMenuItem(menu_window, "Entities Explorer") -- TODO Stringadactyl
			menu_window_tool_settings:addMenuItemPressedListener(fgui_listeners.menuItemPressed( EDITOR.gui_toggleExplorerWindow ))
			local menu_window_tool_settings = fgui.createMenuItem(menu_window, "Tool Settings") -- TODO Stringadactyl
			menu_window_tool_settings:addMenuItemPressedListener(fgui_listeners.menuItemPressed( EDITOR.gui_toggleToolSettingsWindow ))
			local menu_window_grid = fgui.createMenuItem(menu_window, "Editing Functions") -- TODO Stringadactyl
			menu_window_grid:addMenuItemPressedListener(fgui_listeners.menuItemPressed( EDITOR.gui_toggleEditingWindow ))
			local menu_window_textures = fgui.createMenuItem(menu_window, "Textures") -- TODO Stringadactyl
			menu_window_textures:addMenuItemPressedListener(fgui_listeners.menuItemPressed( EDITOR.gui_toggleTexturesWindow ))
			
			local menu_help = fgui.createMenu(menu_bar, "Help") -- TODO Stringadactyl
			local menu_help_keys = fgui.createMenuItem(menu_help, "Keyboard Shortcuts") -- TODO Stringadactyl
			menu_help_keys:addMenuItemPressedListener(fgui_listeners.menuItemPressed( EDITOR.gui_toggleToolsWindow ))
			
			menu_bar:updateMinSize()
			menu_bar:setX(0)
			menu_bar:setY(display:getHeight() - menu_bar:getMinHeight())
	    	menu_bar:setSize(display:getWidth(), menu_bar:getMinHeight())
	   		menu_bar:setShrinkable(false)
	   		-- TODO Add fgui_listeners DisplaySizeChanged listener; use it here to move/resize the menu back to top if size did in fact change.
	   		
			return true
		end
		
		return false
	end
	
	function EDITOR.gui_getMenuBar()
		return menu_bar
	end
	
	-- CS include after
	include("cl_gui_window_editing.lua")
	include("cl_gui_window_textures.lua")
	include("cl_gui_cmds.lua")
	
end

-- Shared include after
include("gui_window_explorer.lua")
include("gui_window_properties.lua")
