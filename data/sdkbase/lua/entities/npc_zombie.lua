--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT_META.CLASSNAME_BASE = "npc_human_base"

ENT.def_health = 45

ENT.def_female = false
ENT.def_aiClass = "ai_enemy"
ENT.def_weaponClass = "weapon_crowbar"

ENT.def_skinColor = color.fromRGBi(255,255,128)
ENT.def_hair = ""
ENT.def_hairColor = color.BLACK
ENT.def_facialHair = ""
ENT.def_facialHairColor = color.BLACK
ENT.def_eyes = ""
ENT.def_eyeColor = color.WHITE
ENT.def_eyebrows = ""
ENT.def_eyebrowColor = color.WHITE

ENT.def_top = ""
ENT.def_bottom = ""
ENT.def_shoes = ""

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

if SERVER then
	ENT.bbox_top = geom.rectangle(-0.3, -0.65, 0.6, 0.65)
	ENT.bbox_mid = geom.rectangle(-0.3, 0, 0.6, 1.6)
	ENT.bbox_feet = geom.rectangle(-0.25, 1.6, 0.5, 0.1)
elseif CLIENT then
	function ENT:cl_initialize()
		ENT_BASE.cl_initialize(self)
		
		self.pulseCol = color.fromHexString("#ff6611")
		
		-- Add glow to head as cloned limb (eugh)
		local rendSkeleton = self.renderable
		local limbHead = rendSkeleton:getSkeleton():getLimb("head")
		local limbLight = limbHead:clone()
		limbLight:detatch()
		limbLight:setName("head_light")
		limbLight.offset = geom.vec2() -- reset its offset
		limbLight:getSprite():setTexture("characters/zombie/head_lightmask.png")
		limbLight:getSprite():setColor(self.pulseCol)
		limbHead:addChild(limbLight)
		rendSkeleton:updateFromSkeleton()
		rendSkeleton:getLimbRenderableByName("head_light"):setLightMode(renderables.LIGHT_EMIT) -- TODO: this doesn't work unless you set it on entire composite renderable
		
		-- Create lightmap renderable
		local rendLight = renderables.fromSprite(limbLight:getSprite())
		rendLight:setLightMode(renderables.LIGHT_EMIT)
--		-- Create composite renderable out of limb and skeleton
--		local rendComposite = renderables.composite(rendSkeleton,rendLight)
--		
--		-- Remove superclasses SkeletonRenderable and replace it with new composite renderable
--		renderables.remove(rendSkeleton)
--		renderables.add(rendComposite)
--		
--		-- Update reference
--		self.renderable = rendComposite
--		
		renderables.add(rendLight)
		
		self.accum = 0
	end
	function ENT:cl_think( delta )
		ENT_BASE.cl_think(self, delta)
		
		if self:isAlive() then
			self.accum = self.accum + delta
			self.pulseCol:setAf(math.abs(math.sin(self.accum * 4)))
		else
		self.pulseCol:setAf(0)
		end
	end
end

-- Allow placement in editor
if (EDITOR) then
	ENT.editor_placementType = EDITOR.PLACEMENT_TYPE_POINT
end
local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)


function ENT:initSkeletal() -- override method from char_human
	self.skeleton = skeleton_factory.create("zombie")
	self.skeleton:setAnimation(skeleton_anims.get("biped_stand"))
end

