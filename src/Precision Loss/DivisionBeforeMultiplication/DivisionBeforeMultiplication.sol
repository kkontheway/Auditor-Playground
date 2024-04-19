// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

import "../../../lib/openzeppelin-contracts/contracts/utils/math/Math.sol";

contract DivisionBeforeMultiplication {
    // source: https://code4rena.com/reports/2023-01-numoen#h-01-precision-loss-in-the-invariant-function-can-lead-to-loss-of-funds
    error InvariantError();

    function errorInvariant(
        uint256 amount0,
        uint256 amount1,
        uint256 liquidity,
        uint256 token0Scale,
        uint256 token1Scale
    ) public pure returns (uint256) {
        if (liquidity == 0) {
            require(amount0 == 0 && amount1 == 0);
            return 0;
        }

        // @audit: division can cause rounding so always want to do it last. Doing
        // multiplicationa after division as occurs here can cause precision loss
        uint256 scale0 = Math.mulDiv(amount0, 1e18, liquidity) * token0Scale;
        uint256 scale1 = Math.mulDiv(amount1, 1e18, liquidity) * token1Scale;

        uint256 upperBound = 5 * 1e18;
        if (scale1 > 2 * upperBound) revert InvariantError();

        uint256 a = scale0 * 1e18;
        uint256 b = scale1 * upperBound;
        uint256 c = (scale1 * scale1) / 4;
        uint256 d = upperBound * upperBound;

        return a + b - c - d;
    }
}
