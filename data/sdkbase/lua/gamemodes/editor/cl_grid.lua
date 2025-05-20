--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


grid = {} -- for global access
grid.MAX_SIZE = 64 -- 64m
grid.MIN_SIZE = 0.03125 -- 3.125cm

local NUM_MAJOR_SUBDIVISIONS = 20 -- Major subdivisions to fit in screen sqrt(scrn_w * scrn_h)
local SUBGRID_MIN_ALPHA = 0.05

editor_config.register("editor_grid_snap", true, editor_config.TYPE_BOOL)
editor_config.register("editor_grid_size", 1, editor_config.TYPE_REAL)
editor_config.register("editor_grid_show", true, editor_config.TYPE_BOOL)

local grid_color_r = 1
local grid_color_g = 1
local grid_color_b = 1
local grid_alpha = 0.35

local spawnOrigin = geom.vec2()

local function get_grid_size()
	local grid_size = editor_config.get("editor_grid_size")
	if grid_size < grid.MIN_SIZE then return grid.MIN_SIZE end
	if grid_size > grid.MAX_SIZE then return grid.MAX_SIZE end
	return grid_size
end

local grid_render = function()
	if not editor_config.get("editor_grid_show") then return end

	local true_grid_size = get_grid_size()

	local cam = camera.getCurrent()
	
	if cam == nil then return end
	
	-- Minimize grid count to camera
	-- TODO: needs serious optimization
	local camDims = cam:getResultantSize()
	local camAvg = math.sqrt(camDims.x * camDims.y)
	local numSubgrid = 0 -- subgrid (we do this backwards to not lose original modulus(?) of 2^n and ensure 0,0 is origin of major (most visible) grid subdivision
	while (camAvg / true_grid_size > NUM_MAJOR_SUBDIVISIONS) do
		true_grid_size = true_grid_size * 2
		numSubgrid = numSubgrid + 1
	end
	draw.setLineWidth(1)
	for invPow=0,numSubgrid do
		local a = grid_alpha/1.5^invPow
		if a <= SUBGRID_MIN_ALPHA then break end
		local current_grid_size = true_grid_size / 2^invPow
		draw.color4f(grid_color_r,grid_color_g,grid_color_b,a)
		local firstX= cam:getTopLeft().x
		firstX = firstX - (firstX % current_grid_size)
		local firstY= cam:getTopLeft().y
		firstY = firstY - (firstY % current_grid_size)
		local noX = math.ceil(cam:getResultantWidth() / current_grid_size)
		local noY = math.ceil(cam:getResultantHeight() / current_grid_size)
		for i = 0, noX + 1, 1 do
			draw.line(firstX, cam:getTopLeft().y, firstX, cam:getBottomRight().y)
			firstX = firstX + current_grid_size
		end
		for i = 0, noY + 1, 1 do
			draw.line(cam:getTopLeft().x, firstY , cam:getBottomRight().x , firstY)
			firstY = firstY + current_grid_size
		end
	end
end

local grid_renderable = renderables.fromFunction(grid_render)
grid_renderable:setLayer(renderables.LAYER_POST_GAME)
grid_renderable:setDepth(EDITOR.REND_DEPTH_GRID)
renderables.add(grid_renderable)


-- GLOBAL ACCESSORS

grid.snapCoord = function(vec)
	local grid_size = get_grid_size()
	return geom.vec2(
		math.floor(vec.x / grid_size + 0.5) * grid_size,
		math.floor(vec.y / grid_size + 0.5) * grid_size
	)
end

grid.getOrigin = function()
	return spawnOrigin:clone()
end

grid.setOrigin = function(x, y)
	spawnOrigin.x = x
	spawnOrigin.y = y
end
