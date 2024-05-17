// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../../src/Proxy/StorageCollision/TTP/TransparentProxy_storageCollisionHack.sol";
import "../../src/Proxy/StorageCollision/TTP/Implementation.sol";

contract TTP_storageCollisionHack is Test {
    Implementation public implementation;
    Proxy public proxy;
    address public attacker;

    function setUp() public {
        implementation = new Implementation();
        proxy = new Proxy(address(implementation), address(this));
        attacker = makeAddr("attacker");
    }

    function testFailTTP_storageCollision() public {
        assertEq(proxy.owner(), address(this));
        assertEq(proxy.implementation(), address(implementation));

        proxy.setImplementation(address(attacker));
        assertEq(address(proxy.implementation()), attacker);
    }
}
