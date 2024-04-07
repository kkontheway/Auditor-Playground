// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../../../src/Proxy/UUPS/Proxy.sol";
import "../../../src/Proxy/UUPS/UUPS1.sol";
import "../../../src/Proxy/UUPS/UUPS2.sol";

contract UUPSTest is Test {
    UUPSProxy proxy;
    UUPS1 uups1;
    UUPS2 uups2;

    function setUp() public {
        uups1 = new UUPS1();
        uups2 = new UUPS2();
        proxy = new UUPSProxy(address(uups1));
    }

    function testSetUP() public {
        bytes4 selector = 0xc2985578;
        bytes memory data = abi.encodeWithSelector(selector);
        (bool success,) = address(proxy).call(data);
        require(success, "Call failed");
        console.log("words: ", proxy.words());
    }

    function TestAddress() public {
        address uupss2 = address(uups2);
        console.log("address:", uupss2);
    }
}
