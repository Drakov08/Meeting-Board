-- LightingManager.lua
-- Manages dynamic lighting and atmosphere for the game

local LightingManager = {}

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)

-- Initialize lighting settings
function LightingManager.Initialize()
	-- Basic lighting setup
	Lighting.Ambient = Color3.fromRGB(128, 128, 128)
	Lighting.Brightness = GameConfig.World.AmbientBrightness
	Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
	Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
	Lighting.EnvironmentDiffuseScale = 0.5
	Lighting.EnvironmentSpecularScale = 0.5
	Lighting.GlobalShadows = GameConfig.World.ShadowsEnabled
	Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
	Lighting.Technology = Enum.Technology.ShadowMap
	
	-- Add atmosphere
	local atmosphere = Instance.new("Atmosphere")
	atmosphere.Density = 0.3
	atmosphere.Offset = 0.25
	atmosphere.Color = Color3.fromRGB(199, 170, 107)
	atmosphere.Decay = Color3.fromRGB(92, 60, 13)
	atmosphere.Glare = 0.2
	atmosphere.Haze = 1.8
	atmosphere.Parent = Lighting
	
	-- Add bloom effect
	local bloom = Instance.new("BloomEffect")
	bloom.Intensity = 0.4
	bloom.Size = 24
	bloom.Threshold = 0.8
	bloom.Parent = Lighting
	
	-- Add color correction
	local colorCorrection = Instance.new("ColorCorrectionEffect")
	colorCorrection.Brightness = 0.05
	colorCorrection.Contrast = 0.1
	colorCorrection.Saturation = 0.1
	colorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
	colorCorrection.Parent = Lighting
	
	-- Add sun rays
	local sunRays = Instance.new("SunRaysEffect")
	sunRays.Intensity = 0.15
	sunRays.Spread = 0.8
	sunRays.Parent = Lighting
	
	print("Lighting initialized")
end

-- Day/night cycle (optional)
local dayNightEnabled = false
local cycleStartTime = 0

function LightingManager.EnableDayNightCycle()
	if GameConfig.World.DayNightEnabled then
		dayNightEnabled = true
		cycleStartTime = tick()
		print("Day/night cycle enabled")
	end
end

function LightingManager.UpdateDayNightCycle()
	if not dayNightEnabled then return end
	
	local elapsed = tick() - cycleStartTime
	local cycleProgress = (elapsed % GameConfig.World.DayLength) / GameConfig.World.DayLength
	
	-- Convert to time of day (6 AM to 6 AM)
	local timeOfDay = 6 + (cycleProgress * 24)
	
	-- Update Lighting
	Lighting.ClockTime = timeOfDay
	
	-- Adjust ambient based on time
	if timeOfDay >= 6 and timeOfDay < 18 then
		-- Daytime
		Lighting.Ambient = Color3.fromRGB(128, 128, 128)
		Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
		Lighting.Brightness = 2
	else
		-- Nighttime
		Lighting.Ambient = Color3.fromRGB(50, 50, 80)
		Lighting.OutdoorAmbient = Color3.fromRGB(30, 30, 60)
		Lighting.Brightness = 0.5
	end
end

-- Add street lights to the city
function LightingManager.AddStreetLights(cityFolder)
	local streetFolder = cityFolder:FindFirstChild("Streets")
	if not streetFolder then return end
	
	local lightCount = 0
	
	-- Add lights along streets
	for _, street in ipairs(streetFolder:GetDescendants()) do
		if street:IsA("BasePart") and street.Name ~= "Street" then
			-- Create light post
			local postHeight = 8
			local post = Instance.new("Part")
			post.Size = Vector3.new(0.5, postHeight, 0.5)
			post.Position = street.Position + Vector3.new(0, postHeight/2, 0)
			post.Material = Enum.Material.Metal
			post.Color = Color3.fromRGB(80, 80, 80)
			post.Anchored = true
			post.Name = "StreetLight"
			post.Parent = streetFolder
			
			-- Light fixture
			local fixture = Instance.new("Part")
			fixture.Size = Vector3.new(1.5, 0.5, 1.5)
			fixture.Position = post.Position + Vector3.new(0, postHeight/2 + 0.5, 0)
			fixture.Material = Enum.Material.Neon
			fixture.Color = Color3.fromRGB(255, 220, 150)
			fixture.Anchored = true
			fixture.Parent = streetFolder
			
			-- Point light
			local light = Instance.new("PointLight")
			light.Brightness = 1.5
			light.Range = 25
			light.Color = Color3.fromRGB(255, 220, 150)
			light.Shadows = true
			light.Parent = fixture
			
			lightCount = lightCount + 1
		end
	end
	
	print("Added " .. lightCount .. " street lights")
end

-- Add building lights
function LightingManager.AddBuildingLights(cityFolder)
	local zones = {
		cityFolder:FindFirstChild("CommercialZone"),
		cityFolder:FindFirstChild("DecorativeZone")
	}
	
	local lightCount = 0
	
	for _, zone in ipairs(zones) do
		if zone then
			for _, building in ipairs(zone:GetChildren()) do
				if building:IsA("Model") then
					-- Add lights to building windows
					for _, part in ipairs(building:GetDescendants()) do
						if part:IsA("BasePart") and part.Material == Enum.Material.Glass then
							local light = Instance.new("PointLight")
							light.Brightness = 0.8
							light.Range = 10
							light.Color = Color3.fromRGB(255, 200, 100)
							light.Parent = part
							
							lightCount = lightCount + 1
						end
					end
				end
			end
		end
	end
	
	print("Added " .. lightCount .. " building lights")
end

-- Weather effects (optional)
function LightingManager.SetWeather(weatherType)
	if weatherType == "Clear" then
		Lighting.FogEnd = 1000
		Lighting.FogStart = 0
	elseif weatherType == "Cloudy" then
		Lighting.FogEnd = 500
		Lighting.FogStart = 100
		Lighting.Brightness = 1.5
	elseif weatherType == "Foggy" then
		Lighting.FogEnd = 150
		Lighting.FogStart = 50
		Lighting.Brightness = 1.2
	end
	
	print("Weather set to: " .. weatherType)
end

return LightingManager
