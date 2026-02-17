-- GameDevPipeline.lua
-- Manages the game development lifecycle from pre-production to post-production

local GameDevPipeline = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)

-- Project class
local Project = {}
Project.__index = Project

function Project.new(name, genre, targetQuality)
	local self = setmetatable({}, Project)
	
	self.Id = game:GetService("HttpService"):GenerateGUID(false)
	self.Name = name or ("Game_" .. math.random(1000, 9999))
	self.Genre = genre
	self.TargetQuality = targetQuality or 0.7
	
	-- Development phases
	self.Phase = "PreProduction"
	self.Progress = 0
	self.TotalWork = 0
	
	-- Calculate required work for each phase
	self.PhaseWork = {
		PreProduction = 100,
		Production = 300,
		PostProduction = 100
	}
	
	-- Quality metrics
	self.QualityScore = 0
	self.DesignQuality = 0
	self.CodeQuality = 0
	self.TestingQuality = 0
	
	-- Team assignment
	self.AssignedEmployees = {}
	
	-- Status
	self.IsActive = false
	self.StartTime = 0
	self.CompletionTime = nil
	
	-- Market data
	self.Revenue = 0
	self.Reputation = 0
	
	return self
end

function Project:AssignEmployee(employee)
	table.insert(self.AssignedEmployees, employee)
	employee.CurrentTask = self.Id
end

function Project:RemoveEmployee(employee)
	for i, emp in ipairs(self.AssignedEmployees) do
		if emp.Id == employee.Id then
			table.remove(self.AssignedEmployees, i)
			employee.CurrentTask = nil
			break
		end
	end
end

function Project:Start()
	self.IsActive = true
	self.StartTime = tick()
	self.Phase = "PreProduction"
	self.Progress = 0
end

function Project:UpdateProgress(deltaTime, teamProductivity)
	if not self.IsActive then return end
	
	local workDone = teamProductivity * deltaTime
	self.Progress = self.Progress + workDone
	self.TotalWork = self.TotalWork + workDone
	
	-- Update quality based on phase
	if self.Phase == "PreProduction" then
		self.DesignQuality = math.min(1, self.Progress / self.PhaseWork.PreProduction)
	elseif self.Phase == "Production" then
		self.CodeQuality = math.min(1, self.Progress / self.PhaseWork.Production)
	elseif self.Phase == "PostProduction" then
		self.TestingQuality = math.min(1, self.Progress / self.PhaseWork.PostProduction)
	end
	
	-- Check if phase is complete
	if self.Progress >= self.PhaseWork[self.Phase] then
		self:CompletePhase()
	end
end

function Project:CompletePhase()
	print("Phase " .. self.Phase .. " completed for " .. self.Name)
	
	self.Progress = 0
	
	if self.Phase == "PreProduction" then
		self.Phase = "Production"
	elseif self.Phase == "Production" then
		self.Phase = "PostProduction"
	elseif self.Phase == "PostProduction" then
		self:Complete()
	end
end

function Project:Complete()
	self.IsActive = false
	self.CompletionTime = tick()
	
	-- Calculate final quality score
	self.QualityScore = (self.DesignQuality + self.CodeQuality + self.TestingQuality) / 3
	
	-- Apply genre popularity multiplier
	local genrePopularity = GameDevPipeline.GetGenrePopularity(self.Genre)
	
	-- Calculate revenue
	local baseRevenue = 10000
	local qualityMultiplier = self.QualityScore * 2
	local popularityMultiplier = genrePopularity
	
	self.Revenue = baseRevenue * qualityMultiplier * popularityMultiplier
	
	-- Calculate reputation gain
	local qualityTier = self:GetQualityTier()
	self.Reputation = GameConfig.Market.ReputationGain[qualityTier]
	
	print(string.format(
		"Project '%s' completed! Quality: %.2f, Revenue: $%.2f, Reputation: %d",
		self.Name,
		self.QualityScore,
		self.Revenue,
		self.Reputation
	))
	
	return self.QualityScore, self.Revenue, self.Reputation
end

function Project:GetQualityTier()
	if self.QualityScore >= GameConfig.Development.QualityThresholds.Excellent then
		return "Excellent"
	elseif self.QualityScore >= GameConfig.Development.QualityThresholds.Good then
		return "Good"
	elseif self.QualityScore >= GameConfig.Development.QualityThresholds.Average then
		return "Average"
	else
		return "Poor"
	end
end

function Project:GetProgressPercentage()
	if not self.IsActive then
		return self.CompletionTime and 100 or 0
	end
	
	return math.floor((self.Progress / self.PhaseWork[self.Phase]) * 100)
end

function Project:Serialize()
	return {
		Id = self.Id,
		Name = self.Name,
		Genre = self.Genre,
		Phase = self.Phase,
		Progress = self.Progress,
		QualityScore = self.QualityScore,
		IsActive = self.IsActive,
		AssignedEmployees = #self.AssignedEmployees,
		Revenue = self.Revenue,
		Reputation = self.Reputation
	}
end

-- Genre popularity system
local genrePopularities = {}
local lastTrendUpdate = 0

function GameDevPipeline.InitializeGenrePopularities()
	for _, genre in ipairs(GameConfig.Development.Genres) do
		genrePopularities[genre] = 1.0
	end
end

function GameDevPipeline.UpdateGenreTrends()
	local currentTime = tick()
	
	-- Update trends periodically
	if currentTime - lastTrendUpdate >= GameConfig.Market.TrendCycleDuration then
		lastTrendUpdate = currentTime
		
		-- Shift genre popularities randomly
		for genre, _ in pairs(genrePopularities) do
			local change = (math.random() - 0.5) * 0.3
			genrePopularities[genre] = math.clamp(
				genrePopularities[genre] + change,
				GameConfig.Market.PopularityRange[1],
				GameConfig.Market.PopularityRange[2]
			)
		end
		
		print("Genre trends updated!")
	end
end

function GameDevPipeline.GetGenrePopularity(genre)
	return genrePopularities[genre] or 1.0
end

function GameDevPipeline.GetAllGenrePopularities()
	return genrePopularities
end

-- Main pipeline functions
function GameDevPipeline.CreateProject(name, genre, targetQuality)
	return Project.new(name, genre, targetQuality)
end

function GameDevPipeline.GetAvailableGenres()
	return GameConfig.Development.Genres
end

function GameDevPipeline.SimulateLiveUpdate(project, updateType)
	-- Simulate post-release live updates
	local revenueBoost = 0
	local reputationChange = 0
	
	if updateType == "ContentUpdate" then
		revenueBoost = project.Revenue * 0.2
		reputationChange = 5
	elseif updateType == "BugFix" then
		revenueBoost = project.Revenue * 0.05
		reputationChange = 2
	elseif updateType == "MajorExpansion" then
		revenueBoost = project.Revenue * 0.5
		reputationChange = 15
	end
	
	return revenueBoost, reputationChange
end

-- Monetization strategies
function GameDevPipeline.CalculateMonetizationRevenue(project, strategy)
	local baseRevenue = project.Revenue
	
	local strategies = {
		Premium = {Multiplier = 1.0, ReputationImpact = 0},
		FreeToPlay = {Multiplier = 1.5, ReputationImpact = -5},
		Subscription = {Multiplier = 2.0, ReputationImpact = 5},
		AdSupported = {Multiplier = 0.8, ReputationImpact = -10}
	}
	
	local strategyData = strategies[strategy] or strategies.Premium
	
	return baseRevenue * strategyData.Multiplier, strategyData.ReputationImpact
end

-- Initialize system
GameDevPipeline.InitializeGenrePopularities()

return GameDevPipeline
