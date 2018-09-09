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

1 createNewCarPass 

Lets you create a brand-new CarPass with few parameters: the chassis number of the vehicle, the year of entry, the car model, the car brand and the owner address

2 addKilometerCheck 

Lets Oracles create new mileage check. 

3 createOracle

Lets the smart contract owner creates new Oracles

4 seeCarPass

Lets any user see the details of a specic CarPass from the chassis Number

5 seeParticularCheck 

Lets any user check the specs of a particular kilometer check from specific CarPass

6 changeCarOwner

Lets car owners to transfer ownership to a new person
