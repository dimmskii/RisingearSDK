--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT

function ENT:editor_createSprite()
	local spr = sprites.create()
	spr:addTexture("gui/editor/ent_glyphs/trigger.png")
	spr.width = 0.25
	spr.height = 0.25
	spr:centerOrigin()
	return spr
end

if CLIENT then

	function ENT:editor_onClientJoin()
		ENT_BASE.editor_onClientJoin(self)
		self:updateSourceEnts()
		self:updateTargetEnts()
	end

-- This is now in gamemodes/editor/cl_ent_draw.lua :
--	function ENT:editor_createRenderable()
--		self:updateSourceEnts()
--		self:updateTargetEnts()
--		local rend = renderables.composite()
--		local spr = self:editor_getSprite()
--		if spr then
--			rend:addRenderable(renderables.fromSprite( spr ))
--		end
--		rend:addRenderable(renderables.fromFunction(function()
--			local arrowScale = camera.getCurrent():getWidth() / 75
--			draw.color4f(1,1,1,1)
--			draw.setLineWidth(2)
--			for _,entSource in ipairs(self.sourceEnts) do
--				draw.line(self.position.x,self.position.y,entSource.position.x,entSource.position.y)
--				local vec1 = entSource.position:sub(self.position)
--				vec1:normalize()
--				vec1:mulLocal(arrowScale)
--				local vec2 = vec1:clone()
--				
--				vec1:addAngleLocal(20)
--				vec2:subAngleLocal(20)
--				
--				vec1:addLocal(self.position)
--				vec2:addLocal(self.position)
--				
--				draw.triangle(self.position.x, self.position.y,vec1.x,vec1.y,vec2.x,vec2.y,true)
--			end
--			for _,entTarget in ipairs(self.targetEnts) do
--				draw.line(self.position.x,self.position.y,entTarget.position.x,entTarget.position.y)
--				local vec1 = self.position:sub(entTarget.position)
--				vec1:normalize()
--				vec1:mulLocal(arrowScale)
--				local vec2 = vec1:clone()
--				
--				vec1:addAngleLocal(20)
--				vec2:subAngleLocal(20)
--				
--				vec1:addLocal(entTarget.position)
--				vec2:addLocal(entTarget.position)
--				
--				draw.triangle(entTarget.position.x, entTarget.position.y,vec1.x,vec1.y,vec2.x,vec2.y,true)
--			end
--		end))
--		return rend
--	end

	local getTargetTag = nil
	local getSourceTag = nil
	
	function ENT:editor_populatePropertiesGUI( container )
		ENT_BASE.editor_populatePropertiesGUI( self, container )
		
		local targetTagCont = fgui.createContainer( container )
		local targetTagLabel = fgui.createLabel(targetTagCont, "Target Tag"); -- TODO: Stringadactyl
		local targetTagField = fgui.createTextField(targetTagCont)
		targetTagField:setText(tostring(self.targetTag))
		
		getTargetTag = function()
			return targetTagField:getText() or ""
		end
		
		local sourceTagCont = fgui.createContainer( container )
		local sourceTagLabel = fgui.createLabel(sourceTagCont, "Source Tag"); -- TODO: Stringadactyl
		local sourceTagField = fgui.createTextField(sourceTagCont)
		sourceTagField:setText(tostring(self.sourceTag))
		
		getSourceTag = function()
			return sourceTagField:getText() or ""
		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		self.targetTag = getTargetTag()
		data:writeString( self.targetTag )
		self.sourceTag = getSourceTag()
		data:writeString( self.sourceTag )
		
		self:updateTargetEnts() -- We need it client
		self:updateSourceEnts() -- We need it client
	end
	
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	
	self:setTargetTag(data:readNext())
	self:setSourceTag(data:readNext())
end
