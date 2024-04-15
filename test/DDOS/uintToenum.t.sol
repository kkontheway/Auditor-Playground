// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

import "../../src/DDOS/uint-to-enum.sol";
import "forge-std/Test.sol";

contract uintToenumTest is Test {
    InterfaceTest target;

    function setUp() public {
        target = new InterfaceTest();
    }

    function testBeforeDDOS() public {
        target.test();
    }

    // The problem is unsafe cast from uint256 to Enum.
    // The DOC says if functions are doing type casting/validation from uint256 to Enumrator and if the value is greater than or equal to 3 , a revert will happen.
    // Let the enumCall function of A return Enumerator instead(implement the correct interface)

    function testDDOS() public {
        target.test();
        address(target.targetContract()).call{value: 4 wei}("");
        target.exploit();
    }
}
