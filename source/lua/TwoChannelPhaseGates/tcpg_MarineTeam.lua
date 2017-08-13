
-- Adds the new PhaseChannel Tech Ids to the list of available activations
-- The comm can use.  No requirements because we only handle these on
-- the Phase Gate
local ns2_InitTechTree = MarineTeam.InitTechTree
function MarineTeam:InitTechTree()
    ns2_InitTechTree(self)
    self.techTree:AddActivation(kTechId.PhaseChannelA)
    self.techTree:AddActivation(kTechId.PhaseChannelB)
    self.techTree:SetComplete()
end
