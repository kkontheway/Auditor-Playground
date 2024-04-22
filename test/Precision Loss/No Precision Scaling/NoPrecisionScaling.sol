// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

import "forge-std/Test.sol";

contract NoPrecisionScaling is Test {
    // source: https://github.com/sherlock-audit/2023-02-notional/blob/main/leveraged-vaults/contracts/vaults/common/internal/pool/TwoTokenPoolUtils.sol#L67
    // given a trading pool of two tokens & an amount of LP pool tokens,
    // return the total value of the given LP tokens in the pool's primary token
    function errorGetWeightedBalance(
        uint256 token1Amount,
        uint256 token1Precision,
        uint256 token2Amount,
        uint256, //token2Precision,
        uint256 poolTotalSupply,
        uint256 lpPoolTokens,
        uint256 lpPoolTokensPrecision,
        uint256 oraclePrice
    ) public view returns (uint256 primaryAmount) {
        console.log("PrecisionLoss.errorGetWeightedBalance()");
        // Get shares of primary and secondary balances with the provided poolClaim

        // token1Amount = 100e18
        // token2Amount = 100e6

        uint256 primaryBalance = token1Amount * lpPoolTokens / poolTotalSupply;
        uint256 secondaryBalance = token2Amount * lpPoolTokens / poolTotalSupply;

        console.log("primaryBalance           : ", primaryBalance);
        console.log("secondaryBalance         : ", secondaryBalance);

        // Value the secondary balance in terms of the primary token using the oraclePrice

        // secondaryAmountInPrimary = 5e7 * 1e18 / 1e18
        uint256 secondaryAmountInPrimary = secondaryBalance * lpPoolTokensPrecision / oraclePrice;

        console.log("secondaryAmountInPrimary : ", secondaryAmountInPrimary);

        // Make sure primaryAmount is reported in token1Precision
        // @audit (primaryBalance + secondaryAmountInPrimary)
        // primaryBalance & secondaryAmountInPrimary may not be denominated in
        // the same precision => they can't safely be added together without
        // first scaling the secondary token to match the primary token's precision
        // primaryAmount = 5e19 + 5e7 =
        primaryAmount = (primaryBalance + secondaryAmountInPrimary) * token1Precision / lpPoolTokensPrecision;
        console.log("primaryAmount            : ", primaryAmount);
    }

    // @audit correct verison scales secondary token to match primary tokens' precision
    // before performing further computation
    function correctGetWeightedBalance(
        uint256 token1Amount,
        uint256 token1Precision,
        uint256 token2Amount,
        uint256 token2Precision,
        uint256 poolTotalSupply,
        uint256 lpPoolTokens,
        uint256 lpPoolTokensPrecision,
        uint256 oraclePrice
    ) public view returns (uint256 primaryAmount) {
        console.log("PrecisionLoss.correctGetWeightedBalance()");
        // Get shares of primary and secondary balances with the provided poolClaim

        uint256 primaryBalance = token1Amount * lpPoolTokens / poolTotalSupply;
        uint256 secondaryBalance = token2Amount * lpPoolTokens / poolTotalSupply;

        // @audit scale secondary token amount to first token's precision prior to any computation
        secondaryBalance = secondaryBalance * token1Precision / token2Precision;

        console.log("primaryBalance           %e: ", primaryBalance);
        console.log("secondaryBalance         %e: ", secondaryBalance);

        // Value the secondary balance in terms of the primary token using the oraclePrice
        uint256 secondaryAmountInPrimary = secondaryBalance * lpPoolTokensPrecision / oraclePrice;
        console.log("secondaryAmountInPrimary %e: ", secondaryAmountInPrimary);

        // Make sure primaryAmount is reported in token1Precision
        primaryAmount = primaryBalance + secondaryAmountInPrimary;
        console.log("primaryAmount            %e: ", primaryAmount);
    }
    // given a pool of two tokens with different precision, calculate
    // value of given amount of LP tokens in the pool's primary token

    function testWeightedPoolBalanceDiffPrecision() public {
        uint256 DAI_PRECISION = 10 ** 18;
        uint256 USDC_PRECISION = 10 ** 6;

        uint256 token1Precision = DAI_PRECISION;
        uint256 token2Precision = USDC_PRECISION;
        uint256 token1Amount = 100 * token1Precision;
        uint256 token2Amount = 100 * token2Precision;
        uint256 poolTotalSupply = 100;
        uint256 lpPoolTokens = 50;
        uint256 lpPoolTokensPrecision = DAI_PRECISION;
        uint256 oraclePrice = 1 * DAI_PRECISION;

        // first test: DAI/USDC pool
        uint256 result = errorGetWeightedBalance(
            token1Amount,
            token1Precision,
            token2Amount,
            token2Precision,
            poolTotalSupply,
            lpPoolTokens,
            lpPoolTokensPrecision,
            oraclePrice
        );
        assertEq(50000000000050000000, result);

        result = correctGetWeightedBalance(
            token1Amount,
            token1Precision,
            token2Amount,
            token2Precision,
            poolTotalSupply,
            lpPoolTokens,
            lpPoolTokensPrecision,
            oraclePrice
        );
        assertEq(100000000000000000000, result);

        // second test: USDC/DAI pool
        result = errorGetWeightedBalance(
            token2Amount,
            token2Precision,
            token1Amount,
            token1Precision,
            poolTotalSupply,
            lpPoolTokens,
            lpPoolTokensPrecision,
            oraclePrice
        );
        assertEq(50000000, result);

        result = correctGetWeightedBalance(
            token2Amount,
            token2Precision,
            token1Amount,
            token1Precision,
            poolTotalSupply,
            lpPoolTokens,
            lpPoolTokensPrecision,
            oraclePrice
        );
        assertEq(100000000, result);
    }
}
