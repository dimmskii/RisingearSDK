--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local actionCallbacks = {}

actions = {}

actions.SELECT = 0
actions.DESELECT = 1
actions.COPY = 2
actions.PASTE = 3
actions.CUT = 4
actions.DELETE = 5
actions.ENTCREATE = 6
actions.ENTMODIFY = 7
actions.HIDE = 8
actions.UNHIDE = 9
actions.UNDO = 10

local actionFuncs = {}

local actionMessages = {}

for k,v in pairs(actions) do
	local msgName = "EDITOR_ACTION_" .. tostring(k)
	console.log("Registering editor action message: " .. msgName)
	actionMessages[v] = net.registerMessage("editor_action_" .. msgName,
		function(sender, data)
			if SERVER and actionFuncs[v] then
				actionFuncs[v](data)
			end
			EDITOR.actionEvent(v)
		end,
	true)
end

EDITOR.actionAddCallback = function(funcCallback)
	table.insert(actionCallbacks, funcCallback)
end

EDITOR.actionEvent = function(action)
	if CLIENT then
		local data = nil
		if (actionFuncs[action]) then
			data = actionFuncs[action]()
		end
		net.sendMessage(actionMessages[action], data)
	end
	for k,v in pairs(actionCallbacks) do
		v(action)
	end
end


local undoEntries = {}

if SERVER then
  EDITOR.addUndoEntry = function(func, data)
    local entry = {}
    entry.func = func
    entry.data = data
    table.insert(undoEntries,entry)
  end
end

local clipboard = {}
local pasteNum = 1

EDITOR.copy = function(data)
	if CLIENT then
		local data = net.data()
		local entTable = {}
		for k,v in pairs(tools.selectedEnts) do
			data:writeEntityID(v)
		end
		return data
	elseif SERVER then
		clipboard = {} -- clear clipboard
		pasteNum = 1 -- to reset position, etc
		while data:hasNext() do
			local ent = ents.findByID( data:readNext() )
			if ent then
				table.insert(clipboard, ents.getEntityData(ent, ents.SNAP_MAP))
			end
		end
	end
end
actionFuncs[actions.COPY] = EDITOR.copy

EDITOR.paste = function(data)
	if SERVER then
	  local undoEntIDs = {}
		local newSelection = {}
		for _,entityData in ipairs(clipboard) do
			local ent = entityData:createEntity()
			ent.position.x = ent.position.x + 1*pasteNum -- TODO: Somehow fetch current grid size from client and move by that for ease of usage due to the user's using
			ent.position.y = ent.position.y + 1*pasteNum -- TODO: Somehow fetch current grid size from client and move by that for ease of usage due to the user's using
			ent:initialize()
			table.insert(newSelection,ent)
			table.insert(undoEntIDs,1,ent.id)
			pasteNum = pasteNum + 1
		end
		EDITOR.setSelection(newSelection)
		EDITOR.addUndoEntry(function(self)
		  for _,id in ipairs(self.data) do
		    ents.remove( ents.findByID(id) )
		  end
		end, undoEntIDs)
		
	end
end
actionFuncs[actions.PASTE] = EDITOR.paste

EDITOR.delete = function(data)
	if CLIENT then
		local data = net.data()
		local entTable = {}
		for k,v in pairs(tools.selectedEnts) do
			data:writeEntityID(v)
		end
		return data
	elseif SERVER then
	  local undoEntDatas = {}
		while( data:hasNext() ) do
			local ent = ents.findByID( data:readNext() )
			if ent then
			 table.insert( undoEntDatas, 1, ents.getEntityData(ent, ents.SNAP_MAP) )
			 ents.remove( ent )
			end
		end
		EDITOR.addUndoEntry(function(self)
      for _,entData in ipairs(self.data) do
        entData:createEntity()
      end
    end, undoEntDatas)
	end
end
actionFuncs[actions.DELETE] = EDITOR.delete

EDITOR.hide = function(data)
  if CLIENT then
   for k,v in pairs(tools.selectedEnts) do
    v:editor_hide()
   end
  end
end
actionFuncs[actions.HIDE] = EDITOR.hide

EDITOR.unhide = function(data)
  if CLIENT then
   for k,v in pairs(tools.selectedEnts) do
    v:editor_unhide()
   end
  end
end
actionFuncs[actions.UNHIDE] = EDITOR.unhide

EDITOR.undo = function(data)
  if SERVER then
    local n = #undoEntries
    if n > 0 then
      undoEntries[n]:func()
      undoEntries[n] = nil
    end
  end
end
actionFuncs[actions.UNDO] = EDITOR.undo
