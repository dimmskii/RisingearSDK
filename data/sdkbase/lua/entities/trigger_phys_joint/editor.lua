--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

if CLIENT then

  local getCollide = nil
  
  function ENT:editor_populatePropertiesGUI( container )
    ENT_BASE.editor_populatePropertiesGUI( self, container )
    
    local collideCont = fgui.createContainer( container )
    local collideLabel = fgui.createLabel(collideCont, "Collide connected"); -- TODO: Stringadactyl
    local collideField = fgui.createCheckBox(collideCont)
    collideField:setSelected( self.collide )
    
    getCollide = function()
      return collideField:isSelected()
    end
    
  end
  
  function ENT:editor_sendProperties( data )
    ENT_BASE.editor_sendProperties( self, data )
    self.collide = getCollide()
    data:writeBool( self.collide )
  end
  
end

function ENT:editor_receiveProperties( data )
  ENT_BASE.editor_receiveProperties( self, data )
  
  self.collide = data:readNext()
end
