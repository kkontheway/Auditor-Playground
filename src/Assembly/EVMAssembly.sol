// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.13;

contract EVMAssembly {
    function test_yul_var() public pure returns (uint256) {
        uint256 s = 0;
        assembly {
            let x := 0
            x := 1
            s := 2
        }
        return s;
    }

    function test_yul_types() public pure returns (bool x, uint256 y, bytes32 z) {
        assembly {
            x := 1
            y := 0xaaa
            z := "Hello Yul"
        }
        return (x, y, z);
    }
}
