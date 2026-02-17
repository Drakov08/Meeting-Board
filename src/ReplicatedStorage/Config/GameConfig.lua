-- GameConfig.lua
-- Central configuration for the Game Development Simulator

local GameConfig = {}

-- City Generation Settings
GameConfig.City = {
	-- Total city size (studs)
	Size = 1000,
	
	-- Plot configuration
	PlayerPlotCount = 12,
	PlotSize = Vector3.new(50, 1, 50), -- Width, Height, Depth
	PlotSpacing = 10, -- Studs between plots
	
	-- Zone sizes (percentage of total city)
	Zones = {
		CentralHub = 0.15,
		Commercial = 0.25,
		Studio = 0.30,
		Decorative = 0.30
	},
	
	-- Visual density settings
	BuildingDensity = 0.7, -- How packed buildings are
	TreeDensity = 0.3,
	PropDensity = 0.4,
	
	-- Street configuration
	StreetWidth = 10,
	CurveIntensity = 0.5, -- 0 = straight, 1 = very curvy
	
	-- Elevation settings
	MaxElevationChange = 20,
	HillFrequency = 0.3
}

-- Player Settings
GameConfig.Player = {
	SpawnLocation = Vector3.new(0, 5, 0), -- Center of city
	WalkSpeed = 16,
	StartingMoney = 5000,
	StartingReputation = 0
}

-- Building Costs
GameConfig.Buildings = {
	GarageStudio = {
		Cost = 2000,
		MaxDesks = 4,
		Unlocked = true
	},
	SmallStudio = {
		Cost = 15000,
		MaxDesks = 10,
		RequiredReputation = 50
	},
	LargeStudioHQ = {
		Cost = 100000,
		MaxDesks = 30,
		RequiredReputation = 200
	}
}

-- Employee Settings
GameConfig.Employees = {
	-- Hiring tiers
	Tiers = {
		Junior = {
			Cost = 500,
			SkillRange = {1, 3},
			ProductivityRange = {0.5, 0.8}
		},
		MidLevel = {
			Cost = 2000,
			SkillRange = {4, 6},
			ProductivityRange = {0.8, 1.2}
		},
		Senior = {
			Cost = 5000,
			SkillRange = {7, 9},
			ProductivityRange = {1.2, 1.5}
		},
		Expert = {
			Cost = 15000,
			SkillRange = {9, 10},
			ProductivityRange = {1.5, 2.0}
		}
	},
	
	-- Personality traits
	Traits = {
		"Creative",
		"Analytical",
		"Social",
		"Perfectionist",
		"Fast Worker",
		"Team Player",
		"Independent",
		"Detail-Oriented"
	},
	
	-- Burnout system
	MaxStress = 100,
	StressPerHour = 2,
	RestRecoveryRate = 10,
	BurnoutThreshold = 80
}

-- Game Development Settings
GameConfig.Development = {
	-- Project phases
	Phases = {
		PreProduction = {
			Duration = 120, -- seconds (in-game time)
			RequiredSkill = "Design"
		},
		Production = {
			Duration = 300,
			RequiredSkill = "Programming"
		},
		PostProduction = {
			Duration = 90,
			RequiredSkill = "Testing"
		}
	},
	
	-- Genre settings
	Genres = {
		"Action",
		"Adventure",
		"RPG",
		"Strategy",
		"Simulation",
		"Puzzle",
		"Racing",
		"Sports"
	},
	
	-- Quality thresholds
	QualityThresholds = {
		Poor = 0.3,
		Average = 0.5,
		Good = 0.7,
		Excellent = 0.9
	}
}

-- Market & Reputation
GameConfig.Market = {
	-- Trend cycle duration (seconds)
	TrendCycleDuration = 600,
	
	-- Genre popularity ranges
	PopularityRange = {0.5, 1.5},
	
	-- Reputation gains/losses
	ReputationGain = {
		Poor = -10,
		Average = 5,
		Good = 20,
		Excellent = 50
	},
	
	-- Revenue multipliers
	RevenueMultiplier = {
		Poor = 0.3,
		Average = 1.0,
		Good = 2.0,
		Excellent = 5.0
	}
}

-- Technology & Research
GameConfig.Research = {
	Technologies = {
		BasicEngine = {
			Cost = 1000,
			ResearchTime = 60,
			Unlocks = {"Basic game creation"}
		},
		AdvancedEngine = {
			Cost = 5000,
			ResearchTime = 180,
			Requires = {"BasicEngine"},
			Unlocks = {"Advanced features", "Better performance"}
		},
		AIAssistant = {
			Cost = 10000,
			ResearchTime = 240,
			Requires = {"AdvancedEngine"},
			Unlocks = {"AI-assisted development", "+20% productivity"}
		},
		MultiplayerSystem = {
			Cost = 15000,
			ResearchTime = 300,
			Requires = {"AdvancedEngine"},
			Unlocks = {"Multiplayer games", "+50% revenue potential"}
		},
		CrossPlatform = {
			Cost = 20000,
			ResearchTime = 360,
			Requires = {"MultiplayerSystem"},
			Unlocks = {"Cross-platform releases", "+100% market reach"}
		}
	}
}

-- Shop Settings
GameConfig.Shops = {
	ComputerStore = {
		Items = {
			BasicPC = {Cost = 500, ProductivityBonus = 0},
			MidRangePC = {Cost = 2000, ProductivityBonus = 0.2},
			HighEndPC = {Cost = 5000, ProductivityBonus = 0.5},
			WorkstationPC = {Cost = 15000, ProductivityBonus = 1.0}
		}
	},
	
	DecorStore = {
		Items = {
			BasicDesk = {Cost = 100, MoodBonus = 0},
			ComfortChair = {Cost = 200, MoodBonus = 0.1},
			PlantDecor = {Cost = 50, MoodBonus = 0.05},
			Poster = {Cost = 30, MoodBonus = 0.03},
			WhiteBoard = {Cost = 150, MoodBonus = 0.08},
			CoffeeStation = {Cost = 500, MoodBonus = 0.15}
		}
	}
}

-- World Reactivity
GameConfig.World = {
	-- NPC settings
	NPCCount = 30,
	NPCWalkSpeed = 12,
	NPCIdleTime = {5, 15}, -- Min, Max seconds
	
	-- Day/night cycle (optional)
	DayNightEnabled = false,
	DayLength = 600, -- seconds for full day/night cycle
	
	-- Lighting
	AmbientBrightness = 2,
	ShadowsEnabled = true
}

-- UI Settings
GameConfig.UI = {
	-- Owner Computer OS
	ComputerOSEnabled = true,
	
	-- Notification settings
	NotificationDuration = 5,
	
	-- Colors
	Colors = {
		Primary = Color3.fromRGB(102, 126, 234),
		Secondary = Color3.fromRGB(118, 75, 162),
		Success = Color3.fromRGB(76, 175, 80),
		Warning = Color3.fromRGB(255, 152, 0),
		Error = Color3.fromRGB(244, 67, 54)
	}
}

return GameConfig
