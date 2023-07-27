// SPDX-License-Identifier: MIT

pragma solidity >=0.6.12;

contract SimpleStorage {
    // Custom types
    struct User {
        address userAddress;
        uint256 userBalance;
    }
    // State variables
    User[] public listOfFundedUsers; // list
    mapping(address => uint256) userBalanceGeter; // dictionary (not public)

    // function for updating the funded users list
    function storeAFundedUser(
        address _userAddress,
        uint256 _userBalance
    ) public {
        listOfFundedUsers.push(User(_userAddress, _userBalance));
        userBalanceGeter[_userAddress] = _userBalance;
    }

    // function for retrieving a user's balance from userName
    function retrieveUserBalance(
        address _userAddress
    ) public view returns (uint256) {
        return userBalanceGeter[_userAddress];
    }
}
