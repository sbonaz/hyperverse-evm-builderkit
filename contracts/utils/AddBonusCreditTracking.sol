// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import {CreditTracking} from "./CreditTracking.sol";

contract AddBonusCreditTracking is CreditTracking {
    function storeUser(
        string memory _userName,
        uint256 _userCredit
    ) public override {
        listOfCreditedUsers.push(User(_userName, _userCredit));
        userNameToCredit[_userName] = _userCredit++;
    }

    function retrieveUserCredit(
        string memory _userName
    ) public view override returns (uint256) {
        return 2 * userNameToCredit[_userName];
    }
}
