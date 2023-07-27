// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6; //>=0.6.0 <0.9.0

import "hardhat/console.sol";

    contract ByomStorage {

    /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  Declaring a state variable and an object type @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

        uint256 ownerId;                               // this will get initialized to 0; and it is internal by default
        struct Member {
            string memberName;
            uint256 ownerId;
        }
        bool public isEnabled;
        uint256 public index;

    /* @@@@@@@@@@@@@ Creating a members list. public variable get assigned a getter function by default. @@@@@@@@@@@@@@@ */

        Member[] public usersList;
        mapping(string => uint256) public memberNameToownerId;                 // https://solidity-by-example.org/mapping

    /* @@@@@@@@@@@@@@@@@@@@@@@@@@ Storing an Id ( for uint data location is inferred to memory, already). @@@@@@@@@@@@@@ */
    /* @@@@@@@@@@@ A function that requires a Tx because it modifies the property ownerId of the contract @@@@@@@@@@@@@ */


        constructor(uint256 _ownerId, uint256 _index){
        ownerId = _ownerId;
        isEnabled = true;
        index = _index;
        }

        function disable() external{
        isEnabled = false;
        }

        function store(uint256 _ownerId) public {                   // this function is accessible from the outside.
            ownerId = _ownerId;
        }

    /* @@@@@@@@@@@@@@@@@@@@@@@@@@@ Retrieving ID,   which just read only, therefore, no cost @@@@@@@@@@@@@@@@@@@@@@@@@@ */
                       // The view keyword marks this function as read-only. Idem for pure keyword.
                        // And the returns keyword marks the return type in the brackets that come after it

        function retrieve() public view returns (uint256) {
            return ownerId;
        }

    /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Adding an user @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

        function addUser(string memory _memberName , uint256 _ownerId) public {
            usersList.push(Member( _memberName, _ownerId ));
            memberNameToownerId[_memberName] = _ownerId;
        }
    }