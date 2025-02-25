--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

materials = {}

local materialsTable = {}

materials.create = function( strUniqueId, fDensity, fFriction, fRestitution, strSoundGroupId )
	local mat = {}
	if strUniqueId == nil then
		console.err("Attempt to create physics material with nil string id!")
		return nil
	end
	
	if type(strUniqueId) ~= "string" then
		console.err("Attempt to create physics material with non-string id parameter!")
		return nil
	end
	
	if materialsTable[strUniqueId] ~= nil and type(materialsTable[strUniqueId]) == "table" then
		console.err("Attempt to create physics material with duplicate id: '" + strUniqueId + "'")
		return nil
	end
	
	mat.id = strUniqueId
	mat.density = fDensity or 1
	mat.friction = fFriction or 0
	mat.restitution = fRestitution or 0
	
	if strSoundGroupId == nil or type(strSoundGroupId) ~= "string" then
		mat.soundGroup = "wood"
	else
		mat.soundGroup = strSoundGroupId
	end
	
	materialsTable[strUniqueId] = mat
	
	return mat
end

materials.get = function(strUniqueId)
	if strUniqueId == nil then
		console.err("Attempt to get physics material with nil string id!")
		return nil
	end
	if type(strUniqueId) ~= "string" then
		console.err("Attempt to get physics material with non-string id parameter!")
		return nil
	end
	return materialsTable[strUniqueId]
end

materials.list = function()
	local materialsList = {}
	for _,v in pairs(materialsTable) do
		table.insert(materialsList,v)
	end
	return materialsList
end

materials.listIDs = function()
	local idList = {}
	for k,v in pairs(materialsTable) do
		table.insert(idList,k)
	end
	return idList
end
