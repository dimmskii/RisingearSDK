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
  spr:addTexture("gui/editor/ent_glyphs/target.png")
  spr.width = 0.125
  spr.height = 0.125
  spr:centerOrigin()
  return spr
end

if CLIENT then

	function ENT:editor_onClientJoin()
		ENT_BASE.editor_onClientJoin(self)
		self:updatePhysEnt()
	end

	local getTag = nil
	
	function ENT:editor_populatePropertiesGUI( container )
		ENT_BASE.editor_populatePropertiesGUI( self, container )
		
		local targetTagCont = fgui.createContainer( container )
		local targetTagLabel = fgui.createLabel(targetTagCont, "Physics Ent Tag"); -- TODO: Stringadactyl
		local targetTagField = fgui.createTextField(targetTagCont)
		targetTagField:setText(tostring(self.physEntTag))
		
		getTag = function()
			return targetTagField:getText() or ""
		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		self.physEntTag = getTag()
		data:writeString( self.physEntTag )
		
		self:updatePhysEnt() -- We need it client
	end
	
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	
	self:setPhysEntTag(data:readNext())
end
