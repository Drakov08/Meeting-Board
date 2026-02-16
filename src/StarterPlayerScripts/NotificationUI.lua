-- NotificationUI.lua
-- Client-side notification system for player feedback

local NotificationUI = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local notificationQueue = {}
local isShowingNotification = false

-- Create notification UI
local function createNotificationUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "NotificationUI"
	screenGui.ResetOnSpawn = false
	screenGui.DisplayOrder = 100
	screenGui.Parent = playerGui
	
	return screenGui
end

-- Get or create notification container
local function getNotificationContainer()
	local screenGui = playerGui:FindFirstChild("NotificationUI")
	if not screenGui then
		screenGui = createNotificationUI()
	end
	return screenGui
end

-- Show a notification
function NotificationUI.Show(message, notificationType, duration)
	duration = duration or GameConfig.UI.NotificationDuration
	notificationType = notificationType or "Info"
	
	-- Add to queue
	table.insert(notificationQueue, {
		Message = message,
		Type = notificationType,
		Duration = duration
	})
	
	-- Process queue if not already showing
	if not isShowingNotification then
		NotificationUI.ProcessQueue()
	end
end

-- Process notification queue
function NotificationUI.ProcessQueue()
	if #notificationQueue == 0 then
		isShowingNotification = false
		return
	end
	
	isShowingNotification = true
	local notification = table.remove(notificationQueue, 1)
	
	local container = getNotificationContainer()
	
	-- Create notification frame
	local frame = Instance.new("Frame")
	frame.Name = "Notification"
	frame.Size = UDim2.new(0, 400, 0, 80)
	frame.Position = UDim2.new(0.5, -200, 0, -100)
	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.BorderSizePixel = 0
	frame.Parent = container
	
	-- Set color based on type
	local colors = {
		Success = GameConfig.UI.Colors.Success,
		Error = GameConfig.UI.Colors.Error,
		Warning = GameConfig.UI.Colors.Warning,
		Info = GameConfig.UI.Colors.Primary
	}
	frame.BackgroundColor3 = colors[notification.Type] or colors.Info
	
	-- Corner rounding
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame
	
	-- Icon (simple)
	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 60, 1, 0)
	icon.BackgroundTransparency = 1
	icon.TextScaled = true
	icon.Font = Enum.Font.GothamBold
	icon.TextColor3 = Color3.fromRGB(255, 255, 255)
	
	if notification.Type == "Success" then
		icon.Text = "✓"
	elseif notification.Type == "Error" then
		icon.Text = "✗"
	elseif notification.Type == "Warning" then
		icon.Text = "⚠"
	else
		icon.Text = "ℹ"
	end
	
	icon.Parent = frame
	
	-- Message text
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -70, 1, -20)
	textLabel.Position = UDim2.new(0, 65, 0, 10)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = notification.Message
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextWrapped = true
	textLabel.TextScaled = false
	textLabel.TextSize = 18
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Parent = frame
	
	-- Animate in
	local tweenIn = TweenService:Create(
		frame,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		{Position = UDim2.new(0.5, -200, 0, 20)}
	)
	tweenIn:Play()
	
	-- Wait and animate out
	wait(notification.Duration)
	
	local tweenOut = TweenService:Create(
		frame,
		TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In),
		{Position = UDim2.new(0.5, -200, 0, -100)}
	)
	tweenOut:Play()
	
	tweenOut.Completed:Connect(function()
		frame:Destroy()
		NotificationUI.ProcessQueue()
	end)
end

-- Convenience functions
function NotificationUI.Success(message, duration)
	NotificationUI.Show(message, "Success", duration)
end

function NotificationUI.Error(message, duration)
	NotificationUI.Show(message, "Error", duration)
end

function NotificationUI.Warning(message, duration)
	NotificationUI.Show(message, "Warning", duration)
end

function NotificationUI.Info(message, duration)
	NotificationUI.Show(message, "Info", duration)
end

return NotificationUI
