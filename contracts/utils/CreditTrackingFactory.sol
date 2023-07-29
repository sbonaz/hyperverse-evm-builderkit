// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import {CreditTracking} from "CreditTracking.sol";

contract CreditTrackingFabric {
    CreditTracking public creditTracking;
    CreditTracking[] public Tenants;

    function createCreditTracking() public {
        creditTracking = new CreditTracking();
        Tenants.push(creditTracking);
    }

    function sfstoreUser(
        uint256 _creditTrackingIndex,
        string memory _userName,
        uint256 userCredit
    ) public {
        Tenants[_creditTrackingIndex].storeUser(_userName, userCredit);
    }

    function sfretrieveUserCredit(
        uint256 _creditTrackingIndex,
        string memory _userName
    ) public view returns (uint256) {
        return Tenants[_creditTrackingIndex].retrieveUserCredit(_userName);
    }
}
