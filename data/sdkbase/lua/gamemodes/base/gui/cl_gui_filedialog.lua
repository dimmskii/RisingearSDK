--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local pixmapDir, pixmapFile
hook.add("fgui_initialize","fgui_filedialog_precache",function()
	pixmapDir = pixmap.fromTexture(textures.get("gui/folder.png"),0,0,16,16,16,16,16,16)
	pixmapFile = pixmap.fromTexture(textures.get("gui/file.png"),0,0,16,16,16,16,16,16)
end)

local function listContents(fdiag, dir)
	local list = file.listNames( fdiag.currentDir, false, true, true, file.SORT_METHOD_NAME, true)
	fdiag.list = {}
	for k,v in pairs(list) do
		table.insert(fdiag.list,v)
	end
	table.sort(fdiag.list,function(v1,v2)
	 if file.isDir(v1) and not file.isDir(v2) then
	   return true
	 elseif not file.isDir(v1) and file.isDir(v2) then
	   return false
	 end
	 return file.getName(v1) < file.getName(v2)
	end)

	fdiag.widgetList:clear()
	if fdiag.traversal > 0 then
		if fdiag.traversal > 1 or file.isInDirectory(fdiag.currentDir, fdiag.initialDir) then
			local item = fdiag.widgetList:addItem("..")
			local data = file.getParent(fdiag.currentDir) or "/"
			item:setData(data)
			item:setPixmap(pixmapDir,fdiag.widgetList:getAppearance())
		end
	end

	for k,v in pairs(fdiag.list) do
		local displayName = file.getName(v)
		local pix = pixmapFile
		if file.isDir(v) then
			displayName = displayName .. "/"
			pix = pixmapDir
		end
		local item = fdiag.widgetList:addItem(displayName)
		item:setData(v)
		item:setPixmap(pix,fdiag.widgetList:getAppearance())
	end
	
end

-- TODO: onButtonAcceptPressed should also be responsible for traversal into directories by having the list widget select the dir name as text in the same way it does for files
-- Following that logic, the file dialog should probably have an additional boolean option for accepting files/folders/both
-- Additionally, there needs to be implemented a file extension filter that will also append the selected extensions when needed (except for All files .*; hidden directory selected exception)
local function onButtonAcceptPressed( fdiag )
	if not file.isValidFileName(fdiag.currentFile) then
		local wMsg = fgui.createMessageWindow( "Invalid file name given.", "Error" ) -- TODO: Stringadactyl
		wMsg:centerOnScreen()
		return
	end
	
	local bExists = file.exists( fdiag.currentDir .. "/" .. fdiag.currentFile )
	
	if fdiag.existing == gui_filedialog.EXISTING_DENY and bExists then
		local wMsg = fgui.createMessageWindow( "File with this name already exists.", "Error" ) -- TODO: Stringadactyl
		wMsg:centerOnScreen()
		return
	end
	
	if fdiag.existing == gui_filedialog.EXISTING_ONLY and (not bExists) then
		local wMsg = fgui.createMessageWindow( "File with this name doesn't exist.", "Error" ) -- TODO: Stringadactyl
		wMsg:centerOnScreen()
		return
	end
	
	if fdiag.existing >= gui_filedialog.EXISTING_BOTH_WARN and bExists then
		local wYesNo = fgui.createYesNoDialog( "File with name '" .. fdiag.currentFile .. "' already exists.\nAre you sure you wish to overwrite it?", "Confirm Overwrite" ) -- TODO: Stringadactyl
		wYesNo:centerOnScreen()
		wYesNo:addYesNoAnsweredListener(fgui_listeners.yesNoAnswered( function(e)
			if e:getResponse() == e.RESPONSE_YES then
				fdiag.funcAccept( fdiag.currentFile, fdiag.currentDir )
				fdiag.window:close()
			end
		end ))
		
		return
	end
	
	fdiag.funcAccept( fdiag.currentFile, fdiag.currentDir )
	fdiag.window:close()
end

gui_filedialog = {}

gui_filedialog.TRAVERSAL_DENY	= 0		-- Don't allow traversal or accept file paths outside specified directory
gui_filedialog.TRAVERSAL_SUBDIR	= 1		-- Allow inward traversal and accept file paths inside specified directory or subdirectories
gui_filedialog.TRAVERSAL_FULL	= 2		-- Allow full traversal and accept file paths in any directory within VFS

gui_filedialog.EXISTING_DENY		= 0		-- Accept only non-existing names
gui_filedialog.EXISTING_ONLY		= 1		-- Accept only existing names
gui_filedialog.EXISTING_BOTH		= 2		-- Accept both without confirmation
gui_filedialog.EXISTING_BOTH_WARN	= 3		-- Accept both with confirmation

-- strTitle:		The title of the dialog
-- strButton:		The text for the accept button
-- func:			The function to execute upon accept button press
-- allowTraversal:	0 to disable, 1 to allow accessing child dirs, 2 to allow accessing child and parent dirs. Default 0
-- existing:		Use gui_filedialog.EXISTING_*
gui_filedialog.show = function( strTitle, strButton, func, dir, traversal, existing )
	
	local fdiag={}
	
	fdiag.traversal = traversal or gui_filedialog.TRAVERSAL_DENY
	fdiag.existing = existing or gui_filedialog.EXISTING_DENY
	
	fdiag.initialDir = dir
	fdiag.currentDir = dir
	
	fdiag.funcAccept = func or function() end

	fdiag.window = fgui.createWindow(true, false, false, false)
	fdiag.window:setTitle(strTitle)
	fdiag.wContentPane = fdiag.window:getContentContainer()
	fdiag.wContentPane:setLayoutManager(fgui.newRowLayout())
	fdiag.wScrollPane = fgui.createScrollContainer(fdiag.wContentPane)
	fdiag.wFileTextField = fgui.createTextEditor(fdiag.wContentPane)
	fdiag.wFileTextField:setText("")
    fdiag.wFileTextField:setMultiline(false)
    fdiag.wFileTextField:addTextChangedListener(fgui_listeners.textChanged( function() fdiag.currentFile = fdiag.wFileTextField:getText() end ))
	local buttonPane = fgui.createContainer(fdiag.wContentPane)
	local btnCancel = fgui.createButton(buttonPane, "Cancel") -- TODO: Stringadactyl
	btnCancel:addButtonPressedListener(fgui_listeners.buttonPressed( function() fdiag.window:close() end ))
	local btnAccept = fgui.createButton(buttonPane, strButton)
	btnAccept:addButtonPressedListener(fgui_listeners.buttonPressed( function() onButtonAcceptPressed(fdiag) end ))
	
	fdiag.window:setResizable(true)
	
	fdiag.widgetList = fgui.createList(fdiag.wScrollPane)
	
	listContents( fdiag )
	
	fdiag.widgetList:getToggableWidgetGroup():addSelectionChangedListener(fgui_listeners.selectionChanged(function()
		if fdiag.widgetList:getSelectedItem() then
			fdiag.selectedItem = fdiag.widgetList:getSelectedItem()
		end
		if fdiag.selectedItem then
			local sel = fdiag.selectedItem:getData()
			if file.isDir(sel) then
				fdiag.currentDir = sel
				if fdiag.traversal > 0 then
					listContents( fdiag )
				end
			else
				fdiag.currentFile = fdiag.selectedItem:getText()
				fdiag.wFileTextField:setText(fdiag.currentFile)
			end
			--fdiag.widgetList:setSelectedItem(fdiag.selectedItem,true)
		end
	end))
	
	fdiag.window:setWidth(320)
	fdiag.window:setMinWidth(320)
	fdiag.window:setMaxWidth(320)
	buttonPane:setExpandable(false)
	buttonPane:setShrinkable(false)
	fdiag.wFileTextField:setExpandable(false)
	fdiag.wFileTextField:setShrinkable(false)
	fdiag.window:setHeight(400)
	fdiag.window:centerOnScreen()
	
	return fdiag
end