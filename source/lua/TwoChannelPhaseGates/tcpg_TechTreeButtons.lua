-- Because NS2 uses a large sprite sheet we cannot have a custom button icon
-- But The PhaseTech Icon will certain work!
local ns2_GetMaterialXYOffset = GetMaterialXYOffset
function GetMaterialXYOffset(techId)
    if techId == kTechId.PhaseChannelA or techId == kTechId.PhaseChannelB then
        techId = kTechId.PhaseTech
    end
    return ns2_GetMaterialXYOffset(techId)
end
