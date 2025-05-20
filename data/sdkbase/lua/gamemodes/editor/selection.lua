
local MSG_SET_SELECTION = net.registerMessage("editor_sv_set_selection",
	function(sender, data)
		if (CLIENT) then
			local selection = {}
			while( data:hasNext() ) do
				local ent = ents.findByID( data:readNext() )
				if ( ent ) then
					table.insert(selection, ent)
				end
			end
			EDITOR.setSelection(selection)
		end
	end,
true)
EDITOR.setSelection = function(tableEnts)
	if (tableEnts) then
		if (CLIENT) then
			tools.setSelection(tableEnts)
		elseif (SERVER) then
			local data = net.data()
			for k,v in pairs(tableEnts) do
				data:writeEntityID(v)
			end
			net.sendMessage(MSG_SET_SELECTION, data)
		end
	end
end