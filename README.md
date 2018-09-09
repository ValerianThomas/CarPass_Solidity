# CarPass_Solidity
A Solidity smart contract for CarPass decentralization 

# CarPass-Smart-Contract

A mid-decentralized solution for car mileage approval running on Ethereum

This allows any user to verify the mileage, model, year of Entry Into Circulation, and the owner's Ethereum of any vehicle , whenever and wherever they are , for free.


Only approved mechanics can add a millage check to a vehicle. They are defined here as Oracles.

Only the Smart Contract owner can create new Oracles.


## Data model

Two data models (struct) are created: the CarPass itself and the kilometerCheck

 the CarPass struct contains everything about the vehicle, from the chassisNumber to the list of all the millieage check the car has passed. 


```
struct CarPass {
    string chassisNumber;
    uint32  yearEntryIntoCirculation;
    uint8  numberOfChecks;
    string carModel;
    string carBrand;
    address ownerAddress;
    mapping(uint8 => KillometerCheck) kilometers;
    
}
```

The KilometerCheck is the struct defining a particular mileage check, containing the address of the Oracle who performed it, the mileage that has been registered, and the timestamp of when it has been done.  

```
struct KillometerCheck {
    uint date;
    uint32 kilometers;
    address oracleAddress;
}
```


## Methods

#### 1 createNewCarPass 

```
function createNewCarPass(string _chassisNumber, uint32 _yearEntryIntoCirculation, string _carModel, string _carBrand, address _ownerAddress) noCarpassForChassisNumber( _chassisNumber ) public {
    require(_yearEntryIntoCirculation < now);
    carPasses[_chassisNumber] = CarPass(_chassisNumber, _yearEntryIntoCirculation,0, _carModel, _carBrand, _ownerAddress);
}
```

Lets you create a brand-new CarPass with few parameters: the chassis number of the vehicle, the year of entry, the car model, the car brand and the owner address

#### 2 addKilometerCheck 

```
function addKilometerCheck (string _chassisNumber, uint32 _kilometers ) onlyOracle carPassMustExist(_chassisNumber) valideKilometer(_chassisNumber, _kilometers) public {
    CarPass storage cp = carPasses[_chassisNumber];
    cp.kilometers[cp.numberOfChecks] = KillometerCheck(now, _kilometers, msg.sender);
    cp.numberOfChecks ++;
}

```

Lets Oracles create new mileage check. 

#### 3 createOracle

```
function createOracle(address newOracle) external onlyOwner {
    isOracle[newOracle] = true;
}

```

Lets the smart contract owner creates new Oracles

#### 4 seeCarPass

```
function seeCarPass(string _chassisNumber) carPassMustExist(_chassisNumber) external view returns(string, string,address, uint[]) {
    uint timeChecked = carPasses[_chassisNumber].numberOfChecks;
    uint[] memory checks = new uint[](timeChecked);
    for(uint8 i = 0; i < timeChecked ; i++) {
        checks[i]= carPasses[_chassisNumber].kilometers[i].kilometers;
    }
    return(carPasses[_chassisNumber].carModel, carPasses[_chassisNumber].carBrand,  carPasses[_chassisNumber].ownerAddress, checks);
}
```

Lets any user see the details of a specic CarPass from the chassis Number

#### 5 seeParticularCheck 

```
function seeParticularCheck (string _chassisNumber, uint8 _checkId) carPassMustExist(_chassisNumber) external view returns(uint, uint32, address) {
   return(carPasses[_chassisNumber].kilometers[_checkId].date, carPasses[_chassisNumber].kilometers[_checkId].kilometers,carPasses[_chassisNumber].kilometers[_checkId].oracleAddress);
}
```

Lets any user check the specs of a particular kilometer check from specific CarPass

#### 6 changeCarOwner

```
function changeCarOwner(string _chassisNumber, address _newOwner) onlyCarOwner(_chassisNumber) external {
    require(_newOwner != msg.sender);
    carPasses[_chassisNumber].ownerAddress = _newOwner;
}
```

Lets car owners to transfer ownership to a new person
