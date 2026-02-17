-- NPCSystem.lua
-- Manages NPC spawning, movement, and ambient behaviors

local NPCSystem = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)

local activeNPCs = {}

-- Create a simple NPC character
local function createNPC(name, position)
	local npc = Instance.new("Model")
	npc.Name = name or "NPC"
	
	-- Torso (main body)
	local torso = Instance.new("Part")
	torso.Name = "Torso"
	torso.Size = Vector3.new(2, 2, 1)
	torso.Position = position
	torso.Color = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
	torso.Material = Enum.Material.SmoothPlastic
	torso.Anchored = false
	torso.CanCollide = true
	torso.Parent = npc
	
	-- Head
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(1.5, 1.5, 1.5)
	head.Position = position + Vector3.new(0, 2, 0)
	head.Color = Color3.fromRGB(255, 220, 177)
	head.Material = Enum.Material.SmoothPlastic
	head.Shape = Enum.PartType.Ball
	head.Anchored = false
	head.CanCollide = true
	head.Parent = npc
	
	-- Weld head to torso
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = torso
	weld.Part1 = head
	weld.Parent = torso
	
	-- Humanoid
	local humanoid = Instance.new("Humanoid")
	humanoid.WalkSpeed = GameConfig.World.NPCWalkSpeed
	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	humanoid.Parent = npc
	
	-- Simple name tag
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.Adornee = head
	billboard.AlwaysOnTop = true
	billboard.Parent = head
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.Text = name
	nameLabel.TextStrokeTransparency = 0.5
	nameLabel.Parent = billboard
	
	npc.PrimaryPart = torso
	
	return npc
end

-- Get random wandering position within a zone
local function getRandomWanderPosition(centerPos, radius)
	local angle = math.random() * 2 * math.pi
	local distance = math.random() * radius
	
	local x = centerPos.X + math.cos(angle) * distance
	local z = centerPos.Z + math.sin(angle) * distance
	
	return Vector3.new(x, centerPos.Y, z)
end

-- NPC AI behavior
local function startNPCBehavior(npc, zoneCenter, zoneRadius)
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	
	-- Wander around the zone
	spawn(function()
		while npc and npc.Parent do
			-- Pick random destination
			local destination = getRandomWanderPosition(zoneCenter, zoneRadius)
			
			-- Move to destination
			humanoid:MoveTo(destination)
			
			-- Wait for movement to complete or timeout
			local timeout = 10
			local moveFinished = humanoid.MoveToFinished:Wait()
			
			-- Idle for a bit
			local idleTime = math.random(GameConfig.World.NPCIdleTime[1], GameConfig.World.NPCIdleTime[2])
			wait(idleTime)
		end
	end)
end

-- Spawn NPCs in the city
function NPCSystem.SpawnNPCs(cityFolder)
	local centralHub = cityFolder:FindFirstChild("CentralHub")
	local commercialZone = cityFolder:FindFirstChild("CommercialZone")
	
	if not centralHub or not commercialZone then
		warn("Could not find city zones for NPC spawning")
		return
	end
	
	local npcCount = GameConfig.World.NPCCount
	local names = {
		"Alex", "Jordan", "Taylor", "Morgan", "Casey",
		"Jamie", "Riley", "Blake", "Sam", "Quinn",
		"Avery", "Cameron", "Drew", "Jessie", "Reese"
	}
	
	-- Spawn NPCs in commercial zone
	for i = 1, math.floor(npcCount * 0.6) do
		local angle = (i / (npcCount * 0.6)) * 2 * math.pi
		local distance = math.random(30, 50)
		local x = math.cos(angle) * distance
		local z = math.sin(angle) * distance
		
		local spawnPos = Vector3.new(40 + x, 5, z)
		local npcName = names[math.random(1, #names)] .. "_" .. i
		
		local npc = createNPC(npcName, spawnPos)
		npc.Parent = cityFolder
		
		table.insert(activeNPCs, npc)
		
		-- Start AI behavior
		startNPCBehavior(npc, Vector3.new(40, 0, 0), 60)
	end
	
	-- Spawn NPCs in central hub
	for i = 1, math.floor(npcCount * 0.4) do
		local angle = (i / (npcCount * 0.4)) * 2 * math.pi
		local distance = math.random(15, 25)
		local x = math.cos(angle) * distance
		local z = math.sin(angle) * distance
		
		local spawnPos = Vector3.new(x, 5, z)
		local npcName = names[math.random(1, #names)] .. "_H" .. i
		
		local npc = createNPC(npcName, spawnPos)
		npc.Parent = cityFolder
		
		table.insert(activeNPCs, npc)
		
		-- Start AI behavior
		startNPCBehavior(npc, Vector3.new(0, 0, 0), 40)
	end
	
	print("Spawned " .. #activeNPCs .. " NPCs in the city")
end

-- Clean up all NPCs
function NPCSystem.CleanupNPCs()
	for _, npc in ipairs(activeNPCs) do
		if npc and npc.Parent then
			npc:Destroy()
		end
	end
	
	activeNPCs = {}
	print("All NPCs cleaned up")
end

-- Get active NPC count
function NPCSystem.GetActiveNPCCount()
	return #activeNPCs
end

return NPCSystem
