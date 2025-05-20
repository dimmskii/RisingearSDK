--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local function nop() end

function GM:registerCommands()
	if (CLIENT) then
		cmds.register("+moveup", nop)
		cmds.register("-moveup", nop)
		cmds.register("+movedown", nop)
		cmds.register("-movedown", nop)
		cmds.register("+moveleft", nop)
		cmds.register("-moveleft", nop)
		cmds.register("+moveright", nop)
		cmds.register("-moveright", nop)
		cmds.register("+use", nop)
		cmds.register("-use", nop)
		cmds.register("+run", nop)
		cmds.register("-run", nop)
		cmds.register("kill", nop)
		cmds.register("+attack", nop)
		cmds.register("-attack", nop)
		cmds.register("dropweapon", nop)
	end
end