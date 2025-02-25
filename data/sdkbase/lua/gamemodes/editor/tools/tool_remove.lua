--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- NETWORKING
local function processRemoveMessage(sender, data)
	if (CLIENT) then return end -- Clients don't need to have this executed
	
	while( data:hasNext() ) do
		local id = data:readNext()
		local ent = ents.findByID( id )
		if ( ent ) then
			ents.remove( ent )
		end
	end
end

local MSG_TOOL_REMOVE = net.registerMessage("tool_remove", processRemoveMessage)
local function sendRemoveMessage()
	if (SERVER) then return end -- Servers don't send remove messsages
	local data = net.data()
	for k,v in pairs(tools.selectedEnts) do
		data:writeEntityID(v)
	end
	net.sendMessage( MSG_TOOL_REMOVE, data )
end

-- CLIENT-SIDED TOOL CODE
if (CLIENT) then
	local tool = tools.register("tool_remove", "Remove Tool") -- TODO: stringadactyl
	
	tool.onMousePressed = function(button, cursorPos, freePos)
		if (button == mouse.BUTTON_1) then
			if ( tools.isSelectionEmpty() ) then
				tools.doSelection( freePos )
			else
				local inSelection = false
				for k,v in pairs(tools.selectedEnts) do
					if (v.outlineShape and v.outlineShape:contains(freePos.x,freePos.y)) then
						inSelection = true
						break
					end
				end
				
				if not inSelection then
					tools.clearSelection()
					tools.doSelection( freePos )
				end
				
			end
			sendRemoveMessage()
		end
	end
	
	-- KEYS
	local function toolKeyPress()
		sendRemoveMessage()
	end
	local listener = editor_keys.newListener( toolKeyPress )
	editor_keys.register(listener, controller.BTN_DELETE)
	
end