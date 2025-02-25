--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT

if CLIENT then

  --local getFrequencyHz = nil
  
  function ENT:editor_populatePropertiesGUI( container )
    ENT_BASE.editor_populatePropertiesGUI( self, container )
--    
--    local maxLengthCont = fgui.createContainer( container )
--    local maxLengthLabel = fgui.createLabel(maxLengthCont, "Angle dampen Hz"); -- TODO: Stringadactyl
--    local maxLengthField = fgui.createTextField(maxLengthCont)
--    maxLengthField:setText(tostring(self.frequencyHz))
--    
--    getFrequencyHz = function()
--      return tonumber(maxLengthField:getText()) or -1
--    end
    
  end
  
  function ENT:editor_sendProperties( data )
    ENT_BASE.editor_sendProperties( self, data )
--    self.frequencyHz = getFrequencyHz()
--    data:writeFloat( self.frequencyHz )
  end
  
end

function ENT:editor_receiveProperties( data )
  ENT_BASE.editor_receiveProperties( self, data )
  
--  self.frequencyHz = data:readNext()
end
