# Cosmic Yield - Space Mining Idle Game

[![BSC Testnet](https://img.shields.io/badge/BSC-Testnet%20Live-success)](https://testnet.bscscan.com/address/0xdd6E4cb8F9262812e4Bad57d7B7E11c53CaE53d6)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> Build, upgrade, and battle your way to passive USDT earnings in this blockchain-powered space mining game.

## 🎮 Overview

**Cosmic Yield** is an idle mining game where players place planets on a 360-tile grid, upgrade them to generate resources, and earn real USDT through strategic gameplay. The game combines classic idle mechanics with blockchain technology for transparent, on-chain earnings.

### Key Features

- 🪐 **8 Planet Types** - Mercury to Neptune, each with unique costs and yields
- ⬆️ **10-Level Upgrade System** - Enhance your planets for maximum production
- ⚡ **Dual Resource Economy** - Energy (on-chain) and Plasma (generated hourly)
- ⚔️ **Battle System** - Raid other players for bonus rewards
- 🔄 **Plasma ↔ Energy Swaps** - Convert resources at a 2× rate
- 💰 **USDT Integration** - Deposit and withdraw real value
- 👥 **Referral Rewards** - Earn bonuses by inviting friends
- 📊 **Dynamic TVL Banner** - Real-time total value locked tracking

## 🚀 Play Now

### Practice Mode (Free)
Try the full game mechanics without spending real money:
- **Live Demo**: [cosmic-yield-topdown.html](https://cosmicyield.onrender.com/cosmic-yield-topdown.html)
- No wallet required
- All features unlocked
- Perfect for learning strategies

### On-Chain Mode (Testnet)
Play with real blockchain transactions on BSC Testnet:
- **Testnet Game**: [cosmic-yield-mainnet.html](https://cosmicyield.onrender.com/cosmic-yield-mainnet.html)
- Connect MetaMask or Rabby wallet
- Get free test USDT from the faucet button
- Experience full on-chain gameplay

### Documentation
- **Full Docs**: [cosmic-yield-docs.html](https://cosmicyield.onrender.com/cosmic-yield-docs.html)
- **Website**: [index.html](https://cosmicyield.onrender.com/)

## 🛠️ Tech Stack

### Frontend
- **Phaser 3** - Game engine for 2D grid-based gameplay
- **ethers.js v6** - Web3 integration for blockchain interactions
- **Vanilla JavaScript** - No framework overhead, pure performance
- **Static HTML** - Fast loading, zero build process

### Smart Contracts
- **Solidity** - EVM-compatible smart contracts
- **BSC (Binance Smart Chain)** - Low fees, fast transactions
- **Testnet**: Fully functional deployment for testing
- **Mainnet**: Pending security audit

## 📜 Smart Contract Details

### BSC Testnet (LIVE)
- **CosmicYield Contract**: `0xdd6E4cb8F9262812e4Bad57d7B7E11c53CaE53d6`
- **Test USDT Contract**: `0x04B0A46F87182FD00C9Ef077b14c1c2bfa7Fe3Ef` (18 decimals)
- **Network**: BSC Testnet
- **Chain ID**: 97

### Verified Functions
✅ All core functions tested and working on testnet:

| Function | Description | Status |
|----------|-------------|--------|
| `buyEnergy()` | Deposit USDT for energy | ✅ Verified |
| `placeBuildings()` | Place planets on grid | ✅ Verified |
| `upgradeBuilding()` | Upgrade existing planets | ✅ Verified |
| `sellPlasma()` | Withdraw USDT earnings | ✅ Verified |
| `swapPlasmaToEnergy()` | Convert plasma to energy (2×) | ✅ Verified |
| `battle()` | Raid system with rewards | ✅ Verified |

### Mainnet Deployment
⏳ **Coming Soon** - After professional security audit

## 🎯 Game Mechanics

### Resource System
- **Energy** (⚡): Stored on-chain, used to place/upgrade planets
- **Plasma** (💎): Generated hourly by planets, can be sold for USDT
- **USDT** (💵): Real currency - deposit to buy energy, withdraw from plasma sales

### Planet Economics

| Planet | Cost | Yield/hr | Efficiency |
|--------|------|----------|------------|
| Mercury | 10,000 | 4 | 0.0004 |
| Venus | 28,000 | 12 | 0.000429 |
| Earth | 54,000 | 24 | 0.000444 |
| Mars | 100,000 | 48 | 0.00048 |
| Jupiter | 250,000 | 124 | 0.000496 |
| Saturn | 500,000 | 260 | 0.00052 |
| Uranus | 1,000,000 | 550 | 0.00055 |
| Neptune | 2,000,000 | 1,150 | 0.000575 |

### Upgrade System
- **Max Level**: 10 per planet
- **Cost Formula**: `Base Cost ÷ 4` per upgrade
- **Yield Increase**: `Base Yield ÷ 4` per upgrade
- **Example**: Mercury L1 → L10 = 4 + (1 × 9) = 13 plasma/hour

### Battle System
- **Cooldown**: 24 hours between raids
- **Risk/Reward**: Choose 40-60% win chance
- **Higher risk** = Higher reward multiplier
- **Win**: Full reward + consolation prize
- **Loss**: Consolation prize only

### Referral System
- **Generate Link**: Get your unique referral URL
- **Rewards**: Earn bonus when referrals buy energy
- **Track**: See your sponsor and recruit count
- **Share**: One-click Twitter sharing

## 🏗️ Architecture

### Frontend Files
```
index.html                  # Homepage/landing page
cosmic-yield-topdown.html   # Practice mode (offline)
cosmic-yield-mainnet.html   # On-chain mode (Web3)
cosmic-yield-docs.html      # Documentation
```

### Key Classes

#### GameManager (Practice Mode)
```javascript
class GameManager {
  constructor() {
    this.energy = 0;
    this.plasma = 0;
    this.modules = new Array(360).fill(0);
    this.moduleLevels = {};
  }

  buildModule(tileIndex, moduleId) { /* ... */ }
  upgradeModule(tileIndex) { /* ... */ }
  executeRaid(winChance) { /* ... */ }
}
```

#### Web3GameManager (On-Chain Mode)
```javascript
class Web3GameManager {
  async connectWallet() { /* MetaMask/Rabby connection */ }
  async buyEnergy(usdtAmount) { /* Deposit USDT */ }
  async placeBuildings(tileIds, level) { /* On-chain placement */ }
  async upgradeBuilding(tileId) { /* On-chain upgrade */ }
  async sellPlasma(plasmaAmount) { /* Withdraw USDT */ }
  async battle(winChance) { /* Execute raid */ }
}
```

## 📦 Installation & Development

### Clone Repository
```bash
git clone https://github.com/cosmicyield/cosmicyield.git
cd cosmicyield
```

### Run Locally
No build process required! Just open HTML files:

```bash
# Option 1: Direct browser open
start index.html

# Option 2: Local server (recommended)
python -m http.server 8000
# Visit: http://localhost:8000
```

### Testing on BSC Testnet
1. Install MetaMask or Rabby wallet
2. Add BSC Testnet network (Chain ID: 97)
3. Get test BNB from [BSC Testnet Faucet](https://testnet.binance.org/faucet-smart)
4. Open `cosmic-yield-mainnet.html`
5. Connect wallet
6. Click "CLAIM 1000 USDT" to get test tokens
7. Start playing!

## 🗺️ Roadmap

### ✅ Phase 1: Practice Mode (COMPLETE)
- Full game mechanics offline
- 8 planet types with upgrade system
- Battle and swap systems
- ROI calculator
- Complete documentation

### 🚀 Phase 2: On-Chain Launch (TESTNET LIVE)
- ✅ BSC Testnet smart contract deployed
- ✅ Wallet connection (MetaMask, Rabby)
- ✅ USDT deposits and withdrawals
- ✅ On-chain planet placement and upgrades
- ✅ Battle system with rewards
- ✅ Plasma → Energy swap (2× rate)
- ✅ Referral system with tracking
- ✅ Dynamic TVL banner
- ⏳ Smart contract audit (in preparation)
- ⏳ Mainnet deployment (post-audit)

### 🔮 Phase 3: Community & Growth
- ✅ Referral rewards program
- ⏳ Active player tracking (requires The Graph)
- ⏳ Leaderboards and achievements
- ⏳ Community governance
- ⏳ Additional game modes
- ⏳ Mobile app

## 🔐 Security

### Current Status
- ✅ All core functions tested on testnet
- ✅ Cross-account interactions verified
- ✅ Transaction parsing and event handling confirmed
- ⏳ Professional security audit in preparation

### Audit Scope
- Smart contract logic verification
- Fund security assessment
- Vulnerability scanning
- Gas optimization review

### Bug Bounty
Coming soon after mainnet launch.

## 📊 Testing Status

All core functions verified working on BSC Testnet:

| Test Case | Status | Notes |
|-----------|--------|-------|
| USDT deposits | ✅ Pass | 10 USDT = 10,000 energy |
| Planet placement | ✅ Pass | Grid persistence verified |
| Planet upgrades | ✅ Pass | Level 1-10 functional |
| USDT withdrawals | ✅ Pass | Plasma → USDT confirmed |
| Resource swaps | ✅ Pass | 2× rate verified |
| Battle rewards | ✅ Pass | Event parsing working |
| Referral tracking | ✅ Pass | Sponsor/recruit display |
| Manager fees | ✅ Pass | Cross-account tested |

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Keep it simple - avoid over-engineering
- Test all Web3 interactions on testnet first
- Update documentation for new features
- Follow existing code style (vanilla JS, no frameworks)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Website**: https://cosmicyield.onrender.com/
- **Testnet Game**: https://cosmicyield.onrender.com/cosmic-yield-mainnet.html
- **Documentation**: https://cosmicyield.onrender.com/cosmic-yield-docs.html
- **GitHub**: https://github.com/cosmicyield/cosmicyield
- **BSCScan (Testnet)**: https://testnet.bscscan.com/address/0xdd6E4cb8F9262812e4Bad57d7B7E11c53CaE53d6

## ⚠️ Disclaimer

**Testnet Only**: The current deployment is on BSC Testnet for testing purposes only. Do not send real funds to testnet contracts.

**Mainnet Launch**: Mainnet contract address will be announced after security audit completion. Always verify the official contract address through our verified channels.

**Investment Risk**: Cryptocurrency investments carry risk. Never invest more than you can afford to lose. This game involves real money transactions on mainnet - play responsibly.

---

**Built with** ⚡ **by** the Cosmic Yield team

**Last Updated**: January 11, 2026
