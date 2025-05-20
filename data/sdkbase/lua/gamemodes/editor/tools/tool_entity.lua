--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local function processSpawnMessage(sender, data)
	if (CLIENT) then return end -- Clients don't need to have this executed
	local className = data:readNext()
	local ent = ents.create(className,false)
	local vec1 = data:readNext()
	local vec2 = data:readNext()
	local tex = data:readNext()
	ent.position = vec1:clone()
	if (ent.editor_onPlaced) then
		ent:editor_onPlaced(vec1, vec2)
	end
	if (ent.editor_applyTexture) then
		ent:editor_applyTexture(tex)
	end
	ents.initialize(ent)
	
	EDITOR.addUndoEntry(function(self)
      ents.remove(self.data)
    end, ent.id)
end

local MSG_TOOL_ENTITY_SPAWN = net.registerMessage("tool_entity_spawn", processSpawnMessage)

-- CLIENT-SIDED TOOL CODE
if (CLIENT) then

	local tool = tools.register("tool_entity", "Entity Tool") -- TODO: stringadactyl
	
	local startPos = nil
	
	-- GUI Getters outside populate method for later use
	local getSelectedClassName = nil
	
  local selectionRect = nil
  local selectionRend = nil
  
  local selectionOutlineColor = color.GREEN
  local selectionFillColor = color.fromRGBAf(0,1,0,0.5)
  
  local function removeRenderable()
    if (selectionRend) then
      renderables.remove(selectionRend)
      selectionRend = nil
    end
  end
	
	local function sendSpawnMessage( startPos, endPos )
		if (SERVER) then return end -- Servers don't send prop spawn messages
		local data = net.data()
		data:writeString(getSelectedClassName())
		data:writeVec2( startPos )
		data:writeVec2( endPos )
		data:writeString(EDITOR.getSelectedTexturePath())
		net.sendMessage( MSG_TOOL_ENTITY_SPAWN, data )
	end
	
	tool.populatePropertiesPanel = function(panel)
	
		local parent = fgui.createContainer(panel)
		parent:setLayoutManager(fgui.newRowExLayout(false))
		
		local classCont = fgui.createContainer(parent)
		classCont:setLayoutManager(fgui.newRowExLayout(false))
		local classLabel = fgui.createLabel(classCont, "Entity Class"); -- TODO: Stringadactyl
		local classField = fgui.createComboBox(classCont)
		
		local tClasses = ents.getClasses()
    local tClassNames = {}
    for k,v in pairs(tClasses) do
      if v.editor_placementType and v.editor_placementType ~= EDITOR.PLACEMENT_TYPE_NONE then -- EDITOR.PLACEMENT_TYPE_RECT EDITOR.PLACEMENT_TYPE_POINT
        table.insert(tClassNames,v.CLASSNAME)
      end
    end
    table.sort(tClassNames)
		
		for _,v in ipairs(tClassNames) do
				classField:addItem(v)
		end
		
		getSelectedClassName = function()
			return classField:getSelectedValue()
		end
		
	end
	
	tool.update = function(delta, cursorPos, freePos)
    if ( selectionRect ) then
      selectionRect:setSize(cursorPos.x - startPos.x, cursorPos.y - startPos.y)
    end
  end
	
	
	tool.onMousePressed = function(button, cursorPos)
		if (button ~= mouse.BUTTON_1) then return end -- Check to make sure that it's LMB
		
		startPos = cursorPos:clone()
		
		if ents.getClass(getSelectedClassName()).editor_placementType == EDITOR.PLACEMENT_TYPE_RECT then
		  selectionRect = geom.rectangle(startPos.x,startPos.y, 0, 0)
      removeRenderable()
      selectionRend = renderables.fromShape(selectionRect)
      selectionRend.outlineColor = selectionOutlineColor
      selectionRend.fillColor = selectionFillColor
      selectionRend:setLayer(renderables.LAYER_POST_GAME)
      selectionRend:setDepth(EDITOR.REND_DEPTH_TOOL) -- TODO: EDITOR.DEPTH_TOOL
      selectionRend = renderables.add(selectionRend)
		end
	end
	
	tool.onMouseReleased = function(button, cursorPos)
		if (button ~= mouse.BUTTON_1) then return end -- Check to make sure that it's LMB
		if (startPos == nil) then return end -- We didn't have a click before 0.0
		
		sendSpawnMessage( startPos, cursorPos:clone() )
		removeRenderable()
		selectionRect = nil
		startPos = nil -- could this be the ulti-fix
	end

end
