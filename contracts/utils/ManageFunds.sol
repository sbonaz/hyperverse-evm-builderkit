// *** GOALS ***
    // allow deposits
    // allow withdrawals
    // set minimum deposit

// SPDX-License-Identifier: MIT
pragma solidity  >=0.6.0 <0.9.0; //^0.8.0;

//***** Imports: interface, library *****
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";  // getPrice() internal, getConversionRate(uint256 ethAmount)  internal

//***** Errors ***
error NotOwner();
error MiniAmountNotOk();

contract ManageFunds {

    //***** Typping ***
    using PriceConverter for uint256;       //using the Library to get real world price

    //***** State variables & Mapping***
    address[] public depositors;           // list of depositors
    mapping(address => uint256) public addressToAmount;    // dictionary                 // dictionary
       
    //***** Immutable & Constant variables ***
    address public /* immutable */ i_owner;                                             // contract owner
    uint256 public constant MINIMUM_USD = 50 * 10 ** 18; 

    //***** Construtor ***    // special function along with receive() and fallback()
    constructor() {                                                                    // deployer is the owneer
        i_owner = msg.sender;
    }

    //***** Functions ***
    function deposit() public payable {
        addressToAmount[msg.sender] += msg.value;
        depositors.push(msg.sender);                                                // add the sender to the list of depositors
        emit DepositRecieved(msg.sender, msg.value);    
    }

    function getVersion() public view returns (uint256){
        // ETH/USD price feed address of Goerli Network.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);  // calling the address with the Interface (ABI)
        return priceFeed.version();                                                                           // fucntion in the Interface
    }

    //***** Events ***          // inside a function's instructions
    event DepositRecieved(address depositor, uint256 amount);

    //***** Modifiers ***      // after function visibility  
    modifier onlyOwner { 
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert NotOwner();
        _;
    }
    modifier minimumRequire {
        if(msg.value.getConversionRate() < MINIMUM_USD) revert MiniAmountNotOk();
        _;
    }

    function withdrawAll() public onlyOwner {
        // reseting all balances  
        for (uint256 _depositorIndex=0; _depositorIndex < depositors.length; _depositorIndex++){
            address depositor = depositors[_depositorIndex];
            addressToAmount[depositor] = 0;                                                     // does it always withdraw all?
        }
        // moving actual funds
        depositors = new address[](0);

    }
}