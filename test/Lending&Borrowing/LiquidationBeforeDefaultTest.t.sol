// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/Lending&Borrowing/Liquidation Before Default/LiquidationBeforeDefault.sol"; // 假设 Lending 合约包含了上述函数;

contract LendingTest is Test {
    LiquidationBeforeDefault public lending;
    uint256 public loanId;

    function setUp() public {
        lending = new LiquidationBeforeDefault();
        // 创建一个新的贷款
        loanId = lending.createLoan(address(this), 100 ether, uint32(block.timestamp), 30 days);
    }

    function testLiquidateLoanBeforeFirstPayment() public {
        // 接受贷款
        lending.acceptLoan(loanId);

        // 获取贷款
        (uint256 amount, uint32 acceptedTimestamp, uint32 lastRepaidTimestamp, bool state) = lending.loans(loanId);
        // 确保贷款已被接受
        assertEq(bool(state), bool(lending.ACCEPTED()));

        // 在第一次还款到期之前，将时间快进到 paymentDefaultDuration 之后
        vm.warp(acceptedTimestamp + lending.paymentDefaultDuration() + 1);

        // 尝试清算贷款
        bool canLiquidate = lending.canLiquidateLoan(loanId);

        // 验证漏洞：在第一次还款到期之前，贷款可以被清算
        assertTrue(canLiquidate);
    }
}
