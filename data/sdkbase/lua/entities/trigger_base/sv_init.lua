--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:postMapLoad()
	ENT_BASE.postMapLoad( self )
	
	self:updateTargetEnts()
	self:updateSourceEnts()
end

cvars.register( "sv_debug_triggers", false, cvars.CA_ARCHIVED)

function ENT:triggerTargets( entSource )
	if (EDITOR) then return end -- We don't trigger on editor
	
	self:updateTargetEnts()
	
	local debugTriggers = cvars.bool( "sv_debug_triggers" ) -- TODO: PERF: cvar listener + localize in this file once.
	
	if ( debugTriggers ) then
		console.log("---------------------------------------------------------------")
		console.log(tostring(self.CLASSNAME) .. " with tag '" .. tostring(self.tag) .. "' (id=" .. tostring(self.id) .. ") triggering all targets")
		console.log("Target tag is '" .. tostring(self.targetTag) .. "'")
	end
	
	for k,v in pairs(self.targetEnts) do
		if ( debugTriggers ) then
			console.log("  |---> " .. tostring(v.CLASSNAME) .. " (" .. "id=" .. tostring(v.id) .. ") triggered")
		end
		v:trigger(entSource, self) -- trigger my targets with given source and self as immediate caller
	end
	
	if ( debugTriggers ) then
		if (entSource) then
			console.log("source is a " .. tostring(entSource.CLASSNAME) .. " with tag '" .. tostring(entSource.tag) .. "' (id=" .. tostring(entSource.id) .. ")")
		else
			console.log("source is nil")
		end
		console.log("---------------------------------------------------------------")
	end
end
