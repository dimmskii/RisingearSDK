--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

local bodyTypes = { ["STATIC"] = phys.BT_STATIC, ["KINEMATIC"] = phys.BT_KINEMATIC, ["DYNAMIC"] = phys.BT_DYNAMIC }

if (CLIENT) then

	local getBodyType = nil
	local isDestructible
	local getHealth
	
	function ENT:editor_populatePropertiesGUI( cont )
		ENT_BASE.editor_populatePropertiesGUI( self, cont )
		
		local bodyTypeCont = fgui.createContainer(cont)
		local bodyTypeLabel = fgui.createLabel(bodyTypeCont, "Body Type"); -- TODO: Stringadactyl
		local bodyTypeField = fgui.createComboBox(bodyTypeCont)
		for k,v in pairs(bodyTypes) do
			bodyTypeField:addItem(k)
			print(k)
		end
		
		bodyTypeField:setSelected( self.bodyType )
		
		getBodyType = function()
			return bodyTypeField:getSelectedValue()
		end
		
		local destructibleCont = fgui.createContainer(cont)
		local destructibleLabel = fgui.createLabel(destructibleCont, "Destructible"); -- TODO: Stringadactyl
		local destructibleField = fgui.createCheckBox(destructibleCont)
		destructibleField:setSelected(self.destructible)
		
		isDestructible = function()
			return destructibleField:isSelected()
		end
		
		local healthCont = fgui.createContainer( cont )
		local healthLabel = fgui.createLabel(healthCont, "Health"); -- TODO: Stringadactyl
		local healthField = fgui.createTextField(healthCont)
		healthField:setText(tostring(self.health))
		
		getHealth = function()
			return tonumber(healthField:getText()) or 1
		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		
		data:writeString( getBodyType() )
		data:writeBool( isDestructible() )
		data:writeFloat( getHealth() )
	end
	
	function ENT:editor_getOutlineShape()
		return self.outlineShape
	end
	
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	
	self:setBodyType( bodyTypes[data:readNext()] )
	self:setDestructible(data:readNext())
	self:setHealth(data:readNext())
end
