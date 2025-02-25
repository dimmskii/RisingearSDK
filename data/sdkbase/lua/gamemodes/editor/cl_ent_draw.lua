--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- This file deals with entity overlays and symbols being drawn

local shapes_col = color.fromRGBAf(1,0.4,0.1,0.8)
local trigger_arrows_col = color.WHITE

local function outlines_render()
	if not editor_config.get("editor_view_outlines") then return end
	local arrowScale = camera.getCurrent():getWidth() / 75
	draw.setLineWidth(2)
	for k,v in pairs(ents.getAll()) do
		draw.color(shapes_col)
		if v.editor_getOutlineShape then
			draw.shape(v:editor_getOutlineShape())
			if ents.isClass(v,"trigger_base",true) then
				draw.color(trigger_arrows_col)
				if v.sourceEnts then
					for _,entSource in ipairs(v.sourceEnts) do
						draw.line(v.position.x,v.position.y,entSource.position.x,entSource.position.y)
						local vec1 = entSource.position:sub(v.position)
						vec1:normalize()
						vec1:mulLocal(arrowScale)
						local vec2 = vec1:clone()
						vec1:addAngleLocal(20)
						vec2:subAngleLocal(20)
						vec1:addLocal(v.position)
						vec2:addLocal(v.position)
						draw.triangle(v.position.x, v.position.y,vec1.x,vec1.y,vec2.x,vec2.y,true)
					end
				end
				if v.targetEnts then
					for _,entTarget in ipairs(v.targetEnts) do
						draw.line(v.position.x,v.position.y,entTarget.position.x,entTarget.position.y)
						local vec1 = v.position:sub(entTarget.position)
						vec1:normalize()
						vec1:mulLocal(arrowScale)
						local vec2 = vec1:clone()
						vec1:addAngleLocal(20)
						vec2:subAngleLocal(20)
						vec1:addLocal(entTarget.position)
						vec2:addLocal(entTarget.position)
						draw.triangle(entTarget.position.x, entTarget.position.y,vec1.x,vec1.y,vec2.x,vec2.y,true)
					end
				end
			end
		end
	end
	draw.setLineWidth(1) -- Be kind rewind
end

local shapes_renderable = renderables.fromFunction(outlines_render)
shapes_renderable:setLayer(renderables.LAYER_POST_GAME)
shapes_renderable:setDepth(EDITOR.REND_DEPTH_ENTSHAPE)
renderables.add(shapes_renderable)
