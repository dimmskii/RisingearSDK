--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

if CLIENT then
	
	-- Declare future functions to get settings from GUI
	local getMaterial = nil
	
	function ENT:editor_populatePropertiesGUI( container )
		ENT_BASE.editor_populatePropertiesGUI( self, container )
		
		local materialCont = fgui.createContainer(container)
		local materialLabel = fgui.createLabel(materialCont, "Material"); -- TODO: Stringadactyl
		local materialField = fgui.createComboBox(materialCont)
		local materialNames = materials.listIDs()
		for _,v in ipairs(materialNames) do
			materialField:addItem(v)
		end
		
		materialField:setSelected( self.materialID )
		
		getMaterial = function()
			return materialField:getSelectedValue()
		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		data:writeString( getMaterial() )
	end
	
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	self:setMaterialID( data:readNext() )
end
