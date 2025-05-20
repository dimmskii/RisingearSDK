--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ENT.def_health = 100

ENT.def_female = false
ENT.def_aiClass = ""
ENT.def_weaponClass = ""

ENT.def_skinColor = color.fromRGBf(0.9,0.8,0)
ENT.def_hair = "afro"
ENT.def_hairColor = color.BLACK
ENT.def_facialHair = ""
ENT.def_facialHairColor = color.BLACK
ENT.def_eyes = "virgil"
ENT.def_eyeColor = color.CYAN
ENT.def_eyebrows = "virgil"
ENT.def_eyebrowColor = color.BLACK

ENT.def_top = "wifebeater"
ENT.def_bottom = "trkblack"
ENT.def_shoes = "bootscamo"

ENT.def_dropWeapon = false

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	self.female = self.def_female
	self.aiClass = self.def_aiClass
	self.health = self.def_health
	ENT_BASE.initialize( self )
end

function ENT:initHumanFeatures()
	self.skinColor = self.def_skinColor
	self.hair = self.def_hair
	self.hairColor = self.def_hairColor
	self.facialHair = self.def_facialHair
	self.facialHairColor = self.def_facialHairColor
	self.eyes = self.def_eyes
	self.eyeColor = self.def_eyeColor
	self.eyebrows = self.def_eyebrows
	self.eyebrowColor = self.def_eyebrowColor

	ENT_BASE.initHumanFeatures( self )
end

function ENT:initHumanClothes()
	self.top = self.def_top
	self.bottom = self.def_bottom
	self.shoes = self.def_shoes
	
	ENT_BASE.initHumanClothes( self )
end

if SERVER then
	function ENT:sv_initialize()
		ENT_BASE.sv_initialize( self )
		
		for k,v in pairs(ammo) do
			self.ammo[k] = 999999
		end
		
		if not EDITOR and string.len(self.def_weaponClass) > 0 then
			local entWeapon = ents.create(self.def_weaponClass, false)
			entWeapon:setPosition( self.position.x, self.position.y )
			ents.initialize( entWeapon )
			entWeapon:use( self )
		end
	end
	
	function ENT:dropWeapon()
		if self.def_dropWeapon then
			ENT_BASE.dropWeapon( self )
		end
	end
end
