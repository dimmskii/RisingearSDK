--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--



skeleton_factory.define("rept01", function()

	local skel = skeletal.createSkeleton()
	
	local spr_torso = sprites.create()
	spr_torso.width = 0.369
	spr_torso.height = 0.660
	spr_torso:addTexture("characters/rept01/torso.png")
	local limb_torso = skeletal.createLimb("torso",spr_torso)
	limb_torso.origin.x = 0.1845
	limb_torso.origin.y = 0.330
	skel:setRoot(limb_torso)
	
	local spr_head = sprites.create()
	spr_head.width = 0.270
	spr_head.height = 0.2895
	spr_head:addTexture("characters/rept01/head.png")
	local limb_head = skeletal.createLimb("head",spr_head)
	limb_head.offset.x = 0
	limb_head.offset.y = -0.330
	limb_head.origin.x = 0.135
	limb_head.origin.y = 0.2895
	limb_head.behindParent = true
	limb_head.flipBehindParent = false -- Head always renders behind parent limb (torso), even when mirrored
	limb_head.physicsMinAngle = -1.4
	limb_head.physicsMaxAngle = 1.4
	limb_head.depth = 2000
	limb_torso:addChild(limb_head)
	
	local spr_legupperleft = sprites.create()
	spr_legupperleft.width = 0.243
	spr_legupperleft.height = 0.450
	spr_legupperleft:addTexture("characters/rept01/legupper.png")
	local limb_legupperleft = skeletal.createLimb("legupperleft",spr_legupperleft)
	limb_legupperleft.offset.x = 0.016
	limb_legupperleft.offset.y = 0.288
	limb_legupperleft.origin.x = 0.1215
	limb_legupperleft.origin.y = 0.052
	limb_legupperleft.behindParent = true
	limb_legupperleft.physicsMinAngle = -0.5
	limb_legupperleft.physicsMaxAngle = 1.5
	limb_legupperleft.depth = 500
	limb_torso:addChild(limb_legupperleft)
	
	local spr_leglowerleft = sprites.create()
	spr_leglowerleft.width = 0.204
	spr_leglowerleft.height = 0.450
	spr_leglowerleft:addTexture("characters/rept01/leglower.png")
	local limb_leglowerleft = skeletal.createLimb("leglowerleft",spr_leglowerleft)
	limb_leglowerleft.offset.x = 0
	limb_leglowerleft.offset.y = 0.375
	limb_leglowerleft.origin.x = 0.102
	limb_leglowerleft.origin.y = 0.0525
	limb_leglowerleft.behindParent = true
	limb_leglowerleft.physicsMinAngle = -1.6
	limb_leglowerleft.physicsMaxAngle = 0
	limb_legupperleft:addChild(limb_leglowerleft)
	
	local spr_footleft = sprites.create()
	spr_footleft.width = 0.267
	spr_footleft.height = 0.1275
	spr_footleft:addTexture("characters/rept01/foot.png")
	local limb_footleft = skeletal.createLimb("footleft",spr_footleft)
	limb_footleft.offset.x = 0
	limb_footleft.offset.y = 0.350
	limb_footleft.origin.x = 0.0615
	limb_footleft.origin.y = 0.006
	limb_footleft.behindParent = true
	limb_footleft.flipBehindParent = false
	limb_footleft.physicsMinAngle = -0.5
	limb_footleft.physicsMaxAngle = 0
	limb_leglowerleft:addChild(limb_footleft)
	
	local spr_legupperright = sprites.create()
	spr_legupperright.width = 0.243
	spr_legupperright.height = 0.450
	spr_legupperright:addTexture("characters/rept01/legupper.png")
	local limb_legupperright = skeletal.createLimb("legupperright",spr_legupperright)
	limb_legupperright.offset.x = 0.016
	limb_legupperright.offset.y = 0.288
	limb_legupperright.origin.x = 0.1215
	limb_legupperright.origin.y = 0.052
	limb_legupperright.behindParent = false
	limb_legupperright.physicsMinAngle = -0.5
	limb_legupperright.physicsMaxAngle = 1.5
	limb_legupperright.depth = 500
	limb_torso:addChild(limb_legupperright)
	
	local spr_leglowerright = sprites.create()
	spr_leglowerright.width = 0.204
	spr_leglowerright.height = 0.450
	spr_leglowerright:addTexture("characters/rept01/leglower.png")
	local limb_leglowerright = skeletal.createLimb("leglowerright",spr_leglowerright)
	limb_leglowerright.offset.x = 0
	limb_leglowerright.offset.y = 0.375
	limb_leglowerright.origin.x = 0.102
	limb_leglowerright.origin.y = 0.0525
	limb_leglowerright.behindParent = false
	limb_leglowerright.physicsMinAngle = -1.6
	limb_leglowerright.physicsMaxAngle = 0
	limb_legupperright:addChild(limb_leglowerright)
	
	local spr_footright = sprites.create()
	spr_footright.width = 0.267
	spr_footright.height = 0.1275
	spr_footright:addTexture("characters/rept01/foot.png")
	local limb_footright = skeletal.createLimb("footright",spr_footright)
	limb_footright.offset.x = 0
	limb_footright.offset.y = 0.350
	limb_footright.origin.x = 0.0615
	limb_footright.origin.y = 0.006
	limb_footright.behindParent = true
	limb_footright.flipBehindParent = false
	limb_footright.physicsMinAngle = -0.5
	limb_footright.physicsMaxAngle = 0
	limb_leglowerright:addChild(limb_footright)
	
	local spr_armleft = sprites.create()
	spr_armleft.width = 0.2355
	spr_armleft.height = 0.450
	spr_armleft:addTexture("characters/rept01/arm.png")
	local limb_armleft = skeletal.createLimb("armleft",spr_armleft)
	limb_armleft.offset.x = 0
	limb_armleft.offset.y = -0.258
	limb_armleft.origin.x = 0.117
	limb_armleft.origin.y = 0.0975
	limb_armleft.behindParent = true
	limb_armleft.physicsMinAngle = -999
	limb_armleft.physicsMaxAngle = 999
	limb_armleft.depth = 1000
	limb_torso:addChild(limb_armleft)
	
	local spr_forearmleft = sprites.create()
	spr_forearmleft.width = 0.183
	spr_forearmleft.height = 0.3315
	spr_forearmleft:addTexture("characters/rept01/forearm.png")
	local limb_forearmleft = skeletal.createLimb("forearmleft",spr_forearmleft)
	limb_forearmleft.offset.x = 0
	limb_forearmleft.offset.y = 0.315
	limb_forearmleft.origin.x = 0.087
	limb_forearmleft.origin.y = 0.0115
	limb_forearmleft.behindParent = true
	limb_armleft:addChild(limb_forearmleft)
	
	local spr_handleft = sprites.create()
	spr_handleft.width = 0.183
	spr_handleft.height = 0.183
	spr_handleft:addTexture("characters/rept01/hand.png")
	local limb_handleft = skeletal.createLimb("handleft",spr_handleft)
	limb_handleft.offset.x = 0.000
	limb_handleft.offset.y = 0.2915
	limb_handleft.origin.x = 0.0915
	limb_handleft.origin.y = 0.0000
	limb_handleft.behindParent = true
	limb_forearmleft:addChild(limb_handleft)
	
	local spr_armright = sprites.create()
	spr_armright.width = 0.2355
	spr_armright.height = 0.450
	spr_armright:addTexture("characters/rept01/arm.png")
	local limb_armright = skeletal.createLimb("armright",spr_armright)
	limb_armright.offset.x = 0
	limb_armright.offset.y = -0.258
	limb_armright.origin.x = 0.117
	limb_armright.origin.y = 0.0975
	limb_armright.behindParent = false
	limb_armright.physicsMinAngle = -999
	limb_armright.physicsMaxAngle = 999
	limb_armright.depth = 1000
	limb_torso:addChild(limb_armright)
	
	local spr_forearmright = sprites.create()
	spr_forearmright.width = 0.183
	spr_forearmright.height = 0.3315
	spr_forearmright:addTexture("characters/rept01/forearm.png")
	local limb_forearmright = skeletal.createLimb("forearmright",spr_forearmright)
	limb_forearmright.offset.x = 0
	limb_forearmright.offset.y = 0.315
	limb_forearmright.origin.x = 0.087
	limb_forearmright.origin.y = 0.0115
	limb_forearmright.behindParent = false
	limb_armright:addChild(limb_forearmright)
	
	local spr_handright = sprites.create()
	spr_handright.width = 0.183
	spr_handright.height = 0.183
	spr_handright:addTexture("characters/rept01/hand.png")
	local limb_handright = skeletal.createLimb("handright",spr_handright)
	limb_handright.offset.x = 0.000
	limb_handright.offset.y = 0.2915
	limb_handright.origin.x = 0.0915
	limb_handright.origin.y = 0.0000
	limb_handright.behindParent = true
	limb_forearmright:addChild(limb_handright)
	
	return skel

end)






































skeleton_factory.define("zombie", function()

	local skel = skeletal.createSkeleton()
	
	local spr_torso = sprites.create()
	spr_torso.width = 0.460
	spr_torso.height = 0.579
	spr_torso:addTexture("characters/zombie/torso.png")
	local limb_torso = skeletal.createLimb("torso",spr_torso)
	limb_torso.origin.x = 0.230
	limb_torso.origin.y = 0.300
	skel:setRoot(limb_torso)
	
	local spr_head = sprites.create()
	spr_head.width = 0.481
	spr_head.height = 0.477
	spr_head:addTexture("characters/zombie/head.png")
	local limb_head = skeletal.createLimb("head",spr_head)
	limb_head.offset.x = 0.035
	limb_head.offset.y = -0.250
	limb_head.origin.x = 0.220
	limb_head.origin.y = 0.445
	limb_head.behindParent = true
	limb_head.flipBehindParent = false -- Head always renders behind parent limb (torso), even when mirrored
	limb_head.physicsMinAngle = -1.4
	limb_head.physicsMaxAngle = 1.4
	limb_head.depth = 2000
	limb_torso:addChild(limb_head)
	
	local spr_legupperleft = sprites.create()
	spr_legupperleft.width = 0.379
	spr_legupperleft.height = 0.783
	spr_legupperleft:addTexture("characters/zombie/legupper.png")
	local limb_legupperleft = skeletal.createLimb("legupperleft",spr_legupperleft)
	limb_legupperleft.offset.x = 0.016
	limb_legupperleft.offset.y = 0.288
	limb_legupperleft.origin.x = 0.185
	limb_legupperleft.origin.y = 0.085
	limb_legupperleft.behindParent = true
	limb_legupperleft.physicsMinAngle = -0.5
	limb_legupperleft.physicsMaxAngle = 1.5
	limb_legupperleft.depth = 500
	limb_torso:addChild(limb_legupperleft)
	
	local spr_leglowerleft = sprites.create()
	spr_leglowerleft.width = 0.562
	spr_leglowerleft.height = 0.756
	spr_leglowerleft:addTexture("characters/zombie/leglower.png")
	local limb_leglowerleft = skeletal.createLimb("leglowerleft",spr_leglowerleft)
	limb_leglowerleft.offset.x = 0
	limb_leglowerleft.offset.y = 0.700
	limb_leglowerleft.origin.x = 0.144
	limb_leglowerleft.origin.y = 0.044
	limb_leglowerleft.behindParent = true
	limb_leglowerleft.physicsMinAngle = -1.6
	limb_leglowerleft.physicsMaxAngle = 0
	limb_legupperleft:addChild(limb_leglowerleft)
	
--	local spr_footleft = sprites.create()
--	spr_footleft.width = 0.267
--	spr_footleft.height = 0.1275
--	spr_footleft:addTexture("characters/zombie/foot.png")
--	local limb_footleft = skeletal.createLimb("footleft",spr_footleft)
--	limb_footleft.offset.x = 0
--	limb_footleft.offset.y = 0.350
--	limb_footleft.origin.x = 0.0615
--	limb_footleft.origin.y = 0.006
--	limb_footleft.behindParent = true
--	limb_footleft.flipBehindParent = false
--	limb_footleft.physicsMinAngle = -0.5
--	limb_footleft.physicsMaxAngle = 0
--	limb_leglowerleft:addChild(limb_footleft)
	
	local spr_legupperright = sprites.create()
	spr_legupperright.width = 0.379
	spr_legupperright.height = 0.783
	spr_legupperright:addTexture("characters/zombie/legupper.png")
	local limb_legupperright = skeletal.createLimb("legupperright",spr_legupperright)
	limb_legupperright.offset.x = 0.016
	limb_legupperright.offset.y = 0.288
	limb_legupperright.origin.x = 0.185
	limb_legupperright.origin.y = 0.085
	limb_legupperright.behindParent = false
	limb_legupperright.physicsMinAngle = -0.5
	limb_legupperright.physicsMaxAngle = 1.5
	limb_legupperright.depth = 500
	limb_torso:addChild(limb_legupperright)
	
	local spr_leglowerright = sprites.create()
	spr_leglowerright.width = 0.562
	spr_leglowerright.height = 0.756
	spr_leglowerright:addTexture("characters/zombie/leglower.png")
	local limb_leglowerright = skeletal.createLimb("leglowerright",spr_leglowerright)
	limb_leglowerright.offset.x = 0
	limb_leglowerright.offset.y = 0.700
	limb_leglowerright.origin.x = 0.144
	limb_leglowerright.origin.y = 0.044
	limb_leglowerright.behindParent = false
	limb_leglowerright.physicsMinAngle = -1.6
	limb_leglowerright.physicsMaxAngle = 0
	limb_legupperright:addChild(limb_leglowerright)
	
--	local spr_footright = sprites.create()
--	spr_footright.width = 0.267
--	spr_footright.height = 0.1275
--	spr_footright:addTexture("characters/zombie/foot.png")
--	local limb_footright = skeletal.createLimb("footright",spr_footright)
--	limb_footright.offset.x = 0
--	limb_footright.offset.y = 0.350
--	limb_footright.origin.x = 0.0615
--	limb_footright.origin.y = 0.006
--	limb_footright.behindParent = true
--	limb_footright.flipBehindParent = false
--	limb_footright.physicsMinAngle = -0.5
--	limb_footright.physicsMaxAngle = 0
--	limb_leglowerright:addChild(limb_footright)
	
	local spr_armleft = sprites.create()
	spr_armleft.width = 0.111
	spr_armleft.height = 0.275
	spr_armleft:addTexture("characters/zombie/arm.png")
	local limb_armleft = skeletal.createLimb("armleft",spr_armleft)
	limb_armleft.offset.x = 0
	limb_armleft.offset.y = -0.258
	limb_armleft.origin.x = 0.055
	limb_armleft.origin.y = 0.025
	limb_armleft.behindParent = true
	limb_armleft.physicsMinAngle = -999
	limb_armleft.physicsMaxAngle = 999
	limb_armleft.depth = 1000
	limb_torso:addChild(limb_armleft)
	
	local spr_forearmleft = sprites.create()
	spr_forearmleft.width = 0.112
	spr_forearmleft.height = 0.429
	spr_forearmleft:addTexture("characters/zombie/forearm.png")
	local limb_forearmleft = skeletal.createLimb("forearmleft",spr_forearmleft)
	limb_forearmleft.offset.x = 0
	limb_forearmleft.offset.y = 0.315
	limb_forearmleft.origin.x = 0.055
	limb_forearmleft.origin.y = 0.040
	limb_forearmleft.behindParent = true
	limb_armleft:addChild(limb_forearmleft)
	
	local spr_handleft = sprites.create()
	spr_handleft.width = 0.175
	spr_handleft.height = 0.369
	spr_handleft:addTexture("characters/zombie/hand.png")
	local limb_handleft = skeletal.createLimb("handleft",spr_handleft)
	limb_handleft.offset.x = 0.000
	limb_handleft.offset.y = 0.2915
	limb_handleft.origin.x = 0.0915
	limb_handleft.origin.y = 0.0000
	limb_handleft.behindParent = true
	limb_forearmleft:addChild(limb_handleft)
	
	local spr_armright = sprites.create()
	spr_armright.width = 0.111
	spr_armright.height = 0.275
	spr_armright:addTexture("characters/zombie/arm.png")
	local limb_armright = skeletal.createLimb("armright",spr_armright)
	limb_armright.offset.x = 0
	limb_armright.offset.y = -0.258
	limb_armright.origin.x = 0.055
	limb_armright.origin.y = 0.025
	limb_armright.behindParent = false
	limb_armright.physicsMinAngle = -999
	limb_armright.physicsMaxAngle = 999
	limb_armright.depth = 1000
	limb_torso:addChild(limb_armright)
	
	local spr_forearmright = sprites.create()
	spr_forearmright.width = 0.112
	spr_forearmright.height = 0.429
	spr_forearmright:addTexture("characters/zombie/forearm.png")
	local limb_forearmright = skeletal.createLimb("forearmright",spr_forearmright)
	limb_forearmright.offset.x = 0
	limb_forearmright.offset.y = 0.315
	limb_forearmright.origin.x = 0.055
	limb_forearmright.origin.y = 0.040
	limb_forearmright.behindParent = false
	limb_armright:addChild(limb_forearmright)
	
	local spr_handright = sprites.create()
	spr_handright.width = 0.175
	spr_handright.height = 0.369
	spr_handright:addTexture("characters/zombie/hand.png")
	local limb_handright = skeletal.createLimb("handright",spr_handright)
	limb_handright.offset.x = 0.000
	limb_handright.offset.y = 0.2915
	limb_handright.origin.x = 0.0915
	limb_handright.origin.y = 0.0000
	limb_handright.behindParent = true
	limb_forearmright:addChild(limb_handright)
	
	return skel

end)
