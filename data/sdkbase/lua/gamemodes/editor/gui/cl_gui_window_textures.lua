--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local window_textures = nil

local selectedTexturePath = "common/default.png"
local selectedTexture = textures.get(selectedTexturePath)
local bLiftTextures = true

local cont_preview = nil

local function createTexturePreview()
	if not cont_preview then return end
	
	cont_preview:removeAllWidgets()

	local preview = fgui.createButton(cont_preview)
	local dim = 64
	preview:setMinSize(dim,dim)
	preview:setSize(dim,dim)
	local tex = selectedTexture
	local pix = pixmap.fromTexture(tex,0,0,dim,dim,dim,dim,dim,dim)
	preview:setPixmap(pix)
	preview:addButtonPressedListener(fgui_listeners.buttonPressed(function() EDITOR.selectTexture() end))
			
	window_textures:setResizable(true)
	window_textures:addWindowResizedListener(fgui_listeners.windowResized(function()
		pix:setSize(preview:getWidth(), preview:getHeight())
		local ptex = pix:getTexture()
		ptex:setTexSize(preview:getWidth(), preview:getHeight())
		ptex:setImgSize(preview:getWidth(), preview:getHeight())
	end))
end

function EDITOR.selectTexture(texPath)
	if not texPath then
		gui_filedialog.show( "Browse Textures", "Open", function(strFileName, strPath)
			strPath = string.sub(strPath, string.len("textures/"))
			EDITOR.selectTexture(strPath .. "/" .. strFileName)
		end, "textures/", gui_filedialog.TRAVERSAL_SUBDIR, gui_filedialog.EXISTING_ONLY ) -- TODO: stringadactyl
		return
	end
	selectedTexturePath = texPath
	selectedTexture = textures.get(texPath)
	
	createTexturePreview()
end

function EDITOR.getSelectedTexturePath()
	return selectedTexturePath
end

function EDITOR.getSelectedTexture()
	return selectedTexture
end

function EDITOR.gui_showTexturesWindow()
	if not ( gui_utils.widgetExists(window_textures) ) then
		window_textures = fgui.createWindow(true, false, false, false)
		window_textures:setTitle("Textures") -- TODO: stringadactyl
		local cont = window_textures:getContentContainer()
		
		cont:setLayoutManager(fgui.newRowLayout())
		
		cont_preview = fgui.createContainer(cont)
		cont_preview:getAppearance():add(fgui_decorators.createTitledBorder("Preview")) -- TODO Stringadactyl
		
		createTexturePreview()
		
		local btnApply = fgui.createButton(cont)
		btnApply:setText("Apply") -- TODO Stringadactyl
		btnApply:addButtonPressedListener(fgui_listeners.buttonPressed(function() EDITOR.applyTexture(selectedTexturePath) end))
		btnApply:setExpandable(false)
		
		local btnFit = fgui.createButton(cont)
		btnFit:setText("Fit") -- TODO Stringadactyl
		btnFit:addButtonPressedListener(fgui_listeners.buttonPressed(function() EDITOR.fitTexture() end))
		btnFit:setExpandable(false)
		
		local liftCont = fgui.createContainer(cont)
		local lifeLabel = fgui.createLabel(liftCont, "Lift selection"); -- TODO: Stringadactyl
		local liftLabel = fgui.createCheckBox(liftCont)
		liftLabel:setSelected( bLiftTextures )
		liftLabel:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev) bLiftTextures = ev:isSelected() end))
		
		window_textures:addWindowClosedListener(fgui_listeners.windowClosed(EDITOR.gui_hideTexturesWindow))
	end
	
	window_textures:setVisible(true)
end

function EDITOR.gui_getTexturesWindow()
	return window_textures
end

function EDITOR.gui_hideTexturesWindow()
	EDITOR.gui_showTexturesWindow()
	window_textures:setVisible(false)
end

function EDITOR.gui_toggleTexturesWindow()
	if not ( gui_utils.widgetExists(window_textures) ) then
		EDITOR.gui_showTexturesWindow()
		return
	end
	window_textures:setVisible(not window_textures:isVisible())
end

EDITOR.actionAddCallback(
function(action)
	if (bLiftTextures and action == actions.SELECT) then
		for k,v in pairs(tools.selectedEnts) do
			if (v.editor_getTexture) then
				local texpath = v:editor_getTexture()
				if (texpath) then
					EDITOR.selectTexture(texpath)
					return
				end
			end
		end
	end
end)
