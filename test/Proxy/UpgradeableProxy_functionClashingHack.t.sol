// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {Proxy} from "../../src/Proxy/FunctionCollision/UpgradeableProxy/UpgradeableProxy_functionClashingHack.sol";
import {Implementation} from "../../src/Proxy/FunctionCollision/UpgradeableProxy/Implementation.sol";

interface IProxy {
    function implementation() external returns (address);
    function doImplementationStuff() external returns (bool);
    function superSafeFunction96508587(address) external;
}

contract UpgradeableProxy_functionClashingHack is Test {
    address payable public proxy;
    address payable public proxyFixed;
    Implementation public implementation;

    address public owner;
    address public admin;

    function setUp() public {
        // deploy vulnerable version
        owner = address(0xbabe);
        implementation = new Implementation();
        proxy = payable(address(new Proxy(address(implementation), owner)));
    }

    // Here's the hack, if owner calls the very innocent looking superSafeFunction96508587
    // then Solidity sees that as calling the setImplmentation fn on the proxy.
    function testProxy_oops() public {
        address implementationAddress = address(implementation);
        vm.prank(owner);
        assert(IProxy(proxy).doImplementationStuff());

        address newImplementationAddress = address(0xb0ffed);
        vm.prank(owner);
        IProxy(proxy).superSafeFunction96508587(newImplementationAddress);
        assertEq(IProxy(proxy).implementation(), newImplementationAddress);
    }
}
