--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local virgil = HUMAN_FEATURES.createEyes()
virgil.niceName = "Virgil"	-- TODO: Stringadactyl
virgil.createLimb = function()
	local spr_eyes = sprites.create()
	spr_eyes.width = 0.055
	spr_eyes.height = 0.039
	spr_eyes:addTexture("characters/male/eyes/eye_virgil.png")
	local limb_eyes = skeletal.createLimb( "eyes", spr_eyes )
	limb_eyes.offset.x = 0.075
	limb_eyes.offset.y = -0.160
	limb_eyes.origin.x = 0 -- 0.135
	limb_eyes.origin.y = 0 -- 0.015
	limb_eyes.behindParent = false
	limb_eyes.flipBehindParent = false
	
	local spr_pupil = sprites.create()
	spr_pupil.width = 0.055
	spr_pupil.height = 0.039
	spr_pupil:addTexture("characters/male/eyes/eye_virgil_pupil.png")
	local limb_pupil = skeletal.createLimb( "pupil", spr_pupil )
	limb_pupil.offset.x = 0.0
	limb_pupil.offset.y = 0
	limb_pupil.origin.x = 0
	limb_pupil.origin.y = 0
	limb_pupil.behindParent = false
	limb_pupil.flipBehindParent = false
	
	limb_eyes:addChild(limb_pupil)
	
	return limb_eyes
end

HUMAN_FEATURES.registerEyesMale("virgil", virgil)




local catalina = HUMAN_FEATURES.createEyes()
catalina.niceName = "Catalina"	-- TODO: Stringadactyl
catalina.createLimb = function()
	local spr_eyes = sprites.create()
	spr_eyes.width = 0.093
	spr_eyes.height = 0.102
	spr_eyes:addTexture("characters/female/eyes/eye_catalina.png")
	local limb_eyes = skeletal.createLimb( "eyes", spr_eyes )
	limb_eyes.offset.x = 0.055
	limb_eyes.offset.y = -0.200
	limb_eyes.origin.x = 0
	limb_eyes.origin.y = 0
	limb_eyes.behindParent = false
	limb_eyes.flipBehindParent = false
	
	local spr_pupil = sprites.create()
	spr_pupil.width = 0.093
	spr_pupil.height = 0.102
	spr_pupil:addTexture("characters/female/eyes/eye_catalina_pupil.png")
	local limb_pupil = skeletal.createLimb( "pupil", spr_pupil )
	limb_pupil.offset.x = 0.0
	limb_pupil.offset.y = 0
	limb_pupil.origin.x = 0
	limb_pupil.origin.y = 0
	limb_pupil.behindParent = false
	limb_pupil.flipBehindParent = false
	
	limb_eyes:addChild(limb_pupil)
	
	return limb_eyes
end

HUMAN_FEATURES.registerEyesFemale("catalina", catalina)
