--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

ent_utils = {}

local function funcTrue()
	return true
end

ent_utils.getEntsInRadius = function( vec2Pos, fDist, funcFilter )
	funcFilter = funcFilter or funcTrue
	local fDistSq = fDist * fDist
	local tableOut = {}
	for k,v in pairs(ents.getAll()) do
		if ( funcFilter(v) and vec2Pos:distanceSquared(v.position) <= fDistSq ) then
			table.insert(tableOut,v)
		end
	end
	return tableOut
end

return ent_utils
