--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

if CLIENT then
	
	local getAiClass = nil
	
	function ENT:editor_populatePropertiesGUI( cont )
		ENT_BASE.editor_populatePropertiesGUI( self, cont )
		
		local aiClassCont = fgui.createContainer( cont )
		local aiClassLabel = fgui.createLabel(aiClassCont, "AI Class"); -- TODO: Stringadactyl
		local aiClassField = fgui.createComboBox(aiClassCont)
		
		aiClassField:addItem("") -- Add empty option
		local aiClasses = ents.getClasses("ai_base")

		for _,v in ipairs(aiClasses) do
			aiClassField:addItem(v.CLASSNAME)
		end
		
		aiClassField:setSelected( self.aiClass )
		
		getAiClass = function()
			return aiClassField:getSelectedValue()
		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		data:writeString( getAiClass() )
	end
	
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	self.aiClass = data:readNext()
end
