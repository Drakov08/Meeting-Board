-- TestRunner.lua
-- Quick validation script to test core systems

local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("=== Running System Tests ===")

-- Test 1: Load all modules
print("\n[TEST 1] Loading Modules...")
local testsPassed = 0
local testsFailed = 0

local modules = {
	{Name = "GameConfig", Path = ReplicatedStorage.Config.GameConfig},
	{Name = "CityGenerator", Path = ReplicatedStorage.Modules.CityGenerator},
	{Name = "EmployeeSystem", Path = ReplicatedStorage.Modules.EmployeeSystem},
	{Name = "GameDevPipeline", Path = ReplicatedStorage.Modules.GameDevPipeline},
	{Name = "ResearchSystem", Path = ReplicatedStorage.Modules.ResearchSystem},
	{Name = "BuildingInteriors", Path = ReplicatedStorage.Modules.BuildingInteriors},
	{Name = "NPCSystem", Path = ReplicatedStorage.Modules.NPCSystem}
}

for _, moduleData in ipairs(modules) do
	local success, result = pcall(function()
		return require(moduleData.Path)
	end)
	
	if success then
		print("✓ " .. moduleData.Name .. " loaded successfully")
		testsPassed = testsPassed + 1
	else
		print("✗ " .. moduleData.Name .. " failed to load: " .. tostring(result))
		testsFailed = testsFailed + 1
	end
end

-- Test 2: Employee System
print("\n[TEST 2] Employee System...")
local EmployeeSystem = require(ReplicatedStorage.Modules.EmployeeSystem)

local testEmployee = EmployeeSystem.CreateEmployee("MidLevel", "Test Employee")
if testEmployee and testEmployee.Name == "Test Employee" then
	print("✓ Employee creation works")
	testsPassed = testsPassed + 1
	
	local productivity = testEmployee:GetProductivity()
	if productivity > 0 then
		print("✓ Employee productivity calculation works: " .. productivity)
		testsPassed = testsPassed + 1
	else
		print("✗ Employee productivity calculation failed")
		testsFailed = testsFailed + 1
	end
else
	print("✗ Employee creation failed")
	testsFailed = testsFailed + 1
end

-- Test 3: Game Development Pipeline
print("\n[TEST 3] Game Development Pipeline...")
local GameDevPipeline = require(ReplicatedStorage.Modules.GameDevPipeline)

local testProject = GameDevPipeline.CreateProject("Test Game", "Action", 0.8)
if testProject and testProject.Name == "Test Game" then
	print("✓ Project creation works")
	testsPassed = testsPassed + 1
	
	testProject:Start()
	if testProject.IsActive then
		print("✓ Project can be started")
		testsPassed = testsPassed + 1
	else
		print("✗ Project start failed")
		testsFailed = testsFailed + 1
	end
else
	print("✗ Project creation failed")
	testsFailed = testsFailed + 1
end

-- Test 4: Research System
print("\n[TEST 4] Research System...")
local ResearchSystem = require(ReplicatedStorage.Modules.ResearchSystem)

ResearchSystem.Initialize()

local canResearch, reason = ResearchSystem.CanResearch("BasicEngine")
if canResearch then
	print("✓ Research system prerequisites work")
	testsPassed = testsPassed + 1
else
	print("✗ Research prerequisites failed: " .. reason)
	testsFailed = testsFailed + 1
end

local availableTech = ResearchSystem.GetAvailableTechnologies()
if #availableTech > 0 then
	print("✓ Research system returns available technologies: " .. #availableTech)
	testsPassed = testsPassed + 1
else
	print("✗ No technologies available")
	testsFailed = testsFailed + 1
end

-- Test 5: Configuration
print("\n[TEST 5] Configuration System...")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)

if GameConfig.Player.StartingMoney == 5000 then
	print("✓ Config values accessible")
	testsPassed = testsPassed + 1
else
	print("✗ Config values incorrect")
	testsFailed = testsFailed + 1
end

if GameConfig.City.PlayerPlotCount == 12 then
	print("✓ City configuration correct")
	testsPassed = testsPassed + 1
else
	print("✗ City configuration incorrect")
	testsFailed = testsFailed + 1
end

-- Test 6: Team Synergy
print("\n[TEST 6] Team Synergy System...")

local employee1 = EmployeeSystem.CreateEmployee("Senior", "Employee 1")
local employee2 = EmployeeSystem.CreateEmployee("Senior", "Employee 2")

local synergy = employee1:CheckSynergy(employee2)
if synergy >= 0 then
	print("✓ Team synergy calculation works: " .. synergy)
	testsPassed = testsPassed + 1
else
	print("✗ Team synergy calculation failed")
	testsFailed = testsFailed + 1
end

local teamProductivity = EmployeeSystem.CalculateTeamProductivity({employee1, employee2})
if teamProductivity > 0 then
	print("✓ Team productivity calculation works: " .. teamProductivity)
	testsPassed = testsPassed + 1
else
	print("✗ Team productivity calculation failed")
	testsFailed = testsFailed + 1
end

-- Test 7: Genre Popularity
print("\n[TEST 7] Market System...")

local genrePopularity = GameDevPipeline.GetGenrePopularity("Action")
if genrePopularity > 0 then
	print("✓ Genre popularity system works: " .. genrePopularity)
	testsPassed = testsPassed + 1
else
	print("✗ Genre popularity system failed")
	testsFailed = testsFailed + 1
end

local allGenres = GameDevPipeline.GetAllGenrePopularities()
local genreCount = 0
for _ in pairs(allGenres) do
	genreCount = genreCount + 1
end

if genreCount > 0 then
	print("✓ All genres have popularity values: " .. genreCount)
	testsPassed = testsPassed + 1
else
	print("✗ Genre popularity initialization failed")
	testsFailed = testsFailed + 1
end

-- Final Results
print("\n=== Test Results ===")
print("Tests Passed: " .. testsPassed)
print("Tests Failed: " .. testsFailed)
print("Total Tests: " .. (testsPassed + testsFailed))

if testsFailed == 0 then
	print("\n✓ ALL TESTS PASSED! System is ready.")
else
	print("\n✗ Some tests failed. Please review the errors above.")
end

return {
	Passed = testsPassed,
	Failed = testsFailed,
	Total = testsPassed + testsFailed
}
