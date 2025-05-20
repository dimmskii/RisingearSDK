--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- MALE ONLY --

local wifebeater = HUMAN_CLOTHES.createTop()
wifebeater.niceName = "Wifebeater"	-- TODO: Stringadactyl
wifebeater.createLimbTorsoF = function()
	local spr = sprites.create()
	spr.width = 0.369
	spr.height = 0.660
	spr:addTexture("clothes/male/top/wifebeater/torso.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.175
	limb.origin.y = 0.330
	return limb
end
wifebeater.createLimbTorsoB = wifebeater.createLimbTorsoF -- Same front and back
HUMAN_CLOTHES.registerTopMale("wifebeater", wifebeater)

local docwhite = HUMAN_CLOTHES.createTop()
docwhite.niceName = "Doctor"	-- TODO: Stringadactyl
docwhite.createLimbTorsoF = function()
	local spr = sprites.create()
	spr.width = 0.45
	spr.height = 0.68
	spr:addTexture("clothes/male/top/docwhite/torso.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.215
	limb.origin.y = 0.420
	return limb
end
docwhite.createLimbTorsoB = docwhite.createLimbTorsoF -- Same front and back
docwhite.createLimbArmLeftF = function()
	local spr = sprites.create()
	spr.width = 0.2355
	spr.height = 0.450
	spr:addTexture("clothes/male/top/docwhite/arm.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0.125
	limb.origin.x = 0.1177
	limb.origin.y = 0.225
	return limb
end
docwhite.createLimbArmLeftB = docwhite.createLimbArmLeftF -- Same front and back
docwhite.createLimbArmRightF = docwhite.createLimbArmLeftF -- Same front and back other side
docwhite.createLimbArmRightB = docwhite.createLimbArmLeftF -- Same front and back other side
docwhite.createLimbForearmLeftF = function()
	local spr = sprites.create()
	spr.width = 0.19
	spr.height = 0.3315
	spr:addTexture("clothes/male/top/docwhite/forearm.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0.07
	limb.origin.x = 0.110
	limb.origin.y = 0.160
	return limb
end
docwhite.createLimbForearmLeftB = docwhite.createLimbForearmLeftF -- Same front and back
docwhite.createLimbForearmRightF = docwhite.createLimbForearmLeftF -- Same front and back other side
docwhite.createLimbForearmRightB = docwhite.createLimbForearmLeftF -- Same front and back other side
HUMAN_CLOTHES.registerTopMale("docwhite", docwhite)

local unifrmblk = HUMAN_CLOTHES.createTop()
unifrmblk.niceName = "Uniform Black"  -- TODO: Stringadactyl
unifrmblk.createLimbTorsoF = function()
  local spr = sprites.create()
  spr.width = 0.45
  spr.height = 0.68
  spr:addTexture("clothes/male/top/unifrmblk/torso.png")
  local limb = skeletal.createLimb("",spr)
  limb.offset.x = 0
  limb.offset.y = 0
  limb.origin.x = 0.215
  limb.origin.y = 0.420
  return limb
end
unifrmblk.createLimbTorsoB = unifrmblk.createLimbTorsoF -- Same front and back
unifrmblk.createLimbArmLeftF = function()
  local spr = sprites.create()
  spr.width = 0.2355
  spr.height = 0.450
  spr:addTexture("clothes/male/top/unifrmblk/arm.png")
  local limb = skeletal.createLimb("",spr)
  limb.offset.x = 0
  limb.offset.y = 0.125
  limb.origin.x = 0.1177
  limb.origin.y = 0.225
  return limb
end
unifrmblk.createLimbArmLeftB = unifrmblk.createLimbArmLeftF -- Same front and back
unifrmblk.createLimbArmRightF = unifrmblk.createLimbArmLeftF -- Same front and back other side
unifrmblk.createLimbArmRightB = unifrmblk.createLimbArmLeftF -- Same front and back other side
HUMAN_CLOTHES.registerTopMale("unifrmblk", unifrmblk)

local unifrmblk_cr = HUMAN_CLOTHES.createTop()
unifrmblk_cr.niceName = "Uniform Black (CrackRock)"  -- TODO: Stringadactyl
unifrmblk_cr.createLimbTorsoF = function()
  local spr = sprites.create()
  spr.width = 0.45
  spr.height = 0.68
  spr:addTexture("clothes/male/top/unifrmblk_cr/torso.png")
  local limb = skeletal.createLimb("",spr)
  limb.offset.x = 0
  limb.offset.y = 0
  limb.origin.x = 0.215
  limb.origin.y = 0.420
  return limb
end
unifrmblk_cr.createLimbTorsoB = unifrmblk_cr.createLimbTorsoF -- Same front and back
unifrmblk_cr.createLimbArmLeftF = function()
  local spr = sprites.create()
  spr.width = 0.2355
  spr.height = 0.450
  spr:addTexture("clothes/male/top/unifrmblk_cr/armlf.png")
  local limb = skeletal.createLimb("",spr)
  limb.offset.x = 0
  limb.offset.y = 0.125
  limb.origin.x = 0.1177
  limb.origin.y = 0.225
  return limb
end
unifrmblk_cr.createLimbArmLeftB = unifrmblk_cr.createLimbArmLeftF -- Same front and back
unifrmblk_cr.createLimbArmRightF = function()
  local spr = sprites.create()
  spr.width = 0.2355
  spr.height = 0.450
  spr:addTexture("clothes/male/top/unifrmblk_cr/armrt.png")
  local limb = skeletal.createLimb("",spr)
  limb.offset.x = 0
  limb.offset.y = 0.125
  limb.origin.x = 0.1177
  limb.origin.y = 0.225
  return limb
end
unifrmblk_cr.createLimbArmRightB = unifrmblk_cr.createLimbArmLeftF -- Same front and back other side
HUMAN_CLOTHES.registerTopMale("unifrmblk_cr", unifrmblk_cr)

-- FEMALE ONLY --

local tubeblack = HUMAN_CLOTHES.createTop()
tubeblack.niceName = "Tube Top Black"	-- TODO: Stringadactyl
tubeblack.createLimbTorsoF = function()
	local spr = sprites.create()
	spr.width = 0.369
	spr.height = 0.660
	spr:addTexture("clothes/female/top/tubeblack/torso.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.175
	limb.origin.y = 0.330
	return limb
end
tubeblack.createLimbTorsoB = tubeblack.createLimbTorsoF -- Same front and back
HUMAN_CLOTHES.registerTopFemale("tubeblack", tubeblack)

local tubepink = HUMAN_CLOTHES.createTop()
tubepink.niceName = "Tube Top Pink"	-- TODO: Stringadactyl
tubepink.createLimbTorsoF = function()
	local spr = sprites.create()
	spr.width = 0.369
	spr.height = 0.660
	spr:addTexture("clothes/female/top/tubepink/torso.png")
	local limb = skeletal.createLimb("",spr)
	limb.offset.x = 0
	limb.offset.y = 0
	limb.origin.x = 0.175
	limb.origin.y = 0.330
	return limb
end
tubepink.createLimbTorsoB = tubepink.createLimbTorsoF -- Same front and back
HUMAN_CLOTHES.registerTopFemale("tubepink", tubepink)
