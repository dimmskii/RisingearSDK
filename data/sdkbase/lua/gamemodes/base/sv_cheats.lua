--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local bCheats = cvars.bool( "sv_cheats", false )

hook.add("onCvarChanged", "onCvarChanged_sv_cheats", function(strName, strOldValue, strNewValue)
  if strName=="sv_cheats" then
    local bCheatsNew = cvars.bool( "sv_cheats", false )
    if bCheatsNew ~= bCheats then
      bCheats = bCheatsNew
--      if bCheats then
--        console.log("Cheats are now enabled")
--      else
--        console.log("Cheats are now disabled")
--      end
    end
  end

end)

function GM:isCheatsEnabled()
  return bCheats
end
