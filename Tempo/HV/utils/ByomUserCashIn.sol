// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <0.9.0;

// Importing Chainlink code.
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
// Interfaces compile down to ABI, which tells Solidity the functions that can be called in an already deployed contract.
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

// Smart contract that lets ANYONE deposit Cash (as ETH / AVAX) into the contract, but only the OWNER of the contract can withdraw.

contract ByomClientDeposit {
    // This contract will accept a payment from BYOM user

    // PROPERTIES
    // safe math library check uint256 for integer overflows
    using SafeMathChainlink for uint256; // A ChainLink import needed.
    //mapping to store which address depositeded how much Cash
    mapping(address => uint256) public addressToAmountDeposited;
    // list of addresses who deposited (depositors)
    address[] public depositors;
    //address of the owner (who deployed the contract)
    address public owner;

    // the first person to deploy the contract is the owner
    constructor() public {
        owner = msg.sender;
    }

    // USER DEPOSIT
    function deposit() public payable {
        // This function is used to make a payment
        // 18 digit number to be compared with deposited amount
        uint256 minimumAmnt = 20 * 10**18; // denomination will be 9 if AVAX
        //is the donated amount less than 20EURO?  a revert msg is sent when condition not met.
        require(
            getConversionRate(msg.value) >= minimumAmnt,
            "You need to deposit more!"
        );
        //if not, add to mapping and depositors list
        addressToAmountDeposited[msg.sender] += msg.value;
        depositors.push(msg.sender);
    }

    // FOREX: what the ETH /AVAX to EURO conversion rate?!
    function getVersion() public view returns (uint256) {
        //function to get the version of the chainlink pricefeed.
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        // data.chain.link/ethereum/mainnet
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData(); // unused variable of the TUPLE are ignored by leaving blanks.
        // ETH/EURO rate in 18 digit or AVAX/EURO rate in 9 digit
        return uint256(answer * 10000000000);
    }

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInEuro = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/EURO conversation rate, after adjusting the extra 0s.
        return ethAmountInEuro;
    }

    // CONTRACT OWNER WITHDRAWL ONLY

    //modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
    modifier onlyOwner() {
        //is the message sender owner of the contract?
        require(msg.sender == owner);
        _;
    }

    function withdraw() public payable onlyOwner {
        // The modifier is used here
        // If you are using version eight (v0.8) of chainlink aggregator interface, you will need to change the code below to
        // payable(msg.sender).transfer(address(this).balance);
        msg.sender.transfer(address(this).balance);

        //iterate through all the mappings and make them 0 since all the deposited amount has been withdrawn by the Owner
        for (
            uint256 depositorIndex = 0;
            depositorIndex < depositors.length;
            depositorIndex++
        ) {
            address depositor = depositors[depositorIndex];
            addressToAmountDeposited[depositor] = 0;
        }
        //depositors list will be initialized to 0
        depositors = new address[](0);
    }
}
