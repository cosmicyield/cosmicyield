# Cosmic Yield - BSC Testnet Deployment Guide

## Current Status
- **Contract Version**: CosmicYield_Testnet.sol
- **Network**: BSC Testnet (Chain ID: 97)
- **Previous Deployment**: 0xC1Ddfd953567e9012A32dECD6621ce1D09ab619f
- **Reason for Redeployment**: Fixed USDT decimal conversion from 1e6 → 1e18

## Contracts to Deploy

### 1. FakeUSDT (if needed)
- **Address** (existing): `0x04B0A46F87182FD00C9Ef077b14c1c2bfa7Fe3Ef`
- **Decimals**: 18
- Only deploy if you need fresh USDT tokens for testing

### 2. CosmicYield (CRITICAL - DO DEPLOY)
- **File**: `CosmicYield_Testnet.sol`
- **Constructor Parameters**:
  ```
  Manager[] _managers = [
    {
      addr: <YOUR_WALLET_ADDRESS>,
      share: 100
    }
  ]
  ```
- **Key Fixes Applied**:
  - Line 122: `buyEnergy()` - Energy calculation using 1e18
  - Line 154: `sellPlasma()` - USDT payout calculation using 1e18
  - Line 157: `sellPlasma()` - Plasma adjustment using 1e18

## Deployment Steps

### Via Remix (Recommended for Testnet)

1. Go to https://remix.ethereum.org
2. Create new file: `CosmicYield_Testnet.sol`
3. Copy entire contract content
4. Set compiler to `0.8.24`
5. Compile (Ctrl+S)
6. Connect Rabby wallet
7. Deploy with constructor parameters above
8. Wait for confirmation on BSCScan

### Via Hardhat (CLI)
```bash
# Set environment variables
$env:TESTNET_RPC = "https://data-seed-prebsc-1-s1.binance.org:8545"
$env:PRIVATE_KEY = "<your_private_key>"
$env:TESTNET_EXPLORER = "https://testnet.bscscan.com"

# Deploy
npx hardhat run scripts/deploy.js --network testnetbsc
```

## After Deployment

### Step 1: Get New Contract Address
After deployment, you'll receive a contract address. Copy it.

Example: `0x<NEW_ADDRESS_HERE>`

### Step 2: Update HTML
Edit `cosmic-yield-mainnet.html` line 3726:

**Before:**
```javascript
const CONTRACTS = {
    cosmicYield: '0xC1Ddfd953567e9012A32dECD6621ce1D09ab619f',
```

**After:**
```javascript
const CONTRACTS = {
    cosmicYield: '0x<YOUR_NEW_ADDRESS>',
```

### Step 3: Test the Deployment

#### Test 1: Wallet Connection
1. Open cosmic-yield-mainnet.html
2. Click "Connect Wallet"
3. Approve connection in Rabby
4. Verify "Connected" shows your address

#### Test 2: Buy Energy
1. Click "Purchase"
2. Enter 10 USDT
3. Click "Buy Energy"
4. Approve USDT in Rabby
5. Wait for transaction
6. Verify energy increased by 10,000
7. Check BSCScan for transaction confirmation

#### Test 3: Place Building
1. Click "Colonize"
2. Select Mercury (Planet 1)
3. Click any empty tile on grid
4. Confirm "Place building"
5. Verify energy decreased by building cost (10,000)
6. Verify planet sprite appears on grid

#### Test 4: Sell Plasma (CRITICAL TEST)
1. Build several planets to generate plasma
2. Wait for hourly collection
3. Click "Sell"
4. Enter plasma amount (e.g., 100)
5. Click "Sell Plasma"
6. Confirm transaction in Rabby
7. **CHECK**: Open Rabby wallet and verify you received USDT
8. If USDT appears: ✅ DEPLOYMENT SUCCESSFUL
9. If USDT not received: ❌ Decimal issue persists

## Contract Deployment Verification

### On BSCScan:

1. Navigate to new contract address
2. Verify "Contract" tab shows source code
3. Check "Read Contract" tab:
   - `getGlobalState()` should return deployment block time
   - `getPlanet(your_address)` should be callable (returns empty if no deposits)

### In Console:

```javascript
// Check manager setup
const state = await cosmicYieldContract.getGlobalState();
console.log("Total Deposited:", state.totalDeposited.toString());
console.log("Total Explorers:", state.totalExplorers.toString());

// Check your planet
const planet = await cosmicYieldContract.getPlanet(userAddress);
console.log("Your Energy:", planet.energy.toString());
console.log("Your Plasma:", planet.plasma.toString());
console.log("Tiles placed:", planet.tiles.filter(t => t > 0).length);
```

## Troubleshooting

### Issue: "Transfer failed" on buyEnergy
- **Cause**: USDT not approved
- **Fix**: Approve USDT first (should happen automatically)

### Issue: Planets don't appear after buying energy
- **Cause**: `loadPlanetData()` not called
- **Fix**: Disconnect and reconnect wallet (should trigger `rebuildAllModules()`)

### Issue: Sold plasma but got 0 USDT
- **Cause**: Decimal mismatch (this was the issue, now fixed)
- **Fix**: Verify you deployed the corrected contract with 1e18
- **Verification**: Check smart contract source on BSCScan shows line 154: `(_plasma * 1e18) / 1000`

### Issue: Wallet says wrong network
- **Cause**: Wallet on wrong chain
- **Fix**: Switch to BSC Testnet (Chain ID 97)
- **Explorer URL**: https://testnet.bscscan.com

## Rollback Plan

If something goes wrong:
1. Contract address: `0xC1Ddfd953567e9012A32dECD6621ce1D09ab619f` (old working version)
2. Update HTML back to this address
3. Create new issue with error details

## Success Criteria

All tests pass = ✅ Ready for mainnet preparation

```
[X] Wallet connects
[X] Buy energy works
[X] Place building works
[X] Planets persist after reconnect
[X] Sell plasma receives USDT
[X] Cross-account interactions work
```

## Next: Mainnet Preparation

Once testnet is fully validated:
1. Deploy to BSC Mainnet (Chain ID 56)
2. Update HTML with mainnet contract address
3. Switch `cosmic-yield-mainnet.html` to production USDT
4. Add mainnet version to GitHub
5. Update Render deployment

---

**Important**: Keep old contract address for reference. All old game data on old contract will be preserved but inaccessible from new frontend. Consider this a fresh deployment.
