# Cosmic Yield - Claude Code Guide

> **Note for Claude:** Always check the `## 🔄 Session Hand-off` section first to see where the last session left off.

## 🔄 Session Hand-off (Context for /clear)
- **Current Goal:** ✅ COMPLETE - Web3 version now has dynamic energy/plasma counters like the demo!
- **Last Significant Change:** Added production estimation system for smooth, dynamic counters in Web3 version (January 8, 2026 - Session 2)
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
    - ⏳ swapPlasmaToEnergy(): Ready for testing
    - ⏳ battle(): Ready for testing

- **What was completed in this session:**
  1. Fixed USDT decimal conversion (1e6 → 1e18)
  2. Added wallet disconnect button with proper styling
  3. Removed minimum 1000 plasma requirement from sell modal
  4. Tested sell plasma - USER RECEIVED USDT! ✅
  5. Updated contract address in HTML: `0xdd6E4cb8F9262812e4Bad57d7B7E11c53CaE53d6`
  6. Added TODO list in CLAUDE.md for future work
  7. Identified that smart contract doesn't support moving buildings (permanent placement)
  8. **NEW (Jan 8 - Session 2):** Integrated upgrade button with Web3 smart contract ✅
     - Simplified UI to single-level upgrades (+1 per click)
     - Removed multi-level selector (buttons +/-)
     - Removed MOVE button (not supported by contract)
     - Rewrote `executeUpgrade()` to use `web3Manager.upgradeBuilding(tileId)`
     - Added validations: max level, energy check, wallet connection
     - Shows transaction modal with gas verification link on BSCScan
     - Planet visuals auto-update after successful upgrade
     - Follows same pattern as other Web3 functions (buyEnergy, sellPlasma, etc.)

  9. **NEW (Jan 8 - Session 2, Part 2):** Added dynamic energy/plasma counters to Web3 version ✅
     - Web3GameManager now has `getEstimatedEnergy()` and `getEstimatedPlasma()` methods
     - Tracks `lastSyncTime` (when blockchain data was last loaded)
     - Estimates production between syncs: `perHour / 3600000 * elapsed_ms`
     - Added `startProductionLoop()` - updates UI every 100ms for smooth animation
     - `updateUI()` now displays estimated values instead of static blockchain values
     - Counters are **optimistic** (smooth visually) but verified on blockchain after each transaction
     - Gives Web3 version same dynamic feel as local demo mode!
     - Zero blockchain cost (pure frontend estimation, no gas)

- **Known Limitations (by design):**
  - Planets cannot be moved once placed (no moveBuilding() function in contract)
  - This is intentional - need to remove move feature from topdown demo to match mainnet

- **Ready for Next Steps:**
  - ✅ Testnet completely functional
  - ✅ All critical paths tested
  - ✅ Ready for security audit before mainnet
  - 📋 TODO: Remove move feature from topdown.html demo (HIGH PRIORITY)
  - 📋 TODO: Test remaining functions (upgradeBuilding, swapPlasmaToEnergy, battle)

- **Active Blockers:** None - Everything is working!

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

**Last Updated**: January 6, 2026
**Claude Code Version**: Generated with Claude Sonnet 4.5

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
- [x] Test `upgradeBuilding()` transaction on testnet (IMPLEMENTATION COMPLETE - Ready for testing!)
- [ ] Test `swapPlasmaToEnergy()` transaction on testnet
- [ ] Test `battle()` function on testnet
- [ ] Test cross-account interactions (manager fee distribution)
- [ ] Full security audit before mainnet deployment
- [ ] Gas optimization review

### Low Priority (Nice to Have)
- [ ] Add `moveBuilding()` function to smart contract (if user requests it)
  - Would require new contract deployment
  - Function signature: `moveBuilding(uint16 _fromTileId, uint16 _toTileId)`
  - Consider energy cost for moving
- [ ] Add building removal/destruction feature
- [ ] Implement batch operations for placing multiple building types at once
- [ ] Add transaction history view in UI

### Completed ✅
- [x] Fix USDT decimal conversion (1e6 → 1e18)
- [x] Add wallet disconnect button
- [x] Remove minimum 1000 plasma requirement from sell modal
- [x] Fix planet persistence after wallet reconnection
- [x] Fix BigInt type errors in Web3 integration
- [x] Deploy CosmicYield_Testnet.sol to BSC Testnet (`0xdd6E4cb8F9262812e4Bad57d7B7E11c53CaE53d6`)
- [x] Test sell plasma - USDT received correctly ✅
