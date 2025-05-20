--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--

if CLIENT then
	include("cl_bullet.lua")
end

local BULLET_DISTANCE = 500 -- 500m

local function processBulletMessage(sender, data)
	if CLIENT then
		local entAttacker = ents.findByID(data:readNext())
		local entWeapon = ents.findByID(data:readNext())
		local vecFrom = data:readNext()
		local vecTo = data:readNext()
		local entHit = ents.findByID(data:readNext())
		local bDrawDebug = data:readNext()
		
		-- DEBUG SHOT RAYCAST CODE
		if bDrawDebug then
			local rendComposite = renderables.composite()
			local rendLine = renderables.fromShape(geom.line(vecFrom.x,vecFrom.y,vecTo.x,vecTo.y))
			rendComposite:addRenderable(rendLine)
			rendLine = renderables.fromShape(geom.line(vecTo.x - 0.05,vecTo.y-0.05,vecTo.x+0.05,vecTo.y+0.05))
			rendLine.outlineColor = color.RED
			rendComposite:addRenderable(rendLine)
			rendLine = renderables.fromShape(geom.line(vecTo.x - 0.05,vecTo.y+0.05,vecTo.x+0.05,vecTo.y-0.05))
			rendLine.outlineColor = color.RED
			rendComposite:addRenderable(rendLine)
			renderables.add(rendComposite)-- Draw line sent to our clientside resulting from a server-sided jbox raycast -- needs cvar with cheat protection
			rendComposite:setLayer(renderables.LAYER_POST_GAME)
			timer.simple(1, function() renderables.remove(rendComposite) return end) -- remove old ones after a second or so -- needs cvar
		end
		
		bullet_tracers.create(vecFrom,vecTo)
	end
end

local MSG_BULLET = net.registerMessage("bullet", processBulletMessage)

if SERVER then
	local bDrawDebug = cvars.bool("sv_debug_bullet_traces")

	local function doServerBullet(entAttacker, entWeapon, vecFrom, vecTo, fAngle, vecNormal, entHit, iDamage, fForce)
--		local entHit = nil
--		if fixtureHit then
--			local bodyHit = fixtureHit:getBody()
--			local vecForce = geom.vec2(fForce,0)
--			vecForce:setTheta(math.deg(fAngle))
--			bodyHit:applyForce(vecForce, vecTo)
--			local entHit = bodyHit:getUserData() -- TODO: verify
--			
--			if entHit and entHit ~= entAttacker then
--				entHit:takeDamage(iDamage, entAttacker, entWeapon)
--			end
--		end
		
	 	-- Broadcast it out to clients
		local data = net.data()
		data:writeEntityID(entAttacker)
		data:writeEntityID(entWeapon)
		data:writeVec2(vecFrom)
		data:writeVec2(vecTo)
		data:writeEntityID(entHit)
		data:writeBool(bDrawDebug or false)
		net.sendMessage(MSG_BULLET, data)
	end
	
	local function isShotThrough(fixtureHit, entAttacker)
		local bodyHit = fixtureHit:getBody()
		if (bodyHit) then
			local entHit = bodyHit:getUserData()
			if (entHit) then
				return entHit == entAttacker or entHit.platform
			end
		end
		return false
	end
	
	---
	--Returns a normal if line intersects shape; nil if not
	local function testIntersection()
	 
	end
	
	function GM:fireBullet( entAttacker, entWeapon, vecFrom, fAngle, iDamage, fForce )
		iDamage = iDamage or 0
		fForce = fForce or 0
		
		local vecTo = geom.vec2(BULLET_DISTANCE, 0)
		vecTo:setTheta(math.deg(fAngle))
		vecTo:addLocal(vecFrom)
	  
		local scanLine = geom.line(vecFrom.x,vecFrom.y,vecTo.x,vecTo.y)
		local allEnts = ents.getAll()
		for id,ent in pairs(allEnts) do
		  if ents.isClass(ent,"char_base",true) then
		    print("chyarna")
		  elseif ents.isClass(ent,"phys_base",true) then
		    print("physma")
		  end
		end
		
		
		local vecNormal = geom.vec2()
		doServerBullet( entAttacker, entWeapon, vecFrom, vecTo:clone(), fAngle, vecNormal, nil, iDamage, fForce )
		
	end
	hook.ensureExists("fireBullet")

end
