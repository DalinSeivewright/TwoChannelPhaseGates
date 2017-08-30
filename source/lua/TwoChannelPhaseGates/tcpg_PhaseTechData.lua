-- Adds custom TechData for our Phase Channel Button activations.
-- No Localizations are setup so players will just see the English strings below.
local ns2_BuildTechData = BuildTechData

local kPhaseGateChannelStrings = {}
kPhaseGateChannelStrings["PHASE_GATE_CHANNEL_A"] = "Channel A"
kPhaseGateChannelStrings["PHASE_GATE_CHANNEL_A_TOOLTIP"] = "Switch Phase Gate to Channel A"
kPhaseGateChannelStrings["PHASE_GATE_CHANNEL_B"] = "Channel B"
kPhaseGateChannelStrings["PHASE_GATE_CHANNEL_B_TOOLTIP"] = "Switch Phase Gate to Channel B"

function BuildTechData()

    local techData = ns2_BuildTechData()

    local phaseTechData =
    {
        {
            [kTechDataId] = kTechId.PhaseChannelA,
            [kTechDataDisplayName] = kPhaseGateChannelStrings["PHASE_GATE_CHANNEL_A"],
            [kTechIDShowEnables] = false,
            [kTechDataMenuPriority] = 2,
            [kTechDataHotkey] = Move.D,
            [kTechDataTooltipInfo] = kPhaseGateChannelStrings["PHASE_GATE_CHANNEL_A_TOOLTIP"]
        },
        {
            [kTechDataId] = kTechId.PhaseChannelB,
            [kTechDataDisplayName] = kPhaseGateChannelStrings["PHASE_GATE_CHANNEL_B"],
            [kTechIDShowEnables] = false,
            [kTechDataMenuPriority] = 3,
            [kTechDataHotkey] = Move.D,
            [kTechDataTooltipInfo] = kPhaseGateChannelStrings["PHASE_GATE_CHANNEL_B_TOOLTIP"]
        }
    }
    -- Append our new Tech Data items to the Tech Data table.
    for i, k in pairs(phaseTechData) do
        table.insert(techData, phaseTechData[i])
    end

    return techData
end
