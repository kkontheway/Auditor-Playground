// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/Lending&Borrowing/BorrowerCan'tBeLiquidated/BorrowerCan'tBeLiquidated.sol";

contract LendingTest is Test {
    BorrowerCanNotBeLiquidated public lending;

    function setUp() public {
        lending = new BorrowerCanNotBeLiquidated();
    }

    function testOverwriteCollateral() public {
        uint256 loanId = 1;
        address token = address(0x1);

        // 提交初始抵押品
        lending.commitCollateral(loanId, token, 1000);

        // 验证初始抵押品数量
        assertEq(lending.getCollateralAmount(loanId, token), 1000);

        // 覆盖抵押品数量为 0
        lending.commitCollateral(loanId, token, 0);

        // 验证抵押品数量已被覆盖为 0
        assertEq(lending.getCollateralAmount(loanId, token), 0);
    }
}
