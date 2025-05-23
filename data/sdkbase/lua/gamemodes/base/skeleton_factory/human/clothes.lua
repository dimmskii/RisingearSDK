--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

HUMAN_CLOTHES = {}

-- TOP --

HUMAN_CLOTHES.TOP_LIMB_DEPTH = -2000
HUMAN_CLOTHES.TOP_LIST_MALE = {}
HUMAN_CLOTHES.TOP_LIST_FEMALE = {}

HUMAN_CLOTHES.createTop = function()
	local top = {}
	top.niceName = "Unnamed Top"	-- TODO: Stringadactyl
	top.createLimbTorsoF = function()
		local spr = sprites.create()
		spr.width = 0.369
		spr.height = 0.660
		spr:addTexture("clothes/male/top/wifebeater/torso.png")
		local limb = skeletal.createLimb("",spr)
		limb.offset.x = 0
		limb.offset.y = 0
		limb.origin.x = 0.1845
		limb.origin.y = 0.330
		return limb
	end
	top.createLimbTorsoB = top.createLimbTorsoF -- Same front and back
	return top
end

local function registerTop( id, top, table )
	if not id then
		console.err("Top ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (table[id]) then
		console.log("Attempted to register top with pre-existing id '" .. id .. "")
		return
	end
	
	top.id = id
	table[id] = top
end

HUMAN_CLOTHES.registerTopMale = function( id, top )
	registerTop( id, top, HUMAN_CLOTHES.TOP_LIST_MALE )
end

HUMAN_CLOTHES.registerTopFemale = function( id, top )
	registerTop( id, top, HUMAN_CLOTHES.TOP_LIST_FEMALE )
end

HUMAN_CLOTHES.addTop = function( skeleton, top )
	if skeleton then
		
		local torso = skeleton:getLimb("torso")
		if torso then
			if (top.createLimbTorsoF) then
				local limb = top.createLimbTorsoF()
				if limb then
					limb:setName( "top_torso_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.TOP_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					limb.depth = 750 -- between forearm and legupper
					torso:addChild( limb )
				end
			end
			if (top.createLimbTorsoB) then
				local limb = top.createLimbTorsoB()
				if limb then
					limb:setName( "top_torso_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.TOP_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					limb.depth = 750 -- between forearm and legupper
					torso:addChild( limb )
				end
			end
		end
		
		local armleft = skeleton:getLimb("armleft")
		if armleft then
			if (top.createLimbArmLeftF) then
				local limb = top.createLimbArmLeftF()
				if limb then
					limb:setName( "top_armleft_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.TOP_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					armleft:addChild( limb )
				end
			end
			if (top.createLimbArmLeftB) then
				local limb = top.createLimbArmLeftB()
				if limb then
					limb:setName( "top_armleft_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.TOP_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					armleft:addChild( limb )
				end
			end
		end
		
		local forearmleft = skeleton:getLimb("forearmleft")
		if forearmleft then
			if (top.createLimbForearmLeftF) then
				local limb = top.createLimbForearmLeftF()
				if limb then
					limb:setName( "top_forearmleft_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.TOP_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					forearmleft:addChild( limb )
				end
			end
			if (top.createLimbForearmLeftB) then
				local limb = top.createLimbForearmLeftB()
				if limb then
					limb:setName( "top_forearmleft_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.TOP_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					forearmleft:addChild( limb )
				end
			end
		end
		
		local armright = skeleton:getLimb("armright")
		if armright then
			if (top.createLimbArmRightF) then
				local limb = top.createLimbArmRightF()
				if limb then
					limb:setName( "top_armright_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.TOP_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					armright:addChild( limb )
				end
			end
			if (top.createLimbArmRightB) then
				local limb = top.createLimbArmRightB()
				if limb then
					limb:setName( "top_armright_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.TOP_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					armright:addChild( limb )
				end
			end
		end
		
		local forearmright = skeleton:getLimb("forearmright")
		if forearmright then
			if (top.createLimbForearmRightF) then
				local limb = top.createLimbForearmRightF()
				if limb then
					limb:setName( "top_forearmright_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.TOP_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					forearmright:addChild( limb )
				end
			end
			if (top.createLimbForearmRightB) then
				local limb = top.createLimbForearmRightB()
				if limb then
					limb:setName( "top_forearmright_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.TOP_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					forearmright:addChild( limb )
				end
			end
		end
		
	end
end
		
HUMAN_CLOTHES.removeTop = function( skeleton )
	local bDetached = false
	if skeleton then
		local limbs = {
			"top_torso_f",
			"top_torso_b",
			"top_armleft_f",
			"top_armleft_b",
			"top_forearmleft_f",
			"top_forearmleft_b",
			"top_armright_f",
			"top_armright_b",
			"top_forearmright_f",
			"top_forearmright_b"
		}
		for _,v in pairs(limbs) do
			local limb = skeleton:getLimb(v)
			if limb then
				limb:detatch()
				bDetached = true
			end
		end
	end
	return bDetached
end



-- BOTTOM --

HUMAN_CLOTHES.BOTTOM_LIMB_DEPTH = -3000
HUMAN_CLOTHES.BOTTOM_LIST_MALE = {}
HUMAN_CLOTHES.BOTTOM_LIST_FEMALE = {}

HUMAN_CLOTHES.createBottom = function()
	local bottom = {}
	bottom.niceName = "Unnamed Bottom"	-- TODO: Stringadactyl
	return bottom
end

local function registerBottom( id, bottom, table )
	if not id then
		console.err("Bottom ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (table[id]) then
		console.log("Attempted to register bottom with pre-existing id '" .. id .. "")
		return
	end
	
	bottom.id = id
	table[id] = bottom
end

HUMAN_CLOTHES.registerBottomMale = function( id, bottom )
	registerBottom( id, bottom, HUMAN_CLOTHES.BOTTOM_LIST_MALE )
end

HUMAN_CLOTHES.registerBottomFemale = function( id, bottom )
	registerBottom( id, bottom, HUMAN_CLOTHES.BOTTOM_LIST_FEMALE )
end

HUMAN_CLOTHES.addBottom = function( skeleton, bottom )
	if skeleton then
		
		local torso = skeleton:getLimb("torso")
		if torso then
			if (bottom.createLimbTorsoF) then
				local limb = bottom.createLimbTorsoF()
				if limb then
					limb:setName( "bottom_torso_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.BOTTOM_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					torso:addChild( limb )
				end
			end
			if (bottom.createLimbTorsoB) then
				local limb = bottom.createLimbTorsoB()
				if limb then
					limb:setName( "bottom_torso_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.BOTTOM_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					torso:addChild( limb )
				end
			end
		end
		
		local legupperleft = skeleton:getLimb("legupperleft")
		if legupperleft then
			if (bottom.createLimbLegUpperLeftF) then
				local limb = bottom.createLimbLegUpperLeftF()
				if limb then
					limb:setName( "bottom_legupperleft_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.BOTTOM_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					legupperleft:addChild( limb )
				end
			end
			if (bottom.createLimbLegUpperLeftB) then
				local limb = bottom.createLimbLegUpperLeftB()
				if limb then
					limb:setName( "bottom_legupperleft_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.BOTTOM_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					legupperleft:addChild( limb )
				end
			end
		end
		
		local leglowerleft = skeleton:getLimb("leglowerleft")
		if leglowerleft then
			if (bottom.createLimbLegLowerLeftF) then
				local limb = bottom.createLimbLegLowerLeftF()
				if limb then
					limb:setName( "bottom_leglowerleft_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.BOTTOM_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					leglowerleft:addChild( limb )
				end
			end
			if (bottom.createLimbLegLowerLeftB) then
				local limb = bottom.createLimbLegLowerLeftB()
				if limb then
					limb:setName( "bottom_leglowerleft_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.BOTTOM_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					leglowerleft:addChild( limb )
				end
			end
		end
		
		local legupperright = skeleton:getLimb("legupperright")
		if legupperright then
			if (bottom.createLimbLegUpperRightF) then
				local limb = bottom.createLimbLegUpperRightF()
				if limb then
					limb:setName( "bottom_legupperright_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.BOTTOM_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					legupperright:addChild( limb )
				end
			end
			if (bottom.createLimbLegUpperRightB) then
				local limb = bottom.createLimbLegUpperRightB()
				if limb then
					limb:setName( "bottom_legupperright_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.BOTTOM_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					legupperright:addChild( limb )
				end
			end
		end
		
		local leglowerright = skeleton:getLimb("leglowerright")
		if leglowerright then
			if (bottom.createLimbLegLowerRightF) then
				local limb = bottom.createLimbLegLowerRightF()
				if limb then
					limb:setName( "bottom_leglowerright_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.BOTTOM_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					leglowerright:addChild( limb )
				end
			end
			if (bottom.createLimbLegLowerRightB) then
				local limb = bottom.createLimbLegLowerRightB()
				if limb then
					limb:setName( "bottom_leglowerright_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.BOTTOM_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					leglowerright:addChild( limb )
				end
			end
		end
		
	end
end
		
HUMAN_CLOTHES.removeBottom = function( skeleton )
	local bDetached = false
	if skeleton then
		local limbs = {
			"bottom_torso_f",
			"bottom_torso_b",
			"bottom_legupperleft_f",
			"bottom_legupperleft_b",
			"bottom_leglowerleft_f",
			"bottom_leglowerleft_b",
			"bottom_legupperright_f",
			"bottom_legupperright_b",
			"bottom_leglowerright_f",
			"bottom_leglowerright_b",
		}
		for _,v in pairs(limbs) do
			local limb = skeleton:getLimb(v)
			if limb then
				limb:detatch()
				bDetached = true
			end
		end
	end
	return bDetached
end


-- SHOES --

HUMAN_CLOTHES.SHOES_LIMB_DEPTH = -2000
HUMAN_CLOTHES.SHOES_LIST_MALE = {}
HUMAN_CLOTHES.SHOES_LIST_FEMALE = {}

HUMAN_CLOTHES.createShoes = function()
	local shoes = {}
	shoes.niceName = "Unnamed Shoes"	-- TODO: Stringadactyl
	return shoes
end

local function registerShoes( id, shoes, table )
	if not id then
		console.err("Shoes ID cannot be nil")
		return
	end
	
	id = tostring(id)
	
	if (table[id]) then
		console.log("Attempted to register shoes with pre-existing id '" .. id .. "")
		return
	end
	
	shoes.id = id
	table[id] = shoes
end

HUMAN_CLOTHES.registerShoesMale = function( id, shoes )
	registerShoes( id, shoes, HUMAN_CLOTHES.SHOES_LIST_MALE )
end

HUMAN_CLOTHES.registerShoesFemale = function( id, shoes )
	registerShoes( id, shoes, HUMAN_CLOTHES.SHOES_LIST_FEMALE )
end

HUMAN_CLOTHES.addShoes = function( skeleton, shoes )
	if skeleton then
		
		local armleft = skeleton:getLimb("footleft")
		if armleft then
			if (shoes.createLimbFootLeftF) then
				local limb = shoes.createLimbFootLeftF()
				if limb then
					limb:setName( "shoes_footleft_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.SHOES_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					armleft:addChild( limb )
				end
			end
			if (shoes.createLimbFootLeftB) then
				local limb = shoes.createLimbFootLeftB()
				if limb then
					limb:setName( "shoes_footleft_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.SHOES_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					armleft:addChild( limb )
				end
			end
		end
		
		local armright = skeleton:getLimb("footright")
		if armright then
			if (shoes.createLimbFootRightF) then
				local limb = shoes.createLimbFootRightF()
				if limb then
					limb:setName( "shoes_footright_f" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.SHOES_LIMB_DEPTH
					limb.behindParent = false
					limb.flipBehindParent = true
					armright:addChild( limb )
				end
			end
			if (shoes.createLimbFootRightB) then
				local limb = shoes.createLimbFootRightB()
				if limb then
					limb:setName( "shoes_footright_b" ) -- Ensure regular limb name
					limb.physicsDisabled = true -- Make sure that the limb's physics flag is disabled. This will matter during ragdoll creation.
					limb.depth = HUMAN_CLOTHES.SHOES_LIMB_DEPTH
					limb.behindParent = true
					limb.flipBehindParent = true
					armright:addChild( limb )
				end
			end
		end
		
	end
end
		
HUMAN_CLOTHES.removeShoes = function( skeleton )
	local bDetached = false
	if skeleton then
		local limbs = {
			"shoes_footleft_f",
			"shoes_footleft_b",
			"shoes_footright_f",
			"shoes_footright_b",
		}
		for _,v in pairs(limbs) do
			local limb = skeleton:getLimb(v)
			if limb then
				limb:detatch()
				bDetached = true
			end
		end
	end
	return bDetached
end

include("bottom_defaults.lua")
include("top_defaults.lua")
include("shoes_defaults.lua")
