--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- NETWORKING
local function processSpawnMessage(sender, data)
	if (CLIENT) then return end -- Clients don't need to have this executed
	
	local ent = ents.create("phys_prop",false)
	ent.position = geom.vec2(data:readNext(),data:readNext())
	ent.definitionIndex = data:readNext()
	ents.initialize(ent)
	
	
	EDITOR.addUndoEntry(function(self)
      ents.remove(self.data)
    end, ent.id)
	
end
local MSG_TOOL_PHYSPROP_SPAWN = net.registerMessage("tool_physprop_spawn", processSpawnMessage)
local function sendSpawnMessage( x, y, def )
	if (SERVER) then return end -- Servers don't send prop spawn messages
	local data = net.data()
	data:writeFloat( x )
	data:writeFloat( y )
	data:writeFloat( props.getDefinitionIndex(def) )
	net.sendMessage( MSG_TOOL_PHYSPROP_SPAWN, data )
end


-- CLIENT-SIDED TOOL CODE
if (CLIENT) then

	local tool = tools.register("tool_physprop", "Physics Prop Tool") -- TODO: stringadactyl
	
	tool.selectedPropDef = nil

	local sprite = nil
	local renderable = nil
	
	local ghostColor = color.fromRGBAf(1,1,1,0.5)
	
	local function adjustCoordOrigin(vec,w,h)
		local hw = w / 2
		local hh = h / 2
		local spawnOrigin = grid.getOrigin()
		local out = geom.vec2(vec.x - hw + (hw*spawnOrigin.x), vec.y - hh + (hh*spawnOrigin.y))
		
		return out
	end

	tool.onMousePressed = function(button, cursorPos)
		if (button ~= mouse.BUTTON_1) then return end -- Check to make sure that it's LMB
		
		if (tool.selectedPropDef == nil) then return end
		
		local pos = adjustCoordOrigin(cursorPos, tool.sprite.width, tool.sprite.height)
		sendSpawnMessage(pos.x,pos.y, tool.selectedPropDef)
	end
	
	local function propSelected(propDef)
		tool.selectedPropDef = propDef
		if (CLIENT) then
			if (tool.renderable ~= nil) then
				renderables.remove(tool.renderable)
			end
			
			tool.sprite = props.createSprite(propDef)
			tool.sprite.color = ghostColor;
			
			tool.renderable = renderables.fromSprite(tool.sprite)
			
			renderables.add(tool.renderable)
		end
	end
	
	tool.populatePropertiesPanel = function(panel)
	
		local parent = fgui.createContainer(panel)
		parent:setLayoutManager(fgui.newRowLayout(false))
	
		local scroll = fgui.createScrollContainer(parent)
		scroll:getAppearance():add(fgui_decorators.createTitledBorder("Props")) -- TODO Stringadactyl
		scroll:setMaxSize(175,150)
		
		local c = fgui.createContainer(scroll)
		local defList = props.getDefinitions()
		local numProps = #defList
		
		c:setLayoutManager(fgui.newGridLayout(math.max(math.ceil(numProps / 2), 2),2))
		
		-- Add the tool buttons
		for k, v in pairs(defList) do
			-- Select the first def if it's nil
			if (tool.selectedPropDef == nil) then
				propSelected(v)
			end
			
			-- Create the button for the prop def
			local button = fgui.createButton(c)
			local tex = textures.get(v.texture)
			local w = 1
			local h = 1
			if v.width > v.height then
				h = v.height / v.width
			elseif v.height > v.width then
				w = v.width / v.height
			end
			local pix = pixmap.fromTexture(tex,0,0,w*24,h*24,w*24,h*24,w*24,h*24)
			button:setPixmap(pix)
			button:setMinSize(64,64)
			button:setSize(64,64)
			button:setExpandable(false)
			--button:setShrinkable(false)
			button:addButtonPressedListener(fgui_listeners.buttonPressed( function() propSelected(v) end ))
		end
		
		c:layout()
	end
	
	tool.update = function(delta, cursorPos)
		if (CLIENT) then
			if (tool.sprite ~= nil) then
				local pos = adjustCoordOrigin(cursorPos, tool.sprite.width, tool.sprite.height)
				tool.sprite.position.x = pos.x
				tool.sprite.position.y = pos.y
			end
		end
	end
	
	tool.onDeselected = function()
		if (CLIENT and tool.renderable ~= nil) then
			-- Remove and nullify the renderable when tool is not in use.
			renderables.remove(tool.renderable)
			tool.renderable = nil
			
			-- Nullify the selected prop def. We will then know to re-make sprite/renderable on next GUI populate.
			tool.selectedPropDef = nil
		end
	end

end
