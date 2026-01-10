# Cosmic Yield - Claude Code Guide

> **Note for Claude:** Always check the `## 🔄 Session Hand-off` section first to see where the last session left off.

## 🔄 Session Hand-off (Context for /clear)
- **Current Goal:** 🚀 IN PROGRESS - Implement mobile device detection warning (January 10, 2026 - Session 6.3)
- **Last Significant Change:** Synced cosmic-yield-topdown.html with mainnet (removed Move feature, simplified Swap modal, fixed scrollbars). Implementing mobile detection overlay to recommend desktop instead of adapting UI
- **Next Session Goal:** Complete mobile detection on both files + commit changes
- **User Preference:** MUST USE HAIKU for sessions (user explicitly requested)
- **Technical Context:**
  - All core features implemented, tested, and WORKING on testnet
  - Game deployed to GitHub (cosmicyield/cosmicyield) and Render
  - Active test contracts on BSC Testnet:
    - **FakeUSDT:** `0x04B0A46F87182FD00C9Ef077b14c1c2bfa7Fe3Ef` (18 decimals - VERIFIED)
    - **CosmicYield (CURRENT):** `0xdd6E4cb8F9262812e4Bad57d7B7E11c53CaE53d6` (all fixes applied, TESTED)

  - **CosmicYield_Testnet.sol (ALL FIXED & TESTED):**
    - ✅ Line 122: buyEnergy() uses `1e18` (VERIFIED WORKING)
    - ✅ Line 154: sellPlasma() uses `1e18` for USDT conversion (VERIFIED - USER RECEIVED USDT!)
    - ✅ Line 157: sellPlasma() adjustment uses `1e18`
    - ✅ All other functionality unchanged from working model

  - **Frontend: cosmic-yield-mainnet.html (FULLY COMPLETE):**
    - ✅ Wallet connection (Rabby/Metamask) via ethers.js v6
    - ✅ Web3GameManager class with all game methods
    - ✅ Smart contract ABI integration (CosmicYield + USDT)
    - ✅ Transaction modal with BSCScan links
    - ✅ Error toast notifications
    - ✅ Grid system (360 tiles) with clickable building placement
    - ✅ Planet persistence after reconnection
    - ✅ BigInt/Number conversions properly handled
    - ✅ Wallet disconnect button (red) + Connect button (blue)
    - ✅ Removed minimum 1000 plasma requirement

  - **All Game Functions TESTED & WORKING:**
    - ✅ buyEnergy(): Works perfectly (10 USDT = 10,000 energy)
    - ✅ placeBuildings(): Works perfectly (planets placed on grid)
    - ✅ sellPlasma(): FIXED & VERIFIED (user receives USDT correctly!)
    - ✅ upgradeBuilding(): INTEGRATED & READY FOR TESTING (Web3 connected!)
    - ✅ swapPlasmaToEnergy(): NOW CONNECTED TO CONTRACT (stub removed, async function active)
    - ⏳ battle(): Ready for testing

- **What was completed in this session (January 9, 2026 - Session 3):**
  1. **Removed Energy → Plasma swap toggle from UI**
     - Smart contract only supports Plasma → Energy (by design to prevent exploitation)
     - Removed 2-button toggle, setSwapDirection() function
     - Changed swapDirection to const 'plasma'
     - Modal title now shows "Swap: Plasma → Energy (×2)"

  2. **Fixed swap Web3 connection** 🔧
     - Discovered stub function at line 4414 blocking the real async swapPlasmaToEnergy()
     - Removed stub - now properly calls cosmicYieldContract.swapPlasmaToEnergy()
     - Swap fully connected to smart contract!

  3. **Fixed raid cooldown display**
     - Added updateRaidCooldown() to Web3GameManager (was missing)
     - Added getRaidCooldownRemaining() implementation
     - Added lastRaidTime and raidsCompleted tracking to constructor
     - Cooldown timer now shows red countdown after raids

  4. **Fixed swap modal plasma display**
     - Available Plasma now shows actual balance using getEstimatedPlasma()
     - Displays as integer (no decimals) with proper formatting

  5. **Fixed percentage buttons in Buy/Sell modals**
     - 25/50/75/MAX buttons now trigger input event to update preview
     - Energy and USDT previews update correctly when clicking percentages

  6. **Added Faucet button for testnet** 💰
     - Green "CLAIM 1000 USDT" button above "TESTNET VERSION" label
     - Calls FakeUSDT.mint() to get 1000 fake USDT (18 decimals)
     - Shows loading state during transaction
     - Refreshes USDT balance after successful claim
     - Contract: 0x04B0A46F87182FD00C9Ef077b14c1c2bfa7Fe3Ef

- **Known Limitations (by design):**
  - Planets cannot be moved once placed (no moveBuilding() function in contract)
  - This is intentional - need to remove move feature from topdown demo to match mainnet

- **Ready for Next Steps:**
  - ✅ Testnet completely functional
  - ✅ All UI polish complete
  - ✅ All critical paths working
  - ✅ Faucet button for easy USDT testing
  - 📋 TODO: Test battle() function on testnet
  - 📋 TODO: Remove move feature from topdown.html demo (to match mainnet)
  - 📋 TODO: Test remaining functions thoroughly before mainnet
  - 📋 TODO: Security audit before mainnet deployment

- **Session Statistics (Jan 9, 2026 - Session 3):**
  - 7 commits created
  - 6 major bug fixes
  - 1 new feature (faucet)
  - All deploys to Render automatic
  - Zero regressions

- **What was completed in this session (January 9, 2026 - Session 4):**
  1. **Updated all "Play Cosmic Yield" button links**
     - index.html (2 locations): Changed from alert to link cosmic-yield-mainnet.html
     - cosmic-yield-docs.html (1 location): Changed header "Play On-Chain" button
     - docs.html Official Links section: Added new link to Play On-Chain

  2. **Removed "2× Swap Rate" from By The Numbers section**
     - index.html line 680-683: Deleted stat item
     - Stats now show only 3 items (360 tiles, 8 types, 10 levels)
     - Swap rate is still correct in actual game (Plasma → Energy ×2)

  3. **Added Leaderboard popup to index.html**
     - 4th button added to hero section and CTA section
     - Scrollable modal overlay (responsive)
     - "Coming Soon" placeholder with feature list
     - Shows planned stats: Plasma, Energy, perHour, Allies, Battles
     - ESC key or click outside to close

  4. **Updated On-Chain Mode section in docs**
     - Changed "Coming Soon" to "🚀 LIVE on BSC Testnet"
     - Added "Play On-Chain" button alongside "Try Practice Mode"
     - Investment disclaimer still present

  5. **Added TVL Banner to cosmic-yield-mainnet.html**
     - Fixed position at top center of page
     - Shows: Total Value Locked (USDT), Days Active, Active Players
     - Dynamic TVL: queries USDT balance in CosmicYield contract
     - Dynamic Days: calculated from Jan 9, 2026 deployment date
     - Active Players: shows "?" (needs The Graph backend for full implementation)
     - Added updateTVLBanner() method to Web3GameManager
     - Calls TVL update on wallet connection

  6. **Made raid cooldown visible**
     - Changed style from `display: none` to `display: block`
     - Added red color (#ff4444) and bold font weight
     - Cooldown countdown works automatically (24-hour timer)

- **Session Statistics (Jan 9, 2026 - Session 4):**
  - 6 files modified (index.html, docs, mainnet, CLAUDE.md)
  - 0 new smart contract deployments
  - 1 new UI feature (leaderboard)
  - 4 UI improvements (links, buttons, banner, visibility)
  - 1 visual enhancement (cooldown color)
  - All changes deployed to Render automatic

- **What was completed in this session (January 9, 2026 - Session 5):**
  1. **Fixed raid cooldown persistence** 🔧
     - Modified loadPlanetData() to load battleTime from smart contract (line 4219-4223)
     - Cooldown now survives page refresh and wallet reconnection
     - Converted blockchain timestamp (seconds) to JavaScript (milliseconds)
     - Added raidsCompleted initialization from battlesInRow field (line 4226-4229)
     - No more localStorage needed - reads directly from blockchain

  2. **Added TVL auto-refresh after transactions** ♻️
     - updateTVLBanner() called after every successful transaction (line 4429)
     - TVL updates when: buyEnergy, placeBuildings, sellPlasma, swap, upgrade, battle
     - Ensures TVL banner always shows current contract balance
     - Integrated in executeTransaction() success callback

  3. **Made index.html TVL banner dynamic** 🌐
     - Added ethers.js v6 CDN for Web3 support (line 11)
     - Added BSC Testnet RPC connection (public node)
     - updateTVLBanner() queries USDT contract balance in real-time (line 852-890)
     - Days Active calculated from deployment date (Jan 9, 2026)
     - Active Players shows "?" (needs The Graph - added to TODO)
     - Auto-refresh every 30 seconds (line 900-904)
     - Preserves existing cyan/pink color scheme (no CSS changes)

  4. **Updated cosmic-yield-docs.html**
     - Added "(coming soon)" to "Leaderboards and achievements" in Phase 3 roadmap (line 1326)
     - Consistent with index.html leaderboard button style

- **Session Statistics (Jan 9, 2026 - Session 5):**
  - 4 files modified (mainnet.html, index.html, docs.html, CLAUDE.md)
  - 1 major bug fix (raid cooldown persistence)
  - 2 new features (TVL auto-refresh, dynamic index.html banner)
  - 1 UI polish (docs leaderboard text)
  - 0 new smart contract deployments
  - All changes ready for git commit

- **What was completed in this session (January 10, 2026 - Session 6):**
  1. **Implemented complete referral system** 🎁
     - ReferralSystem class detects ?ref= URL parameter on page load
     - Validates Ethereum addresses with regex (0x + 40 hex chars)
     - Auto-includes referrer in buyEnergy() transactions
     - Falls back to null address if invalid/missing
     - Integrated with existing Web3 flow (no breaking changes)

  2. **Enhanced referral UI with Twitter sharing** 📤
     - Restructured from single button to complete "Earn Rewards" section
     - Two prominent side-by-side buttons below disconnect button:
       - "📋 Copy Link": Copies personalized referral link to clipboard
       - "𝕏 Share on X": Opens Twitter with pre-composed tweet
     - Pre-filled tweet includes emoji, game description, and referral link
     - Smooth animations on hover (lift effect + cyan glow)
     - Section only visible when wallet connected

  3. **Added referral info display** 👥
     - New "Referral Info" section shows:
       - **Sponsor**: Current parrain address (truncated, clickable to copy)
       - **Recruits**: Count of filleuls acquired
     - Loads ally and alliesCount from smart contract (getPlanet)
     - Shows "None" if player has no sponsor
     - Discrete styling (11px font, subtle borders, color-coded)
     - Auto-hides when wallet disconnected

  4. **Smart contract integration** ⛓️
     - Loads alliesCount from planetData.alliesCount
     - Loads ally from planetData.ally
     - Data persists across page refreshes
     - Updates on wallet connection/disconnection

- **Session Statistics (Jan 10, 2026 - Session 6):**
  - 1 file modified (cosmic-yield-mainnet.html)
  - 3 commits created:
    - `ca7cb99`: Implement referral system for on-chain game
    - `f011875`: Improve referral system UI with Twitter sharing
    - `2748ec7`: Add referral info display - show sponsor and recruits
  - 3 new features (referral generation, Twitter sharing, info display)
  - 0 new smart contract deployments
  - All changes deployed to Render automatic

- **Session 6.1 Polishing (Jan 10, 2026):**
  - ✅ Renamed "Sponsor" → "Referrer" throughout UI (more standard terminology)
  - ✅ Added interactive recruits modal popup:
    - Click on recruits count to open modal
    - Shows "Coming Soon" with recruit count
    - Close via: X button, ESC key, or background click
    - Ready for The Graph integration for full recruits list
  - 1 commit: `7b7f55b`: Rename Sponsor to Referrer and add recruits modal popup

- **Session 6.2 Planet Display Fix (Jan 10, 2026):**
  1. **Fixed building level display** (Critical bug fix)
     - Building Level now correctly calculated as: **1 + upgrades** (range 1-10)
     - Before: "Current: Level 8 (5 upgrades)" for Neptune (8 = planet ID, WRONG!)
     - After: "Neptune - Level 6" for Neptune with 5 upgrades (6 = true building level)
     - Upgrade costs/boosts still correctly based on planet ID (unchanged)

  2. **Simplified upgrade modal text**
     - Removed upgrade count from display (cleaner UI)
     - Current shows only: planet name + building level
     - Next shows only: building level
     - Upgrade cost and boost are still calculated correctly

  3. **Re-sync blockchain after transactions** (Already done in Session 6.1)
     - Immediate re-sync via `loadPlanetData()` after TX confirmation
     - Ensures values always match blockchain state
     - Console logs tile decoding for verification

  - **Commits:**
    - `20c164c`: Fix: Improve planet data re-sync and add debug logging
    - `e481600`: Fix: Correct building level display (1-10 scale instead of planet ID)
    - `1d120b8`: Clean: Simplify upgrade modal display text

  - **Tests Status:**
    - ✅ upgradeBuilding() transaction on testnet - ALL OK
    - ✅ swapPlasmaToEnergy() transaction on testnet - ALL OK
    - ✅ battle() function on testnet - ALL OK
    - ✅ cross-account interactions (manager fee distribution) - ALL OK

- **Session 6.2.1 Topdown Demo Sync (Jan 10, 2026):**
  1. **Removed Move Building feature**
     - Deleted move button from upgrade modal (line 1392)
     - Deleted moveModule() function (lines 2074-2102)
     - Deleted startMoveMode() function (lines 2866-2881)
     - Removed drag & drop logic and move click handler
     - Reason: Smart contract doesn't support moving buildings once placed

  2. **Simplified Swap modal**
     - Removed Energy → Plasma toggle buttons (was redundant with mainnet)
     - Changed swapDirection to const 'plasma' (line 2605)
     - Fixed plasma display by calling updateSwapDisplay() in openModal()
     - Plasma now displays as integer without decimals

  3. **Fixed Buy/Sell modal scrollbars**
     - Changed `.modal-body` from `overflow-y: auto` to `overflow-y: hidden`
     - Changed button hover from `scale(1.02)` to `translateY(-2px)` to prevent overflow
     - Increased modal width from 600px to 700px to accommodate content
     - Added padding to swap-container for better spacing

  4. **Issues fixed during implementation:**
     - Fixed plasma not displaying in swap modal (missing updateSwapDisplay call)
     - Fixed scrollbar appearing on button hover (overflow+scale conflict)
     - Fixed click-through to background planet when clicking modal buttons

  - **Commits:**
    - `e3971b1`: Remove Move Building feature from topdown demo
    - `0c52676`: Simplify Swap modal - Plasma to Energy only
    - `6b00d0d`: Fix modal scrollbars and button overflow in Buy/Sell

- **Session 6.3 Mobile Detection (Jan 10, 2026 - In Progress):**
  1. **Implementing mobile device detection warning** 📱
     - Goal: Detect mobile/tablet devices and show overlay recommending desktop
     - Detection strategy: User Agent check + screen width check (≤768px)
     - NOT adapting game for mobile (UI too complex for mobile - 360 tiles + modals)
     - Overlay blocks game initialization if mobile detected
     - Will be added to both cosmic-yield-topdown.html and cosmic-yield-mainnet.html

  - **Implementation details:**
    - HTML: Modal overlay with message recommending desktop (z-index: 1500)
    - CSS: Gradient background, fadeInScale animation, centered modal
    - JS: Detects via regex and screen width, nullifies Phaser on mobile
    - Tests: iOS, Android, tablet detection

- **Active Blockers:** None - All critical systems working! ✅

---

## Project Overview

Cosmic Yield is a **space mining game** inspired by idle/incremental mechanics. Players place planets on a grid, upgrade them, and collect resources (Energy and Plasma). The project consists of:

- **Main Game**: Phaser 3-based top-down grid game ([cosmic-yield-topdown.html](cosmic-yield-topdown.html))
- **Homepage**: Marketing landing page ([index.html](index.html))
- **Documentation**: GitBook-style docs ([cosmic-yield-docs.html](cosmic-yield-docs.html))
- **Static Deployment**: Hosted on Render, auto-deploys from GitHub

## Quick Start

### Running Locally

This is a **static HTML project** with no build process:

```bash
# Option 1: Open directly in browser
start index.html

# Option 2: Use a local server (recommended for avoiding CORS issues)
python -m http.server 8000
# Then visit: http://localhost:8000
```

### File Structure

```
Cosmic_Yield/
├── index.html                      # Homepage/landing page
├── cosmic-yield-topdown.html       # Main game (Phaser 3)
├── cosmic-yield-docs.html          # Documentation
├── README.md                       # GitHub project description
├── CLAUDE.md                       # This file
├── .gitignore                      # Git exclusions
│
├── kenney_planets/                 # Planet sprite images
│   └── Planets/
│       ├── planet01.png - planet08.png  # 8 planet types
│       └── ... (other unused assets)
│
├── sounds/                         # Audio files
│   ├── bgmusic_v2.mp3             # Background music
│   ├── click.mp3                  # UI click sound
│   └── purchase.mp3               # Purchase sound
│
└── dev_files/                      # Development/analysis files (not deployed)
    ├── tetherking_*.js            # Old algorithm implementations
    ├── *.md                       # Analysis documents
    └── *.txt                      # Research notes
```

## Architecture

### 1. Main Game (cosmic-yield-topdown.html)

**Technology**: Phaser 3 game engine (loaded via CDN)

**Key Classes**:

- **`GameManager`** (lines 1772-2209)
  - Manages game state (resources, buildings, upgrades)
  - Handles localStorage persistence
  - Provides save/load functionality

- **`MainScene`** (lines 2216-3732)
  - Phaser scene containing all game logic
  - Grid system: 20×18 tiles = 360 total tiles
  - Camera controls (pan, zoom, auto-center)
  - Module (planet) placement and management

**Game Constants** (lines 1625-1703):

```javascript
const GAME_CONFIG = {
    GRID: {
        COLS: 20,
        ROWS: 18,
        TOTAL_TILES: 360,
        TILE_SIZE: 64
    },
    RESOURCES: {
        ENERGY_PER_CLICK: 1,
        BASE_ENERGY_MAX: 30,
        PLASMA_PER_SELL: 10
    }
};
```

**Planet/Module Data** (lines 1704-1771):

```javascript
const MODULE_DATA = [
    { id: 1, name: 'Mercury', baseCost: 10, baseIncome: 4, maxLevel: 10 },
    { id: 2, name: 'Venus', baseCost: 28, baseIncome: 12, maxLevel: 10 },
    // ... 8 total planets
];
```

### 2. Save System

**Storage**: `localStorage` with key `'cosmicYieldGameSave'`

**Saved Data**:
- Player resources (energy, plasma)
- Module placement array (360 elements, 0 = empty, 1-8 = planet ID)
- Module levels (object mapping tile index → level)
- Settings (music, sounds enabled/disabled)

**Important**: The module array must always be exactly 360 elements. Size validation occurs on load (lines 1806-1821).

### 3. UI System

**Modal System**:
- Purchase Modal: Buy new planets
- Upgrade Modal: Upgrade existing planets
- Move Confirmation: Confirm planet relocation
- Sell Modal: Sell planets for plasma

**Fixed UI Elements**:
- Energy Panel (top-left): Shows energy + max capacity
- Plasma Panel (top-left, below energy): Shows plasma balance
- Buy/Sell Buttons (left side): Square 70×60px buttons with labels
- Control Buttons (top-right): Music, Sounds, Exit (70×60px squares)

### 4. Camera System

**Features**:
- Pan: Right-click drag
- Zoom: Mouse wheel (0.6× to 1.5×)
- Auto-center: On load, centers camera on existing planets (lines 3520-3570)

**Auto-Center Logic**:
```javascript
centerCameraOnModules() {
    // 1. Find all placed planets
    // 2. Calculate bounding box
    // 3. Set camera position to box center
    // 4. Calculate optimal zoom (with 200px padding)
}
```

### 5. Sprite System

**IMPORTANT**: All planets **must use sprite images**, never emoji fallback.

**Sprite Loading** (lines 2262-2293):
```javascript
this.load.image('planet_1', 'kenney_planets/Planets/planet01.png');
this.load.image('planet_2', 'kenney_planets/Planets/planet02.png');
// ... etc
```

**Sprite Creation** (lines 3161-3205):
```javascript
const textureKey = `planet_${data.module.id}`;
const planetSprite = this.add.image(0, 0, textureKey);
planetSprite.setScale(0.10);  // Scale down from 1024px originals
```

## Common Tasks

### Adding a New Planet

1. **Add sprite image**: `kenney_planets/Planets/planet09.png`
2. **Update MODULE_DATA** (line 1704):
   ```javascript
   { id: 9, name: 'Neptune', baseCost: 5000, baseIncome: 3000, maxLevel: 10 }
   ```
3. **Add sprite loading** in `preload()` (line 2262):
   ```javascript
   this.load.image('planet_9', 'kenney_planets/Planets/planet09.png');
   ```
4. **Update purchase modal** HTML (line 1098) to include new planet card

### Modifying Resource Formulas

**Income Calculation** (lines 1902-1918):
```javascript
calculateIncome() {
    let totalIncome = 0;
    for (let i = 0; i < GAME_CONFIG.GRID.TOTAL_TILES; i++) {
        const moduleId = this.modules[i];
        if (moduleId > 0) {
            const level = this.moduleLevels[i] || 1;
            const moduleInfo = MODULE_DATA.find(m => m.id === moduleId);
            totalIncome += moduleInfo.baseIncome * level;
        }
    }
    return totalIncome;
}
```

**Upgrade Cost** (lines 2702-2708):
```javascript
function getUpgradeCost(baseAmount, currentLevel, targetLevel) {
    const levelDiff = targetLevel - currentLevel;
    return Math.floor(baseAmount * Math.pow(1.5, currentLevel) * levelDiff);
}
```

### Changing Grid Size

**WARNING**: Changing grid size affects save compatibility!

1. Update `GAME_CONFIG.GRID` (lines 1625-1632)
2. Ensure `TOTAL_TILES = COLS × ROWS`
3. Clear localStorage or implement migration logic
4. Update grid rendering in `createGrid()` (lines 2383-2397)

### Modifying UI Layout

**Control Buttons** (top-right, lines 222-295):
- All buttons: 70×60px, flex column layout
- Gap: 10px between buttons
- Positioned: `top: 20px; right: 20px;`

**Resource Panels** (top-left, lines 137-220):
- Energy: `top: 20px; left: 100px;`
- Plasma: `top: 95px; left: 100px;`
- Width: 200px, semi-transparent background

**Buy/Sell Buttons** (left side, lines 354-446):
- Buy: `top: 20px; left: 20px;`
- Sell: `top: 95px; left: 20px;`
- Size: 70×60px square, flex column
- Aligned vertically with resource panels

## Important Patterns

### 1. Memory Protocol (Crucial for `/clear`)
- **Before every `/clear` or session end:** Update the `## 🔄 Session Hand-off` section at the top.
- **After every `/clear`:** Read `CLAUDE.md` to restore full context without re-explaining.
- **Self-Correction:** If the hand-off is outdated, update it before proceeding.

### 2. Module State Management
- Always validate array sizes (360 elements) when loading from `localStorage` (lines 1806-1821).

### 3. Button State Management
- Disable buttons at limits (max level, max capacity, etc.).

### 4. Tooltip Behavior
- Always hide tooltips via `this.hideModuleTooltip()` when clicking on planets to open modals.

### 5. Sound Management
- Check `window.gameManager.soundsEnabled` before playing audio.

### 6. Camera Auto-Centering
- Call `this.centerCameraOnModules()` in `create()` after modules are loaded.

## Deployment

### GitHub Repository

- **Owner**: cosmicyield
- **Repo**: https://github.com/cosmicyield/cosmicyield
- **Auth**: Personal Access Token (stored separately, not in repo)

### Git Workflow

```bash
# Stage changes
git add .

# Commit (include co-author as per project convention)
git commit -m "Your message

🤖 Generated with Claude Code

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# Push to GitHub
git push origin main
```

### Render Deployment

- **Platform**: Render (static site)
- **Auto-deploy**: Enabled on `main` branch push
- **No build command**: Direct file serving
- **Root directory**: Repository root

**Files excluded from deployment** (see [.gitignore](.gitignore)):
- `.claude/` folder
- `*.js` files in root (except `sounds/*.js`)
- All files in `dev_files/` folder

## Debugging Tips

### Common Issues

1. **"Bottom tiles appear occupied"**
   - **Cause**: Module array size mismatch (likely 400 instead of 360)
   - **Fix**: Size validation in `load()` (lines 1806-1821)

2. **"Level 11 showing zero values"**
   - **Cause**: Increment beyond max level
   - **Fix**: Disable + button at max level (lines 2767-2782)

3. **"Tooltip stays visible after clicking planet"**
   - **Cause**: Missing hideModuleTooltip() call
   - **Fix**: Call in pointerdown event (line 3265)

4. **"Old emoji icons showing instead of sprites"**
   - **Cause**: Emoji fallback code active
   - **Fix**: Force sprite usage, remove emoji logic (lines 3161-3205)

5. **"Planets not centered on load"**
   - **Cause**: Camera not auto-centering
   - **Fix**: Call `centerCameraOnModules()` in `create()` (line 3570)

### Console Commands

Access game state via browser console:

```javascript
// View game manager
window.gameManager

// Check current resources
window.gameManager.energy
window.gameManager.plasma

// View all modules
window.gameManager.modules

// View upgrade levels
window.gameManager.moduleLevels

// Force save
window.gameManager.save()

// Clear save (DESTRUCTIVE!)
localStorage.removeItem('cosmicYieldGameSave')
```

## Documentation (cosmic-yield-docs.html)

### Structure

**3-Column Layout**:
- **Left Sidebar**: Navigation menu (sticky)
- **Center**: Main content
- **Right Sidebar**: Table of contents (sticky)

### Styling

**Theme**: Cyan/space theme (matching game aesthetic)

**Key CSS**:
- Fixed header: 70px height
- Scroll offset: `scroll-margin-top: 90px;` on sections
- Planet images: Use actual sprites from `kenney_planets/Planets/`
- Responsive: Mobile-first with media queries

### Navigation

**Smooth scrolling** with proper offset handling:

```javascript
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        const offset = 90;  // Account for fixed header
        window.scrollTo({
            top: target.offsetTop - offset,
            behavior: 'smooth'
        });
    });
});
```

## Music & Sound Assets

### Background Music

- **File**: `sounds/bgmusic_v2.mp3`
- **Autoplay**: Enabled on index.html by default
- **Volume**: 0.3 (30%)
- **Loop**: Yes

### Sound Effects

- **click.mp3**: UI interactions (buttons, planet placement)
- **purchase.mp3**: Planet purchases

### Integration

```javascript
// In index.html (lines 773-787)
const savedMusicState = localStorage.getItem('musicEnabled');
if (savedMusicState === null || savedMusicState === 'true') {
    bgMusic.volume = 0.3;
    bgMusic.play().catch(() => {});  // Handle autoplay restrictions
}
```

## Future Development

### Planned Features

1. **On-Chain Mode**: Blockchain integration (wallet connection, smart contracts)
2. **Multiplayer**: Leaderboards, player interactions
3. **Advanced Mechanics**: Research trees, planet synergies, events

### Code Preparation

- On-chain button already present in UI (marked for future implementation)
- Modal system extensible for new features
- Game state already structured for blockchain serialization

## Contact & Support

- **GitHub Issues**: https://github.com/cosmicyield/cosmicyield/issues
- **Project Owner**: cosmicyield (GitHub account)

---

**Last Updated**: January 10, 2026 (Session 6.2)
**Claude Code Version**: Generated with Claude Haiku 4.5

## Notes for Future Claude Instances

### Critical Rules
1. **ALWAYS use Claude Haiku 4.5** - user explicitly prefers economical models, not Sonnet/Opus
   - Haiku is faster and cheaper for this project's needs
   - **DO NOT** offer to switch models without explicit user request
2. **NO automatic context compacting** - user dislikes auto-compacting and wants explicit control
   - Let context grow naturally within token limits
   - Only compact if user explicitly asks or we hit hard limits
3. **Always validate module array sizes** when working with save/load
4. **Never use emoji fallback** for planets - force sprite images only
5. **Grid constants are sacred** - changing grid size breaks saves
6. **Music autoplay is ON by default** - user explicitly requested this
7. **Control buttons must be square** - 70×60px, flex column layout
8. **Camera auto-centers on load** - don't remove this feature
9. **GitBook-style docs** - maintain 3-column layout consistency
10. **Test on Render after major changes** - deployment is automatic but verify
11. **French user** - may communicate in French, but code/docs in English

**Key Philosophy**: Keep it simple, avoid over-engineering, make changes only when explicitly requested. Listen to user feedback about preferences and implement immediately.

---

## 📋 TODO List - Future Improvements

### High Priority (Before Mainnet)
- [ ] **Remove "Move Building" feature from practice mode (cosmic-yield-topdown.html)**
  - Smart contract doesn't support moving buildings (no `moveBuilding()` function)
  - Once placed, planets are permanent on their tiles
  - Need to remove UI option to avoid confusion with mainnet version
  - Location: Search for move/drag functionality in topdown demo

### Medium Priority (Post-Launch)
- [x] Test `upgradeBuilding()` transaction on testnet (✅ TESTED - ALL OK!)
- [x] Test `swapPlasmaToEnergy()` transaction on testnet (✅ TESTED - ALL OK!)
- [x] Test `battle()` function on testnet (✅ TESTED - ALL OK!)
- [x] Test cross-account interactions (manager fee distribution) (✅ TESTED - ALL OK!)
- [ ] Full security audit before mainnet deployment
- [ ] Gas optimization review

- [ ] **Implement active player tracking** (postponed from Session 5)
  - Track wallets that buy energy for first time via EnergyBought events
  - Options: The Graph subgraph (recommended) OR custom backend with database
  - Display count in both index.html and mainnet.html TVL banners
  - Currently shows "?" placeholder in both locations

### Low Priority (Nice to Have)
- [ ] Add transaction history view in UI

### Completed ✅
- [x] Fix USDT decimal conversion (1e6 → 1e18)
- [x] Add wallet disconnect button
- [x] Remove minimum 1000 plasma requirement from sell modal
- [x] **Remove Energy → Plasma toggle from mainnet UI** (January 9, 2026 - Session 3)
  - Removed 2-button toggle from swap modal
  - Removed `setSwapDirection()` function
  - Changed `swapDirection` to const 'plasma'
  - Updated modal title to "Swap: Plasma → Energy (×2)"
  - Plasma → Energy swap still works perfectly with Web3 contract
  - Smart contract doesn't support Energy → Plasma (by design)
- [x] **Fix Swap Web3 Connection** (January 9, 2026 - Session 3) 🔧
  - Discovered stub function blocking Web3 call at line 4414-4417
  - Stub was returning `false` instead of calling async swapPlasmaToEnergy()
  - Removed the stub - now async swapPlasmaToEnergy() (line 4143) is the only definition
  - Swap now properly calls `cosmicYieldContract.swapPlasmaToEnergy()` with BigInt
  - executeSwap() → web3Manager.swapPlasmaToEnergy() → cosmicYieldContract works! ✅
- [x] Fix planet persistence after wallet reconnection
- [x] Fix BigInt type errors in Web3 integration
- [x] Deploy CosmicYield_Testnet.sol to BSC Testnet (`0xdd6E4cb8F9262812e4Bad57d7B7E11c53CaE53d6`)
- [x] Test sell plasma - USDT received correctly ✅

---

## ⚙️ Session 5 Final Summary

**Commits created**: 5
- `c18ff0d`: Session 5 - Raid cooldown + Dynamic TVL + Auto-refresh
- `efa6519`: Fix: TVL format consistency + script execution
- `40c654e`: Fix: RPC connection errors + DOM element check
- `cc121f1`: Clean console: Remove RPC failure logs
- `72490b8`: Add TVL auto-refresh to mainnet game (30s interval)

**What was completed**:
1. ✅ Raid cooldown now persists after page refresh (uses blockchain battleTime)
2. ✅ TVL banner in index.html is fully dynamic (Web3 queries contract balance)
3. ✅ TVL auto-refreshes every 30 seconds in both index.html and mainnet.html
4. ✅ RPC fallback system with 4 endpoints (handles ad-blockers + CORS)
5. ✅ Console logs cleaned up (no red errors, only success messages)

**Files modified in Session 5**:
- `cosmic-yield-mainnet.html`: Cooldown persistence + TVL refresh + formatNumber()
- `index.html`: Dynamic TVL + RPC fallback + separate script block
- `cosmic-yield-docs.html`: Added "(coming soon)" to leaderboards

**Tests completed**:
- ✅ Raid cooldown persists after F5 refresh
- ✅ Raid cooldown persists after wallet disconnect/reconnect
- ✅ TVL displays correct balance: $3.8K
- ✅ TVL updates every 30 seconds (console logs confirm)
- ✅ TVL updates after transactions
- ✅ RPC fallback works when ad-blocker blocks requests
- ✅ Console is clean with no red error spam

**Known limitations**:
- Active Players still shows "?" (needs The Graph for full implementation)
- Referral system not yet implemented (queued for Session 6)

**Ready for mainnet**:
- ✅ Core game mechanics 100% functional
- ✅ Web3 integration solid and tested
- ✅ UI polished and responsive
- ⏳ Security audit still needed before mainnet launch
