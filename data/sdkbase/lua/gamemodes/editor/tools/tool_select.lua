--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

-- CLIENT-SIDED TOOL CODE
if (CLIENT) then
	local tool = tools.register("tool_select", "Selection Tool") -- TODO: stringadactyl
	
	local selectionStart = geom.vec2()
	local selectionEnd = geom.vec2()
	local selectionRect = nil
	local selectionRend = nil
	
	local selectionOutlineColor = color.BLACK
	local selectionFillColor = color.fromRGBAf(0.1,0.1,1,0.5)
	
	local function removeRenderable()
		if (selectionRend) then
			renderables.remove(selectionRend)
			selectionRend = nil
		end
	end
	
	tool.onMousePressed = function(button, cursorPos, freePos)
		if (button == -100) then
			selectionStart = freePos:clone()
			selectionEnd = freePos:clone()
			selectionRect = geom.rectangle(selectionStart.x,selectionStart.y, 0, 0)
			removeRenderable()
			selectionRend = renderables.fromShape(selectionRect)
			selectionRend.outlineColor = selectionOutlineColor
			selectionRend.fillColor = selectionFillColor
			selectionRend:setLayer(renderables.LAYER_POST_GAME)
			selectionRend:setDepth(EDITOR.REND_DEPTH_TOOL) -- TODO: EDITOR.DEPTH_TOOL
			selectionRend = renderables.add(selectionRend)
		end
	end
	tool.onMouseReleased = function(button, cursorPos, freePos)
		if (button == -100) then
			selectionEnd = freePos:clone()
			removeRenderable()
			if not editor_keys.MOD_SHIFT() then
				tools.clearSelection()
			end
			tools.doSelection(selectionStart, selectionEnd)
		end
	end
	tool.update = function(delta, cursorPos, freePos)
		if ( selectionRect ) then
			selectionEnd = freePos:clone()
			selectionRect:setSize(selectionEnd.x - selectionStart.x, selectionEnd.y - selectionStart.y)
		end
	end
	
	-- KEYS --
	local oldTool = tools.getSelected()
	local function toolKeyPress()
		oldTool = tools.getSelected()
		tools.setCurrent(tool, true)
	end
	local function toolKeyRelease()
		tools.setCurrent(oldTool, true)
	end
	local listener = editor_keys.newListener( toolKeyPress, toolKeyRelease )
	editor_keys.register(listener, controller.BTN_LCONTROL)
	
end
