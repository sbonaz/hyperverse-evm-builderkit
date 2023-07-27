// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;


// My Dev Account : 0x45122452bc2f826b1e6738ff187AcB8a43bfF891 (seboDev)

 // Get the latest ETH/USD price from chainlink price feed contract
 // importing directly from Github (NPM package), the Interface that will give us the ABI of needed contract parent
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; 

// Smart contract that lets anyone deposit ETH into the contract
contract FundMe {

     // 0. Global variables setting
       //  Setting minimum amount for tx;
        uint256 minimumAmount = 50 * 1e18;  // 50 * 10**18                       (18 decimals)
       //  List of addresses who deposited;
        address[] public funders;
       //mapping to store which address depositeded how much ETH
        mapping(address => uint256) public funderToReceivedAmount;

    // 1.  function Get funds from user
    function fund() public payable returns(uint256) {
        // Enforcing the minimum fund amount in ETH
        require(msg.value >= minimumAmount, "Insufiscient, add more Funds");   // in 1e18 == 1*10**18 - 18 decimals
        // convert to USD the amount of ETH received
        receivedFunds = getConversionRate(msg.value);
        return receivedFunds;

    }     
        // We need the Price in ETH first from a contract Interface using its:
            //   ABI: by compiling the imported contract interface (from ChainLing Github repos smartcontractkit)
            //   Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e, from ChainLink docs(ETH2USD contract on Rinkeby)
    function getPrice() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
    ( , int256 price, , ,)  = priceFeed.latestRoundData();      // a recipient to recieve value
    return uint256(price * 1e10);      // 1 ** 10 = 10000000000. Doing type casting at the same time
    }
        // We need price feed contract with a specific version
    function getVersion()  public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version(); 
    }
        // Want to be able to get price in fiat such as USD (connecting to RWA) ==> using Oracle Data Feeds package
            // ETH in terms of USD lastly
    function getConversionRate(uint256 amountETH)  pu