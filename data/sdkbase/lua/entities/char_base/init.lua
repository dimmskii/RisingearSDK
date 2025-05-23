--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

local movementCreate
local function createMovementTable()
	-- Initialize movement
	movementCreate = {}
	movementCreate.landed = false
	movementCreate.crouched = false
	movementCreate.direction = 0
	movementCreate.running = false
	movementCreate.climbing = false
	movementCreate.using = false
	movementCreate.attacking = false
	movementCreate.reloading = false
	movementCreate.up = false
	movementCreate.down = false
	movementCreate.platformVelocity = geom.vec2()
	return movementCreate
end

local function writeMovementTable(movement, data)
	-- Write movement to data
	data:writeBool(movement.landed)
	data:writeBool(movement.crouched)
	data:writeByte(movement.direction)
	data:writeBool(movement.running)
	data:writeBool(movement.climbing)
	data:writeBool(movement.using)
	data:writeBool(movement.attacking)
	data:writeBool(movement.reloading)
	data:writeBool(movement.up)
	data:writeBool(movement.down)
	data:writeVec2(movement.platformVelocity)
end

local movementRead
local function readMovementTable(data)
	-- Read movement from data
	movementRead = {}
	movementRead.landed = data:readNext()
	movementRead.crouched = data:readNext()
	movementRead.direction = data:readNext()
	movementRead.running = data:readNext()
	movementRead.climbing = data:readNext()
	movementRead.using = data:readNext()
	movementRead.attacking = data:readNext()
	movementRead.reloading = data:readNext()
	movementRead.up = data:readNext()
	movementRead.down = data:readNext()
	movementRead.platformVelocity = data:readNext()
	return movementRead
end

local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

ENT.LAZY_UPDATE_DISTANCE = 40

ENT.maxHealth = 100

function ENT:initialize()
	
	self.platformConscious = true -- Characters can jump from underneath unto the platforms above the heads theirs
	
	self:initProperty("health", self.maxHealth)
	
	self:initProperty("mirrored", false)
	
	self:initProperty("ragdollAngles",{})
	
	self:initProperty("ragdollDismem",{})
	
	self:initProperty("animationPlay", true)
	
	self:initProperty("aimVec", geom.vec2())
	
	self:initProperty("useTarget", nil)
	
	self:initProperty("weapon", nil)
	
	self:initProperty("alive", true)
	
	self:initProperty("movement", createMovementTable())
	
	self:initProperty("aiClass", "")
	
	if SERVER then
		self.healthDirty = false
		self.aliveDirty = false
	end
	
	self:initSkeletal()
	
	ENT_BASE.initialize( self )
end

-- Initialize self.skeleton in this function
function ENT:initSkeletal()

end

function ENT:setAnimationPlay( iAnimationPlay )
	self.animationPlay = iAnimationPlay
	if not self.skeleton then return end
	self.skeleton:setAnimationPlay( iAnimationPlay )
end

function ENT:aimAt( x, y )
	self.aimVec.x = x - self.position.x
	self.aimVec.y = y - self.position.y
end

function ENT:getHealth()
	return self.health
end

function ENT:setHealth( iHealth )
	self.health = iHealth
	if SERVER then
		self.healthDirty = true
	end
end

function ENT:getAimVec()
	return self.aimVec:clone()
end

function ENT:getAimVecWorld()
	return self.aimVec:add(self.position)
end

function ENT:getEyePos()
	return geom.vec2(self.position.x, self.position.y)
end

local fixtureUserData, bodyHit
function ENT:canSee( vecPos )
	local bHit = false
	local callback = phys.newRayCastCallback( function(fixtureHit, vecPoint, vecNormal, fFraction)
		bodyHit = fixtureHit:getBody()
		fixtureUserData = fixtureHit:getUserData() or bodyHit:getUserData()
		if fixtureUserData and fixtureUserData.valid and not fixtureUserData.platform and bodyHit.m_type == phys.BT_STATIC then
			bHit = true
			return 0 -- 0 to terminate raycast
		end
		return -1 -- -1 to filter (1 continues)
		
	end)
	phys.getWorld():raycast( callback, self:getEyePos(), vecPos )
	
	return bHit == false -- Return not bHit
end

function ENT:getMuzzlePos()
	return geom.vec2(self.position.x, self.position.y)
end

function ENT:think( delta )
	if self.skeleton then
		self:updateSkeletalAnim( delta )
		self:updateSkeleton( delta )
	end
	
	ENT_BASE.think( self, delta )
end

function ENT:updateSkeletalAnim( delta )
	
end

function ENT:isAlive()
	return self.alive
end

function ENT:setAlive(bAlive)
	self.alive = alive
	if SERVER then
		self.aliveDirty = true
	end
end

ENT.MSG_CHAR_DROP_WEAPON = net.registerMessage( "char_drop_weapon", function(sender, data)
	local entChar = ents.findByID(data:readNext())
	entChar:onDropWeapon()
end )

function ENT:onDropWeapon()
	
end

function ENT:doWeaponRecoil( fRecoilRads )

end

if SERVER then
	include("sv_init.lua")
elseif CLIENT then
	include("cl_init.lua")
end

if EDITOR then
	include("editor.lua")
end

function ENT.persist( thisClass )
		
	ENT_BASE.persist( thisClass )
	
--	ents.persist(thisClass, "sprFrame", {
--			write=function(field, data, ent) data:writeInt(field) end,
--			read=function(data) return data:readNext() end,
--		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "mirrored", {
			write=function(field, data, ent) data:writeBool(field) end,
			read=function(data) return data:readNext() end,
		}, ents.SNAP_NET)
	
	ents.persist(thisClass, "ragdollAngles", {
			write=function(field, data, ent)
				for k,v in pairs(field) do
					data:writeString(k)
					data:writeFloat(v)
				end
			end,
			read=function(data, ent)
				local angs = {}
				while (data:hasNext()) do
					angs[data:readNext()] = data:readNext()
				end
				return angs
			end,
			dirty=function(field, ent) -- return dirty true for ragdollAngles only if at least some phys limbs are awake
				for _,v in ipairs(ent.bodies) do
					if v:isAwake() then return true end
				end
				return false
			end
		}, ents.SNAP_NET)
		
		ents.persist(thisClass, "ragdollDismem", {
      write=function(field, data, ent)
        for k,v in pairs(field) do
          data:writeString(v)
        end
        ent.ragdollDismemDirty = false
      end,
      read=function(data, ent)
        local tab = {}
        while (data:hasNext()) do
          table.insert(tab,data:readNext())
        end
        ent:cl_updateDismemberment(tab)
        return tab
      end,
      dirty=function(field, ent) return ent.ragdollDismemDirty end,
    }, ents.SNAP_NET + ents.SNAP_SAV)
		
	ents.persist(thisClass, "aimVec", {
			write=function(field, data, ent) data:writeFloat(field.x) data:writeFloat(field.y) ent.aimVecDirty=false end,
			read=function(data) return geom.vec2(data:readNext(),data:readNext()) end,
			dirty=function(field, ent) return ent.aimVecDirty end,
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "animationPlay", {
			write=function(field, data, ent) data:writeShort(field) end,
			read=function(data, ent)
				local iPlay = data:readNext()
				ent:setAnimationPlay(iPlay)
				return iPlay
			end,
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "health", {
			write=function(field, data, ent)
				data:writeShort(field)
				ent.healthDirty = false
			end,
			read=function(data, ent) return data:readNext() end,
			dirty=function(field, ent) return ent.healthDirty end,
		}, ents.SNAP_ALL)
		
	ents.persist(thisClass, "alive", {
			write=function(field, data, ent)
				data:writeBool(field)
				ent.aliveDirty = false
			end,
			read=function(data, ent) return data:readNext() end,
			dirty=function(field, ent) return ent.aliveDirty end,
		}, ents.SNAP_ALL )
		
	ents.persist(thisClass, "useTarget", {
			write=function(field, data, ent)
--				if field == nil then
--					data:writeInt(-1)
--				else
--					data:writeInt(field.id)
--				end
				data:writeEntityID(field)
				ent.useTargetDirty=false
			end,
			read=function(data, ent)
				--local entID = data:readNext()
				--if entID == nil or entID < 0 then return nil end
				--local useTargetEnt = ents.findByID(entID)
				--return useTargetEnt
				return ents.findByID(data:readNext())
			end,
			dirty=function(field, ent) return ent.useTargetDirty end
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "weapon", {
			write=function(field, data, ent)
				data:writeEntityID(field)
				ent.weaponDirty=false
			end,
			read=function(data, ent)
				return ents.findByID(data:readNext())
			end,
			dirty=function(field, ent) return ent.weaponDirty end
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "movement", {
			write=function(field, data, ent)
				writeMovementTable(field, data)
			end,
			read=function(data)
				return readMovementTable(data)
			end,
			dirty=function() return true end -- TODO: dirty on movement change only! save bandwitdh
		}, ents.SNAP_NET)
		
	ents.persist(thisClass, "aiClass", {
			write=function(field, data, ent)
				data:writeString(field)
			end,
			read=function(data)
				return data:readNext()
			end,
		}, ents.SNAP_MAP)
end
