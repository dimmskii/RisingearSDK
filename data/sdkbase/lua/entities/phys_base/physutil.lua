--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local phys_util = {}

local tempUserData = nil

-- Checks if a fixture belongs to a phys_prop that has the platform flag enabled
phys_util.fixtureIsPlatform = function(fixture)
		tempUserData = fixture:getUserData()
		if not tempUserData or not tempUserData.valid then
		  tempUserData = fixture:getBody():getUserData()
		  if not tempUserData or not tempUserData.valid then
		    return false
		  end
		end
		if not tempUserData.platform then return false end
		
		return true
end

return phys_util