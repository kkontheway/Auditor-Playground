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

    modifier ifAdmin() {
        if (msg.sender == owner) {
            _;
        } else {
            _fallback();
        }
    }

    constructor(address implementation_, address owner_) {
        owner = owner_;
        implementation = implementation_;
    }

    function setImplementation(address implementation_) external {
        require(msg.sender == owner, "only owner");
        implementation = implementation_;
    }

    /**
     * @dev Delegates the current call to `implementation`.
     *
     * This function does not return to its internal call site, it will return directly to the external caller.
     */
    function _delegate(address implementation_) internal {
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas(), implementation_, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    /**
     * @dev Delegates the current call to the address returned by `_implementation()`.
     *
     * This function does not return to its internal call site, it will return directly to the external caller.
     */
    function _fallback() internal virtual {
        _delegate(implementation);
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
     * function in the contract matches the call data.
     */
    fallback() external payable virtual {
        _fallback();
    }

    receive() external payable {}
}
