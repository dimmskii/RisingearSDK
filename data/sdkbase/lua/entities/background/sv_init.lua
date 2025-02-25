--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:postMapLoad()
	ENT_BASE.postMapLoad(self)
	self:setStencilEntsTag(self.stencilEntsTag) -- Workaround for not showing until apply pressed in editor, etc
end
	
hook.add("onEntityCreated", "background_onEntityCreated", function(ent)
	for k,v in pairs(ents.getAll("background")) do
		v:setStencilEntsTag(v.stencilEntsTag)  -- Workaround for not showing until apply pressed in editor, etc
	end
end)
