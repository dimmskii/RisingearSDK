--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.amountArmor = 0
ENT.amountHealth = 0

if CLIENT then
	ENT.pickupSound = audio.sound("pickups/item_health_m.wav")
end

function ENT:createSprite()
	local spr = ENT_BASE.createSprite( self )
	if self.flashTexture then
		spr:addTexture(self.flashTexture)
		spr.frameNum = 2
		spr.frameDelay = 150
		spr:setAnimationToFullLength()
		spr:setPlaying(true)
	end
	spr:centerOrigin()
	return spr
end

local quarter_pi = math.pi/4
local half_pi = math.pi/2
function ENT:updateSprite( delta )
	self.sprite:setPlaying(true)
	self.sprite.position.x = self.position.x
	self.sprite.position.y = self.position.y
	self.sprite.angle = (self.angle + quarter_pi) % half_pi - quarter_pi -- keep upright by alwayts flipping the square right-side-up
	self.sprite:update( delta )
	self.sprite:setPlaying(true)
end

if SERVER then
	include("sv_init.lua")
end