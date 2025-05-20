--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local moveStart = geom.vec2()
local moveEnd = geom.vec2()
local entsSelected = nil


-- NETWORKING
local function processMoveGrabMessage(sender, data)
	if (CLIENT) then return end -- Clients don't need to have this executed
	
	if ( entsSelected ) then return end
	
	moveStart = geom.vec2( data:readNext(), data:readNext() )
	
	local n = 1
	entsSelected = {}
	while( data:hasNext() ) do
		local id = data:readNext()
		local ent = ents.findByID( id )
		if ( ent ) then
			entsSelected[id] = ent:getPosition()
		end
	end
end

local MSG_TOOL_MOVE_GRAB = net.registerMessage("tool_move_grab", processMoveGrabMessage)
local function sendMoveGrabMessage( x, y )
	if (SERVER) then return end -- Servers don't send grab messsages
	local data = net.data()
	data:writeFloat( x )
	data:writeFloat( y )
	for k,v in pairs(tools.selectedEnts) do
		data:writeInt(v.id)
	end
	
	net.sendMessage( MSG_TOOL_MOVE_GRAB, data )
end



local function processMoveReleaseMessage(sender, data)
	if (CLIENT) then return end -- Clients don't need to have this executed
	local ent = nil
	if not entsSelected then return end
	for k,v in pairs(entsSelected) do
		ent = ents.findByID( k )
	end
	entsSelected = nil
	
end
local MSG_TOOL_MOVE_RELEASE = net.registerMessage("tool_move_release", processMoveReleaseMessage)
local function sendMoveReleaseMessage( )
	if (SERVER) then return end -- Servers don't send release messages
	local data = net.data()
	net.sendMessage( MSG_TOOL_MOVE_RELEASE, data )
end


local function processMoveMoveMessage(sender, data)
	if (CLIENT) then return end -- Clients don't need to have this executed
	
	if (moveStart and moveEnd and entsSelected ~= nil and not table.isEmpty(entsSelected)) then
		moveEnd = geom.vec2( data:readNext(), data:readNext() )
		local offset = moveEnd:clone()
		offset = offset:sub(moveStart)
		
		local undoDatas = {}
		
		for id, pos in pairs( entsSelected ) do
			local ent = ents.findByID( id )
			if ( ent ) then
				local vecOldPos = ent:getPosition()
				local vecNewPos = geom.vec2(pos.x+offset.x, pos.y+offset.y)
				ent:setPosition( vecNewPos.x, vecNewPos.y )
				ent:editor_onMove(vecOldPos, vecNewPos)
				
				local undoData = {
				  id = id,
				  vecPos = vecOldPos
				}
				table.insert( undoDatas, undoData )
			end
		end
		
		EDITOR.addUndoEntry(function(self)
      for _,undoData in ipairs(self.data) do
        local ent = ents.findByID( undoData.id )
        local vecCurrentPos = ent:getPosition()
        ent:setPosition( undoData.vecPos.x, undoData.vecPos.y )
        ent:editor_onMove(vecCurrentPos, undoData.vecPos)
      end
    end, undoDatas)
    
	end
	
end
local MSG_TOOL_MOVE_MOVE = net.registerMessage("tool_move_move", processMoveMoveMessage)
local function sendMoveMoveMessage( x, y )
	if (SERVER) then return end -- Servers don't send move messages
	local data = net.data()
	data:writeFloat( x )
	data:writeFloat( y )
	net.sendMessage( MSG_TOOL_MOVE_MOVE, data, false )
end


-- CLIENT-SIDED TOOL CODE
if (CLIENT) then
	local tool = tools.register("tool_move", "Move Tool") -- TODO: stringadactyl
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
			sendMoveGrabMessage(cursorPos.x,cursorPos.y)
		end
	end
	tool.onMouseReleased = function(button, cursorPos, freePos)
		if (button == mouse.BUTTON_1) then
			sendMoveReleaseMessage()
			tools.updateSelectionRenderable()
			EDITOR.actionEvent(actions.ENTMODIFY)
		end
	end
	tool.update = function(delta, cursorPos, freePos)
		if ( mouse.isButtonDown(mouse.BUTTON_1) ) then
			sendMoveMoveMessage(cursorPos.x,cursorPos.y)
		end
	end
end