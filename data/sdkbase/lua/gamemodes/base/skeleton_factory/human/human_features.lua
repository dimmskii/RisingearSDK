--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


HUMAN_FEATURES = {}

HUMAN_FEATURES.SKIN_PARTS = {
	"torso",
	"head",
	"legupperleft",
	"leglowerleft",
	"footleft",
	"legupperright",
	"leglowerright",
	"footright",
	"armleft",
	"forearmleft",
	"handleft",
	"armright",
	"forearmright",
	"handright"
}

HUMAN_FEATURES.EYES_LIMB_DEPTH				 = 100
HUMAN_FEATURES.FACIAL_HAIR_LIMB_DEPTH		 = 200
HUMAN_FEATURES.HAIR_LIMB_DEPTH				 = 300


-- HAIR --

HUMAN_FEATURES.HAIR_LIST_MALE = {}
HUMAN_FEATURES.HAIR_LIST_FEMALE = {}

HUMAN_FEATURES.createHair = function()
	local hair = {}
	
	hair.niceName = "Unnamed Hairstyle"	-- TODO: Stringadactyl
	
	hair.createLimb = function()
		local spr = sprites.create()
		spr.width = 0.270
		spr.height = 0.2895
		spr:addTexture("characters/male/hair/messy_bowl_cut.png")
		local limb = skeletal.createLimb("hair",spr)
		limb.offset.x = 0
		limb.offset.y = 0
		limb.origin.x = 0.135
		limb.origin.y = 0.2895
		limb.behindParent = false
		limb.flipBehindParent = false
		return limb
	end
	
	return hair
end

local function registerHair( id, hair, table )
	if not id then
		console.err("Hair ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (table[id]) then
		console.log("Attempted to register hair with pre-existing id '" .. id .. "")
		return
	end
	
	hair.id = id
	table[id] = hair
end

HUMAN_FEATURES.registerHairMale = function( id, hair )
	registerHair( id, hair, HUMAN_FEATURES.HAIR_LIST_MALE )
end

HUMAN_FEATURES.registerHairFemale = function( id, hair )
	registerHair( id, hair, HUMAN_FEATURES.HAIR_LIST_FEMALE )
end

HUMAN_FEATURES.addHair = function( skeleton, hair, hairColor )
	if skeleton then
		local head = skeleton:getLimb("head")
		if head then
			local limb = hair.createLimb()
			if limb then
				limb:setName( "hair" ) -- Ensure regular limb name
				limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
				limb.depth = HUMAN_FEATURES.HAIR_LIMB_DEPTH
				head:addChild( limb )
				if (hairColor) then
					limb:setColor( hairColor )
				end
			else
				console.err("Hair table returned a nil limb")
			end
		end
	end
end

HUMAN_FEATURES.removeHair = function( skeleton )
	if skeleton then
		local limb = skeleton:getLimb("hair")
		if limb then
			limb:detatch()
			return true
		end
	end
	return false
end


-- EYES --

HUMAN_FEATURES.EYES_LIST_MALE = {}
HUMAN_FEATURES.EYES_LIST_FEMALE = {}

HUMAN_FEATURES.createEyes = function()
	local eyes = {}
	
	eyes.niceName = "Unnamed Eyes"	-- TODO: Stringadactyl
	
	eyes.createLimb = function()
		local spr = sprites.create()
		spr.width = 0.270
		spr.height = 0.2895
		spr:addTexture("characters/male/eyes/virgil.png")
		local limb = skeletal.createLimb("eyes", spr)
		limb.offset.x = 0
		limb.offset.y = 0
		limb.origin.x = 0.135
		limb.origin.y = 0.2895
		limb.behindParent = false
		limb.flipBehindParent = false
		return limb
	end
	
	return eyes
end

local function registerEyes( id, eyes, table )
	if not id then
		console.err("Eyes ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (table[id]) then
		console.log("Attempted to register eyes with pre-existing id '" .. id .. "")
		return
	end
	
	eyes.id = id
	table[id] = eyes
end

HUMAN_FEATURES.registerEyesMale = function( id, eyes )
	registerEyes( id, eyes, HUMAN_FEATURES.EYES_LIST_MALE )
end

HUMAN_FEATURES.registerEyesFemale = function( id, eyes )
	registerEyes( id, eyes, HUMAN_FEATURES.EYES_LIST_FEMALE )
end

HUMAN_FEATURES.addEyes = function( skeleton, eyes, eyeColor )
	if skeleton then
		local head = skeleton:getLimb("head")
		if head then
			local limb = eyes.createLimb()
			if limb then
				limb:setName( "eyes" ) -- Ensure regular limb name
				limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
				limb.depth = HUMAN_FEATURES.EYES_LIMB_DEPTH
				head:addChild( limb )
				
				local pupil = skeleton:getLimb("pupil")
				if (pupil) then
					pupil.physicsDisabled = true -- Make sure that the pupil's physics flag is disabled too fix
					
					if (eyeColor) then
						limb:setColor( eyeColor )
					end
				end
			else
				console.err("Eyes table returned a nil limb")
			end
		end
	end
end

HUMAN_FEATURES.removeEyes = function( skeleton )
	if skeleton then
		local limb = skeleton:getLimb("eyes")
		if limb then
			limb:detatch()
			return true
		end
	end
	return false
end



-- EYEBROWS --

HUMAN_FEATURES.EYEBROW_LIST_MALE = {}
HUMAN_FEATURES.EYEBROW_LIST_FEMALE = {}

HUMAN_FEATURES.createEyebrows = function()
	local eyebrow = {}
	
	eyebrow.niceName = "Unnamed Eyebrow"	-- TODO: Stringadactyl
	
	eyebrow.createLimb = function()
		local spr = sprites.create()
		spr.width = 0.270
		spr.height = 0.2895
		spr:addTexture("characters/male/eyebrows/virgil.png")
		local limb = skeletal.createLimb("eyebrows", spr)
		limb.offset.x = 0
		limb.offset.y = 0
		limb.origin.x = 0.135
		limb.origin.y = 0.2895
		limb.behindParent = false
		limb.flipBehindParent = false
		return limb
	end
	
	return eyebrow
end

local function registerEyebrows( id, eyebrow, table )
	if not id then
		console.err("Eyebrow ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (table[id]) then
		console.log("Attempted to register eyebrow with pre-existing id '" .. id .. "")
		return
	end
	
	eyebrow.id = id
	table[id] = eyebrow
end

HUMAN_FEATURES.registerEyebrowsMale = function( id, eyebrow )
	registerEyebrows( id, eyebrow, HUMAN_FEATURES.EYEBROW_LIST_MALE )
end

HUMAN_FEATURES.registerEyebrowsFemale = function( id, eyebrow )
	registerEyebrows( id, eyebrow, HUMAN_FEATURES.EYEBROW_LIST_FEMALE )
end

HUMAN_FEATURES.addEyebrows = function( skeleton, eyebrow, eyebrowColor )
	if skeleton then
		local head = skeleton:getLimb("head")
		if head then
			local limb = eyebrow.createLimb()
			if limb then
				limb:setName( "eyebrows" ) -- Ensure regular limb name
				limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
				head:addChild( limb )
				if (eyebrowColor) then
					limb:setColor( eyebrowColor )
				end
			else
				console.err("Eyebrow table returned a nil limb")
			end
		end
	end
end

HUMAN_FEATURES.removeEyebrows = function( skeleton )
	if skeleton then
		local limb = skeleton:getLimb("eyebrows")
		if limb then
			limb:detatch()
			return true
		end
	end
	return false
end



-- FACIAL HAIR --

HUMAN_FEATURES.FACIAL_HAIR_LIST_MALE = {}
HUMAN_FEATURES.FACIAL_HAIR_LIST_FEMALE = {}

HUMAN_FEATURES.createFacialHair = function()
	local facialHair = {}
	
	facialHair.niceName = "Unnamed Facial Hair"	-- TODO: Stringadactyl
	
	facialHair.createLimb = function()
		local spr = sprites.create()
		spr.width = 0.270
		spr.height = 0.2895
		spr:addTexture("characters/male/facialhair/slayer.png")
		local limb = skeletal.createLimb("facialhair",spr)
		limb.offset.x = 0
		limb.offset.y = 0
		limb.origin.x = 0.135
		limb.origin.y = 0.2895
		limb.behindParent = false
		limb.flipBehindParent = false
		return limb
	end
	
	return facialHair
end

local function registerFacialHair( id, facialHair, table )
	if not id then
		console.err("Facial hair ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (table[id]) then
		console.log("Attempted to register facial hair with pre-existing id '" .. id .. "")
		return
	end
	
	facialHair.id = id
	table[id] = facialHair
end

HUMAN_FEATURES.registerFacialHairMale = function( id, facialHair )
	registerFacialHair( id, facialHair, HUMAN_FEATURES.FACIAL_HAIR_LIST_MALE )
end

HUMAN_FEATURES.registerFacialHairFemale = function( id, facialHair )
	registerFacialHair( id, facialHair, HUMAN_FEATURES.FACIAL_HAIR_LIST_FEMALE )
end

HUMAN_FEATURES.addFacialHair = function( skeleton, facialHair, facialHairColor )
	if skeleton then
		local head = skeleton:getLimb("head")
		if head then
			local limb = facialHair.createLimb()
			if limb then
				limb:setName( "facialhair" ) -- Ensure regular limb name
				limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
				limb.depth = HUMAN_FEATURES.FACIAL_HAIR_LIMB_DEPTH
				head:addChild( limb )
				if (facialHairColor) then
					limb:setColor( facialHairColor )
				end
			else
				console.err("Facial hair table returned a nil limb")
			end
		end
	end
end

HUMAN_FEATURES.removeFacialHair = function( skeleton )
	if skeleton then
		local limb = skeleton:getLimb("facialhair")
		if limb then
			limb:detatch()
			return true
		end
	end
	return false
end


include("eye_defaults.lua")
include("eyebrow_defaults.lua")
include("hair_defaults.lua")
include("facial_hair_defaults.lua")
