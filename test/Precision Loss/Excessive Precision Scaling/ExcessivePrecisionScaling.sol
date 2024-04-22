// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

import "../../../lib/openzeppelin-contracts/contracts/utils/math/Math.sol";
import "forge-std/Test.sol";

contract ExcessivePrecisionScalingTest is Test {
    uint256 public constant BALANCER_PRECISION = 1e18;
    uint256 public constant BALANCER_SCALING_FACTOR = 1e30;
    uint256 USDC_PRECISION = 1e6;
    uint256 DAI_PRECISION = 1e18;

    function getSpotPriceIncorrect(
        uint256 primaryBalance,
        uint256 secondaryBalance,
        uint256 primaryPrecision,
        uint256 secondaryPrecision
    ) public returns (uint256) {
        // Scale both balances to BALANCER_PRECISION
        uint256 PrimaryBalance = primaryBalance * BALANCER_PRECISION / primaryPrecision;

        uint256 SecondaryBalance = secondaryBalance * BALANCER_PRECISION / secondaryPrecision;

        // Calculate the Price By Balance Scaling Factor
        // Scaling Factor is consist of the FixedPoint.ONE (1e18) multiplied by the value needed to normalize the token balance to 18 decimals. If it is a USDC with 6 decimals, the scaling factor will be 1e30:

        uint256 scaledPrimaryBalance = PrimaryBalance * BALANCER_SCALING_FACTOR / BALANCER_PRECISION;

        console.log("PrimaryBalance: %e", PrimaryBalance);
        console.log("scaledPrimaryBalance: %e", scaledPrimaryBalance);

        return scaledPrimaryBalance;
    }

    function testPrecisionScaling() public {
        uint256 primaryBalance = 100 * USDC_PRECISION; // 1000 DAI
        uint256 secondaryBalance = 1000 * DAI_PRECISION; // 1000 USDC

        uint256 incorrectSpotPrice =
            getSpotPriceIncorrect(primaryBalance, secondaryBalance, USDC_PRECISION, DAI_PRECISION);

        console.log("Incorrect  Balance: ", incorrectSpotPrice);
    }
}
