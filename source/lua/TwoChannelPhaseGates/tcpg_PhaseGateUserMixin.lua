
local kPhaseDelay = 2

PhaseGateUserMixin.networkVars =
{
    timeOfLastPhase = "compensated private time",
    timeOfLastPhase0 = "compensated private time",
    timeOfLastPhase1 = "compensated private time"
}

local function SharedUpdate(self)
	for _, phaseGate in ipairs(GetEntitiesForTeamWithinRange("PhaseGate", self:GetTeamNumber(), self:GetOrigin(), 0.5)) do
		local channel = phaseGate.phaseChannel or 0
		if self:GetCanPhase(channel) and phaseGate:GetIsDeployed() and GetIsUnitActive(phaseGate) and phaseGate:Phase(self) then

			self.timeOfLastPhase = Shared.GetTime()
			
			if channel == 0 then
				self.timeOfLastPhase0 = Shared.GetTime()
			elseif channel == 1 then
				self.timeOfLastPhase1 = Shared.GetTime()
			end

			
			if Client then               
				self.timeOfLastPhaseClient = Shared.GetTime()
				local viewAngles = self:GetViewAngles()
				Client.SetYaw(viewAngles.yaw)
				Client.SetPitch(viewAngles.pitch)     
			end
			--[[
			if HasMixin(self, "Controller") then
				self:SetIgnorePlayerCollisions(1.5)
			end
			--]]
			break
			
		end
	end
end

function PhaseGateUserMixin:OnProcessMove(input)
	SharedUpdate(self)
end


if Server then

    function PhaseGateUserMixin:OnUpdate(deltaTime)    
        PROFILE("PhaseGateUserMixin:OnUpdate")
		SharedUpdate(self)
    end

end


function PhaseGateUserMixin:GetCanPhase(channel)

	local timeOfPhase = self.timeOfLastPhase
	if channel == 0 then
		timeOfPhase = self.timeOfLastPhase0
	elseif channel == 1 then
		timeOfPhase = self.timeOfLastPhase1
	end

    if Server then
        return self:GetIsAlive() and Shared.GetTime() > timeOfPhase + kPhaseDelay and not GetConcedeSequenceActive()
    else
        return self:GetIsAlive() and Shared.GetTime() > timeOfPhase + kPhaseDelay
    end
    
end
