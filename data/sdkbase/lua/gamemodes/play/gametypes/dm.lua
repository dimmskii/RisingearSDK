--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


if not SERVER then return end

local GM_BASE = gamemode.getClass(GM.CLASSNAME_BASE)

local function removeCharacters()
	for k,v in pairs(ents.getAll()) do
		if v.valid and ents.isClass(v,"char_base",true) and not ents.isClass(v,"player",false) then
			ents.remove(v)
		end
	end
end
hook.add("postMapLoad", "dm_removeCharacters", removeCharacters)

local GM_pickSpawnPoint_old = GM.pickSpawnPoint -- Because we are overriding sameclass; not baseclass (this used to be written for another gamemode extending 'play')
function GM:pickSpawnPoint( ply )
	local spawners = {}
	for k,v in pairs(ents.getAll()) do
		if v.valid and ents.isClass(v,"info_player_dm") then
			table.insert(spawners,v)
		end
	end
	if (table.isEmpty(spawners)) then
		return GM_pickSpawnPoint_old( self, ply ) -- Will try to pick some info_player_start as per coop game code if we don't have any info_player_dm
	end
	return spawners[math.random(table.getn(spawners))]:getPosition():clone()
end
