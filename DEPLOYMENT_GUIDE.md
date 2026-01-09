# 🚀 Guide de Déploiement CosmicYield sur BSC Testnet

## 📋 Prérequis

### 1. Installer Rabby Wallet (Recommandé) ou Metamask
- **Rabby**: https://rabby.io (Extension Chrome/Brave)
- **Metamask**: https://metamask.io (Alternative)

### 2. Configurer BSC Testnet

**Paramètres réseau BSC Testnet:**
```
Network Name: BSC Testnet
RPC URL: https://data-seed-prebsc-1-s1.binance.org:8545
Chain ID: 97
Currency Symbol: BNB
Block Explorer: https://testnet.bscscan.com
```

**Dans Rabby:**
- Rabby détecte automatiquement BSC Testnet ✅

**Dans Metamask:**
- Settings → Networks → Add Network → Paramètres ci-dessus

### 3. Obtenir des BNB de test

**Option 1 - Faucet officiel Binance:**
https://testnet.binance.org/faucet-smart

**Option 2 - Faucet alternatif:**
https://testnet.bnbchain.org/faucet-smart

**Montant requis:** ~0.1 BNB testnet (pour gas fees)

---

## 🛠️ Étape 1: Déployer FakeUSDT

### 1.1. Ouvrir Remix IDE
- URL: https://remix.ethereum.org
- Navigateur: **Brave** (ou Chrome)

### 1.2. Créer le fichier FakeUSDT.sol
1. Dans l'explorateur de fichiers (gauche), clique sur **"contracts"**
2. Créer nouveau fichier: `FakeUSDT.sol`
3. Copier-coller le code depuis `FakeUSDT.sol`

### 1.3. Compiler
1. Onglet **"Solidity Compiler"** (icône "S" à gauche)
2. Compiler version: **0.8.24** (ou 0.8.x)
3. Cliquer **"Compile FakeUSDT.sol"**
4. ✅ Vérifier: "Compilation successful"

### 1.4. Déployer
1. Onglet **"Deploy & Run Transactions"** (icône Ethereum)
2. Environment: **"Injected Provider - Rabby"** (ou Metamask)
3. ⚠️ Vérifier que Rabby/Metamask affiche **"BSC Testnet"** en haut
4. Account: Ton adresse wallet (devrait s'afficher automatiquement)
5. Contract: **FakeUSDT**
6. Cliquer **"Deploy"**
7. ✅ Rabby/Metamask: Confirmer la transaction

### 1.5. Noter l'adresse du contrat
```
📝 Adresse FakeUSDT déployée: 0x...
```
**IMPORTANT:** Copier cette adresse, on en aura besoin !

### 1.6. Tester le mint de USDT
1. Dans Remix, section "Deployed Contracts", développer **FakeUSDT**
2. Fonction `mint`:
   - Paramètre: `1000000000000000000000` (= 1000 USDT avec 18 decimals)
   - Cliquer **"transact"**
   - Confirmer dans Rabby
3. Vérifier le balance:
   - Fonction `balanceOf`: entre ton adresse
   - Cliquer **"call"**
   - ✅ Devrait afficher: `1000000000000000000000`

---

## 🪐 Étape 2: Modifier et Déployer CosmicYield

### 2.1. Modifier l'adresse USDT dans le contrat

1. Ouvrir `CosmicYield_Fixed.sol` dans ton éditeur de code
2. Trouver la ligne 76:
```solidity
Token constant USDT = Token(0x55d398326f99059fF775485246999027B3197955);
```
3. Remplacer par l'adresse de ton FakeUSDT déployé:
```solidity
Token constant USDT = Token(0xTON_ADRESSE_FAKEUSDT_ICI);
```
4. ✅ Sauvegarder le fichier

### 2.2. Créer le fichier dans Remix
1. Dans Remix, créer nouveau fichier: `CosmicYield.sol`
2. Copier-coller le code modifié de `CosmicYield_Fixed.sol`

### 2.3. Compiler
1. Onglet **"Solidity Compiler"**
2. Compiler version: **0.8.24**
3. Cliquer **"Compile CosmicYield.sol"**
4. ✅ Vérifier: "Compilation successful"

### 2.4. Préparer les paramètres de déploiement

Le constructor demande un tableau de `Manager[]` avec des shares totalisant 100%.

**Option A - Toi seul (100%):**
```javascript
[["0xTON_ADRESSE_WALLET", 100]]
```

**Option B - Plusieurs managers (ex: 3 personnes):**
```javascript
[
  ["0xADRESSE_1", 50],
  ["0xADRESSE_2", 30],
  ["0xADRESSE_3", 20]
]
```

### 2.5. Déployer CosmicYield
1. Onglet **"Deploy & Run Transactions"**
2. Environment: **"Injected Provider - Rabby"**
3. Contract: **CosmicYield**
4. Constructor parameter `_managers`:
   - Coller ton tableau (ex: `[["0xTON_ADRESSE", 100]]`)
5. Cliquer **"Deploy"**
6. ✅ Confirmer dans Rabby

### 2.6. Noter l'adresse du contrat
```
📝 Adresse CosmicYield déployée: 0x...
```

---

## 🧪 Étape 3: Tester le Contrat

### 3.1. Approuver USDT pour CosmicYield
1. Dans Remix, section "Deployed Contracts", développer **FakeUSDT**
2. Fonction `approve`:
   - `spender`: Adresse de CosmicYield
   - `value`: `1000000000000000000000000` (= 1,000,000 USDT)
   - Cliquer **"transact"** → Confirmer

### 3.2. Acheter de l'Energy
1. Développer **CosmicYield** dans "Deployed Contracts"
2. Fonction `buyEnergy`:
   - `_depositAmount`: `100000000000000000000` (= 100 USDT)
   - `_ally`: `0x0000000000000000000000000000000000000000` (pas de parrain)
   - Cliquer **"transact"** → Confirmer
3. ✅ Vérifier l'event `EnergyBought` dans la console

### 3.3. Vérifier ta planète
1. Fonction `getPlanet`:
   - `_player`: Ton adresse
   - Cliquer **"call"**
2. ✅ Tu devrais voir:
   - `energy`: 100000 (100 USDT × 1000)
   - `plasma`: 0
   - `perHour`: 0
   - `claimTime`: timestamp

### 3.4. Placer un bâtiment (planète)
1. Fonction `placeBuildings`:
   - `_tileIds`: `[0, 1, 2]` (3 tuiles)
   - `_level`: `1` (Mercury)
   - Cliquer **"transact"** → Confirmer
2. ✅ Coût: 30,000 Energy (3 × 10,000)
3. ✅ Production: 12/hour (3 × 4)

### 3.5. Vérifier la production après 1 heure
**Attendre 1 heure réelle OU manipuler le timestamp (avancé)**

1. Fonction `getPlanet` → `"call"`
2. Avant de call une fonction qui trigger `collect()`:
   - `sellPlasma`, `swapPlasmaToEnergy`, ou `placeBuildings`
3. ✅ Tu devrais voir `energy` et `plasma` augmentés de `12` (1 heure × 12/hour)

### 3.6. Tester le Battle
**Après 24h:**
1. Fonction `battle`:
   - `_winChance`: `50` (50%)
   - Cliquer **"transact"**
2. ✅ Premier battle = toujours victoire
3. ✅ Reward = `(12 * 16 * 50) / 50 = 192` Energy

### 3.7. Vendre du Plasma
1. Attendre 1+ heure pour accumuler du Plasma
2. Fonction `sellPlasma`:
   - `_plasma`: `1000` (= 1 USDT)
   - Cliquer **"transact"**
3. ✅ Vérifier ton balance USDT dans FakeUSDT (`balanceOf`)

---

## ✅ Checklist de Validation

### Contrats déployés
- [ ] FakeUSDT déployé sur BSC Testnet
- [ ] Adresse FakeUSDT notée
- [ ] CosmicYield_Fixed.sol modifié avec bonne adresse USDT
- [ ] CosmicYield déployé sur BSC Testnet
- [ ] Adresse CosmicYield notée

### Tests fonctionnels
- [ ] Mint de FakeUSDT OK
- [ ] Approve USDT → CosmicYield OK
- [ ] buyEnergy fonctionne (Energy reçue)
- [ ] placeBuildings fonctionne (tuiles occupées)
- [ ] Production horaire accumule (Energy + Plasma)
- [ ] battle() fonctionne (reward reçue)
- [ ] sellPlasma fonctionne (USDT reçus)
- [ ] swapPlasmaToEnergy fonctionne (ratio 1:2)
- [ ] upgradeBuilding fonctionne (perHour augmente)

---

## 🔍 Vérifier sur BSCScan Testnet

1. Ouvrir https://testnet.bscscan.com
2. Rechercher l'adresse de ton contrat CosmicYield
3. ✅ Vérifier:
   - Contract Creation: transaction réussie
   - Transactions: tes interactions apparaissent
   - Events: EnergyBought, BuildingsPlaced, etc.

---

## ⚠️ Points Importants

### 🔴 Pour le mainnet (plus tard):
```solidity
// MODIFIER CETTE LIGNE AVANT MAINNET:
Token constant USDT = Token(0x55d398326f99059fF775485246999027B3197955);
// ☝️ C'est la VRAIE adresse USDT sur BSC Mainnet
```

### 🟡 Managers fees:
- Les managers reçoivent 10% des fees en **Plasma** (pas Energy)
- Si tu es seul: `[["0xTON_ADRESSE", 100]]`
- Les 10% de fees sont distribués selon les shares

### 🟢 Anti-streak mechanism:
- Après 3 victoires consécutives → re-roll obligatoire
- Après 2 défaites consécutives → re-roll obligatoire
- ✅ Présent dans `CosmicYield_Fixed.sol` (lignes 233-239)

---

## 🐛 Troubleshooting

### Erreur: "Transfer failed"
➡️ **Solution:** Vérifie que tu as approuvé USDT avec `approve()` avant `buyEnergy()`

### Erreur: "Insufficient energy"
➡️ **Solution:** Achète plus d'Energy avec `buyEnergy()` ou swap du Plasma

### Erreur: "Battle cooldown"
➡️ **Solution:** Attends 24h entre chaque battle

### Erreur: "Tile not empty"
➡️ **Solution:** Utilise des tileIds différents (0-359)

### Rabby n'affiche pas BSC Testnet
➡️ **Solution:**
1. Rabby → Networks → Search "BSC Test"
2. Activer le réseau
3. Switch vers BSC Testnet

---

## 📞 Support

Si problème de déploiement, vérifie:
1. ✅ BSC Testnet sélectionné dans Rabby
2. ✅ Assez de BNB pour gas
3. ✅ Adresse FakeUSDT correcte dans CosmicYield.sol (ligne 76)
4. ✅ Manager shares = 100% total

---

**Bon déploiement! 🚀🪐**
