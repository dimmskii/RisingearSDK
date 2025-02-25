--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


props = {}

props.COLLISION_BOX = 0
props.COLLISION_CIRCLE = 1
props.COLLISION_SPRITE = 2
props.COLLISION_ELLIPSE = 3
props.COLLISION_ROUNDED_RECTANGLE = 4 -- TODO: Check if this even works. I think it's geborked

local DEFINITIONS = {}

props.getDefinitionIndex = function(def)
	return def.index
end

props.getDefinitionByIndex = function(index)
	return DEFINITIONS[index]
end

props.getDefinitions = function() return DEFINITIONS end

props.addDefinition = function(name, texture, width, height, collision, material, onSpawn)
	local def = {}
	def.name = name
	def.texture = texture
	def.width = width
	def.height = height
	def.collision = collision
	def.material = material
	
	if (onSpawn == nil) then def.onSpawn = function( ent ) end else def.onSpawn = onSpawn end
	
	-- Generate the index integer
	def.index = #DEFINITIONS + 1
	
	-- Add it to the definitions list
	DEFINITIONS[def.index] = def
	
	return def
end

props.createSprite = function(def)
	local sprite = sprites.create()
	sprite.width = def.width
	sprite.height = def.height
	
	sprite:setPlaying(false)
	
	sprite:addTexture(def.texture)
	
	return sprite
end


-- Define some default props
props.addDefinition("Wooden Crate 1", "props/crates/cratewood01.png", 0.75, 0.75, props.COLLISION_BOX, "wood") -- TODO stringadactyl
props.addDefinition("Car Wheel", "props/wheel01.png", 0.75, 0.75, props.COLLISION_CIRCLE, "rubber_tyre") -- TODO stringadactyl
props.addDefinition("Banana", "props/food/banana.png", 0.30, 0.30, props.COLLISION_SPRITE, "flesh") -- TODO stringadactyl
props.addDefinition("Orange", "props/food/orange.png", 0.10, 0.10, props.COLLISION_SPRITE, "flesh") -- TODO stringadactyl
props.addDefinition("Pineapple", "props/food/pineapple.png", 0.166, 0.4, props.COLLISION_SPRITE, "flesh") -- TODO stringadactyl
props.addDefinition("Linushead", "props/test/linus.png", 3, 3, geom.polygon(geom.vec2(0.843,0.155),  geom.vec2(1.478,0.182),  geom.vec2(1.845,0.084),  geom.vec2(2.403,0.177),  geom.vec2(2.370,0.363),  geom.vec2(2.649,0.478),  geom.vec2(2.890,1.135),  geom.vec2(2.857,1.594),  geom.vec2(2.978,1.696),  geom.vec2(2.797,2.290),  geom.vec2(2.688,2.306),  geom.vec2(2.496,2.755),  geom.vec2(2.469,2.963), geom.vec2(0.224,2.963),  geom.vec2(0.345,2.519),  geom.vec2(0.274,2.131),  geom.vec2(0.109,2.082),  geom.vec2(0.016,1.611),  geom.vec2(0.159,1.430),  geom.vec2(0.301,0.779),  geom.vec2(0.640,0.374),  geom.vec2(0.651,0.220)), "metal") -- TODO stringadactyl
props.addDefinition("Metal Crate 1", "props/crates/cratemetal01.png", 0.9, 0.9, props.COLLISION_BOX, "metal") -- TODO stringadactyl
props.addDefinition("Basketball", "props/basketball.png", 0.2426, 0.2426, props.COLLISION_CIRCLE, "bouncy_ball") -- TODO stringadactyl
props.addDefinition("Metal Barrel 1", "props/metalbarrel01.png", 0.693, 1.1, props.COLLISION_BOX, "metal_hollow") -- TODO stringadactyl
