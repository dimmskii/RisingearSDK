--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

function GM:cl_initialize()
	
end

function GM:cl_update( delta )
	
end

function GM:onJoinGame()
	
end

function GM:onVideoRestart()

end

function GM:getWorldspawnEntity()
		local tEnts = ents.getAll()
		for k,v in pairs(tEnts) do
			if v.CLASSNAME == "worldspawn" then
				return v
			end
		end
end

function GM:messageMode( messageMode )
	gui_chat.focus( messageMode )
end