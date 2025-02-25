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
	local getGamemode = nil
	local isNotEq = nil
	
	function ENT:editor_populatePropertiesGUI( container )
		ENT_BASE.editor_populatePropertiesGUI( self, container )
		
		local gamemodeCont = fgui.createContainer(container)
		local gamemodeLabel = fgui.createLabel(gamemodeCont, "GM Class Name"); -- TODO: Stringadactyl
		local gamemodeField = fgui.createTextField(gamemodeCont)
		gamemodeField:setText( tostring(self.gamemode) )
		
		getGamemode = function()
			return gamemodeField:getText()
		end
		
		local notEqCont = fgui.createContainer(container)
		local notEqLabel = fgui.createLabel(notEqCont, "NOT"); -- TODO: Stringadactyl
		local notEqField = fgui.createCheckBox(notEqCont)
		notEqField:setSelected( self.notEq )
		
		isNotEq = function()
			return notEqField:isSelected()
		end
	end
	
	function ENT:editor_sendProperties( data )
		ENT_BASE.editor_sendProperties( self, data )
		data:writeString( getGamemode() )
		data:writeBool( isNotEq() )
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
	self.gamemode = data:readNext()
	self.notEq = data:readNext()
end
