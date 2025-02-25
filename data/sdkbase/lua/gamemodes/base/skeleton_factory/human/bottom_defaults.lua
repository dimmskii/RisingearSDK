--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- MALE ONLY --

local trkblack = HUMAN_CLOTHES.createBottom()
trkblack.niceName = "Black Track Pants"	-- TODO: Stringadactyl
trkblack.createLimbTorsoF = function()
	local spr = sprites.create()
	spr.width = 0.369
	spr.height = 0.660
	spr:addTexture("clothes/male/bottom/trkblack/torso.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.1845
	limb.origin.y = 0.330
	return limb
end
trkblack.createLimbTorsoB = trkblack.createLimbTorsoF -- Same front and back
trkblack.createLimbLegUpperLeftF = function()
	local spr = sprites.create()
	spr.width = 0.245
	spr.height = 0.452
	spr:addTexture("clothes/male/bottom/trkblack/legupperlf.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.1225
	limb.origin.y = 0.052
	return limb
end
trkblack.createLimbLegUpperLeftB = function()
	local spr = sprites.create()
	spr.width = 0.245
	spr.height = 0.452
	spr:addTexture("clothes/male/bottom/trkblack/legupperlb.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.1225
	limb.origin.y = 0.052
	return limb
end
trkblack.createLimbLegUpperRightF = trkblack.createLimbLegUpperLeftB -- Same L/R reversed
trkblack.createLimbLegUpperRightB = trkblack.createLimbLegUpperLeftF -- Same L/R reversed
trkblack.createLimbLegLowerLeftF = function()
	local spr = sprites.create()
	spr.width = 0.206
	spr.height = 0.452
	spr:addTexture("clothes/male/bottom/trkblack/leglowerlf.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.103
	limb.origin.y = 0.052
	return limb
end
trkblack.createLimbLegLowerLeftB = function()
	local spr = sprites.create()
	spr.width = 0.206
	spr.height = 0.452
	spr:addTexture("clothes/male/bottom/trkblack/leglowerlb.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.103
	limb.origin.y = 0.052
	return limb
end
trkblack.createLimbLegLowerRightF = trkblack.createLimbLegLowerLeftB -- Same L/R reversed
trkblack.createLimbLegLowerRightB = trkblack.createLimbLegLowerLeftF -- Same L/R reversed
HUMAN_CLOTHES.registerBottomMale("trkblack", trkblack)



-- FEMALE ONLY --

local tightsblack = HUMAN_CLOTHES.createBottom()
tightsblack.niceName = "Black Leather Tights"	-- TODO: Stringadactyl
tightsblack.createLimbTorsoF = function()
	local spr = sprites.create()
	spr.width = 0.369
	spr.height = 0.660
	spr:addTexture("clothes/female/bottom/tightsblack/torso.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.1845
	limb.origin.y = 0.330
	return limb
end
tightsblack.createLimbTorsoB = tightsblack.createLimbTorsoF -- Same front and back
tightsblack.createLimbLegUpperLeftF = function()
	local spr = sprites.create()
	spr.width = 0.245
	spr.height = 0.452
	spr:addTexture("clothes/female/bottom/tightsblack/legupper.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.1225
	limb.origin.y = 0.052
	return limb
end
tightsblack.createLimbLegUpperLeftB = tightsblack.createLimbLegUpperLeftF -- Same front and back
tightsblack.createLimbLegUpperRightF = tightsblack.createLimbLegUpperLeftF -- Same as left
tightsblack.createLimbLegUpperRightB = tightsblack.createLimbLegUpperLeftF -- Same as left
tightsblack.createLimbLegLowerLeftF = function()
	local spr = sprites.create()
	spr.width = 0.206
	spr.height = 0.452
	spr:addTexture("clothes/female/bottom/tightsblack/leglower.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.103
	limb.origin.y = 0.052
	return limb
end
tightsblack.createLimbLegLowerLeftB = tightsblack.createLimbLegLowerLeftF -- Same front and back
tightsblack.createLimbLegLowerRightF = tightsblack.createLimbLegLowerLeftF -- Same as left
tightsblack.createLimbLegLowerRightB = tightsblack.createLimbLegLowerLeftF -- Same as left
HUMAN_CLOTHES.registerBottomFemale("tightsblack", tightsblack)
