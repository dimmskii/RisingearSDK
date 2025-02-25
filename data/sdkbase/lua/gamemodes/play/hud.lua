--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local function processHUDMessage(sender, data)
	if not CLIENT then return end
	localClient().health = data:readNext()
	localClient().clip = data:readNext()
	localClient().ammo = data:readNext()
end

local HUDMessage = net.registerMessage("hudinfo", processHUDMessage)

if (CLIENT) then
	
	local scrW = display.getWidth()
	local scrH = display.getHeight()
	
	local cam = camera.getCurrent()
	
	local backdropColor = color.fromRGBAf(0,0,0,0.35)
	local useTextColor = color.WHITE
	local counterColor = color.fromRGBi(255,240,80)
	
	local useTargetOutline = renderables.fromShape(geom.circle(0,0,1))
	useTargetOutline:setVisible(false)
	useTargetOutline:setLayer(renderables.LAYER_POST_GAME)
	useTargetOutline.outlineWidth = 2
	useTargetOutline.outlineColor = color.fromRGBAf(1,1,1,0.4)
	renderables.add(useTargetOutline)
	
	local useFont = font_sprite.create()
	useFont:addTexture("hud/font_plain32x64_ascii.png")
	useFont:setCharSequence(font_sprite.CHARSEQ_ASCII)
	useFont.cellWidth = 32
	useFont.cellHeight = 64
	useFont.cellNumX = 16
	useFont.cellNumY = 6
	useFont.frameNum = 96
	useFont.color = useTextColor
	
	local hpFont = font_sprite.create()
	hpFont:addTexture("hud/font_num01.png")
	hpFont:setCharSequence("1234567890-%")
	hpFont.cellWidth = 32
	hpFont.cellHeight = 48
	hpFont.cellNumX = 4
	hpFont.cellNumY = 3
	hpFont.frameNum = 12
	hpFont.color = counterColor
	
	local ammoFont = font_sprite.create()
	ammoFont:addTexture("hud/font_num01.png")
	ammoFont:setCharSequence("1234567890-%")
	ammoFont.cellWidth = 32
	ammoFont.cellHeight = 48
	ammoFont.cellNumX = 4
	ammoFont.cellNumY = 3
	ammoFont.frameNum = 12
	ammoFont.color = counterColor
	
	local useText = renderables.fromFontSprite(useFont)
	useText:setLayer(renderables.LAYER_HUD)
	useText.text = ""
	useText:setVisible(true)
	renderables.add(useText)
	
	local hpRect = geom.roundedRectangle(1,1,1,1,8)
	local hpBackdrop = renderables.fromShape(hpRect)
	hpBackdrop.outlineColor = color.fromRGBAf(0,0,0,0) -- TODO: color.TRANSPARENT missing from API?   o.0
	hpBackdrop.fillColor = backdropColor
	hpBackdrop:setLayer(renderables.LAYER_HUD)
	hpBackdrop:setVisible(true)
	renderables.add(hpBackdrop)
	local hpGlyphSpr = sprites.create()
	hpGlyphSpr:addTexture(textures.get("hud/glyph_health.png"))
	hpGlyphSpr.color = counterColor
	local hpGlyph = renderables.fromSprite(hpGlyphSpr)
	hpGlyph:setLayer(renderables.LAYER_HUD)
	hpGlyph:setVisible(true)
	renderables.add(hpGlyph)
	local hpText = renderables.fromFontSprite(hpFont)
	hpText:setLayer(renderables.LAYER_HUD)
	hpText.text = ""
	hpText:setVisible(true)
	renderables.add(hpText)
	
	local ammoRect = geom.roundedRectangle(1,1,1,1,8)
	local ammoBackdrop = renderables.fromShape(ammoRect)
	ammoBackdrop.outlineColor = color.fromRGBAf(0,0,0,0) -- TODO: color.TRANSPARENT missing from API?   o.0
	ammoBackdrop.fillColor = backdropColor
	ammoBackdrop:setLayer(renderables.LAYER_HUD)
	ammoBackdrop:setVisible(true)
	renderables.add(ammoBackdrop)
	local ammoGlyphSpr = sprites.create()
	ammoGlyphSpr:addTexture(textures.get("hud/glyph_ammo.png"))
	ammoGlyphSpr.color = counterColor
	local ammoGlyph = renderables.fromSprite(ammoGlyphSpr)
	ammoGlyph:setLayer(renderables.LAYER_HUD)
	ammoGlyph:setVisible(true)
	renderables.add(ammoGlyph)
	local clipText = renderables.fromFontSprite(ammoFont)
	clipText:setLayer(renderables.LAYER_HUD)
	clipText.text = ""
	clipText:setVisible(true)
	renderables.add(clipText)
	local ammoText = renderables.fromFontSprite(ammoFont)
	ammoText:setLayer(renderables.LAYER_HUD)
	ammoText.text = ""
	ammoText:setVisible(true)
	renderables.add(ammoText)
	
	local margin = scrW * 0.0025
	
	local function updateCalcs()
		scrW = display.getWidth()
		scrH = display.getHeight()
		
		cam = camera.getCurrent()
		
		margin = scrW * 0.0025
		
		ammoRect:setWidth(scrW / 9)
		ammoRect:setHeight(ammoRect:getWidth() * 0.4)
		ammoRect:setX(scrW - ammoRect:getWidth() - margin)
		ammoRect:setY(scrH - ammoRect:getHeight() - margin)
		clipText.size = scrH * 0.05 -- TODO: sounds like a work for superheroes name't DPI!
		ammoGlyphSpr.width = clipText.size
		ammoGlyphSpr.height = clipText.size
		ammoGlyphSpr.position.x = ammoRect:getX() + (ammoRect:getWidth() * 0.1)
		ammoGlyphSpr.position.y = ammoRect:getY() + (ammoRect:getHeight() * 0.5 - clipText.size * 0.5)
		clipText.position.x = ammoRect:getX() + (ammoRect:getWidth() * 0.35)
		clipText.position.y = ammoRect:getY() + (ammoRect:getHeight() * 0.5 - clipText.size * 0.45)
		
		ammoText.size = scrH * 0.03 -- TODO: sounds like a work for superheroes name't DPI!
		ammoText.position.x = ammoRect:getX() + (ammoRect:getWidth() * 0.70)
		ammoText.position.y = clipText.position.y
		
		hpRect:setWidth(scrW / 9)
		hpRect:setHeight(hpRect:getWidth() * 0.4)
		hpRect:setX(scrW - hpRect:getWidth() - ammoRect:getWidth() - margin * 2)
		hpRect:setY(scrH - hpRect:getHeight() - margin)
		hpText.size = scrH * 0.05 -- TODO: sounds like a work for superheroes name't DPI!
		hpGlyphSpr.width = hpText.size
		hpGlyphSpr.height = hpText.size
		hpGlyphSpr.position.x = hpRect:getX() + (hpRect:getWidth() * 0.1)
		hpGlyphSpr.position.y = hpRect:getY() + (hpRect:getHeight() * 0.5 - hpText.size * 0.5)
		hpText.position.x = hpRect:getX() + (hpRect:getWidth() * 0.35)
		hpText.position.y = hpRect:getY() + (hpRect:getHeight() * 0.5 - hpText.size * 0.45)
		
	end
	
	updateCalcs()
	hook.add("onVideoRestart", "gui_onVideoRestart", updateCalcs)
	
	local function onUpdate()
		updateCalcs()
		local lc = localClient()
		
		hpText.text = lc.health
		hpGlyph:setVisible(true)
		hpBackdrop:setVisible(true)
		
		clipText.text = lc.clip
		ammoText.text = lc.ammo
		ammoBackdrop:setVisible(true)
		ammoGlyph:setVisible(true)
		
		if (lc.ammo == nil or lc.ammo < 0) then
			ammoText.text = ""
			if (lc.clip == nil or lc.clip < 0) then
				clipText.text = ""
				ammoBackdrop:setVisible(false)
				ammoGlyph:setVisible(false)
				
				if (lc.health == nil or lc.health < 0) then
					hpText.text = ""
					hpGlyph:setVisible(false)
					hpBackdrop:setVisible(false)
				end
			end
		end
		
		local clientEnt = lc.ent
		if (clientEnt) then
			if (clientEnt.useTarget) then
				local shp = clientEnt.useTarget:getOutlineShape()
				useTargetOutline:setShape(geom.rectangle(shp:getMinX(), shp:getMinY(), shp:getMaxX()-shp:getMinX(), shp:getMaxY()-shp:getMinY()))
				--local maxRadius = math.max( shp:getMaxX() - shp:getMinX(), shp:getMaxY() - shp:getMinY() ) / 2
				--useTargetOutline:setShape(geom.circle(shp:getCenterX(),shp:getCenterY(),maxRadius))
				useTargetOutline:setVisible(true)
				
				-- TODO: ew
				useText.size = scrH * 0.025 -- TODO: sounds like a work for superheroes name't DPI!
				useText.position = geom.vec2(  (shp:getCenterX() - cam:getX() + cam:getWidth()/2) / cam:getWidth() * scrW  ,  (shp:getCenterY()  - cam:getY()  + cam:getHeight()/2)  / cam:getHeight() * scrH)
				useText.text = "USE KEY: " .. clientEnt.useTarget:getUseText() -- TODO stringadactyl
			
			else
				useTargetOutline:setVisible(false)
				useText.text = ""
			end
		end
	end
	hook.add("update", "gui_onUpdate", onUpdate)
end
if (SERVER) then
	local function onNetworkTick()
		-- send clients the info to display on hud
		for k,client in pairs(net.getClients()) do
			local iHealth = -1
			local iClip = -1
			local iAmmo = -1
			if ( client.ent and ents.isClass(client.ent,"char_base",true) ) then
				iHealth = client.ent.health
				if client.ent.weapon then
					iClip = client.ent.weapon.ammo
					iAmmo = client.ent:getAmmo(client.ent.weapon.ammoType)
				end
			end
			
			local data = net.data()
			data:writeShort(iHealth)
			data:writeShort(iClip)
			data:writeShort(iAmmo)
			net.sendMessage(HUDMessage, data, client)
			
		end
	end
	
	hook.add("networkTick", "hud_onNetworkTick", onNetworkTick)
end