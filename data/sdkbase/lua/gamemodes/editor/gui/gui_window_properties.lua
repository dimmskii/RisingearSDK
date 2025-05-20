--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local function applyPropertiesReceived( sender, data )
	local ent = ents.findByID(data:readNext())
	if (ent and ent.editor_receiveProperties) then
		ent:editor_receiveProperties(data)
	end
	EDITOR.actionEvent(actions.ENTMODIFY)
end

local MSG_EDITOR_APPLY_ENT_PROPERTIES = net.registerMessage("editor_apply_properties", applyPropertiesReceived)

if (CLIENT) then

  local function updatePropertiesPane(window_properties_pane, ent)
    window_properties_pane:removeAllWidgets()
    if ent.editor_populatePropertiesGUI then
        ent:editor_populatePropertiesGUI(window_properties_pane)
    end
    window_properties_pane:layout()
  end

	local openPropertiesWindows = {}
	
	EDITOR.actionAddCallback(function(action)
	   if action~=actions.ENTMODIFY then return end
    for ent,window_properties in pairs(openPropertiesWindows) do
      updatePropertiesPane(window_properties:getData("window_properties_pane"), ent)
    end
  end)
	
	
	function EDITOR.gui_showPropertiesWindow( ents )
		-- Make sure we have a table with exactly one ent selected
		local ent = nil
		
		if ents==nil then
			ents = tools.selectedEnts -- Get table from tools if nada is passed in
		end
		
		if table.getn(ents) ~= 1 then return end
		
		if type(ents)=="table" then
			ent = ents[1]
		end
		
		-- Check if one for this ent is already open
		if openPropertiesWindows[ent] then return end
		
		for k,v in pairs(openPropertiesWindows) do -- TODO: this is one prop window at a time mod. Until we fix every ent's editor.lua to not use file-local getters and setters
		  v:close()
		  openPropertiesWindows[k] = nil
		end
		
		
		if ent and ent.valid then
	
			local window_properties = fgui.createWindow(true, false, false, false)
			window_properties:setTitle("Properties") -- TODO: stringadactyl
			
			local cont = window_properties:getContentContainer()
			cont:setLayoutManager(fgui.newRowLayout())
			
			local window_properties_pane_label_class = fgui.createLabel(cont, "")
			window_properties_pane_label_class:setExpandable(false)
			
			local window_properties_pane_label_id = fgui.createLabel(cont, "")
			window_properties_pane_label_id:setExpandable(false)
			
			local scroll = fgui.createScrollContainer(cont)
			local window_properties_pane = fgui.createContainer(scroll)
			window_properties:setData("window_properties_pane",  window_properties_pane)
			window_properties_pane:setLayoutManager(fgui.newRowExLayout())
			
			window_properties:addWindowClosedListener(fgui_listeners.windowClosed(
					function()
						openPropertiesWindows[ent] = nil -- We do need to nullify
						window_properties:close()
					end
			))
			
			local apply = function()
					if SERVER then return end -- Servers don't send prop spawn messages
					if not ent then return end
					if not ent.editor_sendProperties then return end
					local data = net.data()
					data:writeInt(ent.id)
					ent:editor_sendProperties( data )
					net.sendMessage( MSG_EDITOR_APPLY_ENT_PROPERTIES, data )
					
					-- Apply it on the client-side
					if not ent.editor_receiveProperties then return end
					data = net.data() -- Redo: we don't want ent id
					ent:editor_sendProperties( data ) -- Redo: we don't want ent id
					ent:editor_receiveProperties( data )
			end
			
			local buttonsCont = fgui.createContainer(cont)
			buttonsCont:setLayoutManager(fgui.newRowLayout(true))
			buttonsCont:setExpandable(false)
			
			local btnOk = fgui.createButton(buttonsCont, "OK") -- TODO: Stringadactyl
			btnOk:addButtonPressedListener(fgui_listeners.buttonPressed(
			
				function()
					apply()
					openPropertiesWindows[ent] = nil -- We do need to nullify
					window_properties:close()
				end
			
			))
			
			local btnCancel = fgui.createButton(buttonsCont, "Cancel") -- TODO: Stringadactyl
			btnCancel:addButtonPressedListener(fgui_listeners.buttonPressed(
			
				function()
					openPropertiesWindows[ent] = nil -- We do need to nullify
					window_properties:close()
				end
			
			))
			
			local btnApply = fgui.createButton(buttonsCont, "Apply") -- TODO: Stringadactyl
			btnApply:addButtonPressedListener(fgui_listeners.buttonPressed(
      
        function()
          apply()
          updatePropertiesPane(window_properties_pane, ent)
        end
      
      ))
			
			buttonsCont:layout()
			
			window_properties:setWidth(256)
			window_properties:setHeight(512)
			
			window_properties:centerOnScreen()
		
			-- Populate properties pane
			
			window_properties_pane_label_class:setText( "CLASS: " .. ent.CLASSNAME ) -- TODO: Stringadactyl
			window_properties_pane_label_id:setText( "ID:    " .. ent.id ) -- TODO: Stringadactyl
			
			updatePropertiesPane(window_properties_pane, ent)
			
			openPropertiesWindows[ent] = window_properties -- Keep track of existing opened one
		end
	end

end