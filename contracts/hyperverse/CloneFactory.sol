//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0; //^0.8.0;

import "./hyperverse/IHyperverseModule.sol";
import "@openzeppelin/contracts/proxy/clone/CloneFactory.sol";

contract CloneFactory {
    // The createClone function now uses the ERC1967Proxy constructor to create a minimal proxy clone of the target contract.
    function createClone(address target) internal returns (address result) {
        result = address(new ERC1967Proxy(target));
    }

    // The isClone function checks whether the given contract address (query) is a clone of the target contract (target) by comparing their implementations.
    function isClone(
        address target,
        address query
    ) internal view returns (bool result) {
        result = ERC1967Proxy(query).implementation() == target;
    }
}
