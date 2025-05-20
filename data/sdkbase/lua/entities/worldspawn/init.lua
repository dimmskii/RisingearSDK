--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:initialize()
	self:initProperty("ambientLightColor", color.WHITE)
	self:initProperty("music", "")
	self:initProperty("musicStart", false)
	self:initProperty("musicLoop", true)
	ENT_BASE.initialize( self )
end

local function updateAmbientLightColor(col)
	if not CLIENT then return end
	if EDITOR and not editor_config.get("editor_view_lighting") then return end
  renderables.setAmbientLightColor(col)
end

function ENT:setAmbientLightColor(col)
	self.ambientLightColor = col
	if SERVER then
		self.ambientLightColorDirty = true
	elseif CLIENT then
		updateAmbientLightColor()
	end
end

function ENT.persist( thisClass )
	ENT_BASE.persist( thisClass )
		
	ents.persist(thisClass, "ambientLightColor", {
    write=function(field, data, ent) data:writeColor(field) ent.ambientLightColorDirty=false end,
    read=function(data) local col = data:readNext() updateAmbientLightColor(col) return col end,
    dirty=function(field, ent) return ent.ambientLightColorDirty end,
  }, ents.SNAP_NET + ents.SNAP_MAP)
  
	ents.persist(thisClass, "music", {
		write=function(field, data) data:writeString(field) end,
		read=function(data) return data:readNext() end,
		dirty=function() return false end,
	}, ents.SNAP_NET + ents.SNAP_MAP)
	
	ents.persist(thisClass, "musicStart", {
		write=function(field, data) data:writeBool(field) end,
		read=function(data) return data:readNext() end,
		dirty=function() return false end,
	}, ents.SNAP_NET + ents.SNAP_MAP)
	
	ents.persist(thisClass, "musicLoop", {
		write=function(field, data) data:writeBool(field) end,
		read=function(data) return data:readNext() end,
		dirty=function() return false end,
	}, ents.SNAP_NET + ents.SNAP_MAP)
	
end

if EDITOR then
	include("editor.lua")
end

if SERVER then
	include("sv_init.lua")
	
elseif CLIENT then
	
	function ENT:cl_initialize()
		ENT_BASE.cl_initialize(self)
		updateAmbientLightColor(self.ambientLightColor)
	end
	


	function ENT:cl_onJoin()
		ENT_BASE.cl_onJoin(self)
		if self.musicStart and not EDITOR then
			if type(self.music)=="string" and string.len(self.music) > 0 then
				local mus = audio.music(self.music)
				if mus then
					if (self.musicLoop) then
						mus:loop()
					else
						mus:play()
					end
				end
			end
		else
			audio.pauseMusic()
		end
	end
	
end
