// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

import "forge-std/Test.sol";

contract EVMAssembly is Test {
    // slot 0
    uint256 public s_x;
    // slot 1
    uint256 public s_y;
    // slot 2
    bytes32 public s_z;

    function setUp() public {}

    function test_sstore() public {
        assembly {
            sstore(0, 0x111)
            sstore(1, 222)
            sstore(2, 789)
        }
    }

    function test_sstore_again() public {
        // Access slot using .slot
        assembly {
            sstore(s_x.slot, 123)
            sstore(s_y.slot, 456)
            sstore(s_z.slot, 0xcdcdcd)
        }
    }

    function test_sload() public view returns (uint256 x, uint256 y, bytes32 z) {
        assembly {
            x := sload(s_x.slot)
            y := sload(1)
            z := sload(2)
        }

        return (x, y, z);
    }

    function testvalidation() public {
        test_sstore_again();
        console.log("s_x: ", s_x);
        console.log("s_y: ", s_y);
        (uint256 result,,) = test_sload();
        console.log("s_x: ", result);
    }
}
