--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


function ENT:initHumanFeatures()
	self:initProperty("hair", "")
	self:initProperty("hairColor", color.fromRGBf(0.7,0.6,0.05))
	self:initProperty("skinColor", color.fromRGBi(255,185,93))
	self:initProperty("facialHair", "")
	self:initProperty("facialHairColor", color.fromRGBf(0.7,0.6,0.05))
	self:initProperty("eyes", "")
	self:initProperty("eyeColor", color.fromRGBi(150,200,255))
	self:initProperty("eyebrows", "")
	self:initProperty("eyebrowColor", color.fromRGBf(1,0,0))
	
	self:setSkinColor(self.skinColor)
	
	self:setHair(self.hair)
	self:setHairColor(self.hairColor)
	
	self:setFacialHair(self.facialHair)
	self:setFacialHairColor(self.facialHairColor)
	
	self:setEyes(self.eyes)
	self:setEyeColor(self.eyeColor)
	
	self:setEyebrows(self.eyebrows)
	self:setEyebrowColor(self.eyebrowColor)
end

function ENT:setSkinColor( color )
	if self.skeleton then
		local limb = nil
		for _,v in pairs(HUMAN_FEATURES.SKIN_PARTS) do
			limb = self.skeleton:getLimb(v)
			if ( limb ) then
				limb:setColor( color )
			end
		end
	end
	self.skinColor = color
	if (SERVER) then
		self.skinColorDirty = true
	end
end





-- HAIR --

function ENT:setHair( id )

	HUMAN_FEATURES.removeHair( self.skeleton ) -- Remove first
	
	local table = HUMAN_FEATURES.HAIR_LIST_MALE
	if (self.female) then table = HUMAN_FEATURES.HAIR_LIST_FEMALE end
	
	if not id then
		console.err("Hair ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (id == "") then
		self:removeHair()
		return
	end
	
	local hair = table[id]
	if not hair then
		console.err("Hair with id '" .. id .. "' does not exist or is not registered")
		return
	end
	
	if self.skeleton then
		local head = self.skeleton:getLimb("head")
		if head then
			local limb = hair.createLimb()
			if limb then
				limb:setName( "hair" ) -- Ensure regular limb name
				--limb:setColor( hair.color ) -- Ensure color consistency
				limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
				limb.depth = HUMAN_FEATURES.HAIR_LIMB_DEPTH
				head:addChild( limb )
				self.hair = hair.id
				self:setHairColor( self.hairColor )
				if (SERVER) then
					self.hairDirty = true
				end
			else
				console.err("Hair table returned a nil limb")
			end
		end
	end
end

function ENT:removeHair()
	HUMAN_FEATURES.removeHair( self.skeleton )
	self.hair = ""
	self.hairDirty = true
end

function ENT:setHairColor( color )
	if self.skeleton then
		local limb = self.skeleton:getLimb("hair")
		if limb then
			limb:setColor( color )
		end
	end
	self.hairColor = color
	if (SERVER) then
		self.hairColorDirty = true
	end
end




-- OCHYAE --

function ENT:setEyes( id )

	HUMAN_FEATURES.removeEyes( self.skeleton ) -- Remove first
	
	local table = HUMAN_FEATURES.EYES_LIST_MALE
	if (self.female) then table = HUMAN_FEATURES.EYES_LIST_FEMALE end
	
	if not id then
		console.err("Eyes ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (id == "") then
		self:removeEyes()
		return
	end
	
	local eyes = table[id]
	if not eyes then
		console.err("Eyes with id '" .. id .. "' does not exist or is not registered")
		return
	end
	
	if self.skeleton then
		local head = self.skeleton:getLimb("head")
		if head then
			local limb = eyes.createLimb()
			if limb then
				limb:setName( "eyes" ) -- Ensure regular limb name
				limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
				limb.depth = HUMAN_FEATURES.EYES_LIMB_DEPTH
				head:addChild( limb )
				self.eyes = eyes.id
				self:setEyeColor( self.eyeColor )
				local pupil = self.skeleton:getLimb("pupil")
				if (pupil) then
					pupil.physicsDisabled = true -- Make sure that the pupil's physics flag is disabled too fix
				end
				if (SERVER) then
					self.eyesDirty = true
				end
			else
				console.err("Eyes table returned a nil limb")
			end
		end
	end
end

function ENT:removeEyes()
	HUMAN_FEATURES.removeEyes( self.skeleton )
	self.eyes = ""
	self.eyesDirty = true
end

function ENT:setEyeColor( color )
	if self.skeleton then
		local limb = self.skeleton:getLimb("pupil")
		if limb then
			limb:setColor( color )
		end
	end
	self.eyeColor = color
	if (SERVER) then
		self.eyeColorDirty = true
	end
end



-- EYEBROWS --

function ENT:setEyebrows( id )

	HUMAN_FEATURES.removeEyebrows( self.skeleton ) -- Remove first
	
	local table = HUMAN_FEATURES.EYEBROW_LIST_MALE
	if (self.female) then table = HUMAN_FEATURES.EYEBROW_LIST_FEMALE end
	
	if not id then
		console.err("Eyebrow ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (id == "") then
		self:removeEyebrows()
		return
	end
	
	local eyebrow = table[id]
	if not eyebrow then
		console.err("Eyebrow with id '" .. id .. "' does not exist or is not registered")
		return
	end
	
	if self.skeleton then
		local head = self.skeleton:getLimb("head")
		if head then
			local limb = eyebrow.createLimb()
			if limb then
				limb:setName( "eyebrows" ) -- Ensure regular limb name
				--limb:setColor( hair.color ) -- Ensure color consistency
				limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
				head:addChild( limb )
				self.eyebrows = eyebrow.id
				self:setEyebrowColor( self.eyebrowColor )
				if (SERVER) then
					self.eyebrowsDirty = true
				end
			else
				console.err("Eyebrow table returned a nil limb")
			end
		end
	end
end

function ENT:removeEyebrows()
	HUMAN_FEATURES.removeEyebrows( self.skeleton )
	self.eyebrows = ""
	self.eyebrowsDirty = true
end

function ENT:setEyebrowColor( color )
	if self.skeleton then
		local limb = self.skeleton:getLimb("eyebrows")
		if limb then
			limb:setColor( color )
		end
	end
	self.eyebrowColor = color
	if (SERVER) then
		self.eyebrowColorDirty = true
	end
end



-- FACIAL HAIR --

function ENT:setFacialHair( id )

	HUMAN_FEATURES.removeFacialHair( self.skeleton ) -- Remove first
	
	local table = HUMAN_FEATURES.FACIAL_HAIR_LIST_MALE
	if (self.female) then table = HUMAN_FEATURES.FACIAL_HAIR_LIST_FEMALE end
	
	if not id then
		console.err("Facial hair ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (id == "") then
		self:removeFacialHair()
		return
	end
	
	local facialHair = table[id]
	if not facialHair then
		console.err("Facial hair with id '" .. id .. "' does not exist or is not registered")
		return
	end
	
	if self.skeleton then
		local head = self.skeleton:getLimb("head")
		if head then
			local limb = facialHair.createLimb()
			if limb then
				limb:setName( "facialhair" ) -- Ensure regular limb name
				--limb:setColor( facialHair.color ) -- Ensure color consistency
				limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
				limb.depth = HUMAN_FEATURES.FACIAL_HAIR_LIMB_DEPTH
				head:addChild( limb )
				self.facialHair = facialHair.id
				self:setFacialHairColor( self.facialHairColor )
				if (SERVER) then
					self.facialHairDirty = true
				end
			else
				console.err("Facial hair table returned a nil limb")
			end
		end
	end
end

function ENT:removeFacialHair()
	HUMAN_FEATURES.removeFacialHair( self.skeleton )
	self.facialHair = ""
	self.facialHairDirty = true
end

function ENT:setFacialHairColor( color )
	if self.skeleton then
		local limb = self.skeleton:getLimb("facialhair")
		if limb then
			limb:setColor( color )
		end
	end
	self.facialHairColor = color
	if (SERVER) then
		self.facialHairColorDirty = true
	end
end