-- PlayerController.lua
-- Main client-side player controller

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local OwnerComputerUI = require(script.Parent.OwnerComputerUI)

print("Player controller initialized for: " .. player.Name)

-- Set player properties
humanoid.WalkSpeed = GameConfig.Player.WalkSpeed

-- Camera controller
local camera = workspace.CurrentCamera
camera.CameraType = Enum.CameraType.Custom
camera.CameraSubject = humanoid

-- Input handling
local isMenuOpen = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- Open/close menu with E key
	if input.KeyCode == Enum.KeyCode.E then
		isMenuOpen = not isMenuOpen
		print("Menu toggled: " .. tostring(isMenuOpen))
		-- TODO: Show/hide general game menu
	end
	
	-- Open computer with C key
	if input.KeyCode == Enum.KeyCode.C then
		print("Computer interface toggled")
		OwnerComputerUI.Toggle()
	end
	
	-- Quick stats with Tab key
	if input.KeyCode == Enum.KeyCode.Tab and not gameProcessed then
		print("Quick stats displayed")
		-- TODO: Show quick stats overlay
	end
end)

-- Show tutorial message on spawn
local tutorialShown = false

spawn(function()
	wait(2)
	if not tutorialShown then
		tutorialShown = true
		print("=== WELCOME TO GAME DEV SIMULATOR ===")
		print("Press C to open your Owner Computer")
		print("Walk to buildings and press the prompts to interact")
		print("Claim a plot in the Studio Zone to start your studio!")
		print("Visit shops to hire employees and buy equipment")
	end
end)

-- Proximity detection for interactive objects
local currentProximityPart = nil

local function checkProximity()
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end
	
	-- Check for nearby buildings and interactive objects
	local nearbyParts = workspace:GetPartBoundsInRadius(rootPart.Position, 15)
	
	for _, part in ipairs(nearbyParts) do
		if part.Name == "Door" then
			-- Show hint (in real implementation, this would be UI)
			if part ~= currentProximityPart then
				currentProximityPart = part
				-- Display interaction hint
			end
		end
	end
end

-- Update loop
game:GetService("RunService").RenderStepped:Connect(function()
	checkProximity()
end)

print("Player controller ready")
