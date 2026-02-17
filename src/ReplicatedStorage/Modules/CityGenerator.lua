-- CityGenerator.lua
-- Procedural city generation system for the Game Development Simulator

local CityGenerator = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)

-- Helper function to create a part
local function createPart(size, position, color, material, parent)
	local part = Instance.new("Part")
	part.Size = size
	part.Position = position
	part.Color = color or Color3.fromRGB(200, 200, 200)
	part.Material = material or Enum.Material.SmoothPlastic
	part.Anchored = true
	part.Parent = parent
	return part
end

-- Create a low-poly building
local function createBuilding(position, size, color, parent)
	local building = Instance.new("Model")
	building.Name = "Building"
	
	-- Main structure
	local base = createPart(size, position, color, Enum.Material.Concrete, building)
	
	-- Roof
	local roofSize = Vector3.new(size.X + 2, 2, size.Z + 2)
	local roofPosition = position + Vector3.new(0, size.Y/2 + 1, 0)
	createPart(roofSize, roofPosition, color * 0.8, Enum.Material.Slate, building)
	
	-- Windows (simple rectangles)
	local windowCount = math.floor(size.X / 5)
	local windowColor = Color3.fromRGB(100, 150, 200)
	
	for i = 1, windowCount do
		local windowSize = Vector3.new(2, 3, 0.5)
		local windowX = position.X - size.X/2 + (i * size.X / (windowCount + 1))
		local windowZ = position.Z + size.Z/2 + 0.3
		
		-- Front windows
		local windowPos = Vector3.new(windowX, position.Y + 3, windowZ)
		createPart(windowSize, windowPos, windowColor, Enum.Material.Glass, building)
	end
	
	building.Parent = parent
	return building
end

-- Create decorative props (trees, benches, etc.)
local function createTree(position, parent)
	local tree = Instance.new("Model")
	tree.Name = "Tree"
	
	-- Trunk
	local trunk = createPart(
		Vector3.new(1, 5, 1),
		position,
		Color3.fromRGB(101, 67, 33),
		Enum.Material.Wood,
		tree
	)
	
	-- Foliage (simple sphere-like structure)
	for i = 1, 3 do
		local foliageSize = Vector3.new(4 - i, 3, 4 - i)
		local foliagePos = position + Vector3.new(0, 3 + i, 0)
		createPart(
			foliageSize,
			foliagePos,
			Color3.fromRGB(34, 139, 34),
			Enum.Material.Grass,
			tree
		)
	end
	
	tree.Parent = parent
	return tree
end

-- Generate curved street path
local function generateStreetPath(startPos, endPos, curveIntensity)
	local path = {}
	local segments = 10
	
	for i = 0, segments do
		local t = i / segments
		local basePos = startPos:Lerp(endPos, t)
		
		-- Add curve using sine wave
		local curveOffset = math.sin(t * math.pi) * curveIntensity * 20
		local perpendicular = (endPos - startPos).Unit:Cross(Vector3.new(0, 1, 0))
		local curvedPos = basePos + perpendicular * curveOffset
		
		table.insert(path, curvedPos)
	end
	
	return path
end

-- Create a street along a path
local function createStreet(path, width, parent)
	local street = Instance.new("Model")
	street.Name = "Street"
	
	for i = 1, #path - 1 do
		local startPos = path[i]
		local endPos = path[i + 1]
		local midPos = (startPos + endPos) / 2
		local length = (endPos - startPos).Magnitude
		
		local roadPart = createPart(
			Vector3.new(width, 0.5, length),
			midPos,
			Color3.fromRGB(50, 50, 50),
			Enum.Material.Asphalt,
			street
		)
		
		-- Rotate to align with path
		local direction = (endPos - startPos).Unit
		local angle = math.atan2(direction.X, direction.Z)
		roadPart.CFrame = CFrame.new(midPos) * CFrame.Angles(0, angle, 0)
	end
	
	street.Parent = parent
	return street
end

-- Generate Central Hub Zone
function CityGenerator.GenerateCentralHub(centerPos, parent)
	local hub = Instance.new("Folder")
	hub.Name = "CentralHub"
	
	-- Plaza
	local plazaSize = Vector3.new(60, 1, 60)
	local plaza = createPart(
		plazaSize,
		centerPos,
		Color3.fromRGB(150, 150, 150),
		Enum.Material.Cobblestone,
		hub
	)
	plaza.Name = "Plaza"
	
	-- Spawn location
	local spawn = Instance.new("SpawnLocation")
	spawn.Size = Vector3.new(6, 1, 6)
	spawn.Position = centerPos + Vector3.new(0, 1, 0)
	spawn.BrickColor = BrickColor.new("Bright blue")
	spawn.Material = Enum.Material.Neon
	spawn.Anchored = true
	spawn.Name = "MainSpawn"
	spawn.Parent = hub
	
	-- Decorative elements
	for i = 1, 4 do
		local angle = (i - 1) * (math.pi / 2)
		local x = math.cos(angle) * 25
		local z = math.sin(angle) * 25
		createTree(centerPos + Vector3.new(x, 0, z), hub)
	end
	
	-- Signage (simple boards)
	local signPos = centerPos + Vector3.new(0, 3, 30)
	local sign = createPart(
		Vector3.new(8, 4, 0.5),
		signPos,
		Color3.fromRGB(255, 255, 255),
		Enum.Material.SmoothPlastic,
		hub
	)
	sign.Name = "DirectionalSign"
	
	hub.Parent = parent
	return hub
end

-- Generate Commercial Zone
function CityGenerator.GenerateCommercialZone(centerPos, parent)
	local zone = Instance.new("Folder")
	zone.Name = "CommercialZone"
	
	local buildings = {
		{Name = "ComputerStore", Size = Vector3.new(30, 15, 25), Offset = Vector3.new(40, 7.5, 0), Color = Color3.fromRGB(70, 130, 180)},
		{Name = "HiringAgency", Size = Vector3.new(25, 20, 20), Offset = Vector3.new(40, 10, -35), Color = Color3.fromRGB(160, 82, 45)},
		{Name = "DecorStore", Size = Vector3.new(28, 12, 22), Offset = Vector3.new(40, 6, 35), Color = Color3.fromRGB(218, 165, 32)},
		{Name = "MarketingOffice", Size = Vector3.new(20, 18, 20), Offset = Vector3.new(75, 9, 0), Color = Color3.fromRGB(138, 43, 226)}
	}
	
	for _, buildingData in ipairs(buildings) do
		local building = createBuilding(
			centerPos + buildingData.Offset,
			buildingData.Size,
			buildingData.Color,
			zone
		)
		building.Name = buildingData.Name
		
		-- Add door
		local doorSize = Vector3.new(4, 6, 0.5)
		local doorPos = building.PrimaryPart.Position + Vector3.new(0, -buildingData.Size.Y/2 + 3, buildingData.Size.Z/2 + 0.5)
		local door = createPart(doorSize, doorPos, Color3.fromRGB(139, 69, 19), Enum.Material.Wood, building)
		door.Name = "Door"
	end
	
	-- Add trees for ambiance
	for i = 1, 8 do
		local angle = (i - 1) * (math.pi / 4)
		local distance = 55 + math.random(-5, 5)
		local x = math.cos(angle) * distance
		local z = math.sin(angle) * distance
		createTree(centerPos + Vector3.new(x, 0, z), zone)
	end
	
	zone.Parent = parent
	return zone
end

-- Generate Studio Zone with Player Plots
function CityGenerator.GenerateStudioZone(centerPos, parent)
	local zone = Instance.new("Folder")
	zone.Name = "StudioZone"
	
	-- Create 12 player plots in a grid
	local plotSize = GameConfig.City.PlotSize
	local spacing = GameConfig.City.PlotSpacing
	local rows = 3
	local cols = 4
	
	local plotFolder = Instance.new("Folder")
	plotFolder.Name = "PlayerPlots"
	
	for row = 1, rows do
		for col = 1, cols do
			local plotNum = (row - 1) * cols + col
			local xOffset = (col - cols/2 - 0.5) * (plotSize.X + spacing)
			local zOffset = (row - rows/2 - 0.5) * (plotSize.Z + spacing)
			
			local plotPos = centerPos + Vector3.new(xOffset, 0, zOffset)
			local plot = createPart(
				plotSize,
				plotPos,
				Color3.fromRGB(100, 150, 100),
				Enum.Material.Grass,
				plotFolder
			)
			plot.Name = "Plot" .. plotNum
			
			-- Add plot marker
			local marker = createPart(
				Vector3.new(2, 5, 2),
				plotPos + Vector3.new(plotSize.X/2 - 2, 2.5, plotSize.Z/2 - 2),
				Color3.fromRGB(255, 200, 0),
				Enum.Material.Neon,
				plotFolder
			)
			marker.Name = "Marker" .. plotNum
		end
	end
	
	plotFolder.Parent = zone
	
	-- Starter studio buildings (for purchase)
	local garagePos = centerPos + Vector3.new(-100, 5, 0)
	local garage = createBuilding(garagePos, Vector3.new(20, 10, 15), Color3.fromRGB(180, 180, 180), zone)
	garage.Name = "GarageStudio_Template"
	
	zone.Parent = parent
	return zone
end

-- Generate Decorative Buffer Zone
function CityGenerator.GenerateDecorativeZone(centerPos, parent)
	local zone = Instance.new("Folder")
	zone.Name = "DecorativeZone"
	
	-- Create decorative buildings around the perimeter
	local buildingCount = 20
	local radius = 150
	
	for i = 1, buildingCount do
		local angle = (i - 1) * (2 * math.pi / buildingCount)
		local distance = radius + math.random(-10, 10)
		local x = math.cos(angle) * distance
		local z = math.sin(angle) * distance
		
		local size = Vector3.new(
			math.random(15, 30),
			math.random(10, 25),
			math.random(15, 30)
		)
		
		local color = Color3.fromRGB(
			math.random(150, 220),
			math.random(150, 220),
			math.random(150, 220)
		)
		
		local building = createBuilding(
			centerPos + Vector3.new(x, size.Y/2, z),
			size,
			color,
			zone
		)
		building.Name = "DecorativeBuilding" .. i
	end
	
	-- Add trees throughout
	for i = 1, 30 do
		local angle = math.random() * 2 * math.pi
		local distance = math.random(120, 180)
		local x = math.cos(angle) * distance
		local z = math.sin(angle) * distance
		createTree(centerPos + Vector3.new(x, 0, z), zone)
	end
	
	zone.Parent = parent
	return zone
end

-- Main generation function
function CityGenerator.GenerateCity(parent)
	local city = Instance.new("Folder")
	city.Name = "GeneratedCity"
	
	local centerPos = Vector3.new(0, 0, 0)
	
	print("Generating Central Hub...")
	CityGenerator.GenerateCentralHub(centerPos, city)
	
	print("Generating Commercial Zone...")
	CityGenerator.GenerateCommercialZone(centerPos, city)
	
	print("Generating Studio Zone...")
	CityGenerator.GenerateStudioZone(centerPos + Vector3.new(-150, 0, 0), city)
	
	print("Generating Decorative Zone...")
	CityGenerator.GenerateDecorativeZone(centerPos, city)
	
	-- Generate curved streets
	print("Generating Streets...")
	local streets = Instance.new("Folder")
	streets.Name = "Streets"
	
	-- Main street from hub to commercial
	local path1 = generateStreetPath(centerPos, centerPos + Vector3.new(40, 0, 0), GameConfig.City.CurveIntensity)
	createStreet(path1, GameConfig.City.StreetWidth, streets)
	
	-- Street to studio zone
	local path2 = generateStreetPath(centerPos, centerPos + Vector3.new(-150, 0, 0), GameConfig.City.CurveIntensity)
	createStreet(path2, GameConfig.City.StreetWidth, streets)
	
	streets.Parent = city
	
	city.Parent = parent
	print("City generation complete!")
	return city
end

return CityGenerator
