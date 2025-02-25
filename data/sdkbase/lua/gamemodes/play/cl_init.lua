--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local GM_BASE = gamemode.getClass(GM.CLASSNAME_BASE)

function GM:cl_initialize()
	GM_BASE.cl_initialize( self )
	-- Create the camera
	CLIENT_CAMERA = ents.create("cam_chase")
	CLIENT_CAMERA:trigger()
end

function GM:onJoinGame()
	GM_BASE.onJoinGame( self )
	timer.create( 0.9, 1, function() self:gui_showAppearanceWindow() end, true, true )
end

function GM:cl_update( delta )
	GM_BASE.cl_update( self, delta )
	
	self:cl_updateAimVector( delta )
end


local mouseDisplayOld = geom.vec2()
local bLookLeft,bLookRight,bLookUp,bLookDown
function GM:cl_updateAimVector( delta )
	if (localClient().ent and localClient().ent.valid and ents.isClass(localClient().ent, "char_base", true)) then
		
		bLookLeft = self.bLookLeft and not self.bLookRight
		bLookRight = self.bLookRight and not self.bLookLeft
		bLookUp = self.bLookUp and not self.bLookDown
		bLookDown = self.bLookDown and not self.bLookUp
		
		local aim = geom.vec2()
		
		-- Check if mouse moved to determine whether or not to run keyboard look or mouse look code
		local mouseDisplay = geom.vec2(display.getMouseX(), display.getMouseY())
		if mouseDisplay:equals(mouseDisplayOld) then
			
			-- Begin keyboard look logic since the mouse hasn't moved
			local aimVec = localClient().ent:getAimVec()
			if bLookLeft then
				aimVec.x = math.abs(aimVec.x) * -1
				aim = localClient().ent:getPosition():add(aimVec)
				localClient().ent:aimAt(aim.x, aim.y)
				self:cl_sendLookPosMessage( aim )
			elseif bLookRight then
				aimVec.x = math.abs(aimVec.x)
				aim = localClient().ent:getPosition():add(aimVec)
				localClient().ent:aimAt(aim.x, aim.y)
				self:cl_sendLookPosMessage( aim )
			end
			if bLookUp then
				aimVec:setTheta(aimVec:getTheta() - 90*delta*math.signum(aimVec.x))
				aim = localClient().ent:getPosition():add(aimVec)
				localClient().ent:aimAt(aim.x, aim.y)
				self:cl_sendLookPosMessage( aim )
			elseif bLookDown then
				aimVec:setTheta(aimVec:getTheta() + 90*delta*math.signum(aimVec.x))
				aim = localClient().ent:getPosition():add(aimVec)
				localClient().ent:aimAt(aim.x, aim.y)
				self:cl_sendLookPosMessage( aim )
			end
		else
			-- Begin mouselook logic since the mouse moved
			aim:setXY(display.getMouseXViewport(), display.getMouseYViewport())
			localClient().ent:aimAt(aim.x, aim.y)
			self:cl_sendLookPosMessage( aim )
		end
		
		mouseDisplayOld = mouseDisplay
		
	end
end


-- On each key event that makes its way into controller listener (past GUI), we set cursor to DEFAULT
-- TODO: set cursor to NONE and draw our own reticle?
local cursorKeyListener = {}
cursorKeyListener.buttonPressed = function(button)
	cursor.set(cursor.DEFAULT)
end
cursorKeyListener.buttonReleased = function(button)
	cursor.set(cursor.DEFAULT)
end
controller.addListener(cursorKeyListener, false)


function GM:onSayMessage(clientInfo, messageMode, message)
	gui_chat.chatMessage(clientInfo, messageMode, message)
end

function GM:onClientConnect( client )
	 gui_chat.serverMessage(client.name .. " connected.") -- TODO Stringadactyl
end

function GM:onClientDisconnect( client )
	 gui_chat.serverMessage(client.name .. " disconnected.") -- TODO Stringadactyl
end

function GM:onClientNameChanged( client, oldName, newName )
	 gui_chat.serverMessage(oldName .. " changed name to " .. newName) -- TODO Stringadactyl
end