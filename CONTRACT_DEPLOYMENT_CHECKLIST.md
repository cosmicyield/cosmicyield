# Contract Deployment Checklist

## Pre-Deployment

- [ ] Have Rabby wallet connected to BSC Testnet
- [ ] Have testnet BNB for gas (at least 1 BNB recommended)
- [ ] Have CosmicYield_Testnet.sol ready to copy
- [ ] FakeUSDT already deployed at: `0x04B0A46F87182FD00C9Ef077b14c1c2bfa7Fe3Ef`

## Deployment via Remix

### Step 1: Prepare File
- [ ] Go to https://remix.ethereum.org
- [ ] Click "Create New File"
- [ ] Name it: `CosmicYield_Testnet.sol`
- [ ] Copy entire contract from `CosmicYield_Testnet.sol` in your repo

### Step 2: Compile
- [ ] Select Solidity Compiler (left sidebar)
- [ ] Set version to `0.8.24` (exact match required)
- [ ] Click "Compile CosmicYield_Testnet.sol"
- [ ] Verify no errors (warnings are OK)

### Step 3: Deploy
- [ ] Click "Deploy & Run Transactions" (left sidebar)
- [ ] Environment: Select "Injected Provider - Rabby"
- [ ] Contract: Select "CosmicYield"
- [ ] Constructor parameters:
  ```
  Manager[] memory _managers = [
    {
      addr: <COPY_YOUR_WALLET_ADDRESS_HERE>,
      share: 100
    }
  ]
  ```

  **Example:**
  ```
  [["0x1234567890123456789012345678901234567890", 100]]
  ```

- [ ] Click "Deploy"
- [ ] Approve transaction in Rabby wallet
- [ ] Wait for confirmation (about 15-30 seconds)

### Step 4: Record Address
- [ ] Deployment successful message appears
- [ ] Copy contract address from "Deployed Contracts" section
- [ ] **SAVE THIS ADDRESS** - you'll need it to update HTML
- [ ] Example: `0xABC123DEF456...`

## Post-Deployment

### Verify on BSCScan
- [ ] Go to: https://testnet.bscscan.com
- [ ] Search for your new contract address
- [ ] Verify "Contract" shows "CosmicYield"
- [ ] Verify source code is visible
- [ ] Click "Read Contract" tab
- [ ] Call `getGlobalState()` → should return data

### Update HTML
- [ ] Open `cosmic-yield-mainnet.html`
- [ ] Find line 3726: `cosmicYield: '0x...',`
- [ ] Replace with your new address
- [ ] Save file

## Testing After Deployment

### Quick Smoke Test (2 minutes)
1. [ ] Open cosmic-yield-mainnet.html in browser
2. [ ] Click "Connect Wallet"
3. [ ] Approve connection
4. [ ] Verify "Connected" shows in top-right
5. [ ] Verify no console errors

### Full Feature Test (10 minutes)

#### Test: Buy Energy
1. [ ] Click "Purchase"
2. [ ] Enter 10 USDT
3. [ ] Click "Buy Energy"
4. [ ] Approve USDT transaction
5. [ ] Verify success modal appears
6. [ ] Verify energy display updated to 10,000

#### Test: Build Planet
1. [ ] Click "Colonize"
2. [ ] Select "Mercury" (Planet 1)
3. [ ] Click an empty grid tile
4. [ ] Confirm "Place building"
5. [ ] Verify energy decreased (10,000 - 10,000 = 0)
6. [ ] Verify planet sprite appears on grid

#### Test: Sell Plasma (MOST IMPORTANT)
1. [ ] Build 2-3 more planets (requires waiting ~1 hour OR using time-travel tools)
   - **OR** reduce perHour in contract and wait shorter
   - **OR** skip this if testing energy system first
2. [ ] Click "Sell"
3. [ ] Enter plasma amount: `100`
4. [ ] Click "Sell Plasma"
5. [ ] Approve transaction
6. [ ] Verify success modal
7. [ ] **CRITICAL**: Open Rabby wallet balance
8. [ ] Check FakeUSDT balance increased by ~0.1 USDT
   - Expected: 100 plasma × (1e18 / 1000) = 0.1 USDT
9. [ ] **If USDT appears: ✅ DEPLOYMENT SUCCESS**
10. [ ] **If USDT not received: ❌ Recheck decimal conversion**

## Troubleshooting Deployment Issues

### Issue: "Compiler version mismatch"
**Solution**: Set compiler to `0.8.24` exactly (not 0.8.25 or 0.8.23)

### Issue: "TypeError: Cannot instantiate abstract contract"
**Solution**: Make sure you have the full contract including the `contract CosmicYield { }` definition

### Issue: "Gas estimation failed"
**Solution**:
- May need more testnet BNB
- Constructor parameters might be malformed
- Verify Manager array format: `[["0xADDRESS", 100]]`

### Issue: Deployment succeeds but contract doesn't appear on BSCScan
**Solution**: Wait 2-3 minutes for indexing, then refresh

### Issue: "No connected wallet found"
**Solution**:
- Make sure Rabby is installed and enabled
- Browser console shows MetaMask conflict errors?
- Disable MetaMask extension temporarily
- Verify Rabby is set to BSC Testnet

### Issue: Can't approve USDT in Rabby
**Solution**:
- Make sure you have some testnet USDT at: `0x04B0A46F87182FD00C9Ef077b14c1c2bfa7Fe3Ef`
- If not, need to mint more or use old FakeUSDT deployment

## Success Indicators

✅ **Minimal**: Wallet connects, contract address visible on BSCScan
✅ **Good**: Buy energy works, planets appear on grid
✅ **Excellent**: Sell plasma transfers USDT to wallet

## Emergency Contacts

- **BSCScan**: https://testnet.bscscan.com
- **Remix**: https://remix.ethereum.org
- **Testnet Faucet**: https://testnet.binance.org/faucet-smart

---

**Ready to deploy!** Follow these steps in order and you should be live in under 5 minutes.
