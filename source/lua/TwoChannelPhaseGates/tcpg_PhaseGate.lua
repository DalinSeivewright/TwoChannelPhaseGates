local networkVarsOverride = {
    --Original Vars
    linked = "boolean",
    phase = "boolean",
    deployed = "boolean",
    destLocationId = "entityid",
    targetYaw = "float (-3.14159265 to 3.14159265 by 0.003)",
    destinationEndpoint = "position",
    phaseChannel = "integer (0 to 1)"
}


-- From Original NS2 PhaseGate.lua source
local function ComputeDestinationLocationId(self, destGate)

    local destLocationId = Entity.invalidId
    if destGate then

        local location = GetLocationForPoint(destGate:GetOrigin())
        if location then
            destLocationId = location:GetId()
        end

    end
    return destLocationId
end

-- Mostly from the original NS2 PhaseGate.lua source.
-- Added the phaseChannel checks.
local function GetDestinationGate(self)

    -- Find next phase gate to teleport to
    local phaseGates = {}
    for index, phaseGate in ipairs( GetEntitiesForTeam("PhaseGate", self:GetTeamNumber()) ) do
        if GetIsUnitActive(phaseGate) and self.phaseChannel == phaseGate.phaseChannel then
            table.insert(phaseGates, phaseGate)
        end
    end

    if table.count(phaseGates) < 2 then
        return nil
    end

    -- Find our index and add 1
    local index = table.find(phaseGates, self)
    if (index ~= nil) then

        local nextIndex = ConditionalValue(index == table.count(phaseGates), 1, index + 1)
        ASSERT(nextIndex >= 1)
        ASSERT(nextIndex <= table.count(phaseGates))
        return phaseGates[nextIndex]

    end

    return nil

end

-- Setup our default phaseChannel... probably not super needed here
local ns2_OnCreate = PhaseGate.OnCreate
function PhaseGate:OnCreate()
    ns2_OnCreate(self)
    self.phaseChannel = 0
end


if Server then
    -- From the NS2 PhaseGate.lua.  We need this here because GetDestinationGate and ComputeDestinationLocationId are
    -- local functions in the original source and we need to override them.
    -- WHY?  WHY OH WHY?
    function PhaseGate:Update()

        self.phase = (self.timeOfLastPhase ~= nil) and (Shared.GetTime() < (self.timeOfLastPhase + 0.3))

        local destinationPhaseGate = GetDestinationGate(self)
        if destinationPhaseGate ~= nil and GetIsUnitActive(self) and self.deployed and destinationPhaseGate.deployed then

            self.destinationEndpoint = destinationPhaseGate:GetOrigin()
            self.linked = true
            self.targetYaw = destinationPhaseGate:GetAngles().yaw
            self.destLocationId = ComputeDestinationLocationId(self, destinationPhaseGate)

        else
            self.linked = false
            self.targetYaw = 0
            self.destLocationId = Entity.invalidId
        end

        return true

    end

end



-- function PhaseGate:GetTechButtons(techId, teamIndex)
--
--     return { kTechId.None, kTechId.None, kTechId.None, kTechId.None,
--              kTechId.PhaseChannelA, kTechId.PhaseChannelB, kTechId.None, kTechId.None }
--
-- end

-- Tell the UI that we want our custom Phase Channel Tech Ids to be used as
-- Buttons.  They're setup to be Activation buttons which will trigger
-- PhaseGate:PerformActivation
function PhaseGate:GetTechButtons(techId)

    return { kTechId.None, kTechId.None, kTechId.None, kTechId.None,
             kTechId.PhaseChannelA, kTechId.PhaseChannelB, kTechId.None, kTechId.None }

end

-- Override client rendering so we can swap out portal models
function PhaseGate:OnUpdateRender()

    PROFILE("PhaseGate:OnUpdateRender")
    -- We only want to update our phase effects if we actually want to
    -- We will update our effects if a phase gate connection changes
    -- or if a gates channel changes.
    if self.clientLinked ~= self.linked or self.clientPhaseChannel ~= self.phaseChannel then
        -- Keep track of the last state
        self.clientLinked = self.linked
        self.clientPhaseChannel = self.phaseChannel

        -- If we are linked up and Visible
        -- (Not sure when we would ever not be Visible)
        -- we need to setup the proper effects.
        if self.linked and self:GetIsVisible() then
            -- Setup the effects according to our phase channel
            -- When we turn on one link effect, we need to turn off the other
            if self.phaseChannel == 0 then
                self:TriggerEffects("phase_gate_linked")
                self:TriggerEffects("phase_gate_unlinked_channel")
            else
                self:TriggerEffects("phase_gate_linked_channel")
                self:TriggerEffects("phase_gate_unlinked")
            end
        else
            -- If the gate isn't linked to anything, we need to turn off
            -- the other link effects
            self:TriggerEffects("phase_gate_unlinked")
            self:TriggerEffects("phase_gate_unlinked_channel")
        end
    end

end

-- Called by the UI when a Commander selects UI Buttons while a Phase gate
-- is selected.  By default only the Recycle would have shown.
-- We added two new buttons for Tech IDs PhaseChannelA and PhaseChannelB
-- This handles what those buttons do.
function PhaseGate:PerformActivation(techId, position, normal, commander)

    -- When PhaseChannelA is pressed turn the Phase Channel to 0 (default)
    if techId == kTechId.PhaseChannelA then
        self.phaseChannel = 0
        return true, true
    -- If Phase Channel B, turn to the custom Phase Channel
    elseif techId == kTechId.PhaseChannelB then
        self.phaseChannel = 1
        return true, true
    -- This will unfortunately disable Recycle if we don't specifically
    -- allow its activation here
    end
    return ScriptActor.PerformActivation(self, techId, position, normal, commander)
end

-- Enables/Disables our Channel Buttons.
-- If we're already on Phase Channel A for example we don't want the commander
-- Pressing it again and vice versa.
function PhaseGate:GetTechAllowed(techId, techNode, player)
    if techId == kTechId.PhaseChannelA or techId == kTechId.PhaseChannelB then
        if self.phaseChannel == 0 and techId == kTechId.PhaseChannelB then
            return true, true
        elseif self.phaseChannel == 1 and techId == kTechId.PhaseChannelA then
            return true, true
        end
        return false, true
    end
    return ScriptActor.GetTechAllowed(self, techId, techNode, player)
end

Shared.LinkClassToMap("PhaseGate", PhaseGate.kMapName, networkVarsOverride)
