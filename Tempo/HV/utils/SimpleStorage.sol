// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

contract SimpleStorage {
    // SC has: Name, Address, ABI and Bytecode

    // PRIMITIVE TYPES:
    // Boolean,
    // int, uint,    eg. int ... int256 , uint ... uint256
    // bytes,        eg. bytse2, ... bytes32  ( but bytes for any size)
    // string, just bytes but for text only
    // address       eg. (on AVA: 0xE79c491463a5Df7FCA93375811034d9883777F31)
    // variable = Holder for some values

    // VISIBILITY (of variable or function)
    // internal, private, external, public
    // public variable implicitly gets assigned a getter, a function that returns its value
    uint256 public favoriteNumber; // the variable gets initialized to default value, "0"

    // ADVANCED DATA TYPES:

    // struct: (creating a new Type in Solidity)
    //         or need for storing a list of different variables. That list of variables is indexed starting by 0
    struct People {
        // People is now a new type
        string name; // indexed to 0
        uint256 favoriteNumber; // indexed to 1
    }
    // Array: (creating a list in Solidity)
    //        data type that holds a list of other types or sequence of objects
    People[] public people; // a dynamic array (oppose to fixed-size)
    //  Mapping (Creating a dictionary):
    //           a key which returns value associated to that key). What if we know someone name only, but we want its favoriteNumber?
    mapping(string => uint256) public nameToFavoriteNumber; // initialized to no value (0)

    // FUNCTIONS or Methods are self contain modules that execute a subset of code when called
    // The following function is an explicite setter that will change the value of a variable
    // it gets called with the given parameter
    function store(uint256 _favoriteNumber) public virtual {
        // Virtual, so it can be override in child contract
        favoriteNumber = _favoriteNumber;
    }

    // EVM can store and access info in 6 places: Storage, Stack, Memory, Calldata, Code, Logs,
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_name, _favoriteNumber)); // adding to list
        nameToFavoriteNumber[_name] = _favoriteNumber; // creating a dictionay
    }

    // view & pure, function for state reading only (No gas, except when calling from gas function)
    // explicite getter of a state variable
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }
}
