--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


editor_config = {}
editor_config.TYPE_BOOL = 0
editor_config.TYPE_INT = 1
editor_config.TYPE_REAL = 2
editor_config.TYPE_STRING = 3

local entries = {}

editor_config.register = function(name, default, type)
	cvars.register(name,default,cvars.CA_ARCHIVED)
	local entry = {}
	entry.name = name
	entry.default = default
	entry.type = type
	entry.value = nil
	entries[name] = entry
end

editor_config.set = function(name, value)
	local entry=entries[name]
	cvars.set(name, value)
	
	local val
	
	if (entry.type == editor_config.TYPE_BOOL) then
		val = cvars.bool(name, entry.default)
	elseif (entry.type == editor_config.TYPE_INT) then
		val = cvars.int(name, entry.default)
	elseif (entry.type == editor_config.TYPE_REAL) then
		val = cvars.real(name, entry.default)
	else
		val = cvars.string(name, entry.default)
	end
	
	entry.value = val
	
end

editor_config.get = function(name)
	local entry=entries[name]
	
	if (entry ~= nil and entry.value ~= nil) then
		return entry.value
	end
	
	local val
	
	if (entry.type == editor_config.TYPE_BOOL) then
		val = cvars.bool(name, entry.default)
	elseif (entry.type == editor_config.TYPE_INT) then
		val = cvars.int(name, entry.default)
	elseif (entry.type == editor_config.TYPE_REAL) then
		val = cvars.real(name, entry.default)
	else
		val = cvars.string(name, entry.default)
	end
	
	entry.value = val
	return val
end
