--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local container_chat = nil
local textView = nil
local messageBox = nil
local scroll = nil

local nameColor = color.YELLOW
local plainColor = color.WHITE
local chatFont = nil
local nameStyle = nil
local plainStyle = nil

local chatFocused = false
local messageMode = 0

local chatSound = audio.guiSound("fgui/chat_notify.wav")

local textViewAlpha = 0

local textShowTime = 5

local function loadFontsAndStyles()
	chatFont = fgui_fonts.fromAWT("Arial",fgui_fonts.AWT_STYLE_BOLD,14)
	nameStyle = fgui.newTextStyle(chatFont, nameColor)
	plainStyle = fgui.newTextStyle(chatFont, plainColor)
end

gui_chat = {}

gui_chat.initialize = function()
	if not ( gui_utils.widgetExists(container_chat) ) then
		loadFontsAndStyles() -- TODO should loadFontsAndStyles be called every time on chat window creation?
	
		container_chat = fgui.createContainer()
		container_chat:setClickable(false)
		container_chat:setLayoutManager(fgui.newRowExLayout(false))
		container_chat:setSize(256,256)
		container_chat:setMinSize(256,256)
		container_chat:setMaxSize(256,256)
		
		scroll = fgui.createScrollContainer(container_chat)
		scroll:setLayoutData(fgui.newRowExLayoutData(true, true))
		scroll:getHorizontalScrollBar():setVisible(false)
		scroll:getVerticalScrollBar():setVisible(false)
	
		textView = fgui.createTextView(scroll)
		
		messageBox = fgui.createTextField(container_chat)
		
		local mbKeyListener = {}
		mbKeyListener.keyPressed = function(keyPressedEvent)
			if keyPressedEvent:getKeyClass():equals(fgui_listeners.KEYCLASS_ENTER) then
				net.sayMessage(messageBox:getText(), messageMode)
				gui_chat.unfocus()
			end
		end
		
		messageBox:addKeyPressedListener(fgui_listeners.key(mbKeyListener))
		
		container_chat:layout()
		
		messageBox:setVisible(false)
		
		return true
	end
	
	return false
end

gui_chat.destroy = function()
	messageBox = nil
	textView = nil
	container_chat = nil
	chatFocused = false
	scroll = nil
end

gui_chat.focus = function( msgMode )
	messageMode = msgMode or 0
	container_chat:setClickable(true)
	messageBox:setVisible(true)
	scroll:getVerticalScrollBar():setVisible(true)
	messageBox:setFocused(true)
	textViewAlpha = 1 + textShowTime
	chatFocused = true
end

gui_chat.unfocus = function()
	container_chat:setClickable(false)
	messageBox:setVisible(false)
	scroll:getVerticalScrollBar():setVisible(false)
	messageBox:setFocused(false)
	messageBox:setText("")
	chatFocused = false
end

gui_chat.chatMessage = function(clientInfo, mode, message)
	if textView ~= nil then
		if clientInfo ~= nil then
			if mode==1 then
				textView:appendText("(TEAM) ", plainStyle) -- TODO stringadactyl
			end
			
			textView:appendText(clientInfo:getName(), nameStyle)
			textView:appendText(" :  ", plainStyle)
		end
		textViewAlpha = 1 + textShowTime
		textView:appendText(message .. "\n", plainStyle)
		chatSound:play()
	end
end

gui_chat.serverMessage = function(message)
	if textView ~= nil then
		textViewAlpha = 1 + textShowTime
		textView:appendText(message .. "\n", plainStyle)
		chatSound:play()
	end
end

function gui_chat.isFocused()
	return chatFocused
end

local function update( fDelta )
	if EDITOR then return end
	nameStyle:setColor(color.fromRGBAf(nameColor:getRed(),nameColor:getGreen(),nameColor:getBlue(),math.min(textViewAlpha,1)))
	plainStyle:setColor(color.fromRGBAf(plainColor:getRed(),plainColor:getGreen(),plainColor:getBlue(),math.min(textViewAlpha,1)))
	if not chatFocused then
		textViewAlpha = textViewAlpha - (fDelta)
	end
end

hook.add("update", "gui_chat_update", update)

