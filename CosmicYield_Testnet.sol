pragma solidity ^0.8.24;

interface Token {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

struct GlobalState {
    uint128 totalDeposited;
    uint32 totalExplorers;
    uint64 deploymentTime;
    uint32 totalDeposits;
}

struct Planet {
    uint32 energy;
    uint32 plasma;
    uint32 perHour;
    uint32 alliesCount;
    uint32 energyFromAllies;
    uint32 claimTime;
    uint32 battleTime;
    uint16 battleId;
    uint8 battlesInRow;
    bool isWinInRow;
    address ally;
    uint8[360] tiles;
}

struct Deposit {
    address explorer;
    uint32 energy;
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
    uint256 randomHash = uint256(keccak256(abi.encodePacked("CosmicYield", _index)));
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

function collect(Planet storage _planet) {
    uint256 lastHour = _planet.claimTime / 3600;
    uint256 currentHour = block.timestamp / 3600;

    if (currentHour <= lastHour) {
        return;
    }

    uint256 hoursPassed = currentHour - lastHour;
    uint256 earned = hoursPassed * _planet.perHour;

    _planet.energy = capU32Add(_planet.energy, earned);
    _planet.plasma = capU32Add(_planet.plasma, earned);
    _planet.claimTime = uint32(currentHour * 3600);
}

Token constant USDT = Token(0x04B0A46F87182FD00C9Ef077b14c1c2bfa7Fe3Ef);

event EnergyBought(address indexed explorer, address indexed ally, uint256 energy);
event PlasmaSold(address indexed explorer, uint256 plasma);
event PlasmaSwappedToEnergy(address indexed explorer, uint256 plasma);
event BuildingsPlaced(address indexed explorer, uint16[] tileIds, uint8 level);
event BuildingUpgraded(address indexed explorer, uint16 tileId);
event BattleResult(address indexed explorer, bool isWin, uint8 winChance, uint256 battleReward);

contract CosmicYield {
    mapping(address => Planet) internal planets;
    mapping(uint256 => address) internal explorers;
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
            managers.push(_managers[i]);
        }
        require(totalShare == 100, "Invalid total share");
        globalState.deploymentTime = uint64(block.timestamp);
    }

    function buyEnergy(uint256 _depositAmount, address _ally) external nonReentrant {
        require(_depositAmount > 0, "No USDT");
        require(USDT.transferFrom(msg.sender, address(this), _depositAmount), "Transfer failed");

        uint256 energy = (_depositAmount * 1000) / 1e18;
        require(energy > 0, "No energy");

        Planet storage planet = planets[msg.sender];

        if (planet.claimTime == 0) {
            if (planets[_ally].claimTime > 0) {
                planets[_ally].alliesCount++;
                planet.ally = _ally;
            }
            explorers[globalState.totalExplorers] = msg.sender;
            planet.claimTime = uint32(block.timestamp - block.timestamp % 3600);
            planet.battleId = uint16(block.timestamp % 100);
            globalState.totalExplorers++;
        }

        planet.energy = capU32Add(planet.energy, energy);
        globalState.totalDeposited = uint128(globalState.totalDeposited + _depositAmount);
        deposits[globalState.totalDeposits] =
            Deposit({explorer: msg.sender, energy: uint32(energy), time: uint32(block.timestamp)});
        globalState.totalDeposits++;
        emit EnergyBought(msg.sender, _ally, energy);
    }

    function sellPlasma(uint256 _plasma) external nonReentrant {
        require(_plasma > 0, "No plasma");
        Planet storage planet = planets[msg.sender];
        require(planet.claimTime > 0, "Not registered");

        collect(planet);
        require(planet.plasma >= _plasma, "Insufficient plasma");

        uint256 usdtPayout = (_plasma * 1e18) / 1000;
        uint256 contractBalance = USDT.balanceOf(address(this));
        usdtPayout = usdtPayout > contractBalance ? contractBalance : usdtPayout;
        _plasma = (usdtPayout * 1000) / 1e18;

        planet.plasma = uint32(planet.plasma - _plasma);
        emit PlasmaSold(msg.sender, _plasma);
        require(USDT.transfer(msg.sender, usdtPayout), "Transfer failed");
    }

    function swapPlasmaToEnergy(uint256 _plasma) external nonReentrant {
        require(_plasma > 0, "No plasma");
        Planet storage planet = planets[msg.sender];
        require(planet.claimTime > 0, "Not registered");

        collect(planet);
        require(planet.plasma >= _plasma, "Insufficient plasma");

        uint256 energy = _plasma * 2;

        planet.plasma = uint32(planet.plasma - _plasma);
        planet.energy = capU32Add(planet.energy, energy);
        emit PlasmaSwappedToEnergy(msg.sender, _plasma);
    }

    function placeBuildings(uint16[] calldata _tileIds, uint8 _level) external nonReentrant {
        Planet storage planet = planets[msg.sender];
        require(planet.claimTime > 0, "Not registered");
        require(_tileIds.length >= 1, "No tiles");
        require(_level > 0 && _level < 9, "Invalid level");

        collect(planet);

        (uint256 costPerBuilding, uint256 perHourPerBuilding) = getBuildingStats(_level);

        uint256 buildingCount = _tileIds.length;
        uint256 totalCost = costPerBuilding * buildingCount;
        uint256 totalPerHour = perHourPerBuilding * buildingCount;

        for (uint256 i = 0; i < buildingCount; i++) {
            uint256 tileId = _tileIds[i];
            require(tileId < 360, "Invalid tile");
            require(planet.tiles[tileId] == 0, "Tile not empty");
            planet.tiles[tileId] = _level;
        }

        require(planet.energy >= totalCost, "Insufficient energy");

        planet.energy = uint32(planet.energy - totalCost);
        planet.perHour = capU32Add(planet.perHour, totalPerHour);

        emit BuildingsPlaced(msg.sender, _tileIds, _level);

        distributeFees(planet.ally, totalCost);
    }

    function upgradeBuilding(uint16 _tileId) external nonReentrant {
        Planet storage planet = planets[msg.sender];
        require(planet.claimTime > 0, "Not registered");
        require(_tileId < 360, "Invalid tile");

        collect(planet);

        uint256 tileData = planet.tiles[_tileId];
        uint256 level = tileData % 10;
        uint256 currentUpgrades = tileData / 10;

        require(level > 0 && level < 9, "No building");
        require(currentUpgrades < 9, "Max upgrades");

        (uint256 baseCost, uint256 basePerHour) = getBuildingStats(level);

        uint256 upgradeCost = baseCost / 4;
        uint256 upgradePerHour = basePerHour / 4;

        require(planet.energy >= upgradeCost, "Insufficient energy");
        planet.energy = uint32(planet.energy - upgradeCost);
        planet.tiles[_tileId] = uint8((currentUpgrades + 1) * 10 + level);
        planet.perHour = capU32Add(planet.perHour, upgradePerHour);

        emit BuildingUpgraded(msg.sender, _tileId);

        distributeFees(planet.ally, upgradeCost);
    }

    function battle(uint8 _winChance) external nonReentrant {
        Planet storage planet = planets[msg.sender];
        require(planet.claimTime > 0, "Not registered");
        require(_winChance >= 40 && _winChance <= 60, "Invalid win chance");
        require(block.timestamp - planet.battleTime >= 86400, "Battle cooldown");
        require(planet.perHour > 0, "Cannot battle");

        bool isFirstBattle = planet.battlesInRow == 0;
        bool isWin = isFirstBattle ? true : getRandomSequence(planet.battleId) <= _winChance;

        planet.battleTime = uint32(block.timestamp);
        planet.battleId = isFirstBattle ? uint16(block.timestamp % 100) : planet.battleId + 1;
        if (
            (isWin && planet.isWinInRow && planet.battlesInRow >= 3)
                || (!isWin && !planet.isWinInRow && planet.battlesInRow >= 2)
        ) {
            isWin = getRandomSequence(planet.battleId) <= _winChance;
            planet.battleId++;
        }

        if (isWin == planet.isWinInRow) {
            planet.battlesInRow++;
        } else {
            planet.battlesInRow = 1;
            planet.isWinInRow = isWin;
        }

        uint256 reward = isWin ? (uint256(planet.perHour) * 16 * 50) / _winChance : uint256(planet.perHour) * 8;
        planet.energy = capU32Add(planet.energy, reward);
        emit BattleResult(msg.sender, isWin, _winChance, reward);
    }

    function distributeFees(address _ally, uint256 _amount) internal {
        if (_ally != address(0)) {
            uint256 allyFee = _amount / 10;
            planets[_ally].energy = capU32Add(planets[_ally].energy, allyFee);
            planets[_ally].energyFromAllies = capU32Add(planets[_ally].energyFromAllies, allyFee);
        }

        uint256 totalManagers = managers.length;
        uint256 managerFee = _amount / 10;
        for (uint256 i = 0; i < totalManagers; i++) {
            Manager memory manager = managers[i];
            planets[manager.addr].plasma = capU32Add(planets[manager.addr].plasma, (managerFee * manager.share) / 100);
        }
    }

    function getGlobalState() external view returns (GlobalState memory) {
        return globalState;
    }

    function getPlanet(address _player) external view returns (Planet memory) {
        return planets[_player];
    }

    function getExplorer(uint256 _index) external view returns (address) {
        return explorers[_index];
    }

    function getDeposit(uint256 _index) external view returns (Deposit memory) {
        return deposits[_index];
    }
}
