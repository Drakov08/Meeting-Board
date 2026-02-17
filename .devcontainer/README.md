# GitHub Codespaces Setup

## 🚀 Quick Start

This project is fully configured for GitHub Codespaces! You can develop the entire Roblox game in your browser.

### Option 1: One-Click Setup

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/Drakov08/Meeting-Board)

Click the badge above to create a new Codespace with everything pre-configured.

### Option 2: From Repository

1. Go to the repository: https://github.com/Drakov08/Meeting-Board
2. Click the green "Code" button
3. Click "Codespaces" tab
4. Click "Create codespace on [branch-name]"

## ⚙️ What's Pre-Configured

When your Codespace starts, it automatically:

- ✅ **Installs Rojo 7.4.4** - The development server
- ✅ **Sets up Lua extensions** - For VS Code
- ✅ **Configures port forwarding** - For localhost:34872
- ✅ **Creates helpful aliases** - Quick commands
- ✅ **Displays welcome guide** - Every terminal session

## 🔌 Connecting Roblox Studio

### Step 1: Start Rojo Server

In the Codespace terminal, run:
```bash
rojo serve
```

Or use the convenient alias:
```bash
rojo-start
```

### Step 2: Get Your Codespace URL

1. Look at the **PORTS** tab at the bottom of VS Code
2. Find port **34872** (Rojo Server)
3. The URL will look like: `https://[your-codespace]-34872.app.github.dev`
4. Click the globe icon to copy the URL

### Step 3: Connect from Roblox Studio

1. **Install Rojo Plugin** (if not already installed):
   - https://www.roblox.com/library/13916111004/Rojo-7

2. **Open Roblox Studio**:
   - Create a new Baseplate or open existing place

3. **Connect to Codespace**:
   - Click **PLUGINS** → **Rojo**
   - In the Rojo panel, change the address from `localhost:34872` to your Codespace URL
   - Example: `https://vigilant-space-disco-5g6q6xwp5r6fxxx-34872.app.github.dev`
   - Click **Connect**
   - Click **Sync In**

4. **Test the Game**:
   - Press **F5** to play
   - You should spawn in the city central plaza
   - Press **C** to open the Owner Computer

## 💻 Development Workflow

### Live Sync

Once connected, any changes you make to `.lua` files in the Codespace will automatically sync to Roblox Studio!

```
Edit file in Codespace → Save → Auto-sync to Studio
```

### Helpful Commands

| Command | Description |
|---------|-------------|
| `rojo-start` | Start Rojo server on port 34872 |
| `rojo-build` | Build standalone .rbxl file |
| `rojo --help` | Show all available commands |

### File Organization

```
src/
├── ReplicatedStorage/      # Shared modules (game logic)
├── ServerScriptService/    # Server-side scripts
└── StarterPlayerScripts/   # Client UI and controls
```

## 🐛 Troubleshooting

### "Connection refused" in Studio

**Problem**: Can't connect from Roblox Studio

**Solution**:
1. Make sure `rojo serve` is running in the terminal
2. Check the PORTS tab - port 34872 should show "Running"
3. Copy the FULL URL from the PORTS tab (including https://)
4. Make sure the port visibility is set to "Public"

### Port Not Showing

**Problem**: Port 34872 not visible in PORTS tab

**Solution**:
1. Start the Rojo server: `rojo serve`
2. Go to PORTS tab
3. If not visible, click "+" to manually forward port 34872
4. Set visibility to "Public"

### Changes Not Syncing

**Problem**: File changes don't appear in Studio

**Solution**:
1. Save the file in Codespace (Ctrl+S)
2. Check terminal - should see sync messages
3. In Studio, click "Disconnect" then "Connect" again
4. Click "Sync In" again

### Codespace Timeout

**Problem**: Codespace stops after inactivity

**Solution**:
- Codespaces auto-stop after 30 minutes of inactivity
- Simply restart the Codespace from GitHub
- Rojo server will need to be started again
- Reconnect from Studio with the same URL

## 📚 Additional Resources

- **[ROJO_SETUP.md](ROJO_SETUP.md)** - Detailed Rojo connection guide
- **[QUICKSTART_ROJO.md](QUICKSTART_ROJO.md)** - Quick reference
- **[INSTALLATION.md](INSTALLATION.md)** - Full installation guide
- **[FEATURES.md](FEATURES.md)** - Complete feature documentation

## 💡 Tips & Tricks

### Tip 1: Keep Terminal Visible
Keep the terminal with `rojo serve` running visible so you can see sync messages.

### Tip 2: Multiple Terminals
Open multiple terminals (Terminal → New Terminal) to run commands while Rojo is running.

### Tip 3: VS Code Extensions
The Codespace comes with useful Lua extensions pre-installed:
- Lua Language Server
- Rojo extension
- StyLua (code formatter)

### Tip 4: Port Persistence
Your forwarded port URL stays the same while the Codespace is active. Bookmark it for quick access!

### Tip 5: Save Often
While changes auto-sync, make sure to commit and push your changes to save them permanently.

## 🎉 Benefits of Codespaces

- ✅ **No local setup** - Works in browser
- ✅ **Consistent environment** - Same for all developers
- ✅ **Fast startup** - Ready in ~2 minutes
- ✅ **Powerful machine** - Better than many local setups
- ✅ **Accessible anywhere** - Any device with browser
- ✅ **Free tier available** - 60 hours/month for free

## 🆘 Need Help?

If you encounter issues:

1. Check the terminal output for error messages
2. Review the troubleshooting section above
3. Check the main documentation files
4. Open an issue on GitHub with:
   - What you were trying to do
   - Error messages or screenshots
   - Codespace logs if available

---

**Happy coding in the cloud!** ☁️✨
