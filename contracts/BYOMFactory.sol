// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0; //^0.8.6;                        // Carrot character to specify minimum compatible version number
pragma experimental ABIEncoderV2;

import "./hyperverse/CloneFactory.sol";  // CloneFactory article: https://medium.com/coinmonks/delegatecall-calling-another-contract-function-in-solidity-b579f804178c
import "./hyperverse/IHyperverseModule.sol";
import "./contracts/utils/Counters.sol";
import "./BYOM.sol";
import "hardhat/console.sol";

     /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ APPLYING FACTORY PATTERN FOR MULTITENANCY @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
        //
        // @dev: Creating multiple instances of the same contract and keeping track of them to make their management easier.     
        // @dev: Clone Factory is an advanced Factory pattern Implementation ( CreateInstance + GetProxy)
        //
    /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */


contract BYOMFactory is CloneFactory {               // heritage
    using Counters for Counters.Counter;             // property from imported Library

    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ S T A T E VARIABLES @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

    struct Tenant {         // A tenant is defined by its contract instance and the owner address
        BYOM byom;          //@Me: the variable byom is of type contract BYOM 
        address owner;      //@Me: the variable  owner is of type address.
    }

    Counters.Counter public tenantCounter;          // @Me: A public attribute of type Counter

    mapping(address => Tenant) public tenants;
    mapping(address => bool) public instance;

    address public immutable owner;
    address public immutable masterContract;
    address private hyperverseAdmin = 0x62a7aa79a52591Ccc62B71729329A80a666fA50f;
        

    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ E V E N T S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

    event TenantCreated(address _tenant, address _proxy);

    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ E R R O R S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

    error Unauthorized();
    error InstanceAlreadyInitialized();
    error InstanceDoesNotExist();
    error ZeroAddress();

    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ M O D I F I E R S @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

    modifier isAuthorized(address _tenant) {
        if (_tenant == address(0)) {
            revert ZeroAddress();
        }
        if (!(msg.sender == _tenant || msg.sender == hyperverseAdmin)) {
            revert Unauthorized();
        }
        _;                                                                                     //@Me: proceed to the remaining code
    }

    modifier hasAnInstance(address _tenant) {
        if (instance[_tenant]) {
            revert InstanceAlreadyInitialized();
        }
        _;
    }

    /*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ F U N C T I O N S: CREATE_INSTANCE + GET_PROXY @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/

    /*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F0: C O N S T R U C T O R <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
    constructor(address _masterContract, address _owner) {
        masterContract = _masterContract;                       // the first child, which will be referenced by clone's proxies
        owner = _owner;
        console.log(`"Creating a " ${masterContract} " instance " for ${owner}`);
    }

    /*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F1:CREATING A CLONE INSTANCE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
    function createInstance(
        address _tenant,
        string memory _name,
        string memory _symbol,
        uint256 _decimal) external isAuthorized(_tenant) hasAnInstance(_tenant) {
        BYOM token = BYOM(createClone(masterContract));          // heritaged from CloneFactory.sol?
        token.initialize(_name, _symbol, _decimal, _tenant);    //initializing tenant state of clone
        Tenant storage newTenant = tenants[_tenant];            //set Tenant data
        newTenant.byom = token;
        newTenant.owner = _tenant;
        instance[_tenant] = true;
        tenantCounter.increment();
        emit TenantCreated(_tenant, address(token));
    }

    /*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> F2:GETPROXY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
    function getProxy(address _tenant) public view returns (BYOM) {
        if (!instance[_tenant]) {
            revert InstanceDoesNotExist();
        }
        return tenants[_tenant].byom;
    }
}
