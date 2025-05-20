--	--------------------------------------------------------------	--
--	THIS FILE IS PART OF THE GEARSPACE BASE GAME CODEBASE			--
--	COPYRIGHT (c) DMITRI POTERIANSKI 2021,							--
--	ALL RIGHTS RESERVED												--
--	DO NOT REDISTRIBUTE THIS FILE WITHOUT PERMISSION FROM AUTHOR	--
--	--------------------------------------------------------------	--


local ENT_BASE = ents.getClass(ENT.CLASSNAME_BASE)

function ENT:createJoint(entTargetA, entPhysA, entTargetB, entPhysB)

end

  function ENT:removeJoint()
    ents.remove(self.jointEnt)
  end

function ENT:onUpdatedTags()
  if EDITOR then return end
  if self.jointEnt and self.jointEnt.valid then
    self:removeJoint()
  end
  if self.sourceEnts and self.targetEnts then
    local sourceEnt = self.sourceEnts[1]
    local targetEnt = self.targetEnts[1]
    local ent1, ent2
    if sourceEnt and sourceEnt.valid then
      if ents.isClass(sourceEnt,"target_physics",false) then
        ent1=sourceEnt.physEnt
      elseif ents.isClass(sourceEnt,"phys_base",true) then
        ent1=sourceEnt
      end
    end
    if targetEnt and targetEnt.valid then
      if ents.isClass(targetEnt,"target_physics",false) then
        ent2=targetEnt.physEnt
      elseif ents.isClass(targetEnt,"phys_base",true) then
        ent2=targetEnt
      end
    end
    if ent1 and ent1.valid and ent2 and ent2.valid then
      self.jointEnt = self:createJoint(sourceEnt, ent1, targetEnt, ent2)
    end
  end
end

-- We use a hook to truly run this post-map-load ensure all tags have been set already
local function postMapLoad()
  if EDITOR then return end
  local allEnts = ents.getAll()
  for k,v in pairs(allEnts) do
    if v and v.valid and ents.isClass(v,"trigger_phys_joint",true) then v:onUpdatedTags() end -- TODO: why do some ents ent up nil or not valid post map load ents.getAll(). we shouldn't have to check at this point?
  end
end
hook.add("postMapLoad", "postMapLoad_createJoints", postMapLoad)


function ENT:updateTargetEnts()
  ENT_BASE.updateTargetEnts( self )
  if not EDITOR then
    self:onUpdatedTags()
  end
end

function ENT:updateSourceEnts()
  ENT_BASE.updateSourceEnts( self )
  if not EDITOR then
    self:onUpdatedTags()
  end
end
