--  --------------------------------------------------------------  --
--  THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE     --
--  COPYRIGHT (c) DMITRI POTERIANSKI 2021,              --
--  ALL RIGHTS RESERVED                       --
--  DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR  --
--  --------------------------------------------------------------  --


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

  local getMaxLength, getWidth, getSegmentLength, getColor
  
  function ENT:editor_populatePropertiesGUI( container )
    ENT_BASE.editor_populatePropertiesGUI( self, container )
    
    local maxLengthCont = fgui.createContainer( container )
    local maxLengthLabel = fgui.createLabel(maxLengthCont, "Max Length"); -- TODO: Stringadactyl
    local maxLengthField = fgui.createTextField(maxLengthCont)
    maxLengthField:setText(tostring(self.maxLength))
    
    getMaxLength = function()
      return tonumber(maxLengthField:getText()) or -1
    end
    
    
    local widthCont = fgui.createContainer( container )
    local widthLabel = fgui.createLabel(widthCont, "Width"); -- TODO: Stringadactyl
    local widthField = fgui.createTextField(widthCont)
    widthField:setText(tostring(self.width))
    
    getWidth = function()
      return tonumber(widthField:getText()) or 0.2
    end
    
    
    local segmentLengthCont = fgui.createContainer( container )
    local segmentLengthLabel = fgui.createLabel(segmentLengthCont, "Segment Length"); -- TODO: Stringadactyl
    local segmentLengthField = fgui.createTextField(segmentLengthCont)
    segmentLengthField:setText(tostring(self.segmentLength))
    
    getSegmentLength = function()
      return tonumber(segmentLengthField:getText()) or 0.2
    end
    
    
    local colorCont = fgui.createContainer(container)
    local colorLabel = fgui.createLabel(colorCont, "Color"); -- TODO: Stringadactyl
    local colorField = fgui.createColorBox(colorCont)
    colorField:setColor(self.color)
    
    getColor = function()
      local col = colorField:getColor() or color.fromRGBf(0.8,0.8,0.05)
      return col
    end
    
  end
  
  function ENT:editor_sendProperties( data )
    ENT_BASE.editor_sendProperties( self, data )
    self.maxLength = getMaxLength()
    data:writeFloat( self.maxLength )
    self.width = getWidth()
    data:writeFloat( self.width )
    self.segmentLength = getSegmentLength()
    data:writeFloat( self.segmentLength )
    self.color = getColor()
    data:writeColor( self.color )
  end
  
end

function ENT:editor_receiveProperties( data )
  ENT_BASE.editor_receiveProperties( self, data )
  
  self.maxLength = data:readNext()
  self.width = data:readNext()
  self.segmentLength = data:readNext()
  self.color = data:readNext()
end
