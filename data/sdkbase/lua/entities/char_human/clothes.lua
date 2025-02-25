--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

function ENT:initHumanClothes()
	self:initProperty("top", "")
	self:initProperty("bottom", "")
	self:initProperty("shoes", "")

	self:setTop(self.top)
	self:setBottom(self.bottom)
	self:setShoes(self.shoes)
	
end


-- TOP --

function ENT:setTop( id )
	if not self.skeleton then return end

	local table = HUMAN_CLOTHES.TOP_LIST_MALE
	if (self.female) then table = HUMAN_CLOTHES.TOP_LIST_FEMALE end
	
	if not id then
		console.err("Top ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (id == "") then
		self:removeTop()
		return
	end
	
	local item = table[id]
	if not item then
		console.err("Top with id '" .. id .. "' does not exist or is not registered")
		return
	end
	
	HUMAN_CLOTHES.addTop( self.skeleton, item )
	self.top = id
	self.topDirty = true
end

function ENT:removeTop()
	if not self.skeleton then return end
	
	HUMAN_CLOTHES.removeTop( self.skeleton )
	self.top = ""
	self.topDirty = true
end


-- BOTTOM --

function ENT:setBottom( id )
	if not self.skeleton then return end

	local table = HUMAN_CLOTHES.BOTTOM_LIST_MALE
	if (self.female) then table = HUMAN_CLOTHES.BOTTOM_LIST_FEMALE end
	
	if not id then
		console.err("Bottom ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (id == "") then
		self:removeBottom()
		return
	end
	
	local item = table[id]
	if not item then
		console.err("Bottom with id '" .. id .. "' does not exist or is not registered")
		return
	end
	
	HUMAN_CLOTHES.addBottom( self.skeleton, item )
	self.bottom = id
	self.bottomDirty = true
end

function ENT:removeBottom()
	if not self.skeleton then return end
	
	HUMAN_CLOTHES.removeBottom( self.skeleton )
	self.bottom = ""
	self.bottomDirty = true
end



-- SHOES --

function ENT:setShoes( id )
	if not self.skeleton then return end

	local table = HUMAN_CLOTHES.SHOES_LIST_MALE
	if (self.female) then table = HUMAN_CLOTHES.SHOES_LIST_FEMALE end
	
	if not id then
		console.err("Shoes ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (id == "") then
		self:removeShoes()
		return
	end
	
	local item = table[id]
	if not item then
		console.err("Shoes with id '" .. id .. "' does not exist or is not registered")
		return
	end
	
	HUMAN_CLOTHES.addShoes( self.skeleton, item )
	self.shoes = id
	self.shoesDirty = true
end

function ENT:removeShoes()
	if not self.skeleton then return end
	
	HUMAN_CLOTHES.removeShoes( self.skeleton )
	self.shoes = ""
	self.shoesDirty = true
end
