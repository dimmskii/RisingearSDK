--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


skeleton_factory.define("male", function()

	local skel = skeletal.createSkeleton()
	
	local spr_torso = sprites.create()
	spr_torso.width = 0.369
	spr_torso.height = 0.660
	spr_torso:addTexture("characters/male/torso.png")
	local limb_torso = skeletal.createLimb("torso",spr_torso)
	limb_torso.origin.x = 0.1845
	limb_torso.origin.y = 0.330
	skel:setRoot(limb_torso)
	
	local spr_head = sprites.create()
	spr_head.width = 0.270
	spr_head.height = 0.2895
	spr_head:addTexture("characters/male/head.png")
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
	spr_legupperleft:addTexture("characters/male/legupperleft.png")
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
	spr_leglowerleft:addTexture("characters/male/leglowerleft.png")
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
	spr_footleft:addTexture("characters/male/footleft.png")
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
	spr_legupperright:addTexture("characters/male/legupperright.png")
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
	spr_leglowerright:addTexture("characters/male/leglowerright.png")
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
	spr_footright:addTexture("characters/male/footright.png")
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
	spr_armleft:addTexture("characters/male/armleft.png")
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
	spr_forearmleft:addTexture("characters/male/forearmleft.png")
	local limb_forearmleft = skeletal.createLimb("forearmleft",spr_forearmleft)
	limb_forearmleft.offset.x = 0.05
	limb_forearmleft.offset.y = 0.315
	limb_forearmleft.origin.x = 0.107
	limb_forearmleft.origin.y = 0.0915
	limb_forearmleft.behindParent = true
	limb_armleft:addChild(limb_forearmleft)
	
	local spr_handleft = sprites.create()
	spr_handleft.width = 0.183
	spr_handleft.height = 0.183
	spr_handleft:addTexture("characters/male/handleft.png")
	local limb_handleft = skeletal.createLimb("handleft",spr_handleft)
	limb_handleft.offset.x = 0.000
	limb_handleft.offset.y = 0.2315
	limb_handleft.origin.x = 0.0915
	limb_handleft.origin.y = 0.0000
	limb_handleft.behindParent = true
	limb_forearmleft:addChild(limb_handleft)
	
	local spr_armright = sprites.create()
	spr_armright.width = 0.2355
	spr_armright.height = 0.450
	spr_armright:addTexture("characters/male/armright.png")
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
	spr_forearmright:addTexture("characters/male/forearmright.png")
	local limb_forearmright = skeletal.createLimb("forearmright",spr_forearmright)
	limb_forearmright.offset.x = 0.05
	limb_forearmright.offset.y = 0.315
	limb_forearmright.origin.x = 0.107
	limb_forearmright.origin.y = 0.0915
	limb_forearmright.behindParent = false
	limb_armright:addChild(limb_forearmright)
	
	local spr_handright = sprites.create()
	spr_handright.width = 0.183
	spr_handright.height = 0.183
	spr_handright:addTexture("characters/male/handright.png")
	local limb_handright = skeletal.createLimb("handright",spr_handright)
	limb_handright.offset.x = 0.000
	limb_handright.offset.y = 0.2315
	limb_handright.origin.x = 0.0915
	limb_handright.origin.y = 0.0000
	limb_handright.behindParent = true
	limb_forearmright:addChild(limb_handright)
	
	return skel

end)

skeleton_factory.define("female", function()

	local skel = skeletal.createSkeleton()
	
	local spr_torso = sprites.create()
	spr_torso.width = 0.369
	spr_torso.height = 0.660
	spr_torso:addTexture("characters/female/torso.png")
	local limb_torso = skeletal.createLimb("torso",spr_torso)
	limb_torso.origin.x = 0.1845
	limb_torso.origin.y = 0.330
	skel:setRoot(limb_torso)
	
	local spr_head = sprites.create()
	spr_head.width = 0.270
	spr_head.height = 0.2895
	spr_head:addTexture("characters/female/head.png")
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
	spr_legupperleft:addTexture("characters/female/legupperleft.png")
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
	spr_leglowerleft:addTexture("characters/female/leglowerleft.png")
	local limb_leglowerleft = skeletal.createLimb("leglowerleft",spr_leglowerleft)
	limb_leglowerleft.offset.x = 0
	limb_leglowerleft.offset.y = 0.375
	limb_leglowerleft.origin.x = 0.102
	limb_leglowerleft.origin.y = 0.0525
	limb_leglowerleft.behindParent = true
	limb_legupperleft:addChild(limb_leglowerleft)
	
	local spr_footleft = sprites.create()
	spr_footleft.width = 0.267
	spr_footleft.height = 0.1275
	spr_footleft:addTexture("characters/female/footleft.png")
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
	spr_legupperright:addTexture("characters/female/legupperright.png")
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
	spr_leglowerright:addTexture("characters/female/leglowerright.png")
	local limb_leglowerright = skeletal.createLimb("leglowerright",spr_leglowerright)
	limb_leglowerright.offset.x = 0
	limb_leglowerright.offset.y = 0.375
	limb_leglowerright.origin.x = 0.102
	limb_leglowerright.origin.y = 0.0525
	limb_leglowerright.behindParent = false
	limb_legupperright:addChild(limb_leglowerright)
	
	local spr_footright = sprites.create()
	spr_footright.width = 0.267
	spr_footright.height = 0.1275
	spr_footright:addTexture("characters/female/footright.png")
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
	spr_armleft:addTexture("characters/female/armleft.png")
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
	spr_forearmleft:addTexture("characters/female/forearmleft.png")
	local limb_forearmleft = skeletal.createLimb("forearmleft",spr_forearmleft)
	limb_forearmleft.offset.x = 0.05
	limb_forearmleft.offset.y = 0.315
	limb_forearmleft.origin.x = 0.107
	limb_forearmleft.origin.y = 0.0915
	limb_forearmleft.behindParent = true
	limb_armleft:addChild(limb_forearmleft)
	
	local spr_handleft = sprites.create()
	spr_handleft.width = 0.183
	spr_handleft.height = 0.183
	spr_handleft:addTexture("characters/female/handleft.png")
	local limb_handleft = skeletal.createLimb("handleft",spr_handleft)
	limb_handleft.offset.x = 0.000
	limb_handleft.offset.y = 0.2315
	limb_handleft.origin.x = 0.0915
	limb_handleft.origin.y = 0.0000
	limb_handleft.behindParent = true
	limb_forearmleft:addChild(limb_handleft)
	
	local spr_armright = sprites.create()
	spr_armright.width = 0.2355
	spr_armright.height = 0.450
	spr_armright:addTexture("characters/female/armright.png")
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
	spr_forearmright:addTexture("characters/female/forearmright.png")
	local limb_forearmright = skeletal.createLimb("forearmright",spr_forearmright)
	limb_forearmright.offset.x = 0.05
	limb_forearmright.offset.y = 0.315
	limb_forearmright.origin.x = 0.107
	limb_forearmright.origin.y = 0.0915
	limb_forearmright.behindParent = false
	limb_armright:addChild(limb_forearmright)
	
	local spr_handright = sprites.create()
	spr_handright.width = 0.183
	spr_handright.height = 0.183
	spr_handright:addTexture("characters/female/handright.png")
	local limb_handright = skeletal.createLimb("handright",spr_handright)
	limb_handright.offset.x = 0.000
	limb_handright.offset.y = 0.2315
	limb_handright.origin.x = 0.0915
	limb_handright.origin.y = 0.0000
	limb_handright.behindParent = true
	limb_forearmright:addChild(limb_handright)
	
	return skel

end)

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

local anim, frame

-- biped_stand --
anim = skeletal.createAnimation()
skeleton_anims.add("biped_stand", anim)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 0)
frame:setAngleDeg("head", 0)
frame:setAngleDeg("armleft", 10)
frame:setAngleDeg("forearmleft", -20)
frame:setAngleDeg("armright", 5)
frame:setAngleDeg("forearmright", -15)
frame:setAngleDeg("legupperleft", -5)
frame:setAngleDeg("leglowerleft", 10)
frame:setAngleDeg("legupperright", 5)
frame:setAngleDeg("leglowerright", 10)

-- biped_run --
anim = skeletal.createAnimation()
skeleton_anims.add("biped_run", anim)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 8)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 18)
frame:setAngleDeg("forearmleft", -36)
frame:setAngleDeg("armright", 0)
frame:setAngleDeg("forearmright", -50)
frame:setAngleDeg("legupperleft", -30)
frame:setAngleDeg("leglowerleft", 51)
frame:setAngleDeg("legupperright", -27)
frame:setAngleDeg("leglowerright", 24)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 7.5)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 34)
frame:setAngleDeg("forearmleft", -25)
frame:setAngleDeg("armright", -26)
frame:setAngleDeg("forearmright", 0)
frame:setAngleDeg("legupperleft", -90)
frame:setAngleDeg("leglowerleft", 93)
frame:setAngleDeg("legupperright", 3)
frame:setAngleDeg("leglowerright", 15)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 7.5)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 55)
frame:setAngleDeg("forearmleft", -38)
frame:setAngleDeg("armright", -61)
frame:setAngleDeg("forearmright", 0)
frame:setAngleDeg("legupperleft", -98)
frame:setAngleDeg("leglowerleft", 78)
frame:setAngleDeg("legupperright", 9)
frame:setAngleDeg("leglowerright", 63)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3)
frame:setAngleDeg("head", -15)
frame:setAngleDeg("armleft", 79)
frame:setAngleDeg("forearmleft", -39)
frame:setAngleDeg("armright", -53)
frame:setAngleDeg("forearmright", -15)
frame:setAngleDeg("legupperleft", -77)
frame:setAngleDeg("leglowerleft", 80)
frame:setAngleDeg("legupperright", 20)
frame:setAngleDeg("leglowerright", 49)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 0)
frame:setAngleDeg("head", -3)
frame:setAngleDeg("armleft", 64)
frame:setAngleDeg("forearmleft", -36)
frame:setAngleDeg("armright", -34)
frame:setAngleDeg("forearmright", -25)
frame:setAngleDeg("legupperleft", -48)
frame:setAngleDeg("leglowerleft", 68)
frame:setAngleDeg("legupperright", 16)
frame:setAngleDeg("leglowerright", 39)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 6.5)
frame:setAngleDeg("head", -11)
frame:setAngleDeg("armleft", 31)
frame:setAngleDeg("forearmleft", -50)
frame:setAngleDeg("armright", -27)
frame:setAngleDeg("forearmright", -55)
frame:setAngleDeg("legupperleft", -39)
frame:setAngleDeg("leglowerleft", 54)
frame:setAngleDeg("legupperright", -1)
frame:setAngleDeg("leglowerright", 41)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 8)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 18)
frame:setAngleDeg("forearmright", -36)
frame:setAngleDeg("armleft", 0)
frame:setAngleDeg("forearmleft", -50)
frame:setAngleDeg("legupperright", -30)
frame:setAngleDeg("leglowerright", 51)
frame:setAngleDeg("legupperleft", -27)
frame:setAngleDeg("leglowerleft", 24)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 7.5)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 34)
frame:setAngleDeg("forearmright", -25)
frame:setAngleDeg("armleft", -26)
frame:setAngleDeg("forearmleft", 0)
frame:setAngleDeg("legupperright", -90)
frame:setAngleDeg("leglowerright", 93)
frame:setAngleDeg("legupperleft", 3)
frame:setAngleDeg("leglowerleft", 15)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 7.5)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 55)
frame:setAngleDeg("forearmright", -38)
frame:setAngleDeg("armleft", -61)
frame:setAngleDeg("forearmleft", 0)
frame:setAngleDeg("legupperright", -98)
frame:setAngleDeg("leglowerright", 78)
frame:setAngleDeg("legupperleft", 9)
frame:setAngleDeg("leglowerleft", 63)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3)
frame:setAngleDeg("head", -15)
frame:setAngleDeg("armright", 79)
frame:setAngleDeg("forearmright", -39)
frame:setAngleDeg("armleft", -53)
frame:setAngleDeg("forearmleft", -15)
frame:setAngleDeg("legupperright", -77)
frame:setAngleDeg("leglowerright", 80)
frame:setAngleDeg("legupperleft", 20)
frame:setAngleDeg("leglowerleft", 49)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 0)
frame:setAngleDeg("head", -3)
frame:setAngleDeg("armright", 64)
frame:setAngleDeg("forearmright", -36)
frame:setAngleDeg("armleft", -34)
frame:setAngleDeg("forearmleft", -25)
frame:setAngleDeg("legupperright", -48)
frame:setAngleDeg("leglowerright", 68)
frame:setAngleDeg("legupperleft", 16)
frame:setAngleDeg("leglowerleft", 39)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 6.5)
frame:setAngleDeg("head", -11)
frame:setAngleDeg("armright", 31)
frame:setAngleDeg("forearmright", -50)
frame:setAngleDeg("armleft", -27)
frame:setAngleDeg("forearmleft", -55)
frame:setAngleDeg("legupperright", -39)
frame:setAngleDeg("leglowerright", 54)
frame:setAngleDeg("legupperleft", -1)
frame:setAngleDeg("leglowerleft", 41)


-- biped_walk --
anim = skeletal.createAnimation()
skeleton_anims.add("biped_walk", anim)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 4)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 9)
frame:setAngleDeg("forearmleft", -36)
frame:setAngleDeg("armright", 0)
frame:setAngleDeg("forearmright", -50)
frame:setAngleDeg("legupperleft", -20)
frame:setAngleDeg("leglowerleft", 25)
frame:setAngleDeg("legupperright", -20)
frame:setAngleDeg("leglowerright", 12)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.75)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 17)
frame:setAngleDeg("forearmleft", -25)
frame:setAngleDeg("armright", -13)
frame:setAngleDeg("forearmright", 0)
frame:setAngleDeg("legupperleft", -40)
frame:setAngleDeg("leglowerleft", 45)
frame:setAngleDeg("legupperright", 3)
frame:setAngleDeg("leglowerright", 7.5)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.75)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 27.5)
frame:setAngleDeg("forearmleft", -38)
frame:setAngleDeg("armright", -30.5)
frame:setAngleDeg("forearmright", 0)
frame:setAngleDeg("legupperleft", -48)
frame:setAngleDeg("leglowerleft", 39)
frame:setAngleDeg("legupperright", 9)
frame:setAngleDeg("leglowerright", 30)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 1.5)
frame:setAngleDeg("head", -15)
frame:setAngleDeg("armleft", 39.5)
frame:setAngleDeg("forearmleft", -39)
frame:setAngleDeg("armright", -26.5)
frame:setAngleDeg("forearmright", -15)
frame:setAngleDeg("legupperleft", -37)
frame:setAngleDeg("leglowerleft", 40)
frame:setAngleDeg("legupperright", 20)
frame:setAngleDeg("leglowerright", 25)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 0)
frame:setAngleDeg("head", -3)
frame:setAngleDeg("armleft", 32)
frame:setAngleDeg("forearmleft", -36)
frame:setAngleDeg("armright", -17)
frame:setAngleDeg("forearmright", -25)
frame:setAngleDeg("legupperleft", -28)
frame:setAngleDeg("leglowerleft", 34)
frame:setAngleDeg("legupperright", 16)
frame:setAngleDeg("leglowerright", 19)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.25)
frame:setAngleDeg("head", -11)
frame:setAngleDeg("armleft", 15.5)
frame:setAngleDeg("forearmleft", -50)
frame:setAngleDeg("armright", -13.5)
frame:setAngleDeg("forearmright", -55)
frame:setAngleDeg("legupperleft", -19)
frame:setAngleDeg("leglowerleft", 27)
frame:setAngleDeg("legupperright", -1)
frame:setAngleDeg("leglowerright", 20)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 4)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 9)
frame:setAngleDeg("forearmright", -36)
frame:setAngleDeg("armleft", 0)
frame:setAngleDeg("forearmleft", -50)
frame:setAngleDeg("legupperright", -20)
frame:setAngleDeg("leglowerright", 25)
frame:setAngleDeg("legupperleft", -20)
frame:setAngleDeg("leglowerleft", 12)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.75)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 17)
frame:setAngleDeg("forearmright", -25)
frame:setAngleDeg("armleft", -13)
frame:setAngleDeg("forearmleft", 0)
frame:setAngleDeg("legupperright", -40)
frame:setAngleDeg("leglowerright", 45)
frame:setAngleDeg("legupperleft", 3)
frame:setAngleDeg("leglowerleft", 7.5)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.75)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 27.5)
frame:setAngleDeg("forearmright", -38)
frame:setAngleDeg("armleft", -30.5)
frame:setAngleDeg("forearmleft", 0)
frame:setAngleDeg("legupperright", -40)
frame:setAngleDeg("leglowerright", 39)
frame:setAngleDeg("legupperleft", 9)
frame:setAngleDeg("leglowerleft", 30)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 1.5)
frame:setAngleDeg("head", -15)
frame:setAngleDeg("armright", 39.5)
frame:setAngleDeg("forearmright", -39)
frame:setAngleDeg("armleft", -26.5)
frame:setAngleDeg("forearmleft", -15)
frame:setAngleDeg("legupperright", -47)
frame:setAngleDeg("leglowerright", 40)
frame:setAngleDeg("legupperleft", 20)
frame:setAngleDeg("leglowerleft", 25)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 0)
frame:setAngleDeg("head", -3)
frame:setAngleDeg("armright", 32)
frame:setAngleDeg("forearmright", -36)
frame:setAngleDeg("armleft", -17)
frame:setAngleDeg("forearmleft", -25)
frame:setAngleDeg("legupperright", -40)
frame:setAngleDeg("leglowerright", 34)
frame:setAngleDeg("legupperleft", 16)
frame:setAngleDeg("leglowerleft", 19)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.25)
frame:setAngleDeg("head", -11)
frame:setAngleDeg("armright", 15.5)
frame:setAngleDeg("forearmright", -50)
frame:setAngleDeg("armleft", -13.5)
frame:setAngleDeg("forearmleft", -55)
frame:setAngleDeg("legupperright", -39)
frame:setAngleDeg("leglowerright", 27)
frame:setAngleDeg("legupperleft", -1)
frame:setAngleDeg("leglowerleft", 20)


-- biped_march --
anim = skeletal.createAnimation()
skeleton_anims.add("biped_march", anim)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 4)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 18)
frame:setAngleDeg("forearmleft", -36)
frame:setAngleDeg("armright", 0)
frame:setAngleDeg("forearmright", -50)
frame:setAngleDeg("legupperleft", -30)
frame:setAngleDeg("leglowerleft", 25)
frame:setAngleDeg("legupperright", -27)
frame:setAngleDeg("leglowerright", 12)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.75)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 34)
frame:setAngleDeg("forearmleft", -25)
frame:setAngleDeg("armright", -26)
frame:setAngleDeg("forearmright", 0)
frame:setAngleDeg("legupperleft", -90)
frame:setAngleDeg("leglowerleft", 45)
frame:setAngleDeg("legupperright", 3)
frame:setAngleDeg("leglowerright", 7.5)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.75)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 55)
frame:setAngleDeg("forearmleft", -38)
frame:setAngleDeg("armright", -61)
frame:setAngleDeg("forearmright", 0)
frame:setAngleDeg("legupperleft", -98)
frame:setAngleDeg("leglowerleft", 39)
frame:setAngleDeg("legupperright", 9)
frame:setAngleDeg("leglowerright", 30)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 1.5)
frame:setAngleDeg("head", -15)
frame:setAngleDeg("armleft", 79)
frame:setAngleDeg("forearmleft", -39)
frame:setAngleDeg("armright", -53)
frame:setAngleDeg("forearmright", -15)
frame:setAngleDeg("legupperleft", -77)
frame:setAngleDeg("leglowerleft", 40)
frame:setAngleDeg("legupperright", 20)
frame:setAngleDeg("leglowerright", 25)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 0)
frame:setAngleDeg("head", -3)
frame:setAngleDeg("armleft", 64)
frame:setAngleDeg("forearmleft", -36)
frame:setAngleDeg("armright", -34)
frame:setAngleDeg("forearmright", -25)
frame:setAngleDeg("legupperleft", -48)
frame:setAngleDeg("leglowerleft", 34)
frame:setAngleDeg("legupperright", 16)
frame:setAngleDeg("leglowerright", 19)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.25)
frame:setAngleDeg("head", -11)
frame:setAngleDeg("armleft", 31)
frame:setAngleDeg("forearmleft", -50)
frame:setAngleDeg("armright", -27)
frame:setAngleDeg("forearmright", -55)
frame:setAngleDeg("legupperleft", -39)
frame:setAngleDeg("leglowerleft", 27)
frame:setAngleDeg("legupperright", -1)
frame:setAngleDeg("leglowerright", 20)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 4)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 18)
frame:setAngleDeg("forearmright", -36)
frame:setAngleDeg("armleft", 0)
frame:setAngleDeg("forearmleft", -50)
frame:setAngleDeg("legupperright", -30)
frame:setAngleDeg("leglowerright", 25)
frame:setAngleDeg("legupperleft", -27)
frame:setAngleDeg("leglowerleft", 12)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.75)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 34)
frame:setAngleDeg("forearmright", -25)
frame:setAngleDeg("armleft", -26)
frame:setAngleDeg("forearmleft", 0)
frame:setAngleDeg("legupperright", -90)
frame:setAngleDeg("leglowerright", 45)
frame:setAngleDeg("legupperleft", 3)
frame:setAngleDeg("leglowerleft", 7.5)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.75)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 55)
frame:setAngleDeg("forearmright", -38)
frame:setAngleDeg("armleft", -61)
frame:setAngleDeg("forearmleft", 0)
frame:setAngleDeg("legupperright", -98)
frame:setAngleDeg("leglowerright", 39)
frame:setAngleDeg("legupperleft", 9)
frame:setAngleDeg("leglowerleft", 30)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 1.5)
frame:setAngleDeg("head", -15)
frame:setAngleDeg("armright", 79)
frame:setAngleDeg("forearmright", -39)
frame:setAngleDeg("armleft", -53)
frame:setAngleDeg("forearmleft", -15)
frame:setAngleDeg("legupperright", -77)
frame:setAngleDeg("leglowerright", 40)
frame:setAngleDeg("legupperleft", 20)
frame:setAngleDeg("leglowerleft", 25)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 0)
frame:setAngleDeg("head", -3)
frame:setAngleDeg("armright", 64)
frame:setAngleDeg("forearmright", -36)
frame:setAngleDeg("armleft", -34)
frame:setAngleDeg("forearmleft", -25)
frame:setAngleDeg("legupperright", -48)
frame:setAngleDeg("leglowerright", 34)
frame:setAngleDeg("legupperleft", 16)
frame:setAngleDeg("leglowerleft", 19)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.25)
frame:setAngleDeg("head", -11)
frame:setAngleDeg("armright", 31)
frame:setAngleDeg("forearmright", -50)
frame:setAngleDeg("armleft", -27)
frame:setAngleDeg("forearmleft", -55)
frame:setAngleDeg("legupperright", -39)
frame:setAngleDeg("leglowerright", 27)
frame:setAngleDeg("legupperleft", -1)
frame:setAngleDeg("leglowerleft", 20)

-- biped_backpedal --
anim = skeletal.createAnimation()
skeleton_anims.add("biped_backpedal", anim)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 4)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 18)
frame:setAngleDeg("forearmleft", -36)
frame:setAngleDeg("armright", 0)
frame:setAngleDeg("forearmright", -50)
frame:setAngleDeg("legupperleft", -30)
frame:setAngleDeg("leglowerleft", 51)
frame:setAngleDeg("legupperright", -27)
frame:setAngleDeg("leglowerright", 24)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.5)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 34)
frame:setAngleDeg("forearmleft", -25)
frame:setAngleDeg("armright", -26)
frame:setAngleDeg("forearmright", 0)
frame:setAngleDeg("legupperleft", -90)
frame:setAngleDeg("leglowerleft", 93)
frame:setAngleDeg("legupperright", 3)
frame:setAngleDeg("leglowerright", 15)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.5)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armleft", 55)
frame:setAngleDeg("forearmleft", -38)
frame:setAngleDeg("armright", -61)
frame:setAngleDeg("forearmright", 0)
frame:setAngleDeg("legupperleft", -98)
frame:setAngleDeg("leglowerleft", 78)
frame:setAngleDeg("legupperright", 9)
frame:setAngleDeg("leglowerright", 63)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", -1)
frame:setAngleDeg("head", -15)
frame:setAngleDeg("armleft", 79)
frame:setAngleDeg("forearmleft", -39)
frame:setAngleDeg("armright", -53)
frame:setAngleDeg("forearmright", -15)
frame:setAngleDeg("legupperleft", -77)
frame:setAngleDeg("leglowerleft", 80)
frame:setAngleDeg("legupperright", 20)
frame:setAngleDeg("leglowerright", 49)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", -4)
frame:setAngleDeg("head", -3)
frame:setAngleDeg("armleft", 64)
frame:setAngleDeg("forearmleft", -36)
frame:setAngleDeg("armright", -34)
frame:setAngleDeg("forearmright", -25)
frame:setAngleDeg("legupperleft", -48)
frame:setAngleDeg("leglowerleft", 68)
frame:setAngleDeg("legupperright", 16)
frame:setAngleDeg("leglowerright", 39)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 2.5)
frame:setAngleDeg("head", -11)
frame:setAngleDeg("armleft", 31)
frame:setAngleDeg("forearmleft", -50)
frame:setAngleDeg("armright", -27)
frame:setAngleDeg("forearmright", -55)
frame:setAngleDeg("legupperleft", -39)
frame:setAngleDeg("leglowerleft", 54)
frame:setAngleDeg("legupperright", -1)
frame:setAngleDeg("leglowerright", 41)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 4)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 18)
frame:setAngleDeg("forearmright", -36)
frame:setAngleDeg("armleft", 0)
frame:setAngleDeg("forearmleft", -50)
frame:setAngleDeg("legupperright", -30)
frame:setAngleDeg("leglowerright", 51)
frame:setAngleDeg("legupperleft", -27)
frame:setAngleDeg("leglowerleft", 24)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.5)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 34)
frame:setAngleDeg("forearmright", -25)
frame:setAngleDeg("armleft", -26)
frame:setAngleDeg("forearmleft", 0)
frame:setAngleDeg("legupperright", -90)
frame:setAngleDeg("leglowerright", 93)
frame:setAngleDeg("legupperleft", 3)
frame:setAngleDeg("leglowerleft", 15)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.5)
frame:setAngleDeg("head", -12)
frame:setAngleDeg("armright", 55)
frame:setAngleDeg("forearmright", -38)
frame:setAngleDeg("armleft", -61)
frame:setAngleDeg("forearmleft", 0)
frame:setAngleDeg("legupperright", -98)
frame:setAngleDeg("leglowerright", 78)
frame:setAngleDeg("legupperleft", 9)
frame:setAngleDeg("leglowerleft", 63)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", -1)
frame:setAngleDeg("head", -15)
frame:setAngleDeg("armright", 79)
frame:setAngleDeg("forearmright", -39)
frame:setAngleDeg("armleft", -53)
frame:setAngleDeg("forearmleft", -15)
frame:setAngleDeg("legupperright", -77)
frame:setAngleDeg("leglowerright", 80)
frame:setAngleDeg("legupperleft", 20)
frame:setAngleDeg("leglowerleft", 49)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", -4)
frame:setAngleDeg("head", -3)
frame:setAngleDeg("armright", 64)
frame:setAngleDeg("forearmright", -36)
frame:setAngleDeg("armleft", -34)
frame:setAngleDeg("forearmleft", -25)
frame:setAngleDeg("legupperright", -48)
frame:setAngleDeg("leglowerright", 68)
frame:setAngleDeg("legupperleft", 16)
frame:setAngleDeg("leglowerleft", 39)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 3.5)
frame:setAngleDeg("head", -11)
frame:setAngleDeg("armright", 31)
frame:setAngleDeg("forearmright", -50)
frame:setAngleDeg("armleft", -27)
frame:setAngleDeg("forearmleft", -55)
frame:setAngleDeg("legupperright", -39)
frame:setAngleDeg("leglowerright", 54)
frame:setAngleDeg("legupperleft", -1)
frame:setAngleDeg("leglowerleft", 41)

-- biped_crouch --
anim = skeletal.createAnimation()
skeleton_anims.add("biped_crouch", anim)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setDataDeg("torso", 0, geom.vec2(0,0))
frame:setAngleDeg("head", 0)
frame:setAngleDeg("armleft", 0)
frame:setAngleDeg("forearmleft", 0)
frame:setAngleDeg("armright", 0)
frame:setAngleDeg("forearmright", 0)
frame:setAngleDeg("legupperleft", 0)
frame:setAngleDeg("leglowerleft", 0)
frame:setAngleDeg("legupperright", 0)
frame:setAngleDeg("leglowerright", 0)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setDataDeg("torso", 0, geom.vec2(0,0.5))
frame:setDataDeg("head", -12)
frame:setAngleDeg("armleft", 34)
frame:setAngleDeg("forearmleft", -25)
frame:setAngleDeg("armright", -26)
frame:setAngleDeg("forearmright", 0)
frame:setAngleDeg("legupperleft", 10)
frame:setAngleDeg("leglowerleft", 103)
frame:setAngleDeg("legupperright", -100)
frame:setAngleDeg("leglowerright", 80)

-- biped_reload --
anim = skeletal.createAnimation()
skeleton_anims.add("biped_reload", anim)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("armleft", 0)
frame:setAngleDeg("forearmleft", -75)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("armleft", -105)
frame:setAngleDeg("forearmleft", -25)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("armleft", -60)
frame:setAngleDeg("forearmleft", -105)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("armleft", -105)
frame:setAngleDeg("forearmleft", -25)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("armleft", -60)
frame:setAngleDeg("forearmleft", -105)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("armleft", 0)
frame:setAngleDeg("forearmleft", 0)


-- biped_climb --
anim = skeletal.createAnimation()
skeleton_anims.add("biped_climb", anim)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 0)
frame:setAngleDeg("head", 0)
frame:setAngleDeg("armleft", -10)
frame:setAngleDeg("forearmleft", -170)
frame:setAngleDeg("armright", -100)
frame:setAngleDeg("forearmright", -65)
frame:setAngleDeg("legupperleft", -110)
frame:setAngleDeg("leglowerleft", 120)
frame:setAngleDeg("legupperright", -15)
frame:setAngleDeg("leglowerright", 15)
frame = skeletal.createAnimFrame() anim:append(frame)
frame:setAngleDeg("torso", 0)
frame:setAngleDeg("head", 0)
frame:setAngleDeg("armleft", -100)
frame:setAngleDeg("forearmleft", -65)
frame:setAngleDeg("armright", -10)
frame:setAngleDeg("forearmright", -170)
frame:setAngleDeg("legupperleft", -15)
frame:setAngleDeg("leglowerleft", 15)
frame:setAngleDeg("legupperright", -110)
frame:setAngleDeg("leglowerright", 120)

include("human_features.lua")
include("clothes.lua")