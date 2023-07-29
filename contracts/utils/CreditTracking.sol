// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract CreditTracking {
    struct User {
        string userName;
        uint256 userCredit;
    }
    User[] public listOfCreditedUsers;
    mapping(string => uint256) userNameToCredit;

    function storeUser(string memory _userName, uint256 _userCredit) public {
        listOfCreditedUsers.push(User(_userName, _userCredit));
        userNameToCredit[_userName] = _userCredit;
    }

    function retrieveUserCredit(
        string memory _userName
    ) public view returns (uint256) {
        return userNameToCredit[_userName];
    }
}
