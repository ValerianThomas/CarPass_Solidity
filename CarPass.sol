pragma solidity 0.4.24;

contract GoPass {
    address Owner;
    constructor () public {
        Owner = msg.sender;
    }

struct KillometerCheck {
    uint date;
    uint32 kilometers;
    address oracleAddress;
}

struct CarPass {
    string chassisNumber;
    uint32  yearEntryIntoCirculation;
    uint8  numberOfChecks;
    string carModel;
    string carBrand;
    address ownerAddress;
    mapping(uint8 => KillometerCheck) kilometers;
    
}

mapping (string => CarPass) carPasses;

mapping (address => bool) isOracle;

modifier onlyOracle() {
    require(isOracle[msg.sender] == true);
    _;
}

modifier valideKilometer(string _chassisNumber, uint _kilometers) {
    CarPass storage cp = carPasses[_chassisNumber];
    require(cp.kilometers[cp.numberOfChecks].kilometers <= _kilometers);
    _;
    
}

modifier onlyOwner(){
    require(msg.sender == Owner);
    _;
}

modifier noCarpassForChassisNumber(string chassisNumber) {
    //the mapping will return 0 if the struct doesn't exist yet
    require(carPasses[chassisNumber].yearEntryIntoCirculation == 0 );
    _;
}

modifier carPassMustExist(string chassisNumber) {
    //the mapping will return 0 if the struct doesn't exist yet
    require(carPasses[chassisNumber].yearEntryIntoCirculation != 0 );
    _;
}

modifier onlyCarOwner(string _chassisNumber) {
    require(carPasses[_chassisNumber].ownerAddress == msg.sender);
    _;
}

function createOracle(address newOracle) external onlyOwner {
    isOracle[newOracle] = true;
}

function createNewCarPass(string _chassisNumber, uint32 _yearEntryIntoCirculation, string _carModel, string _carBrand, address _ownerAddress) noCarpassForChassisNumber( _chassisNumber ) public {
    require(_yearEntryIntoCirculation < now);
    carPasses[_chassisNumber] = CarPass(_chassisNumber, _yearEntryIntoCirculation,0, _carModel, _carBrand, _ownerAddress);
}

function addKilometerCheck (string _chassisNumber, uint32 _kilometers ) onlyOracle carPassMustExist(_chassisNumber) valideKilometer(_chassisNumber, _kilometers) public {
    CarPass storage cp = carPasses[_chassisNumber];
    cp.kilometers[cp.numberOfChecks] = KillometerCheck(now, _kilometers, msg.sender);
    cp.numberOfChecks ++;
}

function seeCarPass(string _chassisNumber) carPassMustExist(_chassisNumber) external view returns(string, string,address, uint[]) {
    uint timeChecked = carPasses[_chassisNumber].numberOfChecks;
    uint[] memory checks = new uint[](timeChecked);
    for(uint8 i = 0; i < timeChecked ; i++) {
        checks[i]= carPasses[_chassisNumber].kilometers[i].kilometers;
    }
    return(carPasses[_chassisNumber].carModel, carPasses[_chassisNumber].carBrand,  carPasses[_chassisNumber].ownerAddress, checks);
}

function seeParticularCheck (string _chassisNumber, uint8 _checkId) carPassMustExist(_chassisNumber) external view returns(uint, uint32, address) {
   return(carPasses[_chassisNumber].kilometers[_checkId].date, carPasses[_chassisNumber].kilometers[_checkId].kilometers,carPasses[_chassisNumber].kilometers[_checkId].oracleAddress);
}

function changeCarOwner(string _chassisNumber, address _newOwner) onlyCarOwner(_chassisNumber) external {
    require(_newOwner != msg.sender);
    carPasses[_chassisNumber].ownerAddress = _newOwner;
}


function () public payable {}

}