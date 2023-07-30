/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
                Defines Module Metadata of the Hyperverse Smart Modules.
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ *

/*  GOAL:
In essense, this contract serves two purposes:
1) Enforces the `metadata` variable
2) Defines what a ModuleMetadata is 
*/

// SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.6.0 <0.9.0; //^0.8.0;

abstract contract IHyperverseModule {
    // custom types definition
    struct Author {
        address authorAddress; //
        string externalLink;
    }
    struct ModuleMetadata {
        bytes title; // String?
        Author author;
        bytes version;
        uint64 publishedAt; // timestamp?
        bytes externalLink;
    }

    // variables definition;
    ModuleMetadata metadata;
    address private owner;
}
