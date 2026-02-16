# Quick Start: Connect Roblox to localhost:34872

**TL;DR - Fast Instructions for Connecting to Rojo**

## 1️⃣ Install Rojo Plugin
- Go to: https://www.roblox.com/library/13916111004/Rojo-7
- Click "Get" button
- Open Roblox Studio

## 2️⃣ Start Rojo Server
```bash
cd Meeting-Board
rojo serve
```
✅ Look for: `Rojo server listening on http://localhost:34872/`

## 3️⃣ Connect in Studio
1. Open Roblox Studio
2. Create new place (Baseplate)
3. Click **PLUGINS** tab → **Rojo** button
4. In Rojo panel: Click **"Connect"**
5. Click **"Sync In"**

## 4️⃣ Test
- Press **F5** to play
- Should spawn in city
- Press **C** for Owner Computer

---

## Common Issues

### "Can't find Rojo button"
→ Install plugin: https://www.roblox.com/library/13916111004/Rojo-7

### "Connection refused"
→ Make sure `rojo serve` is running in terminal

### "Disconnected"
→ Restart: Stop server (Ctrl+C), run `rojo serve` again, reconnect

### "Files don't sync"
→ Click "Disconnect", then "Connect", then "Sync In"

---

## The Connection Process (Visual)

```
Terminal                  Roblox Studio
--------                  -------------
$ cd Meeting-Board       1. Open Studio
$ rojo serve            2. New Baseplate
                        3. PLUGINS → Rojo
[Server Running]        4. Click "Connect"
  ↕                         ↕
Connection to localhost:34872
  ↕                         ↕
                        5. Click "Sync In"
                        6. Press F5 to play!
```

---

**Need more help?** See ROJO_SETUP.md for detailed instructions.

**Video tutorials:** Search "Rojo Roblox Studio" on YouTube.
