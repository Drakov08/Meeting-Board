-- EmployeeSystem.lua
-- Manages employee hiring, traits, productivity, and burnout

local EmployeeSystem = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)

-- Employee class
local Employee = {}
Employee.__index = Employee

function Employee.new(tier, name)
	local self = setmetatable({}, Employee)
	
	local tierData = GameConfig.Employees.Tiers[tier]
	
	self.Id = game:GetService("HttpService"):GenerateGUID(false)
	self.Name = name or ("Employee_" .. math.random(1000, 9999))
	self.Tier = tier
	self.Skill = math.random(tierData.SkillRange[1], tierData.SkillRange[2])
	self.BaseProductivity = math.random() * (tierData.ProductivityRange[2] - tierData.ProductivityRange[1]) + tierData.ProductivityRange[1]
	
	-- Assign 2-3 random traits
	self.Traits = {}
	local traitCount = math.random(2, 3)
	local availableTraits = {table.unpack(GameConfig.Employees.Traits)}
	
	for i = 1, traitCount do
		if #availableTraits > 0 then
			local index = math.random(1, #availableTraits)
			table.insert(self.Traits, availableTraits[index])
			table.remove(availableTraits, index)
		end
	end
	
	-- Status
	self.Stress = 0
	self.Loyalty = 50
	self.IsWorking = false
	self.CurrentTask = nil
	self.Experience = 0
	
	return self
end

function Employee:GetProductivity()
	local productivity = self.BaseProductivity
	
	-- Reduce productivity based on stress
	if self.Stress > GameConfig.Employees.BurnoutThreshold then
		productivity = productivity * 0.5
	elseif self.Stress > 50 then
		productivity = productivity * 0.75
	end
	
	-- Loyalty affects productivity
	productivity = productivity * (0.5 + self.Loyalty / 100)
	
	-- Trait bonuses
	if table.find(self.Traits, "Fast Worker") then
		productivity = productivity * 1.2
	end
	
	return productivity
end

function Employee:AddStress(amount)
	self.Stress = math.clamp(self.Stress + amount, 0, GameConfig.Employees.MaxStress)
	
	-- Loyalty decreases when stressed
	if self.Stress > GameConfig.Employees.BurnoutThreshold then
		self.Loyalty = math.max(0, self.Loyalty - 1)
	end
end

function Employee:Rest(duration)
	local recovery = GameConfig.Employees.RestRecoveryRate * (duration / 60)
	self.Stress = math.max(0, self.Stress - recovery)
	
	-- Loyalty increases slightly when well-rested
	if self.Stress < 30 then
		self.Loyalty = math.min(100, self.Loyalty + 0.5)
	end
end

function Employee:Work(hours)
	self.IsWorking = true
	local stressGain = GameConfig.Employees.StressPerHour * hours
	self:AddStress(stressGain)
	self.Experience = self.Experience + (hours * self.Skill)
	
	-- Level up skill based on experience
	if self.Experience >= 100 then
		self.Skill = math.min(10, self.Skill + 1)
		self.Experience = self.Experience - 100
		print(self.Name .. " leveled up! New skill: " .. self.Skill)
	end
end

function Employee:StopWork()
	self.IsWorking = false
	self.CurrentTask = nil
end

function Employee:CheckSynergy(otherEmployee)
	-- Calculate team synergy based on shared traits
	local synergyScore = 0
	
	for _, trait in ipairs(self.Traits) do
		if table.find(otherEmployee.Traits, trait) then
			synergyScore = synergyScore + 0.1
		end
	end
	
	-- Team Player trait increases synergy
	if table.find(self.Traits, "Team Player") or table.find(otherEmployee.Traits, "Team Player") then
		synergyScore = synergyScore + 0.15
	end
	
	return synergyScore
end

function Employee:Serialize()
	return {
		Id = self.Id,
		Name = self.Name,
		Tier = self.Tier,
		Skill = self.Skill,
		BaseProductivity = self.BaseProductivity,
		Traits = self.Traits,
		Stress = self.Stress,
		Loyalty = self.Loyalty,
		Experience = self.Experience,
		IsWorking = self.IsWorking
	}
end

-- EmployeeSystem functions
function EmployeeSystem.CreateEmployee(tier, name)
	return Employee.new(tier, name)
end

function EmployeeSystem.CalculateTeamProductivity(employees)
	local totalProductivity = 0
	local teamSize = #employees
	
	-- Base productivity from all employees
	for _, employee in ipairs(employees) do
		totalProductivity = totalProductivity + employee:GetProductivity()
	end
	
	-- Calculate average synergy bonus
	local synergyBonus = 0
	if teamSize > 1 then
		local synergyCount = 0
		for i = 1, teamSize do
			for j = i + 1, teamSize do
				synergyBonus = synergyBonus + employees[i]:CheckSynergy(employees[j])
				synergyCount = synergyCount + 1
			end
		end
		if synergyCount > 0 then
			synergyBonus = synergyBonus / synergyCount
		end
	end
	
	totalProductivity = totalProductivity * (1 + synergyBonus)
	
	return totalProductivity, synergyBonus
end

function EmployeeSystem.GenerateRandomName()
	local firstNames = {
		"Alex", "Jordan", "Taylor", "Casey", "Morgan",
		"Jamie", "Riley", "Avery", "Quinn", "Blake",
		"Sam", "Drew", "Cameron", "Jessie", "Reese"
	}
	
	local lastNames = {
		"Smith", "Johnson", "Williams", "Brown", "Jones",
		"Garcia", "Miller", "Davis", "Rodriguez", "Martinez",
		"Wilson", "Anderson", "Taylor", "Thomas", "Moore"
	}
	
	return firstNames[math.random(1, #firstNames)] .. " " .. lastNames[math.random(1, #lastNames)]
end

function EmployeeSystem.GetHireCost(tier)
	return GameConfig.Employees.Tiers[tier].Cost
end

function EmployeeSystem.GetAvailableEmployees(tier, count)
	local employees = {}
	
	for i = 1, count do
		local name = EmployeeSystem.GenerateRandomName()
		table.insert(employees, EmployeeSystem.CreateEmployee(tier, name))
	end
	
	return employees
end

return EmployeeSystem
