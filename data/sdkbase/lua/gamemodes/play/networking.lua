--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


-- SERVER TO CLIENT MESSAGES

local function processPlyEntMessage(sender, data)
	if ( SERVER ) then return end
	
	local id = data:readNext()
	local ent = ents.findByID( id )
	if ( ent ) then
		CLIENT_CAMERA.target = ent
		localClient().ent = ent
	else
		CLIENT_CAMERA.target = nil
		localClient().ent = nil
	end
	
end

local MSG_PLAYER_SET_ENT = net.registerMessage("setplyent", processPlyEntMessage)

function GM:sendPlyEntMessage( ent , client )
	local data = net.data()
	if ( client ) then
		data:writeInt( ent.id )
	else
		data:writeInt( ent.id )
	end
	net.sendMessage( MSG_PLAYER_SET_ENT, data, client )
end





-- CLIENT TO SERVER MESSAGES

local function processLookPosMessage(sender, data)
	if ( CLIENT ) then return end
	
	if ( sender.ent and sender.ent.valid and ents.isClass(sender.ent,"char_base",true) ) then
		local vec = data:readNext()
		sender.ent:aimAt(vec.x,vec.y)
	end
	
end

local CLMSG_LOOKPOS = net.registerMessage("cl_lookpos", processLookPosMessage)

function GM:cl_sendLookPosMessage( pos )
	local data = net.data()
	data:writeVec2( pos )
	net.sendMessage( CLMSG_LOOKPOS, data )
end