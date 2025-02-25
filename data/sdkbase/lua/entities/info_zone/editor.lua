--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_RECT
ENT.editor_polygonEditable = true

function ENT:editor_getOutlineShape()
	return self.outlineShape
end

function ENT:editor_getPolygon()
	return self.outlineShape
end
	
if (SERVER) then

	function ENT:editor_onPlaced(vec1, vec2)
		local x = math.min(vec1.x,vec2.x)
		local y = math.min(vec1.y,vec2.y)
		self:setPosition(x,y)
		local w = math.max(vec1.x,vec2.x) - x
		local h = math.max(vec1.y,vec2.y) - y
		if (w <= 0) then
			w = 1
		end
		if (h <= 0) then
			h = 1
		end
		self.polygon = geom.polygon(geom.vec2(0,0),geom.vec2(w,0),geom.vec2(w,h),geom.vec2(0,h))
	end
	
	function ENT:editor_applyPolygon( polygon )
		self.polygon = polygon:transform(geom.translateTransform(-self.position.x, -self.position.y):concatenate(geom.rotateTransform(-self.angle)))
		net.forceEntUpdate(self,ents.SNAP_NET,false)
		return
	end
	
end
