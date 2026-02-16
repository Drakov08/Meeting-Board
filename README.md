# Game Development Simulator - Roblox

A deep, systemic, interactive Roblox simulator game where players build a game development studio from the ground up, within a dense, explorable, low-poly city.

## 🚀 Quick Start

**New to Rojo?** See our setup guides:
- 📘 **[Quick Start Guide](QUICKSTART_ROJO.md)** - Fast instructions to connect to localhost:34872
- 📗 **[Detailed Rojo Setup](ROJO_SETUP.md)** - Step-by-step with troubleshooting
- 📕 **[Full Installation Guide](INSTALLATION.md)** - Complete setup instructions

## 🎮 Game Overview

Build and manage your own game development studio in an immersive 3D city environment. Hire employees, develop games, research new technologies, and grow your reputation in the gaming industry.

### Key Features

- **Explorable City**: Navigate a procedurally generated, low-poly city with distinct zones
- **Studio Management**: Hire employees, manage teams, and balance productivity with wellbeing
- **Game Development Pipeline**: Create games through pre-production, production, and post-production phases
- **Research System**: Unlock new technologies and capabilities
- **Dynamic Market**: Adapt to changing genre popularities and market trends
- **Owner Computer**: Centralized management interface for remote operations

## 🏗️ Project Structure

```
src/
├── ReplicatedStorage/
│   ├── Config/
│   │   └── GameConfig.lua          # Central game configuration
│   └── Modules/
│       ├── CityGenerator.lua       # Procedural city generation
│       ├── EmployeeSystem.lua      # Employee management & traits
│       ├── GameDevPipeline.lua     # Game development lifecycle
│       └── ResearchSystem.lua      # Technology tree & upgrades
├── ServerScriptService/
│   ├── GameServer.lua              # Main server logic
│   └── Services/
│       └── PlayerDataManager.lua   # Player data & progression
└── StarterPlayerScripts/
    ├── PlayerController.lua        # Player input & interactions
    └── OwnerComputerUI.lua        # Management UI system
```

## 🌆 City Zones

### Central Hub
- Player spawn plaza
- Navigation signage
- Quick access to all major areas

### Commercial Zone
- Computer Store (hardware upgrades)
- Hiring Agency (employee recruitment)
- Interior Decor Store (office furniture)
- Marketing Offices

### Studio Zone
- 12 player plots for studio buildings
- Starter garage studios
- Expansion buildings
- Professional workspace aesthetic

### Decorative Buffer Zone
- Non-enterable buildings for scale
- Parks and green spaces
- Visual density elements

## 🎯 Gameplay Systems

### Employee Management
- **Tiers**: Junior, Mid-Level, Senior, Expert
- **Traits**: Creative, Analytical, Team Player, Fast Worker, etc.
- **Systems**: Burnout, Loyalty, Team Synergy, Training

### Game Development
- **Phases**: Pre-production → Production → Post-production
- **Genres**: Action, Adventure, RPG, Strategy, Simulation, and more
- **Quality**: Based on team skill, productivity, and phase completion
- **Market**: Dynamic genre popularity and revenue calculations

### Technology Research
- **Basic Engine**: Foundation for game creation
- **Advanced Engine**: Enhanced features and performance
- **AI Assistant**: +20% productivity boost
- **Multiplayer System**: +50% revenue potential
- **Cross-Platform**: +100% market reach

### Progression
- Earn money through game releases
- Build reputation with quality titles
- Unlock better buildings and technologies
- Hire more skilled employees

## 🛠️ Development

This is a Roblox game project using the Rojo workflow.

### Requirements
- Roblox Studio
- Rojo (for syncing source code to Roblox)

### Setup

1. Install Rojo: https://rojo.space/
2. Open terminal in project directory
3. Run: `rojo serve`
4. In Roblox Studio, connect to localhost:34872
5. Use the Rojo plugin to sync the project

### Configuration

Main configuration file: `src/ReplicatedStorage/Config/GameConfig.lua`

Adjust settings for:
- City generation parameters
- Starting money and reputation
- Building costs and capacities
- Employee tier attributes
- Development phase durations
- Research costs and benefits

## 📖 Design Philosophy

This game follows a core design philosophy:

- **Not a clicker/idle game**: Fully interactive and explorable
- **Compact but deep**: Small footprint, massive perceived depth
- **Systemic gameplay**: All systems work together cohesively
- **Performance optimized**: Low-poly art style for smooth performance
- **Immersive world**: Every building and zone has purpose

See `GAME_DESIGN.md` for complete design documentation.

## 🚀 Future Enhancements

- NPC pedestrian AI
- Day/night cycle system
- More building interiors
- Employee animations
- Multiplayer studio cooperation
- Competitive leaderboards
- Special events and challenges

## 📄 License

This project is for educational and entertainment purposes.
