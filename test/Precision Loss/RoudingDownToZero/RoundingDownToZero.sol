// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../../../lib/openzeppelin-contracts/contracts/utils/math/Math.sol";
import "forge-std/Test.sol";

contract RoundingDownToZero is Test {
    uint256 public constant USDC_PRECISION = 1e6;
    // borrow 10 USDC using 1 USDC as collateral
    uint256 loanAmount = 10 * USDC_PRECISION;
    uint256 loanCollateral = 1 * USDC_PRECISION;

    function setUp() public {}
    // source: https://github.com/sherlock-audit/2023-01-cooler-judging/issues/263

    function errorRepay(uint256 repaid) public {
        console.log("PrecisionLoss.errorRepay()");
        // @audit if repaid small enough, decollateralized will round down to 0,
        // allowing loan to be repaid without changing collateral
        uint256 decollateralized = loanCollateral * repaid / loanAmount;

        loanAmount -= repaid;
        loanCollateral -= decollateralized;

        console.log("decollateralized : ", decollateralized);
        console.log("loanAmount       : ", loanAmount);
        console.log("loanCollateral   : ", loanCollateral);
    }

    function testDivRoundToZero() public {
        // repay very small amount
        uint256 repayAmount = 0.000009 * 10 ** 6;

        errorRepay(repayAmount);

        // loan amount reduced but collateral stayed the same
        assertEq(loanAmount - repayAmount, loanAmount);
        assertEq(loanCollateral, loanCollateral);
    }

    // source: https://github.com/sherlock-audit/2022-12-notional-judging/issues/16
}
