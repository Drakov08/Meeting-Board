-- PlayerDataManager.lua
-- Manages player data, including money, reputation, employees, and projects

local PlayerDataManager = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)

local playerData = {}

function PlayerDataManager.InitializePlayer(player)
	playerData[player.UserId] = {
		Money = GameConfig.Player.StartingMoney,
		Reputation = GameConfig.Player.StartingReputation,
		OwnedPlot = nil,
		OwnedBuildings = {},
		Employees = {},
		ActiveProjects = {},
		CompletedProjects = {},
		Research = {},
		Inventory = {
			Computers = {},
			Furniture = {},
			Decorations = {}
		},
		Statistics = {
			TotalGamesReleased = 0,
			TotalRevenue = 0,
			TotalReputationGained = 0,
			PlayTime = 0
		}
	}
	
	print("Initialized player data for: " .. player.Name)
	return playerData[player.UserId]
end

function PlayerDataManager.GetPlayerData(player)
	return playerData[player.UserId]
end

function PlayerDataManager.AddMoney(player, amount)
	local data = playerData[player.UserId]
	if data then
		data.Money = data.Money + amount
		return data.Money
	end
	return 0
end

function PlayerDataManager.RemoveMoney(player, amount)
	local data = playerData[player.UserId]
	if data and data.Money >= amount then
		data.Money = data.Money - amount
		return true, data.Money
	end
	return false, data and data.Money or 0
end

function PlayerDataManager.AddReputation(player, amount)
	local data = playerData[player.UserId]
	if data then
		data.Reputation = data.Reputation + amount
		data.Statistics.TotalReputationGained = data.Statistics.TotalReputationGained + amount
		return data.Reputation
	end
	return 0
end

function PlayerDataManager.CanAfford(player, cost)
	local data = playerData[player.UserId]
	return data and data.Money >= cost
end

function PlayerDataManager.ClaimPlot(player, plotNumber)
	local data = playerData[player.UserId]
	if data and not data.OwnedPlot then
		data.OwnedPlot = plotNumber
		return true
	end
	return false
end

function PlayerDataManager.PurchaseBuilding(player, buildingType, cost)
	local success, newBalance = PlayerDataManager.RemoveMoney(player, cost)
	
	if success then
		local data = playerData[player.UserId]
		table.insert(data.OwnedBuildings, {
			Type = buildingType,
			PurchaseTime = tick()
		})
		return true
	end
	
	return false
end

function PlayerDataManager.HireEmployee(player, employee, cost)
	local success, newBalance = PlayerDataManager.RemoveMoney(player, cost)
	
	if success then
		local data = playerData[player.UserId]
		table.insert(data.Employees, employee)
		return true
	end
	
	return false
end

function PlayerDataManager.StartProject(player, project)
	local data = playerData[player.UserId]
	if data then
		table.insert(data.ActiveProjects, project)
		return true
	end
	return false
end

function PlayerDataManager.CompleteProject(player, project, revenue, reputation)
	local data = playerData[player.UserId]
	if data then
		-- Remove from active projects
		for i, proj in ipairs(data.ActiveProjects) do
			if proj.Id == project.Id then
				table.remove(data.ActiveProjects, i)
				break
			end
		end
		
		-- Add to completed projects
		table.insert(data.CompletedProjects, project)
		
		-- Update stats
		PlayerDataManager.AddMoney(player, revenue)
		PlayerDataManager.AddReputation(player, reputation)
		data.Statistics.TotalGamesReleased = data.Statistics.TotalGamesReleased + 1
		data.Statistics.TotalRevenue = data.Statistics.TotalRevenue + revenue
		
		return true
	end
	return false
end

function PlayerDataManager.PurchaseItem(player, itemType, itemName, cost)
	local success, newBalance = PlayerDataManager.RemoveMoney(player, cost)
	
	if success then
		local data = playerData[player.UserId]
		
		if itemType == "Computer" then
			table.insert(data.Inventory.Computers, itemName)
		elseif itemType == "Furniture" or itemType == "Decoration" then
			table.insert(data.Inventory.Furniture, itemName)
		end
		
		return true
	end
	
	return false
end

function PlayerDataManager.GetStatistics(player)
	local data = playerData[player.UserId]
	return data and data.Statistics or nil
end

function PlayerDataManager.SavePlayerData(player)
	-- In a real game, this would save to DataStore
	local data = playerData[player.UserId]
	if data then
		print("Player data saved for: " .. player.Name)
		return true
	end
	return false
end

function PlayerDataManager.CleanupPlayer(player)
	playerData[player.UserId] = nil
	print("Cleaned up player data for: " .. player.Name)
end

return PlayerDataManager
