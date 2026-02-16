-- ResearchSystem.lua
-- Manages technology research tree and upgrades

local ResearchSystem = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)

-- Research state
local researchedTechnologies = {}
local activeResearch = nil
local researchProgress = 0

function ResearchSystem.Initialize()
	researchedTechnologies = {}
	activeResearch = nil
	researchProgress = 0
end

function ResearchSystem.IsResearched(technologyName)
	return researchedTechnologies[technologyName] == true
end

function ResearchSystem.CanResearch(technologyName)
	local tech = GameConfig.Research.Technologies[technologyName]
	
	if not tech then
		return false, "Technology not found"
	end
	
	-- Check if already researched
	if ResearchSystem.IsResearched(technologyName) then
		return false, "Already researched"
	end
	
	-- Check if there's active research
	if activeResearch then
		return false, "Another research is in progress"
	end
	
	-- Check prerequisites
	if tech.Requires then
		for _, requirement in ipairs(tech.Requires) do
			if not ResearchSystem.IsResearched(requirement) then
				return false, "Requires: " .. requirement
			end
		end
	end
	
	return true, "Can research"
end

function ResearchSystem.StartResearch(technologyName, playerMoney)
	local canResearch, reason = ResearchSystem.CanResearch(technologyName)
	
	if not canResearch then
		return false, reason
	end
	
	local tech = GameConfig.Research.Technologies[technologyName]
	
	-- Check if player has enough money
	if playerMoney < tech.Cost then
		return false, "Not enough money"
	end
	
	-- Start research
	activeResearch = technologyName
	researchProgress = 0
	
	print("Started researching: " .. technologyName)
	return true, "Research started"
end

function ResearchSystem.UpdateResearch(deltaTime)
	if not activeResearch then return end
	
	local tech = GameConfig.Research.Technologies[activeResearch]
	researchProgress = researchProgress + deltaTime
	
	-- Check if research is complete
	if researchProgress >= tech.ResearchTime then
		ResearchSystem.CompleteResearch()
	end
end

function ResearchSystem.CompleteResearch()
	if not activeResearch then return end
	
	local tech = GameConfig.Research.Technologies[activeResearch]
	researchedTechnologies[activeResearch] = true
	
	print("Research completed: " .. activeResearch)
	print("Unlocked: " .. table.concat(tech.Unlocks, ", "))
	
	local completedTech = activeResearch
	activeResearch = nil
	researchProgress = 0
	
	return completedTech, tech.Unlocks
end

function ResearchSystem.CancelResearch()
	if not activeResearch then return false end
	
	print("Research cancelled: " .. activeResearch)
	activeResearch = nil
	researchProgress = 0
	
	return true
end

function ResearchSystem.GetActiveResearch()
	if not activeResearch then return nil end
	
	local tech = GameConfig.Research.Technologies[activeResearch]
	local progressPercent = (researchProgress / tech.ResearchTime) * 100
	
	return {
		Name = activeResearch,
		Progress = progressPercent,
		TimeRemaining = tech.ResearchTime - researchProgress,
		Cost = tech.Cost
	}
end

function ResearchSystem.GetAvailableTechnologies()
	local available = {}
	
	for techName, techData in pairs(GameConfig.Research.Technologies) do
		local canResearch, reason = ResearchSystem.CanResearch(techName)
		
		table.insert(available, {
			Name = techName,
			Cost = techData.Cost,
			ResearchTime = techData.ResearchTime,
			Unlocks = techData.Unlocks,
			Requires = techData.Requires,
			CanResearch = canResearch,
			Reason = reason,
			IsResearched = ResearchSystem.IsResearched(techName)
		})
	end
	
	return available
end

function ResearchSystem.GetResearchedTechnologies()
	local researched = {}
	
	for techName, _ in pairs(researchedTechnologies) do
		local techData = GameConfig.Research.Technologies[techName]
		table.insert(researched, {
			Name = techName,
			Unlocks = techData.Unlocks
		})
	end
	
	return researched
end

function ResearchSystem.GetTechnologyBonus(bonusType)
	local bonus = 0
	
	-- Check researched technologies for specific bonuses
	if bonusType == "Productivity" then
		if ResearchSystem.IsResearched("AIAssistant") then
			bonus = bonus + 0.2
		end
	elseif bonusType == "Revenue" then
		if ResearchSystem.IsResearched("MultiplayerSystem") then
			bonus = bonus + 0.5
		end
		if ResearchSystem.IsResearched("CrossPlatform") then
			bonus = bonus + 1.0
		end
	end
	
	return bonus
end

function ResearchSystem.Serialize()
	return {
		ResearchedTechnologies = researchedTechnologies,
		ActiveResearch = activeResearch,
		ResearchProgress = researchProgress
	}
end

function ResearchSystem.Deserialize(data)
	if data then
		researchedTechnologies = data.ResearchedTechnologies or {}
		activeResearch = data.ActiveResearch
		researchProgress = data.ResearchProgress or 0
	end
end

return ResearchSystem
