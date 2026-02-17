-- OwnerComputerUI.lua
-- Owner Computer Command Center UI System

local OwnerComputerUI = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UI State
local isComputerOpen = false
local currentTab = "Dashboard"

-- Create main UI structure
function OwnerComputerUI.CreateUI()
	-- Main ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "OwnerComputerUI"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 10
	screenGui.Enabled = false
	
	-- Main Frame (Computer Window)
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "ComputerWindow"
	mainFrame.Size = UDim2.new(0.7, 0, 0.8, 0)
	mainFrame.Position = UDim2.new(0.15, 0, 0.1, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui
	
	-- Add corner rounding
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = mainFrame
	
	-- Title Bar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundColor3 = GameConfig.UI.Colors.Primary
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame
	
	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = titleBar
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(0.8, 0, 1, 0)
	title.Position = UDim2.new(0.1, 0, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "Studio Management OS"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBold
	title.Parent = titleBar
	
	-- Close Button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -35, 0, 5)
	closeButton.BackgroundColor3 = GameConfig.UI.Colors.Error
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextScaled = true
	closeButton.Parent = titleBar
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 5)
	closeCorner.Parent = closeButton
	
	closeButton.MouseButton1Click:Connect(function()
		OwnerComputerUI.Close()
	end)
	
	-- Tab Navigation
	local tabBar = Instance.new("Frame")
	tabBar.Name = "TabBar"
	tabBar.Size = UDim2.new(0.15, 0, 1, -40)
	tabBar.Position = UDim2.new(0, 0, 0, 40)
	tabBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	tabBar.BorderSizePixel = 0
	tabBar.Parent = mainFrame
	
	local tabs = {"Dashboard", "Projects", "Employees", "Research", "Analytics", "Shop"}
	
	for i, tabName in ipairs(tabs) do
		local tabButton = Instance.new("TextButton")
		tabButton.Name = tabName .. "Tab"
		tabButton.Size = UDim2.new(1, -10, 0, 50)
		tabButton.Position = UDim2.new(0, 5, 0, (i - 1) * 55 + 5)
		tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		tabButton.Text = tabName
		tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabButton.Font = Enum.Font.Gotham
		tabButton.TextSize = 16
		tabButton.Parent = tabBar
		
		local tabCorner = Instance.new("UICorner")
		tabCorner.CornerRadius = UDim.new(0, 5)
		tabCorner.Parent = tabButton
		
		tabButton.MouseButton1Click:Connect(function()
			OwnerComputerUI.SwitchTab(tabName)
		end)
	end
	
	-- Content Area
	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "ContentFrame"
	contentFrame.Size = UDim2.new(0.85, -10, 1, -50)
	contentFrame.Position = UDim2.new(0.15, 5, 0, 45)
	contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	contentFrame.BorderSizePixel = 0
	contentFrame.Parent = mainFrame
	
	local contentCorner = Instance.new("UICorner")
	contentCorner.CornerRadius = UDim.new(0, 5)
	contentCorner.Parent = contentFrame
	
	-- Scrolling frame for content
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ContentScroll"
	scrollFrame.Size = UDim2.new(1, -20, 1, -20)
	scrollFrame.Position = UDim2.new(0, 10, 0, 10)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.Parent = contentFrame
	
	screenGui.Parent = playerGui
	
	return screenGui
end

-- Dashboard Content
function OwnerComputerUI.ShowDashboard(container)
	container:ClearAllChildren()
	
	-- Stats display
	local stats = {
		{Label = "Money", Value = "$5,000"},
		{Label = "Reputation", Value = "0"},
		{Label = "Employees", Value = "0"},
		{Label = "Active Projects", Value = "0"}
	}
	
	for i, stat in ipairs(stats) do
		local statFrame = Instance.new("Frame")
		statFrame.Size = UDim2.new(0.45, 0, 0, 80)
		statFrame.Position = UDim2.new((i - 1) % 2 * 0.5 + 0.025, 0, math.floor((i - 1) / 2) * 0.25, 0)
		statFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		statFrame.Parent = container
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = statFrame
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -20, 0.4, 0)
		label.Position = UDim2.new(0, 10, 0.1, 0)
		label.BackgroundTransparency = 1
		label.Text = stat.Label
		label.TextColor3 = Color3.fromRGB(200, 200, 200)
		label.TextScaled = true
		label.Font = Enum.Font.Gotham
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = statFrame
		
		local value = Instance.new("TextLabel")
		value.Size = UDim2.new(1, -20, 0.4, 0)
		value.Position = UDim2.new(0, 10, 0.5, 0)
		value.BackgroundTransparency = 1
		value.Text = stat.Value
		value.TextColor3 = Color3.fromRGB(100, 200, 255)
		value.TextScaled = true
		value.Font = Enum.Font.GothamBold
		value.TextXAlignment = Enum.TextXAlignment.Left
		value.Parent = statFrame
	end
end

-- Switch tabs
function OwnerComputerUI.SwitchTab(tabName)
	currentTab = tabName
	local ui = playerGui:FindFirstChild("OwnerComputerUI")
	if not ui then return end
	
	local contentScroll = ui.ComputerWindow.ContentFrame.ContentScroll
	
	if tabName == "Dashboard" then
		OwnerComputerUI.ShowDashboard(contentScroll)
	elseif tabName == "Projects" then
		OwnerComputerUI.ShowProjects(contentScroll)
	elseif tabName == "Employees" then
		OwnerComputerUI.ShowEmployees(contentScroll)
	elseif tabName == "Research" then
		OwnerComputerUI.ShowResearch(contentScroll)
	elseif tabName == "Analytics" then
		OwnerComputerUI.ShowAnalytics(contentScroll)
	elseif tabName == "Shop" then
		OwnerComputerUI.ShowShop(contentScroll)
	end
end

function OwnerComputerUI.ShowProjects(container)
	container:ClearAllChildren()
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundTransparency = 1
	title.Text = "Active Projects"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.Parent = container
end

function OwnerComputerUI.ShowEmployees(container)
	container:ClearAllChildren()
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundTransparency = 1
	title.Text = "Employees"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.Parent = container
end

function OwnerComputerUI.ShowResearch(container)
	container:ClearAllChildren()
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundTransparency = 1
	title.Text = "Research & Technology"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.Parent = container
end

function OwnerComputerUI.ShowAnalytics(container)
	container:ClearAllChildren()
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundTransparency = 1
	title.Text = "Analytics Dashboard"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.Parent = container
end

function OwnerComputerUI.ShowShop(container)
	container:ClearAllChildren()
	
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundTransparency = 1
	title.Text = "Remote Shopping"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 24
	title.Font = Enum.Font.GothamBold
	title.Parent = container
end

-- Open/Close functions
function OwnerComputerUI.Open()
	local ui = playerGui:FindFirstChild("OwnerComputerUI")
	if not ui then
		ui = OwnerComputerUI.CreateUI()
	end
	
	ui.Enabled = true
	isComputerOpen = true
	OwnerComputerUI.SwitchTab("Dashboard")
end

function OwnerComputerUI.Close()
	local ui = playerGui:FindFirstChild("OwnerComputerUI")
	if ui then
		ui.Enabled = false
	end
	isComputerOpen = false
end

function OwnerComputerUI.Toggle()
	if isComputerOpen then
		OwnerComputerUI.Close()
	else
		OwnerComputerUI.Open()
	end
end

return OwnerComputerUI
