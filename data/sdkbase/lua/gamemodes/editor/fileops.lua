--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local MSG_GUI_CMD_MAP_NEW = net.registerMessage("gui_cmd_map_new", function(sender, data) EDITOR.new() end, true)
function EDITOR.new()
	if (CLIENT) then
		local dat = net.data()
		net.sendMessage(MSG_GUI_CMD_MAP_NEW, dat)
	elseif (SERVER) then
		map.changeToEmpty()
	end
end

local MSG_GUI_CMD_MAP_OPEN = net.registerMessage("gui_cmd_map_open", function(sender, data) EDITOR.open(data:readNext()) end, true)
function EDITOR.open( strFileName )
	if (CLIENT) then
		if ( strFileName ) then
			local dat = net.data()
			dat:writeString(strFileName)
			net.sendMessage(MSG_GUI_CMD_MAP_OPEN, dat)
		else
			gui_filedialog.show( "Open", "Open", EDITOR.open, "maps/", gui_filedialog.TRAVERSAL_NONE, gui_filedialog.EXISTING_ONLY ) -- TODO: stringadactyl
		end
	elseif (SERVER) then
		if (strFileName) then
			map.change( strFileName )
		end
	end
end

function EDITOR.save()
	EDITOR.saveAs( map.getCurrentMapName() )
end

local MSG_GUI_CMD_MAP_SAVE = net.registerMessage("gui_cmd_map_saveas", function(sender, data) EDITOR.saveAs(data:readNext()) end, true)
function EDITOR.saveAs( strFileName )
	if (CLIENT) then
		if ( strFileName and string.len(strFileName) > 0 ) then
			local dat = net.data()
			dat:writeString(strFileName)
			net.sendMessage(MSG_GUI_CMD_MAP_SAVE, dat)
		else
			gui_filedialog.show( "Save As...", "Save", EDITOR.saveAs, "maps/", gui_filedialog.TRAVERSAL_NONE, gui_filedialog.EXISTING_BOTH_WARN ) -- TODO: stringadactyl
		end
	elseif (SERVER) then
		if (strFileName) then
			map.save( strFileName )
		end
	end
end
