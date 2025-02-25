--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT

if CLIENT then
	-- Declare future functions to get settings from GUI
	local getClass = nil
	local isNotEq = nil
	local isAllowSubclass = nil
	
	function ENT:editor_populatePropertiesGUI( container )
		ENT_BASE.editor_populatePropertiesGUI( self, container )
		
		local classCont = fgui.createContainer(container)
		local classLabel = fgui.createLabel(classCont, "Entity Class Name"); -- TODO: Stringadactyl
		local classField = fgui.createTextField(classCont)
		classField:setText( tostring(self.sourceClass) )
		
		getClass = function()
			return classField:getText()
		end
		
		local notEqCont = fgui.createContainer(container)
		local notEqLabel = fgui.createLabel(notEqCont, "NOT"); -- TODO: Stringadactyl
		local notEqField = fgui.createCheckBox(notEqCont)
		notEqField:setSelected( self.notEq )
		
		isNotEq = function()
			return notEqField:isSelected()
		end
		
		local allowSubclassCont = fgui.createContainer(container)
		local allowSubclassLabel = fgui.createLabel(allowSubclassCont, "Allow Subclass"); -- TODO: Stringadactyl
		local allowSubclassField = fgui.createCheckBox(allowSubclassCont)
		allowSubclassField:setSelected( self.allowSubclass )
		
		isAllowSubclass = function()
			return allowSubclassField:isSelected()
		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		data:writeString( getClass() )
		data:writeBool( isNotEq() )
		data:writeBool( isAllowSubclass() )
	end
	
	function ENT:editor_getOutlineShape()
		return self.outlineShape
	end
	
	function ENT:editor_getPolygon()
		return self.outlineShape
	end
	
end

function ENT:editor_receiveProperties( data )
	ENT_BASE.editor_receiveProperties( self, data )
	self.sourceClass = data:readNext()
	self.notEq = data:readNext()
	self.allowSubclass = data:readNext()
end
