// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// To interact with a contract we need its:
// ABI  : tells us the differents ways we can interact with the contract (functions, ...)
// Address

import "./SimpleStorage.sol"; // the import brings the ABI of the contract when compiling

contract StorageFactory {
    // Container to list instances of contract by indexing
    SimpleStorage[] public simpleStorageArray;

    // Factory main function
    function createSimpleStorageContract() public {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage); // here we are storing the contract address, at the deployment
    }

    // Using the deployed contract's capabilities from the Factory

    // 1. its store function
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber)  public {
        simpleStorageArray[_simpleStorageIndex].store(_simpleStorageNumber);
    }

    // 2. its retrieve function
    function sfRetrieve(uint256 _simpleStorageIndex) public view returns (uint256) {
        return simpleStorageArray[_simpleStorageIndex].retrieve();
    }

    // 3. its addPerson function
    function sfAddPerson(  uint256 _simpleStorageIndex,  string memory _name, uint256 _simpleStorageNumber ) public {
        simpleStorageArray[_simpleStorageIndex].addPerson( _name,  _simpleStorageNumber );
    }
}
