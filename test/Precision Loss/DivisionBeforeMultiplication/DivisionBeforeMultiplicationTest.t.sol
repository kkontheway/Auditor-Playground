// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

import "../../../lib/openzeppelin-contracts/contracts/utils/math/Math.sol";
import "forge-std/Test.sol";

contract DivisionBeforeMultiplicationTest is Test {
    // source: https://code4rena.com/reports/2023-01-numoen#h-01-precision-loss-in-the-invariant-function-can-lead-to-loss-of-funds
    error InvariantError();

    function errorInvariant(
        uint256 amount0,
        uint256 amount1,
        uint256 liquidity,
        uint256 token0Scale,
        uint256 token1Scale
    ) public view returns (uint256) {
        if (liquidity == 0) {
            require(amount0 == 0 && amount1 == 0);
            return 0;
        }

        // @audit: division can cause rounding so always want to do it last. Doing
        // multiplicationa after division as occurs here can cause precision loss

        // mulDiv(amount0, 1e18, liquidity) = amount0 * 1e18 / liquidity

        uint256 scale0 = Math.mulDiv(amount0, 1e18, liquidity) * token0Scale;
        uint256 scale1 = Math.mulDiv(amount1, 1e18, liquidity) * token1Scale;

        console.log("Loss of precision: multiplication after division");
        console.log("scale0 : ", scale0);
        console.log("scale1 : ", scale1);

        uint256 upperBound = 5 * 1e18;
        if (scale1 > 2 * upperBound) revert InvariantError();

        uint256 a = scale0 * 1e18;
        uint256 b = scale1 * upperBound;
        uint256 c = (scale1 * scale1) / 4;
        uint256 d = upperBound * upperBound;

        console.log("a      : ", a);
        console.log("b      : ", b);
        console.log("c      : ", c);
        console.log("d      : ", d);

        return a + b - c - d;
    }

    function correctInvariant(
        uint256 amount0,
        uint256 amount1,
        uint256 liquidity,
        uint256 token0Scale,
        uint256 token1Scale
    ) public view returns (uint256) {
        if (liquidity == 0) {
            require(amount0 == 0 && amount1 == 0);
            return 0;
        }

        // @audit: changed to perform division after multiplication
        uint256 scale0 = Math.mulDiv(amount0 * token0Scale, 1e18, liquidity);
        uint256 scale1 = Math.mulDiv(amount1 * token1Scale, 1e18, liquidity);

        console.log("Prevent precision loss: multiplication before division");
        console.log("scale0 : ", scale0);
        console.log("scale1 : ", scale1);

        uint256 upperBound = 5 * 1e18;
        if (scale1 > 2 * upperBound) revert InvariantError();

        uint256 a = scale0 * 1e18;
        uint256 b = scale1 * upperBound;
        uint256 c = (scale1 * scale1) / 4;
        uint256 d = upperBound * upperBound;

        console.log("a      : ", a);
        console.log("b      : ", b);
        console.log("c      : ", c);
        console.log("d      : ", d);

        return a + b - c - d;
    }

    function testInvariantDivBeforeMult() public {
        uint256 token0Amount = 1.5 * 10 ** 6;
        uint256 token1Amount = 2 * (5 * 10 ** 24 - 10 ** 21);
        uint256 liquidity = 10 ** 24;
        uint256 token0Precision = 10 ** 12;
        uint256 token1Precision = 1;

        uint256 result = errorInvariant(token0Amount, token1Amount, liquidity, token0Precision, token1Precision);
        assertEq(0, result);

        result = correctInvariant(token0Amount, token1Amount, liquidity, token0Precision, token1Precision);
        assertEq(500000000000000000000000000000, result);
    }
}
