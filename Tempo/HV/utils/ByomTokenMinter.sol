// SPDX-License-Identifier: MIT

        // A compiler directive. It states that this specific source file needs 
        // at least version 0.0.1 of the Solidity compiler and doesn't work with compiler versions from 0.8.4 on.
        // Allways check which compiler versions libraries you pull in require, as there can be different.
pragma solidity ^0.8.4;

import "hardhat/console.sol";

        // Now the contract (as classes in Javascript)

contract Byomc {

    address public minter;                      // This gonna be used as public address property of the contract.
    mapping (address => uint) public balances;  // maps the address to the value representing balances

         // Events allow clients to react to specific contract changes you declare
    event Sent(address from, address to, uint amount);

    constructor() {                              // Constructor code is only run when the contract is created
        minter = msg.sender;
    }

        // Sends an amount of newly created coins to an address. Can only be called by the contract creator
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    error InsufficientBalance(uint requested, uint available);

        // Sends an amount of existing coins from any caller to an address
    function send(address receiver, uint amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });

        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}