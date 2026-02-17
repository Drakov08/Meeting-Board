# How to Connect Roblox Studio to localhost:34872 (Rojo)

This guide will walk you through connecting Roblox Studio to the Rojo development server running on `localhost:34872`.

## 📋 Prerequisites

Before you start, make sure you have:
- ✅ Roblox Studio installed
- ✅ Rojo installed on your computer
- ✅ This project cloned to your computer

---

## 🔧 Step-by-Step Connection Guide

### Step 1: Install the Rojo Plugin in Roblox Studio

**Option A: Install from Roblox Marketplace (Easiest)**
1. Open your web browser
2. Go to: https://www.roblox.com/library/13916111004/Rojo-7
3. Click the green "Get" button to add it to your account
4. Open Roblox Studio
5. The plugin should appear in your PLUGINS tab at the top

**Option B: Install Manually**
1. Download the latest Rojo plugin from: https://github.com/rojo-rbx/rojo/releases
2. Look for a file named `Rojo.rbxm` in the release assets
3. In Roblox Studio, go to: PLUGINS → Folder Icon (Plugins Folder)
4. Copy the `Rojo.rbxm` file into this folder
5. Restart Roblox Studio

**Verify Installation:**
- Look for a "Rojo" button in the PLUGINS toolbar
- It should have an icon and say "Rojo"

---

### Step 2: Start the Rojo Server

1. **Open Terminal/Command Prompt**
   - Windows: Press `Win + R`, type `cmd`, press Enter
   - Mac: Press `Cmd + Space`, type "Terminal", press Enter
   - Linux: Open your terminal application

2. **Navigate to Project Directory**
   ```bash
   cd path/to/Meeting-Board
   ```
   Replace `path/to/Meeting-Board` with the actual path where you cloned this repository.

3. **Start Rojo**
   ```bash
   rojo serve
   ```

4. **Verify Server is Running**
   You should see output like:
   ```
   Rojo server listening on http://localhost:34872/
   ```

   ✅ **Success!** Your Rojo server is now running on port 34872.

   ⚠️ **Important:** Keep this terminal window open! If you close it, the server will stop.

---

### Step 3: Connect Roblox Studio to the Server

1. **Open Roblox Studio**
   - Launch Roblox Studio from your applications

2. **Create or Open a Place**
   - Option 1: Create a new Baseplate (File → New → Baseplate)
   - Option 2: Open an existing place file

3. **Locate the Rojo Plugin**
   - Look at the top toolbar
   - Find the "PLUGINS" tab
   - You should see a "Rojo" button/icon

4. **Open the Rojo Panel**
   - Click on the "Rojo" button in the PLUGINS tab
   - A panel will appear (usually on the right side of Studio)
   - The panel shows connection status and sync options

5. **Connect to the Server**
   - In the Rojo panel, you'll see:
     - Server address field (should show `localhost:34872`)
     - A "Connect" button
   - Click the **"Connect"** button

6. **Verify Connection**
   ✅ If successful, you'll see:
   - Connection status changes to "Connected" (green)
   - Project name: "GameDevSimulator"
   - A "Sync In" button becomes available

---

### Step 4: Sync the Project to Roblox Studio

1. **Initial Sync**
   - After connecting, click the **"Sync In"** button
   - This will create the project structure in your place
   - You'll see folders appear in Explorer:
     - ReplicatedStorage
     - ServerScriptService
     - StarterPlayer
     - Workspace

2. **Verify Project Structure**
   - Check the Explorer panel (usually on the right)
   - Expand ReplicatedStorage → should see Config and Modules folders
   - Expand ServerScriptService → should see GameServer.lua
   - Expand StarterPlayer → StarterPlayerScripts → should see UI scripts

3. **You're Connected!**
   - Any changes you make to `.lua` files will automatically sync
   - You can now test the game by pressing F5

---

## 🎮 Testing the Connection

1. **Test the Game**
   - Press F5 or click the ▶️ Play button
   - You should spawn in a city with a plaza
   - Press C to open the Owner Computer
   - Explore and interact with buildings

2. **Test Live Sync**
   - With the game running, open a .lua file in your code editor
   - Make a small change (like changing starting money in GameConfig.lua)
   - Save the file
   - The change should automatically sync to Studio
   - Stop and restart the game to see the change

---

## 🐛 Troubleshooting

### Problem: Can't Find Rojo Plugin in Studio

**Solution 1: Verify Installation**
- Close and restart Roblox Studio
- Check PLUGINS tab carefully
- Try reinstalling the plugin

**Solution 2: Manual Plugin Installation**
- Download Rojo.rbxm from GitHub releases
- Place it in the Plugins folder (PLUGINS → Plugins Folder)
- Restart Studio

---

### Problem: Rojo Panel Says "Disconnected"

**Possible Causes & Solutions:**

1. **Server Not Running**
   - Check your terminal - is `rojo serve` still running?
   - If not, run `rojo serve` again

2. **Wrong Port**
   - Verify the Rojo panel shows `localhost:34872`
   - If it shows a different port, change it manually

3. **Firewall Blocking**
   - Windows: Allow Rojo through Windows Firewall
   - Mac: Check System Preferences → Security & Privacy

4. **Wrong Directory**
   - Make sure you ran `rojo serve` in the Meeting-Board directory
   - The directory must contain `default.project.json`

---

### Problem: "Connection Refused" Error

**Solutions:**

1. **Check Rojo is Running**
   ```bash
   # In terminal, you should see:
   Rojo server listening on http://localhost:34872/
   ```

2. **Verify Port is Free**
   - Another program might be using port 34872
   - Try: `rojo serve --port 34873`
   - Update Roblox Studio connection to match new port

3. **Check default.project.json Exists**
   ```bash
   ls default.project.json
   ```
   - Should exist in project root
   - If missing, something went wrong with the clone

---

### Problem: Files Don't Sync Automatically

**Solutions:**

1. **Manual Sync**
   - Click "Sync In" button in Rojo panel again

2. **Restart Connection**
   - Click "Disconnect" in Rojo panel
   - Click "Connect" again
   - Click "Sync In"

3. **Check File Paths**
   - Verify you're editing files in the correct `src/` directory
   - Changes to files outside `src/` won't sync

---

### Problem: "Project file not found" Error

**Solution:**
- Make sure you're in the correct directory when running `rojo serve`
- The directory should contain `default.project.json`
- Try:
  ```bash
  cd /path/to/Meeting-Board
  ls default.project.json  # Verify it exists
  rojo serve
  ```

---

## 💡 Pro Tips

### Tip 1: Keep Terminal Visible
- Keep your terminal window visible while developing
- This way you can see Rojo's sync messages
- Helps catch errors immediately

### Tip 2: Use Two Monitors
- Monitor 1: Roblox Studio
- Monitor 2: Code editor + Terminal
- Makes development much smoother

### Tip 3: Rojo Status Messages
Watch for these messages in terminal:
- `[INFO] Session opened` - Roblox Studio connected
- `[INFO] Session closed` - Studio disconnected
- Sync messages appear when files change

### Tip 4: Restart When Confused
If things get weird:
1. Stop the game (F5 again if running)
2. Disconnect in Rojo panel
3. Stop Rojo server (Ctrl+C in terminal)
4. Start Rojo again (`rojo serve`)
5. Connect in Studio again
6. Sync In again

---

## 🔄 Alternative: Manual Installation (No Rojo)

If you can't get Rojo working, you can manually copy files:

1. **In Roblox Studio, create these services if they don't exist:**
   - ReplicatedStorage
   - ServerScriptService
   - StarterPlayer → StarterPlayerScripts

2. **Copy files manually:**
   - Open each `.lua` file from `src/` folders
   - Create matching scripts in Studio
   - Copy-paste the code

3. **Maintain folder structure:**
   - Keep the same folder organization as in `src/`

**Note:** With manual installation, you won't get automatic sync. You'll need to manually copy-paste changes every time.

---

## 📚 Additional Resources

- **Rojo Documentation:** https://rojo.space/docs
- **Rojo GitHub:** https://github.com/rojo-rbx/rojo
- **Video Tutorial:** Search "Rojo Roblox Studio tutorial" on YouTube
- **Project Docs:** See INSTALLATION.md in this repository

---

## ✅ Quick Checklist

Before asking for help, verify:
- [ ] Rojo is installed (`rojo --version` in terminal)
- [ ] Rojo plugin is installed in Studio (check PLUGINS tab)
- [ ] You're in the correct directory (has default.project.json)
- [ ] Rojo server is running (`rojo serve` in terminal)
- [ ] You can see "listening on http://localhost:34872" message
- [ ] Roblox Studio is open
- [ ] Rojo panel is visible in Studio
- [ ] Connection address is "localhost:34872"
- [ ] You clicked "Connect" button
- [ ] Connection status shows "Connected"
- [ ] You clicked "Sync In" button

If all checkboxes are ✅, you should be connected and ready to develop!

---

**Still having issues?** Open an issue on GitHub with:
1. Your operating system (Windows/Mac/Linux)
2. Rojo version (`rojo --version`)
3. The exact error message
4. Screenshot of the Rojo panel in Studio

---

**Happy developing!** 🎮✨
