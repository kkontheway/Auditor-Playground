// SPDX-License-Identifier: MIT
// NOTE: These contracts have a critical bug.
// DO NOT USE THIS IN PRODUCTION
pragma solidity ^0.8.13;

/// A proxy contract inspired by
/// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/proxy/Proxy.sol
///
/// Only the owner can call the contract, where owner is an immutable variable set during the
/// construction.
///
/// The implementation will be set to a deployment of `Implementation.sol` but is also settable.
contract Proxy {
    address public immutable owner;
    address public implementation;

    constructor(address implementation_, address owner_) {
        owner = owner_;
        implementation = implementation_;
    }

    function setImplementation(address implementation_) external {
        require(msg.sender == owner, "only owner");
        implementation = implementation_;
    }

    fallback() external payable {
        require(msg.sender == owner);

        address implementation_ = implementation;
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch space at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // delegatecall the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let success := delegatecall(gas(), implementation_, 0, calldatasize(), 0, 0)

            // copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch success
            // delegatecall returns 0 on error.
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}
