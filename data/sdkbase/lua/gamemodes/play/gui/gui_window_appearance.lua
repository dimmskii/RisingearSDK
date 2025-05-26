--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local function applyAppearanceReceived( sender, data )
	if CLIENT then return end -- Clients don't.
	--local ent = ents.findByID(data:readNext())
	--if (ent and ent.editor_receiveProperties) then
	--	ent:editor_receiveProperties(data)
	--end
	local receivedAppearance = {}
	receivedAppearance.female = data:readNext()
	receivedAppearance.skinColor = data:readNext()
	receivedAppearance.hair = data:readNext() -- IMPORTANT: This one is the string ID; not the way client has it set to the hair's table.
	receivedAppearance.hairColor = data:readNext()
	receivedAppearance.facialHair = data:readNext() -- IMPORTANT: This one is the string ID; not the way client has it set to the facial hair's table.
	receivedAppearance.facialHairColor = data:readNext()
	receivedAppearance.eyebrows = data:readNext() -- IMPORTANT: This one is the string ID; not the way client has it set to the eyebrows's table.
	receivedAppearance.eyebrowColor = data:readNext()
	receivedAppearance.eyes = data:readNext() -- IMPORTANT: This one is the string ID; not the way client has it set to the eyes's table.
	receivedAppearance.eyeColor = data:readNext()
	receivedAppearance.top = data:readNext()
	receivedAppearance.bottom = data:readNext()
	receivedAppearance.shoes = data:readNext()
	
	GAMEMODE:setPlayerAppearance( sender, receivedAppearance )
	if GAMEMODE:getClientEntity( sender ) == nil then
		GAMEMODE:spawnPlayer( sender )
	end
end

local MSG_CLIENT_APPLY_APPEARANCE = net.registerMessage("msg_client_appearance", applyAppearanceReceived)

if CLIENT then
	
	local appearanceMenuUpdateTimer = nil
	local updateFreqSeconds = 0.05
	
	local window_appearance = nil
	local body_pane = nil
	local clothes_pane = nil
	
	local bgRenderable = nil
	local luxRenderable = nil
	local fadeRenderable = nil
	
	local skeletonRenderable = nil
	local skeletonDummy = nil
	
	local appearanceCam = camera.create()
	appearanceCam:setHeight(4)
	appearanceCam:setY(-0.70)
	
	local sprBackdrop = sprites.create()
	sprBackdrop.position.y = -1.25
	sprBackdrop.width = 8
	sprBackdrop.height = 8 / 1.5
	sprBackdrop:centerOrigin()
	sprBackdrop:setPlaying(false)
	sprBackdrop.repeatingH = true
	sprBackdrop:addTexture(textures.get("charselect/backdrop.png"))
	
	local shpLight = geom.rectangle(-10,-10,20,20)
	
	local sprFade = sprites.create()
	sprFade.angle = math.rad(270)
	sprFade.width = appearanceCam:getResultantHeight()
	sprFade.height = appearanceCam:getResultantWidth() / 4
	sprFade:centerOrigin()
	sprFade:setPlaying(false)
	sprFade:addTexture(textures.get("common/grad_alpha_linear.png"))
	sprFade.color = color.fromRGBAf(0.1,0.2,0.4,0.8)
	sprFade.position.x = appearanceCam:getBottomRight().x - sprFade.height / 2
	sprFade.position.y = appearanceCam:getY()
	
	local appearance = {}
	appearance.female = false
	appearance.hair = nil
	appearance.facialHair = nil
	appearance.eyebrows = nil
	appearance.eyes = nil
	appearance.top = nil
	appearance.bottom = nil
	appearance.shoes = nil
	
	local skinColorSelection = nil
	
	local hairSelection = nil
	local hairs = {}
	local hairColorSelection = nil
	
	local facialHairSelection = nil
	local facialHairs = {}
	local facialHairColorSelection = nil
	
	local eyebrowSelection = nil
	local eyebrows = {}
	local eyebrowColorSelection = nil
	
	local eyeSelection = nil
	local eyes = {}
	local eyeColorSelection = nil
	
	local topSelection = nil
	local tops = {}
	
	local bottomSelection = nil
	local bottoms = {}
	
	local shoesSelection = nil
	local shoes = {}
	
	local skinColors = {}
	skinColors["Light"] = color.fromRGBf(1.000,0.725,0.364) -- TODO: Stringadactyl
	skinColors["Slight Tan"] = color.fromRGBf(0.800,0.525,0.164) -- TODO: Stringadactyl
	skinColors["Tan"] = color.fromRGBf(0.600,0.325,0.020) -- TODO: Stringadactyl
	skinColors["Dark"] = color.fromRGBf(0.400,0.125,0.005) -- TODO: Stringadactyl
	
	appearance.skinColor = color.fromRGBf(0.600,0.325,0.020) -- tan default
	
	local hairColors = {} -- Selection pool used for both main hair and eyebrows
	hairColors["Blonde"] = color.fromRGBf(1.000,1.00,0.364) -- TODO: Stringadactyl
	hairColors["Redhead"] = color.fromRGBf(0.95,0.35,0.05) -- TODO: Stringadactyl
	hairColors["Chestnut"] = color.fromRGBf(0.27,0.05,0.0) -- TODO: Stringadactyl
	hairColors["Dark Brown"] = color.fromRGBf(0.04,0.0,0.0) -- TODO: Stringadactyl
	hairColors["Grey"] = color.fromRGBf(0.65,0.65,0.65) -- TODO: Stringadactyl
	hairColors["White"] = color.fromRGBf(0.94,0.94,0.94) -- TODO: Stringadactyl
	
	appearance.hairColor = hairColors["Redhead"]
	appearance.facialHairColor = hairColors["Redhead"]
	appearance.eyebrowColor = hairColors["Redhead"]
	
	local eyeColors = {} -- Selection pool used for both main hair and eyebrows
	eyeColors["Blue"] = color.fromRGBf(0.25,0.3,1) -- TODO: Stringadactyl
	eyeColors["Green"] = color.fromRGBf(0.05,0.8,0.07) -- TODO: Stringadactyl
	eyeColors["Dark Brown"] = color.fromRGBf(0.1,0.05,0.05) -- TODO: Stringadactyl
	eyeColors["Deep Blue"] = color.fromRGBf(0.05,0.05,1) -- TODO: Stringadactyl
	eyeColors["Red"] = color.fromRGBf(1,0,0) -- TODO: Stringadactyl
	
	appearance.eyeColor = eyeColors["Red"]
	
	local function renderBackground()
		draw.color4f(0,0,0,1)
		local tl = appearanceCam:getTopLeft()
		local br = appearanceCam:getBottomRight()
		draw.rectangle(tl.x, tl.y, appearanceCam:getWidth(), appearanceCam:getHeight(), true)
	end
	
	local function showCharacter()
		if appearance.female then
			skeletonDummy = skeleton_factory.create("female")
		else
			skeletonDummy = skeleton_factory.create("male")
		end
		
		skeletonDummy.position.x = -1
		skeletonDummy.position.y = 0
		skeletonDummy:setAnimation(skeleton_anims.get("biped_walk"))
		skeletonDummy:setAnimationSpeed(6.0)
		skeletonDummy:setAnimationPlay(skeletal.AP_LOOP)
		
		-- TODO: A lot of this code is repeated from entities/char_human/features.lua
		if skeletonDummy then
			local limb = nil
			for _,v in pairs(HUMAN_FEATURES.SKIN_PARTS) do
				limb = skeletonDummy:getLimb(v)
				if limb then
					limb:setColor( appearance.skinColor )
				end
			end
			
			if appearance.hair then
				HUMAN_FEATURES.addHair( skeletonDummy, appearance.hair )
			end
			limb = skeletonDummy:getLimb("hair")
			if limb then
				limb:setColor( appearance.hairColor )
			end
			
			if appearance.facialHair then
				HUMAN_FEATURES.addFacialHair( skeletonDummy, appearance.facialHair )
			end
			limb = skeletonDummy:getLimb("facialhair")
			if limb then
				limb:setColor( appearance.facialHairColor )
			end
			
			if appearance.eyebrows then
				HUMAN_FEATURES.addEyebrows( skeletonDummy, appearance.eyebrows )
			end
			limb = skeletonDummy:getLimb("eyebrows")
			if limb then
				limb:setColor( appearance.eyebrowColor )
			end
			
			-- EYES
			if appearance.eyes then
				HUMAN_FEATURES.addEyes( skeletonDummy, appearance.eyes )
			end
			limb = skeletonDummy:getLimb("pupil")
			if limb then
				limb:setColor( appearance.eyeColor )
			end
			
			
			-- CLOTHES
			if appearance.top then
				HUMAN_CLOTHES.addTop( skeletonDummy, appearance.top )
			end
			if appearance.bottom then
				HUMAN_CLOTHES.addBottom( skeletonDummy, appearance.bottom )
			end
			if appearance.shoes then
				HUMAN_CLOTHES.addShoes( skeletonDummy, appearance.shoes )
			end
		end
		
		if skeletonRenderable ~= nil then
			renderables.remove(skeletonRenderable)
		end
		skeletonRenderable = renderables.fromSkeleton(skeletonDummy)
		skeletonRenderable:setLayer(renderables.LAYER_BELOW_HUD)
		renderables.add(skeletonRenderable)
	end
	
	local function updateMenu()
		if skeletonDummy then
			skeletonDummy:update(updateFreqSeconds)
		end
		
		if sprBackdrop then
			sprBackdrop.offset.x = sprBackdrop.offset.x - updateFreqSeconds/2
		end
	end
	
	local function updateHairSelection()
		hairs = {}
		hairs["None"] = nil -- TODO: Stringadactyl
		
		hairSelection:addItem("")
		
		local genderedHairList = HUMAN_FEATURES.HAIR_LIST_MALE
		
		if appearance.female then
			genderedHairList = HUMAN_FEATURES.HAIR_LIST_FEMALE
		end
		
		for k,v in pairs(genderedHairList) do
			hairs[v.niceName] = v
		end
		
		hairSelection:removeAll()
		
		for k,v in pairs(hairs) do
			hairSelection:addItem(k)
		end
		
		for k,v in pairs(hairs) do
			if v.id==cvars.string("appearance_hair","") then
				hairSelection:setSelected(v.niceName)
			end
		end
		
		hairColorSelection:setColor( color.fromHexString(cvars.string("appearance_hairColor","")) or color.fromRGBf(0.27,0.05,0.0) )
	end
	
	local function updateFacialHairSelection()
		facialHairs = {}
		facialHairs["None"] = nil -- TODO: Stringadactyl
		
		facialHairSelection:addItem("")
		
		local genderedFacialHairList = HUMAN_FEATURES.FACIAL_HAIR_LIST_MALE
		
		if appearance.female then
			genderedFacialHairList = HUMAN_FEATURES.FACIAL_HAIR_LIST_FEMALE
		end
		
		for k,v in pairs(genderedFacialHairList) do
			facialHairs[v.niceName] = v
		end
		
		facialHairSelection:removeAll()
		
		for k,v in pairs(facialHairs) do
			facialHairSelection:addItem(k)
		end
		
		for k,v in pairs(facialHairs) do
			if v.id==cvars.string("appearance_facialhair","") then
				facialHairSelection:setSelected(v.niceName)
			end
		end
		
		facialHairColorSelection:setColor( color.fromHexString(cvars.string("appearance_facialhairColor","")) or color.fromRGBf(0.27,0.05,0.0) )
	end
	
	local function updateEyebrowSelection()
		eyebrows = {}
		eyebrows["None"] = nil -- TODO: Stringadactyl
		
		eyebrowSelection:addItem("")
		
		local genderedEyebrowList = HUMAN_FEATURES.EYEBROW_LIST_MALE
		
		if appearance.female then
			genderedEyebrowList = HUMAN_FEATURES.EYEBROW_LIST_FEMALE
		end
		
		for k,v in pairs(genderedEyebrowList) do
			eyebrows[v.niceName] = v
		end
		
		eyebrowSelection:removeAll()
		
		for k,v in pairs(eyebrows) do
			eyebrowSelection:addItem(k)
		end
		
		for k,v in pairs(eyebrows) do
			if v.id==cvars.string("appearance_eyebrows","") then
				eyebrowSelection:setSelected(v.niceName)
			end
		end
		
		eyebrowColorSelection:setColor( color.fromHexString(cvars.string("appearance_eyebrowColor","")) or color.fromRGBf(0.08,0.0,0.0) )
	end
	
	local function updateEyeSelection()
		eyes = {}
		eyes["None"] = nil -- TODO: Stringadactyl
		
		eyeSelection:addItem("")
		
		local genderedEyeList = HUMAN_FEATURES.EYES_LIST_MALE
		
		if appearance.female then
			genderedEyeList = HUMAN_FEATURES.EYES_LIST_FEMALE
		end
		
		for k,v in pairs(genderedEyeList) do
			eyes[v.niceName] = v
		end
		
		eyeSelection:removeAll()
		
		for k,v in pairs(eyes) do
			eyeSelection:addItem(k)
		end
		
		for k,v in pairs(eyes) do
			if v.id==cvars.string("appearance_eyes","") then
				eyeSelection:setSelected(v.niceName)
			end
		end
		
		eyeColorSelection:setColor( color.fromHexString(cvars.string("appearance_eyeColor","")) or color.fromRGBf(0.09,0.75,0.12) )
	end
	
	local function updateTopSelection()
		tops = {}
		
		local genderedTopList = HUMAN_CLOTHES.TOP_LIST_MALE
		
		if appearance.female then
			genderedTopList = HUMAN_CLOTHES.TOP_LIST_FEMALE
		end
		
		for k,v in pairs(genderedTopList) do
			tops[v.niceName] = v
		end
		
		topSelection:removeAll()
		
		for k,v in pairs(tops) do
			topSelection:addItem(k)
		end
		
		for k,v in pairs(tops) do
			if v.id==cvars.string("appearance_top","") then
				topSelection:setSelected(v.niceName)
			end
		end
		
		--topSelection:setSelectedIndex(0)
	end
	
	local function updateBottomSelection()
		bottoms = {}
		
		local genderedBottomList = HUMAN_CLOTHES.BOTTOM_LIST_MALE
		
		if appearance.female then
			genderedBottomList = HUMAN_CLOTHES.BOTTOM_LIST_FEMALE
		end
		
		for k,v in pairs(genderedBottomList) do
			bottoms[v.niceName] = v
		end
		
		bottomSelection:removeAll()
		
		for k,v in pairs(bottoms) do
			bottomSelection:addItem(k)
		end
		
		for k,v in pairs(bottoms) do
			if v.id==cvars.string("appearance_bottom","") then
				bottomSelection:setSelected(v.niceName)
			end
		end
		
		--bottomSelection:setSelectedIndex(0)
	end
	
	local function updateShoesSelection()
		shoes = {}
		
		local genderedShoesList = HUMAN_CLOTHES.SHOES_LIST_MALE
		
		if appearance.female then
			genderedShoesList = HUMAN_CLOTHES.SHOES_LIST_FEMALE
		end
		
		for k,v in pairs(genderedShoesList) do
			shoes[v.niceName] = v
		end
		
		shoesSelection:removeAll()
		
		for k,v in pairs(shoes) do
			shoesSelection:addItem(k)
		end
		
		for k,v in pairs(shoes) do
			if v.id==cvars.string("appearance_shoes","") then
				shoesSelection:setSelected(v.niceName)
			end
		end
		
		--shoesSelection:setSelectedIndex(0)
	end
	
	-- Callback for when the apply button is pressed
	local function onOkButton()
		if SERVER then return end -- Servers don't.
		local data = net.data()
		GAMEMODE:appearanceToCvars(appearance)
		data:writeBool(appearance.female)
		data:writeColor(appearance.skinColor)
		data:writeString(appearance.hair.id)
		data:writeColor(appearance.hairColor)
		data:writeString(appearance.facialHair.id)
		data:writeColor(appearance.facialHairColor)
		data:writeString(appearance.eyebrows.id)
		data:writeColor(appearance.eyebrowColor)
		data:writeString(appearance.eyes.id)
		data:writeColor(appearance.eyeColor)
		data:writeString(appearance.top.id)
		data:writeString(appearance.bottom.id)
		data:writeString(appearance.shoes.id)
		net.sendMessage( MSG_CLIENT_APPLY_APPEARANCE, data )
		cvars.set("appearance_set",true) -- Never show this again
		GAMEMODE:gui_hideAppearanceWindow()
	end
	
	function GM:gui_showAppearanceWindow()
		if not gui_utils.widgetExists(window_appearance) then
			--window_appearance = fgui.createWindow(true, false, false, false)
			
			--window_appearance:setTitle("Character Appearance") -- TODO: stringadactyl
			
			window_appearance = fgui.createContainer()
			
			--local cont = window_appearance:getContentContainer()
			local cont = window_appearance
			cont:setLayoutManager(fgui.newRowLayout())
			
			local tabCont = fgui.createTabContainer(cont)
			local toggableGroup = fgui.newToggableGroup()
			
			
			
			
			-- BODY TAB
			
			local tab1 = fgui.createTabItem()
			tab1:setGroup(toggableGroup)
			tab1:getHeadWidget():setText("Body") -- TODO: stringadactyl
			
			local scroll = fgui.createScrollContainer(tab1)
			body_pane = fgui.createContainer(scroll)
			body_pane:setLayoutManager(fgui.newRowExLayout())
			
			local genderLabel = fgui.createLabel(body_pane,"Gender") -- TODO: Stringadactyl
			local genderGroup = fgui.newToggableGroup()
			local genderMale = fgui.createRadioButton(genderGroup, body_pane, "Male") -- TODO: Stringadactyl
			genderMale:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev)
				if ev:isSelected() then
					appearance.female = false
					updateHairSelection()
					updateFacialHairSelection()
					updateEyebrowSelection()
					updateEyeSelection()
					updateTopSelection()
					updateBottomSelection()
					updateShoesSelection()
					showCharacter()
				end
			end))
			local genderFemale = fgui.createRadioButton(genderGroup, body_pane, "Female") -- TODO: Stringadactyl
			genderFemale:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev)
				if ev:isSelected() then
					appearance.female = true
					updateHairSelection()
					updateFacialHairSelection()
					updateEyebrowSelection()
					updateEyeSelection()
					updateTopSelection()
					updateBottomSelection()
					updateShoesSelection()
					showCharacter()
				end
			end))
			
			fgui.createLabel(body_pane," ") -- Spacer
			
			local skinColorLabel = fgui.createLabel(body_pane,"Skin Color") -- TODO: Stringadactyl
			skinColorSelection = fgui.createColorBox(body_pane)
			skinColorSelection:addColorChangedListener(fgui_listeners.colorChanged(function(ev)
				local col = skinColorSelection:getColor()
				if col then
					appearance.skinColor = col
					showCharacter()
				end
			end))
			
			
			fgui.createLabel(body_pane," ") -- Spacer
			
			local hairLabel = fgui.createLabel(body_pane, "Hair") -- TODO: Stringadactyl
			hairSelection = fgui.createComboBox(body_pane)
			
			hairSelection:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev)
				local hair = hairs[hairSelection:getSelectedValue()]
				if hair then
					appearance.hair = hair
					showCharacter()
				end
			end))
			
			local hairColorLabel = fgui.createLabel(body_pane,"Hair Color") -- TODO: Stringadactyl
			hairColorSelection = fgui.createColorBox(body_pane)
			hairColorSelection:addColorChangedListener(fgui_listeners.colorChanged(function(ev)
				local col = hairColorSelection:getColor()
				if col then
					appearance.hairColor = col
					showCharacter()
				end
			end))
			
			updateHairSelection()
			
			
			
			fgui.createLabel(body_pane," ") -- Spacer
			
			local facialHairLabel = fgui.createLabel(body_pane, "Facial Hair") -- TODO: Stringadactyl
			facialHairSelection = fgui.createComboBox(body_pane)
			
			facialHairSelection:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev)
				local facialHair = facialHairs[facialHairSelection:getSelectedValue()]
				if facialHair then
					appearance.facialHair = facialHair
					showCharacter()
				end
			end))
			
			local facialHairColorLabel = fgui.createLabel(body_pane,"Facial Hair Color") -- TODO: Stringadactyl
			facialHairColorSelection = fgui.createColorBox(body_pane)
			facialHairColorSelection:addColorChangedListener(fgui_listeners.colorChanged(function(ev)
				local col = facialHairColorSelection:getColor()
				if col then
					appearance.facialHairColor = col
					showCharacter()
				end
			end))
			
			updateFacialHairSelection()
			
			
			
			fgui.createLabel(body_pane," ") -- Spacer
			
			local eyebrowsLabel = fgui.createLabel(body_pane, "Eyebrows") -- TODO: Stringadactyl
			eyebrowSelection = fgui.createComboBox(body_pane)
			
			eyebrowSelection:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev)
				local brow = eyebrows[eyebrowSelection:getSelectedValue()]
				if brow then
					appearance.eyebrows = brow
					showCharacter()
				end
			end))
			
			local eyebrowColorLabel = fgui.createLabel(body_pane,"Eyebrow Color") -- TODO: Stringadactyl
			eyebrowColorSelection = fgui.createColorBox(body_pane)
			eyebrowColorSelection:addColorChangedListener(fgui_listeners.colorChanged(function(ev)
				local col = eyebrowColorSelection:getColor()
				if col then
					appearance.eyebrowColor = col
					showCharacter()
				end
			end))
			
			updateEyebrowSelection()
			
			
			
			fgui.createLabel(body_pane," ") -- Spacer
			
			local eyesLabel = fgui.createLabel(body_pane, "Eyes") -- TODO: Stringadactyl
			eyeSelection = fgui.createComboBox(body_pane)
			
			eyeSelection:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev)
				local eye = eyes[eyeSelection:getSelectedValue()]
				if eye then
					appearance.eyes = eye
					showCharacter()
				end
			end))
			
			local eyeColorLabel = fgui.createLabel(body_pane,"Eye Color") -- TODO: Stringadactyl
			eyeColorSelection = fgui.createColorBox(body_pane)
			eyeColorSelection:addColorChangedListener(fgui_listeners.colorChanged(function(ev)
				local col = eyeColorSelection:getColor()
				if col then
					appearance.eyeColor = col
					showCharacter()
				end
			end))
			
			updateEyeSelection()
			
			
			
			
			-- CLOTHES TAB
			
			local tab2 = fgui.createTabItem()
			tab2:setGroup(toggableGroup)
			tab2:getHeadWidget():setText("Clothes") -- TODO: stringadactyl
			
			scroll = fgui.createScrollContainer(tab2)
			clothes_pane = fgui.createContainer(scroll)
			clothes_pane:setLayoutManager(fgui.newRowExLayout())
			
			
			local topLabel = fgui.createLabel(clothes_pane, "Top") -- TODO: Stringadactyl
			topSelection = fgui.createComboBox(clothes_pane)
			
			topSelection:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev)
				local top = tops[topSelection:getSelectedValue()]
				if top then
					appearance.top = top
					showCharacter()
				end
			end))
			
			updateTopSelection()
			
			
			fgui.createLabel(clothes_pane," ") -- Spacer
			
			local bottomLabel = fgui.createLabel(clothes_pane, "Bottom") -- TODO: Stringadactyl
			bottomSelection = fgui.createComboBox(clothes_pane)
			
			bottomSelection:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev)
				local bottom = bottoms[bottomSelection:getSelectedValue()]
				if bottom then
					appearance.bottom = bottom
					showCharacter()
				end
			end))
			
			updateBottomSelection()
			
			
			fgui.createLabel(clothes_pane," ") -- Spacer
			
			local shoesLabel = fgui.createLabel(clothes_pane, "Shoes") -- TODO: Stringadactyl
			shoesSelection = fgui.createComboBox(clothes_pane)
			
			shoesSelection:addSelectionChangedListener(fgui_listeners.selectionChanged(function(ev)
				local shoes = shoes[shoesSelection:getSelectedValue()]
				if shoes then
					appearance.shoes = shoes
					showCharacter()
				end
			end))
			
			updateShoesSelection()
			
			
			
			
			
			-- WINDOW
			
			--window_appearance:addWindowClosedListener(fgui_listeners.windowClosed(function() self:gui_hideAppearanceWindow() end))
			
			genderMale:setSelected(cvars.bool("appearance_female", false) == false)
			genderFemale:setSelected(cvars.bool("appearance_female", false) == true)
			skinColorSelection:setColor( color.fromHexString(cvars.string("appearance_skinColor","")) or color.fromRGBf(0.800,0.525,0.164) )
--			hairColorSelection:setColor( color.fromHexString(cvars.string("appearance_hairColor","")) )
--			facialHairColorSelection:setColor( color.fromHexString(cvars.string("appearance_facialhairColor","")) )
--			eyeColorSelection:setColor( color.fromHexString(cvars.string("appearance_eyeColor","")) )
--			eyebrowColorSelection:setColor( color.fromHexString(cvars.string("appearance_eyebrowColor","")) )
			
			local btnOk = fgui.createButton(cont, "OK") -- TODO: Stringadactyl
			btnOk:addButtonPressedListener(fgui_listeners.buttonPressed(onOkButton))
			btnOk:setExpandable(false)
			btnOk:setWidth(256)
			
			window_appearance:setWidth(256)
			window_appearance:setHeight(display.getHeight())
			
			--window_appearance:centerOnScreen()
			window_appearance:setX(fgui.getDisplay():getWidth()-256)
			window_appearance:setY(0)
			
			tabCont:addTab(tab1)
			tabCont:addTab(tab2)
			
			tabCont:setActiveTab(0)
		end
		
		window_appearance:setVisible(true)
		
		camera.use(appearanceCam)
		
		if bgRenderable == nil then
			--bgRenderable = renderables.fromFunction(renderBackground)
			bgRenderable = renderables.fromSprite(sprBackdrop)
			bgRenderable:setLayer(renderables.LAYER_BELOW_HUD)
			renderables.add(bgRenderable)
		end
		
		showCharacter()
		
		if luxRenderable == nil then
			--luxRenderable = renderables.fromFunction(renderBackground)
			luxRenderable = renderables.fromShape(shpLight)
			luxRenderable:setLayer(renderables.LAYER_BELOW_HUD)
			luxRenderable.fillColor = color.WHITE
			luxRenderable:setLightMode(renderables.LIGHT_EMIT)
			luxRenderable:setBlendMode(renderables.BLEND_NONE)
			luxRenderable:setDepth(-10)
			renderables.add(luxRenderable)
		end
		
		if fadeRenderable == nil then
			fadeRenderable = renderables.fromSprite(sprFade)
			fadeRenderable:setLayer(renderables.LAYER_BELOW_HUD)
			renderables.add(fadeRenderable)
		end
		
		if appearanceMenuUpdateTimer == nil then -- Check nil to not infinitely create update timers
			appearanceMenuUpdateTimer = timer.create( updateFreqSeconds, -1, updateMenu, true, true )
		end
	end
	
	function GM:gui_getAppearanceWindow()
		return window_appearance
	end
	
	function GM:gui_hideAppearanceWindow()
		self:gui_showAppearanceWindow()
		window_appearance:setVisible(false)
		fgui.getDisplay():setFocusedWidget(nil) -- So the player doesn't have to click once to un-grab input from FGUI
		
		CLIENT_CAMERA:trigger()
		renderables.remove(bgRenderable)
		bgRenderable = nil
		renderables.remove(luxRenderable)
		luxRenderable = nil
		renderables.remove(skeletonRenderable)
		skeletonRenderable = nil
		renderables.remove(fadeRenderable)
		fadeRenderable = nil
	end
	
	function GM:appearanceToCvars(appearance)
			
			cvars.set("appearance_female",appearance.female)
			cvars.set("appearance_skinColor",appearance.skinColor:toHexString())
			cvars.set("appearance_hair",appearance.hair.id)
			cvars.set("appearance_hairColor",appearance.hairColor:toHexString())
			cvars.set("appearance_facialHair",appearance.facialHair.id)
			cvars.set("appearance_facialHairColor",appearance.facialHairColor:toHexString())
			cvars.set("appearance_eyes",appearance.eyes.id)
			cvars.set("appearance_eyeColor",appearance.eyeColor:toHexString())
			cvars.set("appearance_eyebrows",appearance.eyebrows.id)
			cvars.set("appearance_eyebrowColor",appearance.eyebrowColor:toHexString())
			
			cvars.set("appearance_top",appearance.top.id)
			cvars.set("appearance_bottom",appearance.bottom.id)
			cvars.set("appearance_shoes",appearance.shoes.id)
	end
	
	function GM:applyAppearanceFromCvars()
		local data = net.data()
		data:writeBool(cvars.bool("appearance_female",false))
		data:writeColor(color.fromHexString(cvars.string("appearance_skinColor","")))
		data:writeString(cvars.string("appearance_hair",""))
		data:writeColor(color.fromHexString(cvars.string("appearance_hairColor","")))
		data:writeString(cvars.string("appearance_facialhair",""))
		data:writeColor(color.fromHexString(cvars.string("appearance_facialHairColor","")))
		data:writeString(cvars.string("appearance_eyebrows",""))
		data:writeColor(color.fromHexString(cvars.string("appearance_eyebrowColor","")))
		data:writeString(cvars.string("appearance_eyes",""))
		data:writeColor(color.fromHexString(cvars.string("appearance_eyeColor","")))
		data:writeString(cvars.string("appearance_top",""))
		data:writeString(cvars.string("appearance_bottom",""))
		data:writeString(cvars.string("appearance_shoes",""))
		net.sendMessage( MSG_CLIENT_APPLY_APPEARANCE, data )
	end

end

