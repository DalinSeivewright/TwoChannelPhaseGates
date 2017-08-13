-- Custom Effect Cinematics for the "Channel B" phase gate mode.
-- Will probably rename these effects later
local kPhaseGateEffects = {
    phase_gate_linked_channel =
    {
        pgLinkedEffectsA =
        {
            -- Play spin for spinning infantry portal
            {looping_cinematic = "cinematics/TwoChannelPhaseGates/phasegate_channel.cinematic"},
        },
    },

    phase_gate_unlinked_channel =
    {
        pgLinkedEffectsA =
        {
            -- Destroy it if not spinning
            {stop_cinematic = "cinematics/TwoChannelPhaseGates/phasegate_channel.cinematic", done = true},
        },
    },
}
GetEffectManager():AddEffectData("MarineStructureEffects", kPhaseGateEffects)
