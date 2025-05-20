--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- MALE ONLY --

local bootscamo = HUMAN_CLOTHES.createShoes()
bootscamo.niceName = "Camo Boots"	-- TODO: Stringadactyl
bootscamo.createLimbFootLeftF = function()
	local spr = sprites.create()
	spr.width = 0.281
	spr.height = 0.189
	spr:addTexture("clothes/male/shoes/bootscamo.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.068
	limb.origin.y = 0.045
	return limb
end
bootscamo.createLimbFootLeftB = bootscamo.createLimbFootLeftF -- Same front and back
bootscamo.createLimbFootRightF = bootscamo.createLimbFootLeftF -- Same as left
bootscamo.createLimbFootRightB = bootscamo.createLimbFootLeftF -- Same as left
HUMAN_CLOTHES.registerShoesMale("bootscamo", bootscamo)

local dresblk = HUMAN_CLOTHES.createShoes()
dresblk.niceName = "Black Dress Shoe"	-- TODO: Stringadactyl
dresblk.createLimbFootLeftF = function()
	local spr = sprites.create()
	spr.width = 0.267
	spr.height = 0.1275
	spr:addTexture("clothes/male/shoes/dresblk.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.0615
	limb.origin.y = 0.006
	return limb
end
dresblk.createLimbFootLeftB = dresblk.createLimbFootLeftF -- Same front and back
dresblk.createLimbFootRightF = dresblk.createLimbFootLeftF -- Same as left
dresblk.createLimbFootRightB = dresblk.createLimbFootLeftF -- Same as left
HUMAN_CLOTHES.registerShoesMale("dresblk", dresblk)


-- FEMALE ONLY --

local slipesblack = HUMAN_CLOTHES.createShoes()
slipesblack.niceName = "Black Slippers"	-- TODO: Stringadactyl
slipesblack.createLimbFootLeftF = function()
	local spr = sprites.create()
	spr.width = 0.271
	spr.height = 0.1315
	spr:addTexture("clothes/female/shoes/slipesblack.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.068
	limb.origin.y = 0.001
	return limb
end
slipesblack.createLimbFootLeftB = slipesblack.createLimbFootLeftF -- Same front and back
slipesblack.createLimbFootRightF = slipesblack.createLimbFootLeftF -- Same as left
slipesblack.createLimbFootRightB = slipesblack.createLimbFootLeftF -- Same as left
HUMAN_CLOTHES.registerShoesFemale("slipesblack", slipesblack)
