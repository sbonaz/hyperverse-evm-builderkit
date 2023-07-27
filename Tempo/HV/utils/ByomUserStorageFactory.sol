// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0; //^0.8.4;

import "./ByomStorage.sol";

/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ APPLYING FACTORY PATTERN @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
// @dev: in order to verify what we are creating, we'll store then retrieve, created instances in a list of created objects
//       So, we need a Setter (store()) and a Getter (retrieve()) for this factory.
// @dev: to interact with a deployed contract, we need its ADDRESS (where it has been deployed) and its ABI
/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

contract ByomStorageFactory is ByomStorage {
    ByomStorage[] public byomStorageList;
    uint256 disabledCount;

    event ByomStorageContractCreated(
        address byomStorageContractAddress,
        uint256 ownerId
    );

    /* @@@@@@@@@@@@@@@@@  Creating a new instance of the same contract and filling up a list in a numerical indexing way @@@@@@@@@@ */
    function createByomStorageContract() external {
        ByomStorage byomStorageContract = new byomStorageContract(
            ownerId,
            byomStorageList.length
        ); // as class instanciation, leveraging a constructor
        byomStorageList.push(byomStorageContract);
        emit ByomStorageContractCreated(address(byomStorageContract), ownerId);
    }

    /* @@@@@@@@@@@@@@@@@  Setter                                                                                    @@@@@@@@@@@@@@ */
    function bsfStore(
        uint256 _byomStorageIndex,
        uint256 _byomStorageNumber
    ) public {
        //this line has an explicit cast to the address type and initializes a new ByomStorage object from the address
        ByomStorage(address(byomStorageList[_byomStorageIndex])).store(
            _byomStorageNumber
        );
        //this line simply gets the ByomStorage object at the index _byomStorageIndex in the list byomStorageList
        //byomStorageList[_byomStorageIndex].store(_byomStorageNumber);
    }

    /* @@@@@@@@@@@@@@@@  Getter                                                                                  @@@@@@@@@@@@@@@ */
    function bsfGet(uint256 _byomStorageIndex) public view returns (uint256) {
        //this line has an explicit cast to the address type and initializes a new ByomStorage object from the retrieved address
        return
            ByomStorage(address(byomeStorageList[_byomStorageIndex]))
                .retrieve();
        //this line simply gets the ByomStorage object at the index _byomeStorageIndex in the list byomStorageList
        //return byomStorageList[_byomStorageIndex].retrieve();
    }

    /* @@@@@@@@@@@@@@@@  Another Getter                                                                           @@@@@@@@@@@@@@@ */
    function getbyomStorageList()
        external
        view
        returns (ByomStorageContract[] memory _byomStorageList)
    {
        _byomStorageList = new ByomStorageContract[](
            byomStorageList.length - disabledCount
        );
        uint count;
        for (uint i = 0; i < byomStorageList.length; i++) {
            if (byomStorageList[i].isEnabled()) {
                _byomStorageList[count] = byomStorageList[i];
                count++;
            }
        }
    }

    /* @@@@@@@@@@@@@@@@  Disable an instance of the contract                                                    @@@@@@@@@@@@@@@ */
    function disable(ByomStorage byomStorageContract) external {
        byomStorageList[byomStorageContract.index()].disable();
        disabledCount++;
    }
}
