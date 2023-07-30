// SPDX-License-Identifier: MIT

/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 0.1. SOLIDITY VERSIONS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
pragma solidity >=0.6.0 <0.9.0; //^0.8.0;
// pragma abicoder v2; // @Me:Application Binary Interface Encoder v2. Depricated as version 0.8.0

/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 0.2. IMPORTS (CONTRACTS; INTERFACES & LIBRARIES) @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
import "./interfaces/IERC20.sol";
// totalSupply(), balanceOf(address account), transfer(address to, uint256 amount), allowance(address owner, address spender),
// approve(address spender, uint256 amount),  function transferFrom(address from, address to, uint256 amount ) : all External.
import "./hyperverse/Initializable.sol";
// _disableInitializers() internal, _setInitializedVersion(uint8 version) private
import "./hyperverse/IHyperverseModule.sol";
// ModuleMetadata and Author struct.    // all functions are internal pure (Math ops)
// import "hardhat/console.sol"; // a JavaScript environment, for running Js commands to interact with any blockchain
// Oracle (Chainlink)
import "./utils/AggregatorV3Interface.sol";
// Get the latest ETH/USD price from chainlink price feed
//  interface at https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol
import "./utils/PriceConverter.sol"; // getPrice() internal, getConversionRate(uint256 ethAmount)  internal

/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ CONTRACT + INHERITANCE  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
contract BYOM is
    IERC20, //  Inheritance1
    IHyperverseModule, //  Inheritance2
    Initializable //  library1
{
    /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 0.3.  TYPPING  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
    using PriceConverter for uint256; //using a Library
    // Possible to define custom types with struct{} and Enum

    /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 1. IMMUTABLE & CONSTANT VARIABLES DEFINITION  @@@@@@@@@@@@@@@@@@@@@@@@@@ */
    /* this variables are gaz effiscient as, stored in the byte code of the SC, dirrectly.
      @Me: Address of the owner (who deployed the contract). 
                 It's deployer's EVM compatible public address (@Me: get it from Metamask/Core for instance)
                 Default is address(0) or
                 (sbo/MM): 0x45122452bc2f826b1e6738ff187AcB8a43bfF891 | (mve): 0x4264E741C74F8c2873fC491fa0e2193aeFF26E31
    */
    /* @Me: contract's owner definition 
    (the persona who will instanciate this smart contract for resuse in multi-tenancy context such as on Hyperverse)
   */
    address public immutable i_owner;
    // chain currency's variables definition.
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    uint256 public constant UNIT_MULTIPLIER; // 10**18  to get Wei?    // Multiplier to convert to smallest unit
    uint256 public constant decimals;
    uint256 public constant initialSupply; // Tokens created when contract was deployed
    string public constant currencyName;
    string public constant symbol;
    uint256 public override totalSupply; // Tokens currently in circulation (VarCap or FixedCap?)

    /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 2.  STATE VARIABLES DEFINITION  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

    /*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> KEY ACCOUNTS (PERSONAS) + LIST + DICTIONARY <<<<<<<<<<<<<<<<<<<<<<<<<*/
    string public pegCurr;
    string public pegRate;
    address private _tenantOwner; // @Me: "private", address only visible to the tenant (instant of the smart module) owner
    // End User addresses of the TENANT service, enrolled at the Location X (LocX). Using TENANT Services to pay or/and transfer money
    // We'll create an enum with all following types of users in Typescrypt App.
    address public _tenantCustomer;
    // “Point of Sales” (PoS) perform Cash-In or Cash-out with the End Users at the Location X (LocX). Receives compensation from TENANT. Should have a bank account
    address public _tenantPoS;
    // Merchants accept payments in TENANT from End Users buying good in their stores. Pay fees to TENANT to use the TENANT Payment service ?
    address public _tenantMerchant;
    // Ambassadors “recruit” new End Users, PoS or Merchants for the TENANT services. Receives compensation from TENANT (Handled outside of the system by a specific contract)
    address public _tenantAmbassador;
    // Support people for the TENANT services help End Users, PoS, Merchants & Ambassador in case of problems
    // Authorities can audit the TENANT systems (e.g ACPR in FR or BCEAO in IC) or receive alert in case of suspicious behavior (e.g TRACFIN or CENTIF in IC)
    address public _tenantAuthority;
    // List of addresses who deposited
    address[] public tenantDepositors;
    // Storing balances (list of balance of each user's address index )
    address[] public depositors; // List

    /*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> MAPPINGS <<<<<<<<<<<<<<<<<<<<<<<<<*/
    //mapping to store which address deposited how much ETH
    mapping(address => uint256) public addressToAmount; // dictionary
    //mapping to retrieve a balance for a specific address
    mapping(address => uint256) balances;

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> CHAIN CURRENCY's VARIABLES (constants) DEFINITION  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< */

    // Approval granted to transfer tokens from one address to another.
    mapping(address => mapping(address => uint256)) internal allowed;

    /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 3. E V E N T S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
    // Events allow clients to react to specific contract changes we declare
    ///+events                          // emit eventName();
    event DepositRecieved(address _to, uint256 _amount);
    event TransferOrdered(
        address sender,
        address _to, // This should be the remote recipient address
        uint256 _amount,
        string _reason
    );
    event TransferPending(
        address _from,
        address _to,
        uint256 _amount,
        string _reason
    );
    event TransferComplet(address _to, uint256 _amount);
    event withdrawalDone(address _from, uint256 _amount); // ?? not sure yet

    // Customs errors that describe failures.
    /// +errors
    /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 4. E R R O R S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

    error Unauthorized();
    error AlreadyInitialized();
    error ZeroAddress();
    error SameAddress();
    error InsufficientBalance();
    error InsufficientAllowance();
    error NotOwner();
    error AgentMaxPerDayExceeded();
    error AgentMaxPerWeekExceeded();
    error AgentMaxPerMonthExceeded();
    error AgentMaxPerYearExceeded();
    error CustomerMaxPerDayExceeded();
    error CustomerMaxPerWeekExceeded();
    error CustomerMaxPerMonthExceeded();
    error CustomerMaxPerYearExceeded();
    error MerchantMaxPerDayExceeded();
    error MerchanMaxPerWeekExceeded();
    error MerchanMaxPerMonthExceeded();
    error MerchanMaxPerYearExceeded();
    error PosMaxPerDayExceeded();
    error PosMaxPerWeekExceeded();
    error PosMaxPerMonthExceeded();
    error PosMaxPerYearExceeded();
    error MiniAmountNotOk();
    error KycNotOk();
    error amlNotOk();
    error cftNotOk();
    error NotCompliant();

    /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 5.  M O D I F I E R S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
    // modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
    // Pattern: if() {revert errorName()} instead of require(condition, "description") as of v0.8.4;

    ///+modifiers        (modifierName just after function visibility - A convenient way to validate inputs to functions)
    modifier isTenantOwner() {
        if (msg.sender != _tenantOwner) {
            revert Unauthorized();
        }
        _;
    }
    modifier canInitialize(address _tenant) {
        if (_tenantOwner != address(0)) {
            revert AlreadyInitialized();
        }
        _;
    }
    modifier isTenantCustomer() {
        if (msg.sender != _tenantCustomer) {
            revert Unauthorized();
        }
        _;
    }
    modifier isTenantMerchant() {
        if (msg.sender != _tenantMerchant) {
            revert Unauthorized();
        }
        _;
    }
    modifier isTenantPoS() {
        if (msg.sender != _tenantPoS) {
            revert Unauthorized();
        }
        _;
    }
    modifier isTenantAgent() {
        if (msg.sender != _tenantPoS) {
            revert Unauthorized();
        }
        _;
    }
    modifier isTenantAuthority() {
        if (msg.sender != _tenantAuthority) {
            revert Unauthorized();
        }
        _;
    }
    modifier addressCheck(address _from, address _to) {
        if (_from == _to) {
            revert SameAddress();
        }
        if (_to == address(0) || _from == address(0)) {
            revert _ZeroAddress();
        }
        _;
    }
    modifier onlyOwner() {
        // require(msg.sender == i_owner);
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }
    modifier minimumRequire() {
        if (msg.value.getConversionRate() < MINIMUM_USD)
            revert MiniAmountNotOk();
        _;
    }

    /*
    modifier onlyKyced() {
        //is the message sender owner of the contract?
        require(msg.sender == kyced);
        _;
    }
    modifier onlyNotSanctioned() {
        //is the message sender owner of the contract?
        require(msg.sender == notSanctioned);
        _;
    }
    */

    /*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F0: INIT1 -> Smart Module Metadata setting <<<<<<<<<<<<<*/
    /* @Me: Constructor, special function that is executed only once during the deployment process.
        Constructors are used to initialize the state variables 
        and perform any other setup tasks required for the contract to function correctly.
    */
    constructor(address _i_owner) public {
        metadata = ModuleMetadata( // a structure define in IHyperverseModule interface
            "BYOM",
            Author(_i_owner, "https://externallink.net"),
            "0.0.1",
            3479831479814,
            "https://externalLink.net"
        );
        Owner = _i_owner; // @Me: The first person to deploy the contract is the Owner.
        console.log(
            "Owner is deploying an instance of BYOM contract",
            "${Owner}"
        );
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F1: INITx -> TOKEN VARIABLES (ASSET VALUE TRACKING:) INITIAL STATE  <<<<<<<<<<<<< */
    /* * @dev Initializes the contract by setting a `currencyName` and a `symbol` to the token .
     * @dev Initializes the instance of a tenant for this contract and sets the state variables
     * @param _name The name of the token
     * @param _symbol The symbol of the token
     * @param _pegCurr The fiat pegged to
     * @param _pegRate The peg rate for the token
     * @param _decimal The number of decimals of the token
     * @param _tenant The address of the instance owner
     * @param _authority The name of the regulation authority
     */
    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _pegCurr,
        string memory _pegRate,
        uint256 _decimal,
        address _tenant
    ) external initializer canInitialize(_tenant) {
        // @Me:  initializer is a parent from "import "./hyperverse/Initializable.sol""?
        currencyName = _currencyName;
        symbol = _symbol;
        decimals = _decimal; // 18 for EVM
        pegCurr = _pegCurr;
        pegRate = _pegRate;
        UNIT_MULTIPLIER = 10 ** uint256(decimals); // Multiplier to convert to smallest unit
        uint256 supply = 1000000; // Fixed cap asset?
        totalSupply = supply.mul(UNIT_MULTIPLIER); // Convert supply to smallest unit
        initialSupply = totalSupply; // Assign entire initial supply to tenant owner
        balances[_tenant] = totalSupply;
        _tenantOwner = _tenant; // @Me: unique time we get in, this parameter is set.
        // Then next time, execution will be forbiden by canInitialize
        console.log(
            "Token initialized:",
            _currencyName,
            _symbol,
            _decimal,
            _pegCurr,
            _pegRate,
            _tenant
        );
    }

    /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 7. T E N A N T's  F U N C T I O N S (13 as of jan 2023) @@@@@@@@@@@@@@@@@@@@@@@@ */
    /// +functions   // function? functionName () visibility view? pure? payable? virtual? override? returns(?) {... return() }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F2 -> INCREASING THE TOKEN SUPPLY (MINTING) (external) <<<<<<<<<<<<< */
    /* @dev Creates `amount` tokens and assigns them to tenantOwner, increasing the total supply.
     * Emits a {Transfer} event with `from` set to the zero address.
     * @param _amount The address which will spend the funds.
     * @Me: Not a scarece asset or not fixed capped asset.
     * @Me: // Function that lets anyone deposit ETH into the contract
     */
    function mint(uint256 _amount) external isTenantOwner {
        // needs to be called by deposit()?
        balances[msg.sender] += _amount;
        totalSupply += _amount;
        emit mintedByom(address(0), msg.sender, _amount);
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F3 -> DECREASING THE TOKEN SUPPLY (BURN) (external) <<<<<<<<<<<<< */
    /* @dev Destroys `amount` of tokens from the caller's account, decreasing
     * the total supply.
     * Emits a {Transfer} event with `from` set to the zero address.
     * @param _amount The total tokens to be destroyed.
     */
    function burn(uint256 _amount) external {
        if (balanceOf(msg.sender) < _amount) {
            revert _InsufficientBalance();
        }
        balances[msg.sender] -= _amount;
        totalSupply -= _amount;
        emit TransferComplet(msg.sender, address(0), _amount);
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F4 -> DEPOSIT (public payable) <<<<<<<<<<<<< */
    /*
     * @dev  Allow the user to deposit
     */
    function deposit() public payable minimumRequire {
        // @Me: payable function which needs to add minimum ETH
        // 18 digit number to be compared with deposited amount
        uint256 minimumUSD = 5 * 10 ** 18; //the deposited amountis not less than 5 USD?
        addressToAmount[msg.sender] += msg.value;
        tenantDepositors.push(msg.sender);
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F5 -> get the version of the chainlink pricefeed (public view) <<<<<<<<<<<<< */
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        return priceFeed.version();
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F6 -> get the price from thee chainlink pricefeed (public view) <<<<<<<<<<<<< */
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F7 -> get conversion rate USD/ETH (public view) <<<<<<<<<<<<< */
    function getConversionRate(
        uint256 ethAmount
    ) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversation rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  F8 -> TRANSFER TOKEN TO ADDRES X (public override) <<<<<<<<<<<<< */
    /* @dev Transfers token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     * @return A bool indicating if the transfer was successful.
     */
    function transfer(
        // Is this gas effiscient compare to using functions transfer() | send() | call() ??!
        address _to,
        uint256 _value,
        string memory _reason
    ) public override addressCheck(msg.sender, _to) returns (bool) {
        if (balanceOf(msg.sender) < _value) {
            revert _InsufficientBalance();
        }
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit TransferOrdered(msg.sender, _to, _value, _reason);
        return true;
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  F9 ->TRANSFER TOKEN FROM ADDRESS1 TO ADDRESS2 (public override) <<<<<<<<<<<<< */
    /*
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     * @param _reason string, The reason for transfering
     * @param _time uint256
     * @return A bool indicating if the transfer was successful.
     * @Me: Using transferFrom requires the token owner to give allowance to withdraw the tokens,
     * @Me: and usually giving this allowance requires a transaction.
     * @Me: you could use permit (https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#ERC20Permit) functionality.
     * @Me: This is the same as owner giving allowance, but it doesn't require a transaction - only a signature.
     * @Me: Another option is something like Gas Station Network (https://opengsn.org/).
     */
    function transferFrom(
        // Is this gas effiscient compare to using functions transfer() | send() | call() ??!
        address _from,
        address _to,
        uint256 _value,
        string memory _reason
    ) public override addressCheck(_from, _to) returns (bool) {
        if (allowed[_from][msg.sender] < _value) {
            revert _InsufficientAllowance();
        }
        balances[_from] = balances[_from].sub(_value);
        balances[_to] = balances[_to].add(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
        emit TransferPending(_from, _to, _value, _reason);
        return true;
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F10 -> ENTIERTY OF DEPOSIT WITHDRAW (public payable) <<<<<<<<<<<<< */

    // @Me: payable function to withdraw all the ETH from the contract, by the owner only
    function ownerWithdraw() public payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
        //iterate through the depositors list and make them 0 since all the deposited amount has been withdrawn
        for (
            uint256 depositorIndex = 0;
            depositorIndex < tenantDepositors.length;
            depositorIndex++
        ) {
            address depositor = tenantDepositors[depositorIndex];
            addressToAmount[depositor] = 0;
        }
        // tenantDepositors list will be reset to 0
        tenantDepositors = new address[](0);
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  F11: BALANCEOF : BALANCE OF SPECIFIED ADDRESS  ( public view overrride) <<<<<<<<<<<<< */
    /** @dev Gets the balance of an address.
     * @param _user The address to query the balance of
     * @return An uint256 representing the amount owned by the passed address
     */
    function balanceOf(address _user) public view override returns (uint256) {
        // virtual function in ERC20.sol?
        return balances[_user]; // Using a mapping
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F12. BALANCE -> SENDER'S BALANCE (public view) <<<<<<<<<<<<< */
    /** @dev Gets the balance of the calling address.
     * @return An uint256 representing the amount owned by the calling address
     */
    function balance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F13. ALLOWANCE -> CHECK ALLOWED LIMIT AMOUNT TO SPEND (piublic view override) <<<<<<<<<<<<< */
    /**
     * @dev Checks the amount of tokens that an owner allowed to a spender.
     * @param _i_owner address, the address that owns the funds.
     * @param _spender address, the address that will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(
        address _i_owner,
        address _spender
    ) public view override returns (uint256) {
        return allowed[_i_owner][_spender];
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  F14 -> SET AMOUNT THAT TENANT WILL SPEND ON BEHALF OF AN USER (ADDRESS) (public override)<<<<<<<<<<<<< */
    /*
     * @dev Approves the passed address to spend the specified amount of tokens
     *      on behalf of msg.sender.
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     * @return A bool indicating success (always returns true)
     */
    function approve(
        address _spender,
        uint256 _value
    ) public override returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F15 -> ANY WITHDRAWAL <<<<<<<<<<<<< */
    /*
     * @dev  Allow the any client to whithdrawl its balance
    
    function withdrawClients() public payable {}
     */

    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ H E L P E R  F U N C T I O N S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

    /* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F16 -> FALLBACK() and RECIEVE() (external payable) <<<<<<<<<<<<< */
    fallback() external payable {
        // as constructor, fallback() a special Solidity function
        deposit();
    }

    receive() external payable {
        // recieve() is  a special Solidity function too
        deposit();
    }

    /*              Explainer from: https://solidity-by-example.org/fallback/
     * @dev  when funds are sent to the contrack without calling a specific payable function, recieve() or fallback() is called
     */
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

    // special functions such as constructor(), fallback() and receive() don't need the keyword function.

    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ O V E R R I D E S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ E R C 20   M E T H O D S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

    /*

Here's a breakdown of the code:

1.	Pragmas: The contract specifies the Solidity version it is compatible with, 

2.	Imports: Several external contracts are imported, 

3.	State Variables:

4.	Mappings:

5.	Immutable Variables:

6.	Events:

7.	Errors:

8.	Modifiers:

9.	Constructor:

10.	Functions:

11. Receive and Fallback Functions:


*/
}
