--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local function applyTexture(texPath, tableEnts)
	for k,v in pairs(tableEnts) do
		if (v.editor_applyTexture) then
			v:editor_applyTexture(texPath)
		end
	end
end
local MSG_GUI_TEXTURE_APPLY = net.registerMessage("gui_texture_apply", function(sender, data)
	local texPath = data:readNext()
	local tableEnts = {}
	local ent = nil
	local id = nil
	while (data:hasNext()) do
		id = data:readNext()
		ent = ents.findByID(id)
		if (ent) then
			table.insert(tableEnts,ent)
		end
	end
	applyTexture(texPath, tableEnts)
end, true)
function EDITOR.applyTexture(texPath)
	if (CLIENT) then
		local data = net.data()
		data:writeString(texPath)
		for k,v in pairs(tools.selectedEnts) do
			data:writeInt(v.id)
		end
		applyTexture(texPath, tools.selectedEnts)
		net.sendMessage(MSG_GUI_TEXTURE_APPLY,data)
	end
end


local MSG_GUI_TEXTURE_FIT = net.registerMessage("gui_texture_fit", function(sender, data)
	local tableEnts = {}
	local ent = nil
	local id = nil
	while (data:hasNext()) do
		id = data:readNext()
		ent = ents.findByID(id)
		if (ent and ent.valid) then
			ent:editor_fitTexture()
		end
	end
end, true)
function EDITOR.fitTexture()
	if (CLIENT) then
		local data = net.data()
		for k,v in pairs(tools.selectedEnts) do
			data:writeInt(v.id)
			v:editor_fitTexture()
		end
		net.sendMessage(MSG_GUI_TEXTURE_FIT,data)
	end
end
