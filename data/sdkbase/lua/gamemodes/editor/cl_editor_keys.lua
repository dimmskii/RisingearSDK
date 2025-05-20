--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

------------------------------------------------------------------------------
-- Editor Keys
-- This is the global variable which holds the preloaded @{editor_keys} functions
-- @field[parent=#global] editor_keys#editor_keys editor_keys table
editor_keys = {}

local function isAlt() return controller.isButtonDown(controller.BTN_LMENU) or controller.isButtonDown(controller.BTN_RMENU) end
local function isControl() return controller.isButtonDown(controller.BTN_LCONTROL) or controller.isButtonDown(controller.BTN_RCONTROL) end
local function isShift() return controller.isButtonDown(controller.BTN_LSHIFT) or controller.isButtonDown(controller.BTN_RSHIFT) end

editor_keys.MOD_IGNORE = function() return true end	-- Ignore all modifiers. Key down event will be triggered regardless of ALT/CTRL/SHIFT
editor_keys.MOD_NONE = function() return			not isAlt()		and		not isControl()		and			not isShift() 		end		-- MOD_NONE ensures that none of the three modifiers are down
editor_keys.MOD_ALT = function() return				isAlt()			and		not isControl()		and			not isShift() 		end
editor_keys.MOD_CTRL = function() return			not isAlt()		and		isControl()			and			not isShift() 		end
editor_keys.MOD_SHIFT = function() return			not isAlt()		and		not isControl()		and			isShift() 			end
editor_keys.MOD_ALT_CTRL = function() return		isAlt()			and		isControl()			and			not isShift() 		end
editor_keys.MOD_ALT_SHIFT = function() return		isAlt()			and		not isControl()		and			isShift() 			end
editor_keys.MOD_CTRL_SHIFT = function() return		not isAlt()		and		isControl()			and			isShift() 			end
editor_keys.MOD_ALT_CTRL_SHIFT = function() return	isAlt()			and		isControl()			and			isShift() 			end

-------------------------------------------------------------------------------
-- Initialize the editor_keys system.
-- @function [parent=#editor_keys] initialize
editor_keys.initialize = function()

	-- FILE HOTKEYS
	editor_keys.register( editor_keys.newListener(function() EDITOR.save() end), controller.BTN_S, editor_keys.MOD_CTRL ) -- CTRL+S to Save
	editor_keys.register( editor_keys.newListener(function() EDITOR.saveAs() end), controller.BTN_S, editor_keys.MOD_CTRL_SHIFT ) -- CTRL+SHIFT+S to Save As...
	editor_keys.register( editor_keys.newListener(function() EDITOR.open() end), controller.BTN_O, editor_keys.MOD_CTRL ) -- CTRL+O to Open
	
	-- SELECTION AND CLIPBOARD HOTKEYS
	editor_keys.register( editor_keys.newListener(function() tools.selectAll() end), controller.BTN_A, editor_keys.MOD_CTRL ) -- CTRL+A to Select All
	editor_keys.register( editor_keys.newListener(function() tools.clearSelection() end), controller.BTN_D, editor_keys.MOD_CTRL ) -- CTRL+D to De-select All
	editor_keys.register( editor_keys.newListener(function() EDITOR.actionEvent(actions.COPY) end), controller.BTN_C, editor_keys.MOD_CTRL ) -- CTRL+C to Copy
	editor_keys.register( editor_keys.newListener(function() EDITOR.actionEvent(actions.PASTE) end), controller.BTN_V, editor_keys.MOD_CTRL ) -- CTRL+V to Paste
	editor_keys.register( editor_keys.newListener(function() EDITOR.actionEvent(actions.DELETE) end), controller.BTN_DELETE, editor_keys.NONE ) -- DELETE to Delete
	editor_keys.register( editor_keys.newListener(function() EDITOR.actionEvent(actions.UNDO) end), controller.BTN_Z, editor_keys.MOD_CTRL ) -- CTRL+Z to Undo
	
	-- GUI HOTKEYS
	editor_keys.register( editor_keys.newListener(
		function()
			EDITOR.gui_showPropertiesWindow(tools.selectedEnts)
		end
	),controller.BTN_RETURN, editor_keys.MOD_ALT ) -- ALT+ENTER Ent Properties
	
	-- Init scroll wheel zoomins
	local listener = {}
	listener.buttonPressed = function(button)
		if button == controller.BTN_MWHEELUP then
			editor_cam.zoomIn(1.1, true)
			return true
		elseif button == controller.BTN_MWHEELDOWN then
			editor_cam.zoomOut(1.1, true)
			return true
		end
		return false
	end
	
	controller.addListener(listener, false)
end

-------------------------------------------------------------------------------
-- Creates a listener table with empty functions. For use in editor_keys.* functions.
-- @function [parent=#editor_keys] newListener
-- @return #table listener
editor_keys.newListener = function( onPressed, onReleased )
	local listen = {}
	listen.onPressed = onPressed or function() end
	listen.onReleased = onReleased or function() end
	return listen
end

-------------------------------------------------------------------------------
-- Registers an editor key function
-- @function [parent=#editor_keys] register
-- @param #table listener the editor key listener table. Use editor_keys.newListener
-- @param modifier the key modifier. Use editor_keys.MOD_*
editor_keys.register = function(listener, key, modifier)
	local parentListener = {}
	modifier = modifier or editor_keys.MOD_IGNORE
	parentListener.buttonPressed = function(button)
		if button == key and modifier() then
			listener.onPressed()
		end
		return false
	end
	
	parentListener.buttonReleased = function(button)
		if button == key then
			listener.onReleased()
		end
		return false
	end
	
	controller.addListener(parentListener, false)
end