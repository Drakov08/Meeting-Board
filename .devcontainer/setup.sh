#!/bin/bash

# Codespace Setup Script for Roblox Game Dev Simulator
# This script installs Rojo and sets up the development environment

set -e

echo "🚀 Setting up Roblox Game Dev Simulator development environment..."

# Install Rojo
echo "📦 Installing Rojo..."
ROJO_VERSION="7.4.4"
ROJO_URL="https://github.com/rojo-rbx/rojo/releases/download/v${ROJO_VERSION}/rojo-${ROJO_VERSION}-linux-x86_64.zip"

cd /tmp
curl -L "$ROJO_URL" -o rojo.zip
unzip -o rojo.zip
chmod +x rojo
sudo mv rojo /usr/local/bin/
rm rojo.zip

# Verify installation
echo "✅ Rojo installed: $(rojo --version)"

# Create helpful aliases
echo "⚙️ Setting up aliases..."
cat >> ~/.zshrc << 'EOF'

# Roblox Game Dev Simulator Aliases
alias rojo-start='rojo serve --port 34872'
alias rojo-build='rojo build -o GameDevSimulator.rbxl'
EOF

# Create welcome message
cat > ~/.welcome.txt << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                  🎮 ROBLOX GAME DEV SIMULATOR                               ║
║                     GitHub Codespace Ready!                                  ║
╚══════════════════════════════════════════════════════════════════════════════╝

Welcome to your Roblox Game Development Simulator workspace!

🚀 QUICK START:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Start Rojo server:
   $ rojo serve

2. The server will start on port 34872 (already forwarded!)

3. Connect from Roblox Studio:
   - Install Rojo plugin: https://www.roblox.com/library/13916111004/Rojo-7
   - Copy the forwarded URL from the PORTS tab
   - In Studio: PLUGINS → Rojo → Connect to your Codespace URL
   - Click "Sync In"

📚 DOCUMENTATION:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- README.md              - Project overview
- ROJO_SETUP.md          - Detailed Rojo connection guide
- QUICKSTART_ROJO.md     - Quick reference
- INSTALLATION.md        - Full setup instructions
- FEATURES.md            - Complete feature list

💡 HELPFUL COMMANDS:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

rojo-start               - Start Rojo server on port 34872
rojo-build               - Build .rbxl file
rojo --help              - Show all Rojo commands

📁 PROJECT STRUCTURE:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

src/
├── ReplicatedStorage/   - Shared game modules
├── ServerScriptService/ - Server-side logic
└── StarterPlayerScripts/- Client UI and controls

🎯 READY TO DEVELOP!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

All dependencies are installed and ready to go.
Edit any .lua file and changes will sync automatically to Roblox Studio!

EOF

# Display welcome message
cat ~/.welcome.txt

# Add welcome message to .zshrc for future terminal sessions
echo 'cat ~/.welcome.txt' >> ~/.zshrc

echo ""
echo "✨ Setup complete! Your development environment is ready."
echo ""
