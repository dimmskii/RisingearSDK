--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:updateMotion( delta )
	-- On the client side, this [entity base] method essentially is client-side prediction
	-- Physics ents will override this and prevent increment of delta angle based on angular velocity coming in from server
	-- This will prevent the jittery rotations that are especially noticeable with circular bouncy balls or tires rotating and translating at the same time
	self.position = self.position:add( self.velocity:mul(delta) )
--	self.angle = self.angle + self.angleVelocity * delta -- We don't
end

function ENT:addAsListenerToFixture( fixture )
end
