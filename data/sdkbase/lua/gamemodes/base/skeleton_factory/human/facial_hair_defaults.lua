--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local none = HUMAN_FEATURES.createFacialHair()
none.niceName = "None"	-- TODO: Stringadactyl
none.createLimb = function()
	return nil
end
HUMAN_FEATURES.registerFacialHairMale("none", none)
HUMAN_FEATURES.registerFacialHairFemale("none", none)

--local slayer = HUMAN_FEATURES.createFacialHair()
--slayer.niceName = "Slayer Beard"	-- TODO: Stringadactyl
--slayer.createLimb = function()
--	local spr = sprites.create()
--	spr.width = 0.270
--	spr.height = 0.2895
--	spr:addTexture("characters/male/facialhair/slayer.png")
--	local limb = skeletal.createLimb("facialhair",spr)
--	limb.offset.x = 0
--	limb.offset.y = 0
--	limb.origin.x = 0.135
--	limb.origin.y = 0.2895
--	limb.behindParent = false
--	limb.flipBehindParent = false
--	return limb
--end
--HUMAN_FEATURES.registerFacialHairMale("slayer", slayer)

local slayer = HUMAN_FEATURES.createFacialHair()
slayer.niceName = "Slayer Beard"	-- TODO: Stringadactyl
slayer.createLimb = function()
	local spr = sprites.create()
	spr.width = 0.135
	spr.height = 0.145
	spr:addTexture("characters/male/facialhair/slayer.png")
	local limb = skeletal.createLimb("facialhair",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0
	limb.origin.y = 0.145
	limb.behindParent = false
	limb.flipBehindParent = false
	return limb
end
HUMAN_FEATURES.registerFacialHairMale("slayer", slayer)

local oldgoatee = HUMAN_FEATURES.createFacialHair()
oldgoatee.niceName = "Old Man Goatee"	-- TODO: Stringadactyl
oldgoatee.createLimb = function()
	local spr = sprites.create()
	spr.width = 0.135
	spr.height = 0.145
	spr:addTexture("characters/male/facialhair/oldgoatee.png")
	local limb = skeletal.createLimb("facialhair",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0
	limb.origin.y = 0.145
	limb.behindParent = false
	limb.flipBehindParent = false
	return limb
end
HUMAN_FEATURES.registerFacialHairMale("oldgoatee", oldgoatee)


