--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- CLIENT-SIDED TOOL CODE
if (CLIENT) then
	local tool = tools.register("tool_hand", "Hand Tool") -- TODO: stringadactyl
	
	local cameraClickPos = geom.vec2(0,0)
	local screenClickPos = geom.vec2(0,0)
	local pressed = false
	
	tool.onMousePressed = function(button, cursorPos, freePos)
		if (button ~= mouse.BUTTON_1 and button ~= mouse.BUTTON_3) then return end -- Return if it's not LMB or MMB
		
		local cam = camera.getCurrent()
		
		cameraClickPos = geom.vec2(cam:getX(), cam:getY())
		screenClickPos = geom.vec2(display.getMouseX(), display.getMouseY())
		pressed = true
	end
	
	tool.update = function(delta, cursorPos, freePos)
		if not pressed then return end -- Only if the button is pressed
		
		if (camera.getCurrent() == nil) then return end -- Exit function if we have no camera set up
		
		local cam = camera.getCurrent()
		
		local screenMousePos = geom.vec2(display.getMouseX(), display.getMouseY())
		local scale = geom.vec2( (cam:getBottomRight().x - cam:getTopLeft().x) / display.getWidth(), (cam:getBottomRight().y - cam:getTopLeft().y) / display.getHeight() )
		
		cam:setPosition(cameraClickPos.x - ( (screenMousePos.x - screenClickPos.x) * scale.x ), cameraClickPos.y - ( (screenMousePos.y - screenClickPos.y) * scale.y )) -- Very general: manipulates any currently active camera
	end
	
	tool.onMouseReleased = function(button, cursorPos, freePos)
		if (button ~= mouse.BUTTON_1 and button ~= mouse.BUTTON_3) then return end -- Return if it's not LMB or MMB
		
		pressed = false
	end
	
	-- KEYS
	local oldTool = tools.getSelected()
	local function toolKeyPress()
		oldTool = tools.getSelected()
		tools.setCurrent(tool, true)
	end
	local function toolKeyRelease()
		tools.setCurrent(oldTool, true)
	end
	local listener = editor_keys.newListener( toolKeyPress, toolKeyRelease )
	editor_keys.register(listener, controller.BTN_SPACE)
	
	
	-- MMB Mod
	mouse.addListener({
		buttonPressed = function(iButton)
			if iButton == mouse.BUTTON_3 then
				toolKeyPress()
			end
		end,
		buttonReleased = function(iButton)
			if iButton == mouse.BUTTON_3 then
				toolKeyRelease()
			end
		end
	})
end
