--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT.def_health = 45

ENT.def_female = false
ENT.def_aiClass = "ai_enemy"
ENT.def_weaponClass = "weapon_syringe"

ENT.def_skinColor = color.fromRGBi(143,205,41)
ENT.def_hair = ""
ENT.def_hairColor = color.BLACK
ENT.def_facialHair = ""
ENT.def_facialHairColor = color.BLACK
ENT.def_eyes = ""
ENT.def_eyeColor = color.GREEN
ENT.def_eyebrows = "virgil"
ENT.def_eyebrowColor = color.BLACK

ENT.def_top = ""
ENT.def_bottom = ""
ENT.def_shoes = ""


-- Allow placement in editor
if (EDITOR) then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	ENT_BASE.initialize(self)
	--self.CLASSNAME = "npc_rept"
end

function ENT:initSkeletal() -- override method from char_human
	self.skeleton = skeleton_factory.create("rept01")
	self.skeleton:setAnimation(skeleton_anims.get("biped_stand"))
end

--function ENT:initHumanFeatures()
--	
--
--	ENT_BASE.initHumanFeatures( self )
--	
--	local spr = sprites.create()
--	spr.width = 0.270
--	spr.height = 0.2895
--	spr:addTexture("clothes/male/face/covidmask.png")
--	spr.color = color.WHITE
--	local limb = skeletal.createLimb("faceacc_head_f",spr)
--	limb.offset.x = -0.135
--	limb.offset.y = -0.2895
--	limb.origin.x = 0.0
--	limb.origin.y = 0.0
--	limb.behindParent = false
--	limb.flipBehindParent = false
--	limb.physicsDisabled = true
--	 
--	self.skeleton:getLimb("head"):addChild(limb)
--	
--	spr = sprites.create()
--	spr.width = 0.330
--	spr.height = 0.36
--	spr:addTexture("clothes/male/hat/surgeon.png")
--	spr.color = color.WHITE
--	limb = skeletal.createLimb("hat_head_f",spr)
--	limb.offset.x = -0.195
--	limb.offset.y = -0.36
--	limb.origin.x = 0.0
--	limb.origin.y = 0.0
--	limb.behindParent = false
--	limb.flipBehindParent = false
--	limb.physicsDisabled = true
--	 
--	self.skeleton:getLimb("head"):addChild(limb)
--	
----		spr_head.width = 0.270
----	spr_head.height = 0.2895
----	spr_head:addTexture("characters/male/head.png")
----	local limb_head = skeletal.createLimb("head",spr_head)
----	limb_head.offset.x = 0
----	limb_head.offset.y = -0.330
----	limb_head.origin.x = 0.135
----	limb_head.origin.y = 0.2895
--end

