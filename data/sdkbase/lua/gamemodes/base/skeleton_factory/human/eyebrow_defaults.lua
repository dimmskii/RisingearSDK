--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local virgil = HUMAN_FEATURES.createEyebrows()
virgil.niceName = "Virgil"	-- TODO: Stringadactyl
virgil.createLimb = function()
	local spr = sprites.create()
	spr.width = 0.054
	spr.height = 0.038
	spr:addTexture("characters/male/eyebrows/eyebrw_virgil.png")
	local limb = skeletal.createLimb( "eyebrows", spr )
	limb.offset.x = 0.070
	limb.offset.y = -0.19
	limb.origin.x = 0
	limb.origin.y = 0
	limb.behindParent = false
	limb.flipBehindParent = false
	
	return limb
end

HUMAN_FEATURES.registerEyebrowsMale("virgil", virgil)


local catalina = HUMAN_FEATURES.createEyebrows()
catalina.niceName = "Catalina"	-- TODO: Stringadactyl
catalina.createLimb = function()
	local spr = sprites.create()
	spr.width = 0.093
	spr.height = 0.102
	spr:addTexture("characters/female/eyebrows/eyebrw_catalina.png")
	local limb = skeletal.createLimb( "eyebrows", spr )
	limb.offset.x = 0.055
	limb.offset.y = -0.200
	limb.origin.x = 0
	limb.origin.y = 0
	limb.behindParent = false
	limb.flipBehindParent = false
	
	return limb
end

HUMAN_FEATURES.registerEyebrowsFemale("catalina", catalina)
