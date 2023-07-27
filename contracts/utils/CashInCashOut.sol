// SPDX-License-Identifier: MIT
pragma solidity ^0.7.2;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "./PriceConverter.sol";
// getPrice() internal, getConversionRate(uint256 ethAmount)  internal

error NotOwner();

contract CashInCashOut {
    using PriceConverter for uint256;       //using the Library

    mapping(address => uint256) public addressToAmountDeposited;                        // dictionary
    address[] public depositors;                                                        // List

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */ i_owner;                                             // contract owner
    uint256 public constant MINIMUM_USD = 50 * 10 ** 18;                                // constant? reserve keyword?
    
    constructor() {                                                                    // deployer is the owneer
        i_owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "You need to spend more ETH!");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        addressToAmountDeposited[msg.sender] += msg.value;
        depositors.push(msg.sender);                                                // add the sender to the list of depositors
    }
    
    function getVersion() public view returns (uint256){
        // ETH/USD price feed address of Goerli Network.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);  // calling the address with the Interface (ABI)
        return priceFeed.version();                                                                           // fucntion in the Interface
    }
    
    modifier onlyOwner { 
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
    
    function withdraw() public onlyOwner {                                                                  // only owner can withdraw, in this context
        for (uint256 _depositorIndex=0; _depositorIndex < depositors.length; _depositorIndex++){
            address depositor = depositors[_depositorIndex];
            addressToAmountDeposited[depositor] = 0;                                                       // does it always withdraw all?
        }
        depositors = new address[](0);                                                                    // all accounts emptied?
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        deposit();
    }

    receive() external payable {
        deposit();
    }

}

// Concepts we didn't cover yet (will cover in later sections)
// 1. Enum
// 2. Events
// 3. Try / Catch
// 4. Function Selector
// 5. abi.encode / decode
// 6. Hash with keccak256
// 7. Yul / Assembly
