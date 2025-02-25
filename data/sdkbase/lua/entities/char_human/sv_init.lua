--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:updateMotion( delta )
	ENT_BASE.updateMotion(self, delta)
	if (self:getAimVecWorld().x < self:getEyePos().x) then
		if (self.direction > -1) then
			self.movement.direction = self.movement.direction * -1
		end
		self.direction = -1
	else
		if (self.direction < 1) then
			self.movement.direction = self.movement.direction * -1
		end
		self.direction = 1
	end
end

function ENT:randomAppearance()
	local randomHairs = {}
	table.insert(randomHairs, "")
	
	if (self.female) then
		for k,v in pairs(HUMAN_FEATURES.HAIR_LIST_FEMALE) do
			table.insert(randomHairs, k)
		end
	else
		for k,v in pairs(HUMAN_FEATURES.HAIR_LIST_MALE) do
			table.insert(randomHairs, k)
		end
	end
	
	local randomSkinColors = {}
	local skinCol = color.fromRGBi(255,185,93)
	for i=1,5 do
		table.insert(randomSkinColors, skinCol)
		skinCol = skinCol:clone():darker()
	end
	
	self:setHair( randomHairs[math.random(1,#randomHairs)] )
	self:setSkinColor( randomSkinColors[math.random(1,#randomSkinColors)] )
	self:setHairColor( color.fromRGBf(math.random(),math.random(),math.random()) )
end

