-- BuildingInteriors.lua
-- Manages building interiors and interactive systems

local BuildingInteriors = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)

-- Create interior for Computer Store
function BuildingInteriors.CreateComputerStoreInterior(building)
	local interior = Instance.new("Folder")
	interior.Name = "Interior"
	
	-- Floor
	local floor = Instance.new("Part")
	floor.Size = Vector3.new(28, 0.5, 23)
	floor.Position = building.PrimaryPart.Position - Vector3.new(0, building.PrimaryPart.Size.Y/2 - 0.25, 0)
	floor.Material = Enum.Material.Tile
	floor.Color = Color3.fromRGB(220, 220, 220)
	floor.Anchored = true
	floor.Name = "Floor"
	floor.Parent = interior
	
	-- Display shelves with computers
	local shelves = {
		{Name = "BasicPC", Position = Vector3.new(-10, 2, -8), Color = Color3.fromRGB(180, 180, 180)},
		{Name = "MidRangePC", Position = Vector3.new(-10, 2, 0), Color = Color3.fromRGB(100, 150, 255)},
		{Name = "HighEndPC", Position = Vector3.new(-10, 2, 8), Color = Color3.fromRGB(255, 100, 100)},
		{Name = "WorkstationPC", Position = Vector3.new(10, 2, 0), Color = Color3.fromRGB(255, 215, 0)}
	}
	
	for _, shelfData in ipairs(shelves) do
		-- Shelf base
		local shelf = Instance.new("Part")
		shelf.Size = Vector3.new(4, 0.5, 4)
		shelf.Position = building.PrimaryPart.Position + shelfData.Position
		shelf.Material = Enum.Material.Wood
		shelf.Color = Color3.fromRGB(139, 90, 43)
		shelf.Anchored = true
		shelf.Name = shelfData.Name .. "Shelf"
		shelf.Parent = interior
		
		-- Display computer
		local computer = Instance.new("Part")
		computer.Size = Vector3.new(2, 1.5, 2)
		computer.Position = shelf.Position + Vector3.new(0, 1.25, 0)
		computer.Material = Enum.Material.SmoothPlastic
		computer.Color = shelfData.Color
		computer.Anchored = true
		computer.Name = shelfData.Name .. "Display"
		computer.Parent = interior
		
		-- Add interaction prompt
		local proximityPrompt = Instance.new("ProximityPrompt")
		proximityPrompt.ActionText = "Purchase " .. shelfData.Name
		proximityPrompt.ObjectText = shelfData.Name
		proximityPrompt.MaxActivationDistance = 8
		proximityPrompt.Parent = computer
		
		-- Add price label
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 100, 0, 50)
		billboard.Adornee = computer
		billboard.AlwaysOnTop = true
		billboard.Parent = computer
		
		local priceLabel = Instance.new("TextLabel")
		priceLabel.Size = UDim2.new(1, 0, 1, 0)
		priceLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		priceLabel.BackgroundTransparency = 0.3
		priceLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		priceLabel.TextScaled = true
		priceLabel.Font = Enum.Font.GothamBold
		priceLabel.Text = "$" .. GameConfig.Shops.ComputerStore.Items[shelfData.Name].Cost
		priceLabel.Parent = billboard
	end
	
	-- Cashier counter
	local counter = Instance.new("Part")
	counter.Size = Vector3.new(8, 3, 2)
	counter.Position = building.PrimaryPart.Position + Vector3.new(0, 1.5, 10)
	counter.Material = Enum.Material.Wood
	counter.Color = Color3.fromRGB(101, 67, 33)
	counter.Anchored = true
	counter.Name = "Counter"
	counter.Parent = interior
	
	interior.Parent = building
	return interior
end

-- Create interior for Hiring Agency
function BuildingInteriors.CreateHiringAgencyInterior(building)
	local interior = Instance.new("Folder")
	interior.Name = "Interior"
	
	-- Floor
	local floor = Instance.new("Part")
	floor.Size = Vector3.new(23, 0.5, 18)
	floor.Position = building.PrimaryPart.Position - Vector3.new(0, building.PrimaryPart.Size.Y/2 - 0.25, 0)
	floor.Material = Enum.Material.Carpet
	floor.Color = Color3.fromRGB(100, 100, 120)
	floor.Anchored = true
	floor.Name = "Floor"
	floor.Parent = interior
	
	-- Reception desk
	local desk = Instance.new("Part")
	desk.Size = Vector3.new(6, 3, 2)
	desk.Position = building.PrimaryPart.Position + Vector3.new(0, 1.5, 7)
	desk.Material = Enum.Material.Wood
	desk.Color = Color3.fromRGB(139, 69, 19)
	desk.Anchored = true
	desk.Name = "ReceptionDesk"
	desk.Parent = interior
	
	-- Hiring stations (one for each tier)
	local tiers = {"Junior", "MidLevel", "Senior", "Expert"}
	for i, tier in ipairs(tiers) do
		local station = Instance.new("Part")
		station.Size = Vector3.new(4, 3, 1)
		station.Position = building.PrimaryPart.Position + Vector3.new((i - 2.5) * 5, 1.5, -6)
		station.Material = Enum.Material.Plastic
		station.Color = Color3.fromRGB(80, 100, 120)
		station.Anchored = true
		station.Name = tier .. "Station"
		station.Parent = interior
		
		-- Interaction prompt
		local prompt = Instance.new("ProximityPrompt")
		prompt.ActionText = "Hire " .. tier .. " Employee"
		prompt.ObjectText = tier .. " Hiring"
		prompt.MaxActivationDistance = 8
		prompt.Parent = station
		
		-- Info billboard
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 120, 0, 60)
		billboard.Adornee = station
		billboard.AlwaysOnTop = true
		billboard.Parent = station
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
		label.BackgroundTransparency = 0.2
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.TextScaled = true
		label.Font = Enum.Font.Gotham
		label.Text = tier .. "\n$" .. GameConfig.Employees.Tiers[tier].Cost
		label.Parent = billboard
	end
	
	-- Waiting area chairs
	for i = 1, 4 do
		local chair = Instance.new("Part")
		chair.Size = Vector3.new(2, 2, 2)
		chair.Position = building.PrimaryPart.Position + Vector3.new((i - 2.5) * 3, 1, 2)
		chair.Material = Enum.Material.Fabric
		chair.Color = Color3.fromRGB(70, 70, 90)
		chair.Anchored = true
		chair.Name = "Chair" .. i
		chair.Parent = interior
	end
	
	interior.Parent = building
	return interior
end

-- Create interior for Decor Store
function BuildingInteriors.CreateDecorStoreInterior(building)
	local interior = Instance.new("Folder")
	interior.Name = "Interior"
	
	-- Floor
	local floor = Instance.new("Part")
	floor.Size = Vector3.new(26, 0.5, 20)
	floor.Position = building.PrimaryPart.Position - Vector3.new(0, building.PrimaryPart.Size.Y/2 - 0.25, 0)
	floor.Material = Enum.Material.Wood
	floor.Color = Color3.fromRGB(160, 120, 80)
	floor.Anchored = true
	floor.Name = "Floor"
	floor.Parent = interior
	
	-- Display items
	local items = {
		{Name = "BasicDesk", Size = Vector3.new(3, 2, 1.5), Position = Vector3.new(-8, 1, -6)},
		{Name = "ComfortChair", Size = Vector3.new(1.5, 2, 1.5), Position = Vector3.new(-8, 1, -2)},
		{Name = "PlantDecor", Size = Vector3.new(1, 2, 1), Position = Vector3.new(-8, 1, 2)},
		{Name = "Poster", Size = Vector3.new(2, 2, 0.1), Position = Vector3.new(-8, 2, 6)},
		{Name = "WhiteBoard", Size = Vector3.new(3, 2, 0.2), Position = Vector3.new(8, 2, -4)},
		{Name = "CoffeeStation", Size = Vector3.new(2, 3, 2), Position = Vector3.new(8, 1.5, 2)}
	}
	
	for _, itemData in ipairs(items) do
		local item = Instance.new("Part")
		item.Size = itemData.Size
		item.Position = building.PrimaryPart.Position + itemData.Position
		item.Material = Enum.Material.SmoothPlastic
		item.Color = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
		item.Anchored = true
		item.Name = itemData.Name .. "Display"
		item.Parent = interior
		
		-- Interaction prompt
		local prompt = Instance.new("ProximityPrompt")
		prompt.ActionText = "Purchase " .. itemData.Name
		prompt.ObjectText = itemData.Name
		prompt.MaxActivationDistance = 8
		prompt.Parent = item
		
		-- Price tag
		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0, 100, 0, 40)
		billboard.Adornee = item
		billboard.AlwaysOnTop = true
		billboard.Parent = item
		
		local price = Instance.new("TextLabel")
		price.Size = UDim2.new(1, 0, 1, 0)
		price.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		price.BackgroundTransparency = 0.3
		price.TextColor3 = Color3.fromRGB(0, 0, 0)
		price.TextScaled = true
		price.Font = Enum.Font.GothamBold
		price.Text = "$" .. GameConfig.Shops.DecorStore.Items[itemData.Name].Cost
		price.Parent = billboard
	end
	
	interior.Parent = building
	return interior
end

-- Create garage studio interior (player's starter building)
function BuildingInteriors.CreateGarageStudioInterior(building, playerPlot)
	local interior = Instance.new("Folder")
	interior.Name = "Interior"
	
	-- Floor
	local floor = Instance.new("Part")
	floor.Size = Vector3.new(18, 0.5, 13)
	floor.Position = building.PrimaryPart.Position - Vector3.new(0, building.PrimaryPart.Size.Y/2 - 0.25, 0)
	floor.Material = Enum.Material.Concrete
	floor.Color = Color3.fromRGB(150, 150, 150)
	floor.Anchored = true
	floor.Name = "Floor"
	floor.Parent = interior
	
	-- Empty space for 2-4 desks
	-- Players will purchase and place furniture themselves
	
	-- Basic lighting
	local light = Instance.new("PointLight")
	light.Brightness = 2
	light.Range = 30
	light.Parent = floor
	
	interior.Parent = building
	return interior
end

-- Add interiors to all buildings in the city
function BuildingInteriors.InitializeAllInteriors(cityFolder)
	local commercialZone = cityFolder:FindFirstChild("CommercialZone")
	
	if commercialZone then
		local computerStore = commercialZone:FindFirstChild("ComputerStore")
		if computerStore and computerStore:IsA("Model") then
			BuildingInteriors.CreateComputerStoreInterior(computerStore)
		end
		
		local hiringAgency = commercialZone:FindFirstChild("HiringAgency")
		if hiringAgency and hiringAgency:IsA("Model") then
			BuildingInteriors.CreateHiringAgencyInterior(hiringAgency)
		end
		
		local decorStore = commercialZone:FindFirstChild("DecorStore")
		if decorStore and decorStore:IsA("Model") then
			BuildingInteriors.CreateDecorStoreInterior(decorStore)
		end
	end
	
	print("Building interiors initialized!")
end

return BuildingInteriors
