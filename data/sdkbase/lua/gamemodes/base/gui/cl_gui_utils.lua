--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- General-purpose Lua FGUI utils

gui_utils = {}

-- Checks and returns true if a widget is not nil and is in the widget tree
gui_utils.widgetExists = function( widget )
	if ( widget == nil ) then return false end
	if not ( widget:isInWidgetTree() ) then return false end
	return true
end