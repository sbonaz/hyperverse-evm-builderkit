/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                Defines Module Metadata of the Hyperverse Smart Modules.
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ *

/**

## The Decentology Smart Module standard on Ethereum

## `IHyperverseModule` interface

In essense, this contract serves two purposes:
1) Enforces the `metadata` variable
2) Defines what a ModuleMetadata is 

*/

// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0 <0.9.0; //^0.8.0;

// pragma experimental ABIEncoderV2;  this pragma is not needed in this contract, and has been removed since version 0.8.0.

abstract contract IHyperverseModule {
    struct ModuleMetadata {
        bytes title; // <-- `pub var title: String` in Cadence
        Author author;
        bytes version;
        uint64 publishedAt;
        bytes externalLink; // <-- can't be "external" in Solidity because it's a keyword
    }
    struct Author {
        address authorAddress; // <-- can't be "address" in Solidity because it's a keyword
        string externalLink;
    }

    // ModuleMetadata public metadata;
    ModuleMetadata metadata;
    address private owner;
}
