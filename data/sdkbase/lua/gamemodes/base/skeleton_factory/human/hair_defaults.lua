--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local messy_bowl_cut = HUMAN_FEATURES.createHair()
messy_bowl_cut.niceName = "Messy Bowl Cut"	-- TODO: Stringadactyl
messy_bowl_cut.createLimb = function()
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
HUMAN_FEATURES.registerHairMale("messy_bowl_cut", messy_bowl_cut)




-- UNISEX

local mohawk = HUMAN_FEATURES.createHair()
mohawk.niceName = "Mohawk"	-- TODO: Stringadactyl
mohawk.createLimb = function()
	local spr = sprites.create()
	spr.width = 0.528
	spr.height = 0.4342
	spr:addTexture("characters/male/hair/mohawk.png")
	local limb = skeletal.createLimb("hair",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.260
	limb.origin.y = 0.4342
	limb.behindParent = false
	limb.flipBehindParent = false
	return limb
end
HUMAN_FEATURES.registerHairMale("mohawk", mohawk)
HUMAN_FEATURES.registerHairFemale("mohawk", mohawk)

local afro = HUMAN_FEATURES.createHair()
afro.niceName = "Afro"	-- TODO: Stringadactyl
afro.createLimb = function()
	local spr = sprites.create()
	spr.width = 0.540
	spr.height = 0.4342
	spr:addTexture("characters/male/hair/afro.png")
	local limb = skeletal.createLimb("hair",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.270
	limb.origin.y = 0.4342
	limb.behindParent = false
	limb.flipBehindParent = false
	return limb
end
HUMAN_FEATURES.registerHairMale("afro", afro)
HUMAN_FEATURES.registerHairFemale("afro", afro)

local bald = HUMAN_FEATURES.createHair()
bald.niceName = "Bald"	-- TODO: Stringadactyl
bald.createLimb = function()
	return nil
end
HUMAN_FEATURES.registerHairMale("bald", bald)
HUMAN_FEATURES.registerHairFemale("bald", bald)




-- FEMALE ONLY --

local gabrielle = HUMAN_FEATURES.createHair()
gabrielle.niceName = "Gabrielle"	-- TODO: Stringadactyl
gabrielle.createLimb = function()
	local spr = sprites.create()
	spr.width = 0.516
	spr.height = 0.5017
	spr:addTexture("characters/female/hair/gabrielle.png")
	local limb = skeletal.createLimb("hair",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.370
	limb.origin.y = 0.4342
	limb.behindParent = false
	limb.flipBehindParent = false
	return limb
end
HUMAN_FEATURES.registerHairFemale("gabrielle", gabrielle)

local bruja = HUMAN_FEATURES.createHair()
bruja.niceName = "Witcheress"	-- TODO: Stringadactyl
bruja.createLimb = function()
	local spr = sprites.create()
	spr.width = 0.4995
	spr.height = 0.7755
	spr:addTexture("characters/female/hair/bruja.png")
	local limb = skeletal.createLimb("hair",spr)
	limb.offset.x = -0.1935
	limb.offset.y = -0.057
	limb.origin.x = 0.135
	limb.origin.y = 0.2895
	limb.behindParent = false
	limb.flipBehindParent = false
	return limb
end
HUMAN_FEATURES.registerHairFemale("bruja", bruja)

local ponyt1 = HUMAN_FEATURES.createHair()
ponyt1.niceName = "Ponytail 1"	-- TODO: Stringadactyl
ponyt1.createLimb = function()
	local spr = sprites.create()
	spr.width = 0.520
	spr.height = 0.410
	spr:addTexture("characters/female/hair/ponyt1.png")
	local limb = skeletal.createLimb("hair",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.375
	limb.origin.y = 0.3955
	limb.behindParent = false
	limb.flipBehindParent = false
	return limb
end
HUMAN_FEATURES.registerHairFemale("ponyt1", ponyt1)
