-- GameServer.lua
-- Main server script that initializes all systems and handles game logic

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Load modules
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local CityGenerator = require(ReplicatedStorage.Modules.CityGenerator)
local EmployeeSystem = require(ReplicatedStorage.Modules.EmployeeSystem)
local GameDevPipeline = require(ReplicatedStorage.Modules.GameDevPipeline)
local ResearchSystem = require(ReplicatedStorage.Modules.ResearchSystem)
local PlayerDataManager = require(ServerScriptService.Services.PlayerDataManager)

print("=== Game Development Simulator Server Starting ===")

-- Initialize systems
ResearchSystem.Initialize()

-- Generate the city
print("Generating city...")
local city = CityGenerator.GenerateCity(Workspace)
print("City generated successfully!")

-- Player connection handlers
Players.PlayerAdded:Connect(function(player)
	print("Player joined: " .. player.Name)
	
	-- Initialize player data
	PlayerDataManager.InitializePlayer(player)
	
	-- Set player spawn location
	player.RespawnLocation = Workspace.GeneratedCity.CentralHub.MainSpawn
	
	-- Create leaderstats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	
	local money = Instance.new("IntValue")
	money.Name = "Money"
	money.Value = GameConfig.Player.StartingMoney
	money.Parent = leaderstats
	
	local reputation = Instance.new("IntValue")
	reputation.Name = "Reputation"
	reputation.Value = GameConfig.Player.StartingReputation
	reputation.Parent = leaderstats
	
	leaderstats.Parent = player
end)

Players.PlayerRemoving:Connect(function(player)
	print("Player leaving: " .. player.Name)
	
	-- Save player data
	PlayerDataManager.SavePlayerData(player)
	
	-- Cleanup
	PlayerDataManager.CleanupPlayer(player)
end)

-- Game loop for updating systems
local lastUpdate = tick()
local UPDATE_INTERVAL = 1 -- Update every second

game:GetService("RunService").Heartbeat:Connect(function()
	local currentTime = tick()
	local deltaTime = currentTime - lastUpdate
	
	if deltaTime >= UPDATE_INTERVAL then
		lastUpdate = currentTime
		
		-- Update genre trends
		GameDevPipeline.UpdateGenreTrends()
		
		-- Update research progress for all players
		ResearchSystem.UpdateResearch(deltaTime)
		
		-- Update active projects for all players
		for _, player in ipairs(Players:GetPlayers()) do
			local playerData = PlayerDataManager.GetPlayerData(player)
			
			if playerData then
				-- Update active projects
				for _, project in ipairs(playerData.ActiveProjects) do
					if project.IsActive then
						-- Calculate team productivity
						local teamProductivity = 1
						if #project.AssignedEmployees > 0 then
							teamProductivity = EmployeeSystem.CalculateTeamProductivity(project.AssignedEmployees)
						end
						
						-- Update project progress
						project:UpdateProgress(deltaTime, teamProductivity)
						
						-- Update employee stress
						for _, employee in ipairs(project.AssignedEmployees) do
							employee:Work(deltaTime / 3600) -- Convert to hours
						end
					end
				end
				
				-- Update player statistics
				playerData.Statistics.PlayTime = playerData.Statistics.PlayTime + deltaTime
			end
		end
	end
end)

print("=== Game Development Simulator Server Ready ===")
print("City size: " .. GameConfig.City.Size .. " studs")
print("Player plots available: " .. GameConfig.City.PlayerPlotCount)
print("Starting money: $" .. GameConfig.Player.StartingMoney)
