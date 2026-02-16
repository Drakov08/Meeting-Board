# Installation & Setup Guide

## Prerequisites

Before you begin, ensure you have the following installed:

1. **Roblox Studio** - Download from [roblox.com/create](https://www.roblox.com/create)
2. **Rojo** - Install from [rojo.space](https://rojo.space/)
   - Windows: Download the installer
   - macOS/Linux: Use `cargo install rojo` or download prebuilt binaries

## Setup Instructions

### Method 1: Using Rojo (Recommended for Development)

1. **Install Rojo Plugin in Roblox Studio**
   - Download the Rojo plugin from the Roblox marketplace
   - Or install from [rojo.space/docs/installation](https://rojo.space/docs/installation/)

2. **Clone or Download this Repository**
   ```bash
   git clone https://github.com/Drakov08/Meeting-Board.git
   cd Meeting-Board
   ```

3. **Start Rojo Server**
   ```bash
   rojo serve
   ```
   This will start a server on `localhost:34872`

4. **Connect Roblox Studio**
   - Open Roblox Studio
   - Create a new place or open an existing one
   - Click the Rojo plugin button in the toolbar
   - Click "Connect" and it should connect to `localhost:34872`
   - The project structure will sync to your Roblox place

5. **Test the Game**
   - Press F5 or click the Play button in Roblox Studio
   - You should spawn in the central plaza of the city
   - Press C to open the Owner Computer
   - Explore the city and interact with buildings

### Method 2: Manual Import

1. **Create a New Place in Roblox Studio**

2. **Copy Source Files**
   - Copy the contents of `src/ReplicatedStorage/` to ReplicatedStorage in Studio
   - Copy the contents of `src/ServerScriptService/` to ServerScriptService
   - Copy the contents of `src/StarterPlayerScripts/` to StarterPlayer > StarterPlayerScripts

3. **Run the Game**
   - The city will be generated when you start the game
   - Press F5 to test

## Project Structure Overview

```
src/
├── ReplicatedStorage/
│   ├── Config/
│   │   └── GameConfig.lua              # Main configuration
│   └── Modules/
│       ├── CityGenerator.lua           # City generation
│       ├── EmployeeSystem.lua          # Employee management
│       ├── GameDevPipeline.lua         # Game development
│       ├── ResearchSystem.lua          # Research tree
│       ├── BuildingInteriors.lua       # Interior systems
│       └── NPCSystem.lua               # NPC AI
├── ServerScriptService/
│   ├── GameServer.lua                  # Main server script
│   └── Services/
│       ├── PlayerDataManager.lua       # Player data
│       └── InteractionHandler.lua      # Interactions
└── StarterPlayerScripts/
    ├── PlayerController.lua            # Player input
    └── OwnerComputerUI.lua            # UI system
```

## Configuration

### Adjusting Game Settings

Edit `src/ReplicatedStorage/Config/GameConfig.lua` to customize:

- **Starting money**: `GameConfig.Player.StartingMoney`
- **City size**: `GameConfig.City.Size`
- **Number of NPCs**: `GameConfig.World.NPCCount`
- **Building costs**: `GameConfig.Buildings`
- **Employee tiers**: `GameConfig.Employees.Tiers`
- **Research costs**: `GameConfig.Research.Technologies`

### Example: Changing Starting Money

```lua
-- In GameConfig.lua
GameConfig.Player = {
    SpawnLocation = Vector3.new(0, 5, 0),
    WalkSpeed = 16,
    StartingMoney = 10000,  -- Changed from 5000 to 10000
    StartingReputation = 0
}
```

## Controls

- **WASD** - Move around
- **Space** - Jump
- **Mouse** - Look around
- **C** - Open/Close Owner Computer
- **Tab** - Quick stats (placeholder)
- **Proximity Prompts** - Interact with buildings and shops

## Gameplay Quick Start

1. **Claim a Plot**
   - Go to the Studio Zone (left of spawn)
   - Walk to a yellow marker on a plot
   - Press the proximity prompt to claim it

2. **Hire Employees**
   - Visit the Hiring Agency in the Commercial Zone
   - Walk to a hiring station
   - Press the prompt to hire employees of different tiers

3. **Buy Equipment**
   - Visit the Computer Store for hardware upgrades
   - Visit the Decor Store for furniture and decorations

4. **Start a Project** (via Owner Computer - Press C)
   - Navigate to the Projects tab
   - Create a new game project
   - Assign employees to work on it

5. **Research Technologies** (via Owner Computer)
   - Navigate to the Research tab
   - Unlock new capabilities and bonuses

## Troubleshooting

### City doesn't generate
- Check the Output window for errors
- Make sure GameServer.lua is in ServerScriptService
- Verify all modules are in ReplicatedStorage

### NPCs aren't spawning
- Ensure NPCSystem.lua is loaded
- Check `GameConfig.World.NPCCount` is greater than 0
- Look for errors in the Output window

### UI doesn't open (Computer)
- Make sure PlayerController.lua is in StarterPlayerScripts
- Verify OwnerComputerUI.lua is also in StarterPlayerScripts
- Press C to toggle the computer interface

### Interactions don't work
- Ensure ProximityPrompt service is enabled
- Check that InteractionHandler.lua is running on the server
- Verify building interiors were created

## Development Tips

### Live Sync Changes
When using Rojo, any changes you make to `.lua` files will automatically sync to Roblox Studio. You don't need to restart the game for code changes.

### Testing Performance
- Monitor the Stats window (Shift + F2)
- Keep part count reasonable
- Use StreamingEnabled for larger worlds

### Debugging
- Use `print()` statements liberally
- Check the Output window (View > Output)
- Use the Developer Console (F9) for client-side debugging

## Next Steps

1. Read `GAME_DESIGN.md` for detailed game design philosophy
2. Review `README.md` for feature overview
3. Customize `GameConfig.lua` to your liking
4. Start building your game dev empire!

## Support

For issues or questions:
- Check the Output window for errors
- Review the code comments in each module
- Open an issue on GitHub

## Advanced: Building for Production

To build a standalone `.rbxl` file:

```bash
rojo build -o GameDevSimulator.rbxl
```

This creates a Roblox place file you can upload directly to Roblox.

---

**Happy developing!** 🎮✨
