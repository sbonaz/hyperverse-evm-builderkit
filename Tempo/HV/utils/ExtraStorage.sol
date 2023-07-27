// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Let this contract know about SimpleStorage contract
import "./SimpleStorage.sol";

// Heritance
contract ExtraStorage is SimpleStorage {
    function store(uint256 _favoriteNumber) public override {
            // Overriding function store. So we should make it virtual in parent
        favoriteNumber = _favoriteNumber + 5;
    }
}
