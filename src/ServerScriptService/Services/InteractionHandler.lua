-- InteractionHandler.lua
-- Handles player interactions with buildings, shops, and objects

local InteractionHandler = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local EmployeeSystem = require(ReplicatedStorage.Modules.EmployeeSystem)
local PlayerDataManager = require(ServerScriptService.Services.PlayerDataManager)

-- Computer Store interactions
function InteractionHandler.HandleComputerPurchase(player, itemName)
	local itemData = GameConfig.Shops.ComputerStore.Items[itemName]
	
	if not itemData then
		return false, "Item not found"
	end
	
	local playerData = PlayerDataManager.GetPlayerData(player)
	if not playerData then
		return false, "Player data not found"
	end
	
	-- Check if player can afford
	if not PlayerDataManager.CanAfford(player, itemData.Cost) then
		return false, "Not enough money"
	end
	
	-- Purchase item
	local success = PlayerDataManager.PurchaseItem(player, "Computer", itemName, itemData.Cost)
	
	if success then
		-- Update player's money display
		if player:FindFirstChild("leaderstats") then
			local money = player.leaderstats:FindFirstChild("Money")
			if money then
				money.Value = playerData.Money
			end
		end
		
		return true, "Purchased " .. itemName .. " for $" .. itemData.Cost
	end
	
	return false, "Purchase failed"
end

-- Hiring Agency interactions
function InteractionHandler.HandleEmployeeHire(player, tier)
	local tierData = GameConfig.Employees.Tiers[tier]
	
	if not tierData then
		return false, "Invalid tier"
	end
	
	local playerData = PlayerDataManager.GetPlayerData(player)
	if not playerData then
		return false, "Player data not found"
	end
	
	-- Check if player can afford
	if not PlayerDataManager.CanAfford(player, tierData.Cost) then
		return false, "Not enough money (need $" .. tierData.Cost .. ")"
	end
	
	-- Create employee
	local employeeName = EmployeeSystem.GenerateRandomName()
	local employee = EmployeeSystem.CreateEmployee(tier, employeeName)
	
	-- Hire employee
	local success = PlayerDataManager.HireEmployee(player, employee, tierData.Cost)
	
	if success then
		-- Update player's money display
		if player:FindFirstChild("leaderstats") then
			local money = player.leaderstats:FindFirstChild("Money")
			if money then
				money.Value = playerData.Money
			end
		end
		
		return true, "Hired " .. employeeName .. " (" .. tier .. ") for $" .. tierData.Cost
	end
	
	return false, "Hire failed"
end

-- Decor Store interactions
function InteractionHandler.HandleDecorPurchase(player, itemName)
	local itemData = GameConfig.Shops.DecorStore.Items[itemName]
	
	if not itemData then
		return false, "Item not found"
	end
	
	local playerData = PlayerDataManager.GetPlayerData(player)
	if not playerData then
		return false, "Player data not found"
	end
	
	-- Check if player can afford
	if not PlayerDataManager.CanAfford(player, itemData.Cost) then
		return false, "Not enough money"
	end
	
	-- Purchase item
	local success = PlayerDataManager.PurchaseItem(player, "Furniture", itemName, itemData.Cost)
	
	if success then
		-- Update player's money display
		if player:FindFirstChild("leaderstats") then
			local money = player.leaderstats:FindFirstChild("Money")
			if money then
				money.Value = playerData.Money
			end
		end
		
		return true, "Purchased " .. itemName .. " for $" .. itemData.Cost
	end
	
	return false, "Purchase failed"
end

-- Plot claiming
function InteractionHandler.HandlePlotClaim(player, plotNumber)
	local playerData = PlayerDataManager.GetPlayerData(player)
	
	if not playerData then
		return false, "Player data not found"
	end
	
	if playerData.OwnedPlot then
		return false, "You already own a plot"
	end
	
	local success = PlayerDataManager.ClaimPlot(player, plotNumber)
	
	if success then
		return true, "Claimed Plot " .. plotNumber
	end
	
	return false, "Failed to claim plot"
end

-- Building purchase
function InteractionHandler.HandleBuildingPurchase(player, buildingType)
	local buildingData = GameConfig.Buildings[buildingType]
	
	if not buildingData then
		return false, "Building type not found"
	end
	
	local playerData = PlayerDataManager.GetPlayerData(player)
	
	if not playerData then
		return false, "Player data not found"
	end
	
	-- Check if unlocked
	if not buildingData.Unlocked then
		if playerData.Reputation < buildingData.RequiredReputation then
			return false, "Requires " .. buildingData.RequiredReputation .. " reputation"
		end
	end
	
	-- Check if player owns a plot
	if not playerData.OwnedPlot then
		return false, "You need to claim a plot first"
	end
	
	-- Check if player can afford
	if not PlayerDataManager.CanAfford(player, buildingData.Cost) then
		return false, "Not enough money (need $" .. buildingData.Cost .. ")"
	end
	
	-- Purchase building
	local success = PlayerDataManager.PurchaseBuilding(player, buildingType, buildingData.Cost)
	
	if success then
		-- Update player's money display
		if player:FindFirstChild("leaderstats") then
			local money = player.leaderstats:FindFirstChild("Money")
			if money then
				money.Value = playerData.Money
			end
		end
		
		return true, "Purchased " .. buildingType .. " for $" .. buildingData.Cost
	end
	
	return false, "Purchase failed"
end

-- Setup proximity prompts for all interactive objects
function InteractionHandler.SetupInteractions(cityFolder)
	-- Computer Store
	local commercialZone = cityFolder:FindFirstChild("CommercialZone")
	if commercialZone then
		local computerStore = commercialZone:FindFirstChild("ComputerStore")
		if computerStore then
			local interior = computerStore:FindFirstChild("Interior")
			if interior then
				for _, child in ipairs(interior:GetDescendants()) do
					if child:IsA("ProximityPrompt") then
						child.Triggered:Connect(function(player)
							local itemName = child.Parent.Name:gsub("Display", "")
							local success, message = InteractionHandler.HandleComputerPurchase(player, itemName)
							
							-- Send feedback to player (in real game, use RemoteEvents)
							print(player.Name .. " attempted to purchase " .. itemName .. ": " .. message)
						end)
					end
				end
			end
		end
		
		-- Hiring Agency
		local hiringAgency = commercialZone:FindFirstChild("HiringAgency")
		if hiringAgency then
			local interior = hiringAgency:FindFirstChild("Interior")
			if interior then
				for _, child in ipairs(interior:GetDescendants()) do
					if child:IsA("ProximityPrompt") then
						child.Triggered:Connect(function(player)
							local tier = child.Parent.Name:gsub("Station", "")
							local success, message = InteractionHandler.HandleEmployeeHire(player, tier)
							
							print(player.Name .. " attempted to hire " .. tier .. ": " .. message)
						end)
					end
				end
			end
		end
		
		-- Decor Store
		local decorStore = commercialZone:FindFirstChild("DecorStore")
		if decorStore then
			local interior = decorStore:FindFirstChild("Interior")
			if interior then
				for _, child in ipairs(interior:GetDescendants()) do
					if child:IsA("ProximityPrompt") then
						child.Triggered:Connect(function(player)
							local itemName = child.Parent.Name:gsub("Display", "")
							local success, message = InteractionHandler.HandleDecorPurchase(player, itemName)
							
							print(player.Name .. " attempted to purchase " .. itemName .. ": " .. message)
						end)
					end
				end
			end
		end
	end
	
	-- Plot markers
	local studioZone = cityFolder:FindFirstChild("StudioZone")
	if studioZone then
		local plotFolder = studioZone:FindFirstChild("PlayerPlots")
		if plotFolder then
			for _, plot in ipairs(plotFolder:GetChildren()) do
				if plot.Name:match("^Plot%d+$") then
					local plotNumber = tonumber(plot.Name:match("%d+"))
					local marker = plotFolder:FindFirstChild("Marker" .. plotNumber)
					
					if marker then
						local prompt = Instance.new("ProximityPrompt")
						prompt.ActionText = "Claim Plot"
						prompt.ObjectText = "Plot " .. plotNumber
						prompt.MaxActivationDistance = 10
						prompt.Parent = marker
						
						prompt.Triggered:Connect(function(player)
							local success, message = InteractionHandler.HandlePlotClaim(player, plotNumber)
							print(player.Name .. " attempted to claim plot " .. plotNumber .. ": " .. message)
						end)
					end
				end
			end
		end
	end
	
	print("Interaction handlers setup complete!")
end

return InteractionHandler
