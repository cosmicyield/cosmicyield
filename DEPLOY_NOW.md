# 🚀 DEPLOY NOW - Quick Start Guide

## You're Ready! Here's the 5-Minute Path

### Step 1: Open Remix (1 minute)
Go to: https://remix.ethereum.org

### Step 2: Create New File (1 minute)
1. Left sidebar → Click folder icon
2. Click "Create New File"
3. Name: `CosmicYield_Testnet.sol`
4. Copy **entire** content from `CosmicYield_Testnet.sol` in your repo
5. Paste into Remix

### Step 3: Compile (1 minute)
1. Left sidebar → Solidity Compiler icon
2. Set version: `0.8.24` (exact!)
3. Click "Compile CosmicYield_Testnet.sol"
4. Wait for ✅ success

### Step 4: Deploy (2 minutes)
1. Left sidebar → Deploy & Run Transactions icon
2. Environment: Select "Injected Provider - Rabby"
3. Approve Rabby connection
4. Contract: Select "CosmicYield"

**Constructor parameters** - paste this into the field:
```
[["0xABC123...YOUR_WALLET_ADDRESS...DEF789", 100]]
```

Replace `0xABC123...YOUR_WALLET_ADDRESS...DEF789` with your actual wallet address!

5. Click "Deploy"
6. Approve in Rabby wallet
7. Wait 15-30 seconds

### Step 5: Get Address (30 seconds)
1. Scroll down to "Deployed Contracts"
2. Click the copy icon next to contract address
3. **Save this address!** You'll need it in 10 seconds

### Step 6: Update HTML (1 minute)
Open `cosmic-yield-mainnet.html`

Find line 3726:
```javascript
cosmicYield: '0xC1Ddfd953567e9012A32dECD6621ce1D09ab619f',
```

Replace with:
```javascript
cosmicYield: '0x<YOUR_NEW_ADDRESS>',
```

Save file.

### Step 7: Test (3 minutes)
Open `cosmic-yield-mainnet.html` in browser

1. Click "Connect Wallet"
2. Approve in Rabby
3. Click "Purchase"
4. Enter: `10`
5. Click "Buy Energy"
6. Approve in Rabby
7. Check energy = 10,000 ✅

### Step 8: Critical Test (2 minutes)
If you have plasma (wait 1 hour or skip this):

1. Click "Sell"
2. Enter: `100`
3. Click "Sell Plasma"
4. Approve in Rabby
5. **OPEN RABBY WALLET** (extension icon)
6. Click "Assets" → Search "USDT" or scroll
7. Check balance increased by **0.1 USDT** ✅

**If USDT appears: ALL GOOD!**

## That's It!

Total time: **~15 minutes**

## Troubleshooting

### "Compiler error"
- Make sure version is exactly `0.8.24`

### "Constructor parameters invalid"
- Use this exact format: `[["0xYOUR_ADDRESS", 100]]`
- Replace only the `0xYOUR_ADDRESS` part

### "Transaction failed"
- Make sure you have testnet BNB
- Faucet: https://testnet.binance.org/faucet-smart

### "Still seeing old balance after buying energy"
- Refresh page
- Disconnect wallet → Reconnect

### "Planet not appearing"
- Reload page
- Reconnect wallet
- Should trigger rebuildAllModules()

### "Selling plasma but no USDT"
- If still using old contract: Need to deploy new one
- Check contract address updated in HTML line 3726
- Verify BSCScan shows your new contract address

## The 3 Fixes Applied

Everything is fixed for you, but here's what was wrong before:

**Old Code (BROKEN):**
```javascript
// Line 122
uint256 energy = (_depositAmount * 1000) / 1e6; // ❌ Wrong decimals!

// Line 154
uint256 usdtPayout = (_plasma * 1e6) / 1000; // ❌ Wrong decimals!
```

**New Code (FIXED):**
```javascript
// Line 122
uint256 energy = (_depositAmount * 1000) / 1e18; // ✅ Correct!

// Line 154
uint256 usdtPayout = (_plasma * 1e18) / 1000; // ✅ Correct!
```

The reason: FakeUSDT has **18 decimals**, not 6!

## Success Indicators

✅ Wallet connects
✅ Buy energy works (energy updates to 10,000)
✅ Place planet (use Colonize → select Mercury → click tile)
✅ **CRITICAL:** Sell plasma → USDT appears in wallet

## Next After Deployment

Once testnet is working:
1. Save this contract address
2. Later: Deploy to mainnet with same contract
3. Update HTML to mainnet version
4. Done!

---

**You're 5 minutes away from a fully working Web3 game!**

Questions? Check `DEPLOYMENT_TESTNET.md` for detailed troubleshooting.

Good luck! 🎮
