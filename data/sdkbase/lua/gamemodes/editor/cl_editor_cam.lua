--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


editor_cam = {}

local cam = nil
local cam_height = 10
editor_cam.initialize = function()
	-- Create the camera
	cam = camera.create()
	camera.use(cam)
	cam:setHeight(cam_height)
end

editor_cam.zoomIn = function( factor, bCenterOnMouse )
	cam_height = cam_height / factor
	local vecMouseOld = geom.vec2(display.getMouseXViewport(), display.getMouseYViewport())
	cam:setHeight(cam_height)
	if bCenterOnMouse then
		local vecMouseDiff = geom.vec2(display.getMouseXViewport(), display.getMouseYViewport()):sub(vecMouseOld)
		cam:setPosition(cam:getPosition():sub(vecMouseDiff))
	end
end

editor_cam.zoomOut = function( factor, bCenterOnMouse )
	cam_height = cam_height * factor
	local vecMouseOld = geom.vec2(display.getMouseXViewport(), display.getMouseYViewport())
	cam:setHeight(cam_height)
	if bCenterOnMouse then
		local vecMouseDiff = geom.vec2(display.getMouseXViewport(), display.getMouseYViewport()):sub(vecMouseOld)
		cam:setPosition(cam:getPosition():sub(vecMouseDiff))
	end
end
