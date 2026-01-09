pragma solidity ^0.8.24;

interface Token {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

struct GlobalState {
    uint128 totalDeposited;
    uint32 totalKings;
    uint64 deploymentTime;
    uint32 totalDeposits;
}

struct Kingdom {
    uint32 gold;
    uint32 gems;
    uint32 perHour;
    uint32 alliesCount;
    uint32 alliesEarned;
    uint32 claimTime;
    uint32 battleTime;
    uint16 battleId;
    uint8 battlesInRow;
    bool isWinInRow;
    address ally;
    uint8[360] tiles;
}

struct Deposit {
    address king;
    uint32 gold;
    uint32 time;
}

struct Manager {
    address addr;
    uint32 share;
}

function capU32Add(uint256 _a, uint256 _b) pure returns (uint32) {
    uint256 value = _a + _b;
    return value > type(uint32).max ? type(uint32).max : uint32(value);
}

function getRandomSequence(uint256 _index) pure returns (uint256) {
    uint256 randomHash = uint256(keccak256(abi.encodePacked("TetherKing", _index)));
    return (randomHash % 100) + 1;
}

function getBuildingStats(uint256 _level) pure returns (uint256 cost, uint256 perHour) {
    if (_level == 1) return (10_000, 4);
    if (_level == 2) return (28_000, 12);
    if (_level == 3) return (54_000, 24);
    if (_level == 4) return (100_000, 48);
    if (_level == 5) return (250_000, 124);
    if (_level == 6) return (500_000, 260);
    if (_level == 7) return (1_000_000, 550);
    if (_level == 8) return (2_000_000, 1_150);
    revert("Invalid level");
}

function collect(Kingdom storage _kingdom) {
    uint256 lastHour = _kingdom.claimTime / 3600;
    uint256 currentHour = block.timestamp / 3600;

    if (currentHour <= lastHour) {
        return;
    }

    uint256 hoursPassed = currentHour - lastHour;
    uint256 earned = hoursPassed * _kingdom.perHour;

    _kingdom.gold = capU32Add(_kingdom.gold, earned);
    _kingdom.gems = capU32Add(_kingdom.gems, earned);
    _kingdom.claimTime = uint32(currentHour * 3600);
}

Token constant USDT = Token(0x55d398326f99059fF775485246999027B3197955);

event GoldBought(address indexed king, address indexed ally, uint256 gold);

event GemsSold(address indexed king, uint256 gems);

event GemsSwappedToGold(address indexed king, uint256 gems);

event BuildingsPlaced(address indexed king, uint16[] tileIds, uint8 level);

event BuildingUpgraded(address indexed king, uint16 tileId);

event BattleResult(address indexed king, bool isWin, uint8 winChance, uint256 battleReward);

contract TetherKing {
    mapping(address => Kingdom) internal kingdoms;
    mapping(uint256 => address) internal kings;
    mapping(uint256 => Deposit) internal deposits;

    GlobalState internal globalState;
    Manager[] internal managers;

    uint256 private status = 1;

    modifier nonReentrant() {
        require(status == 1, "Reentrant");
        status = 2;
        _;
        status = 1;
    }

    constructor(Manager[] memory _managers) {
        uint256 totalShare = 0;
        for (uint256 i = 0; i < _managers.length; i++) {
            uint256 share = _managers[i].share;
            require(share > 0, "Invalid share");
            totalShare += share;
        }
        require(totalShare == 100, "Invalid total share");

        managers = _managers;
        globalState.deploymentTime = uint64(block.timestamp);
    }

    function buyGold(uint256 _depositAmount, address _ally) external nonReentrant {
        require(_depositAmount > 0, "No USDT");
        require(USDT.transferFrom(msg.sender, address(this), _depositAmount), "Transfer failed");

        uint256 gold = (_depositAmount * 1000) / 1e18;
        require(gold > 0, "No gold");

        Kingdom storage kingdom = kingdoms[msg.sender];

        if (kingdom.claimTime == 0) {
            if (kingdoms[_ally].claimTime > 0) {
                kingdoms[_ally].alliesCount++;
                kingdom.ally = _ally;
            }

            kings[globalState.totalKings] = msg.sender;
            kingdom.claimTime = uint32(block.timestamp - block.timestamp % 3600);
            kingdom.battleId = uint16(block.timestamp % 100); // offset for random sequence
            globalState.totalKings++;
        }

        kingdom.gold = capU32Add(kingdom.gold, gold);
        globalState.totalDeposited = uint128(globalState.totalDeposited + _depositAmount);
        deposits[globalState.totalDeposits] =
            Deposit({king: msg.sender, gold: uint32(gold), time: uint32(block.timestamp)});
        globalState.totalDeposits++;

        emit GoldBought(msg.sender, _ally, gold);
    }

    function sellGems(uint256 _gems) external nonReentrant {
        require(_gems > 0, "No gems");
        Kingdom storage kingdom = kingdoms[msg.sender];
        require(kingdom.claimTime > 0, "Not registered");

        collect(kingdom);
        require(kingdom.gems >= _gems, "Insufficient gems");

        uint256 usdtPayout = (_gems * 1e18) / 1000;
        uint256 contractBalance = USDT.balanceOf(address(this));
        usdtPayout = usdtPayout > contractBalance ? contractBalance : usdtPayout;
        _gems = (usdtPayout * 1000) / 1e18;

        kingdom.gems = uint32(kingdom.gems - _gems);

        emit GemsSold(msg.sender, _gems);

        require(USDT.transfer(msg.sender, usdtPayout), "Transfer failed");
    }

    function swapGemsToGold(uint256 _gems) external nonReentrant {
        require(_gems > 0, "No gems");
        Kingdom storage kingdom = kingdoms[msg.sender];
        require(kingdom.claimTime > 0, "Not registered");

        collect(kingdom);
        require(kingdom.gems >= _gems, "Insufficient gems");

        uint256 gold = _gems * 2;

        kingdom.gems = uint32(kingdom.gems - _gems);
        kingdom.gold = capU32Add(kingdom.gold, gold);

        emit GemsSwappedToGold(msg.sender, _gems);
    }

    function placeBuildings(uint16[] calldata _tileIds, uint8 _level) external nonReentrant {
        Kingdom storage kingdom = kingdoms[msg.sender];
        require(kingdom.claimTime > 0, "Not registered");
        require(_tileIds.length >= 1, "No tiles");
        require(_level > 0 && _level < 9, "Invalid level");

        collect(kingdom);

        (uint256 costPerBuilding, uint256 perHourPerBuilding) = getBuildingStats(_level);

        uint256 buildingCount = _tileIds.length;
        uint256 totalCost = costPerBuilding * buildingCount;
        uint256 totalPerHour = perHourPerBuilding * buildingCount;

        for (uint256 i = 0; i < buildingCount; i++) {
            uint256 tileId = _tileIds[i];
            require(tileId < 360, "Invalid tile");
            require(kingdom.tiles[tileId] == 0, "Tile not empty");
            kingdom.tiles[tileId] = _level;
        }

        require(kingdom.gold >= totalCost, "Insufficient gold");

        kingdom.gold = uint32(kingdom.gold - totalCost);
        kingdom.perHour = capU32Add(kingdom.perHour, totalPerHour);

        emit BuildingsPlaced(msg.sender, _tileIds, _level);

        distributeFees(kingdom.ally, totalCost);
    }

    function upgradeBuilding(uint16 _tileId) external nonReentrant {
        Kingdom storage kingdom = kingdoms[msg.sender];
        require(kingdom.claimTime > 0, "Not registered");
        require(_tileId < 360, "Invalid tile");

        collect(kingdom);

        uint256 tileData = kingdom.tiles[_tileId];
        uint256 level = tileData % 10;
        uint256 currentUpgrades = tileData / 10;

        require(level > 0 && level < 9, "No building");
        require(currentUpgrades < 9, "Max upgrades");

        (uint256 baseCost, uint256 basePerHour) = getBuildingStats(level);

        uint256 upgradeCost = baseCost / 4;
        uint256 upgradePerHour = basePerHour / 4;

        require(kingdom.gold >= upgradeCost, "Insufficient gold");
        kingdom.gold = uint32(kingdom.gold - upgradeCost);
        kingdom.tiles[_tileId] = uint8((currentUpgrades + 1) * 10 + level);
        kingdom.perHour = capU32Add(kingdom.perHour, upgradePerHour);

        emit BuildingUpgraded(msg.sender, _tileId);

        distributeFees(kingdom.ally, upgradeCost);
    }

    function battle(uint8 _winChance) external nonReentrant {
        Kingdom storage kingdom = kingdoms[msg.sender];
        require(kingdom.claimTime > 0, "Not registered");
        require(_winChance >= 40 && _winChance <= 60, "Invalid win chance");
        require(block.timestamp - kingdom.battleTime >= 86400, "Battle cooldown");
        require(kingdom.perHour > 0, "Cannot battle");

        bool isFirstBattle = kingdom.battlesInRow == 0;
        bool isWin = isFirstBattle ? true : getRandomSequence(kingdom.battleId) <= _winChance;

        kingdom.battleTime = uint32(block.timestamp);
        kingdom.battleId = isFirstBattle ? uint16(block.timestamp % 100) : kingdom.battleId + 1;

        if (
            (isWin && kingdom.isWinInRow && kingdom.battlesInRow >= 3)
                || (!isWin && !kingdom.isWinInRow && kingdom.battlesInRow >= 2)
        ) {
            isWin = getRandomSequence(kingdom.battleId) <= _winChance;
            kingdom.battleId++;
        }

        if (isWin == kingdom.isWinInRow) {
            kingdom.battlesInRow++;
        } else {
            kingdom.battlesInRow = 1;
            kingdom.isWinInRow = isWin;
        }

        uint256 battleReward = isWin ? (kingdom.perHour * 16 * 50) / _winChance : kingdom.perHour * 8;
        kingdom.gold = capU32Add(kingdom.gold, battleReward);

        emit BattleResult(msg.sender, isWin, _winChance, battleReward);
    }

    function distributeFees(address _ally, uint256 _amount) internal {
        if (_ally != address(0)) {
            uint256 allyFee = _amount / 10;
            kingdoms[_ally].gold = capU32Add(kingdoms[_ally].gold, allyFee);
            kingdoms[_ally].alliesEarned = capU32Add(kingdoms[_ally].alliesEarned, allyFee);
        }

        uint256 totalManagers = managers.length;
        uint256 managerFee = _amount / 10;
        for (uint256 i = 0; i < totalManagers; i++) {
            Manager memory manager = managers[i];
            kingdoms[manager.addr].gems = capU32Add(kingdoms[manager.addr].gems, (managerFee * manager.share) / 100);
        }
    }

    function getGlobalState() external view returns (GlobalState memory) {
        return globalState;
    }

    function getKingdom(address _player) external view returns (Kingdom memory) {
        return kingdoms[_player];
    }

    function getKing(uint256 _index) external view returns (address) {
        return kings[_index];
    }

    function getDeposit(uint256 _index) external view returns (Deposit memory) {
        return deposits[_index];
    }
}
